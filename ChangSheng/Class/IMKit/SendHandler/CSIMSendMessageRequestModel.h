//
//  CSIMSendMessageRequestModel.h
//  TestAAA
//
//  Created by cnepayzx on 2017/9/25.
//  Copyright © 2017年 bingtianyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deferred.h"
#import "CSMessageModel.h"
#import "CSMessageDBModel.h"

#define CSIM_SENDMESSAGE_TIME_OUT 30
#define CS_IM_MAX_RESEND_NUMBER 1
typedef enum {
    IM_Sending = 0,          //发送中
    IM_SendFailed  = 1,      //发送失败
    IM_SendSuccessed   = 2,  //发送成功
    IM_Send_No = 3           //发送未开始
} IM_SEND_STATUS;





@protocol CSIMSendMessageRequestModelDelegate <NSObject>

@required
/*-------------------------------消息发送状态监听-------------------------------*/
@property(nonatomic,strong)Deferred * msgStatus;
//从发次数
@property(nonatomic,assign)int sendNumber;

@property(nonatomic,assign)IM_SEND_STATUS sendStatus;

@property(nonatomic,assign)CS_Message_Record_Type chatType;
@end



@class CSIMUnReadListModel;

@interface CSIMSendMessageRequestModel : NSObject<CSIMSendMessageRequestModelDelegate,NSMutableCopying>

- (id)initWithChatType:(CS_Message_Record_Type)chatType;
@property(nonatomic,assign)CS_Message_Record_Type chatType;

@property(nonatomic,strong)Deferred * msgStatus;

@property(nonatomic,assign)int sendNumber;

@property(nonatomic,assign)IM_SEND_STATUS sendStatus;

//是否是自己发出 默认是0,自己发出的消息要手动 改成 1
@property(nonatomic,assign)BOOL isSelf;
//消息id (客户端自定义字段)
@property(nonatomic,copy)NSString * msgId;
@property(nonatomic,copy)NSString * msgCode;
/**
 缓存消息Key
 */
@property(nonatomic,copy)NSString * msgCacheKey;
//成功或失败提示消息
@property(nonatomic,copy)NSString * msg;
//发送状态 1000 成功
@property(nonatomic,assign)int code;

@property (nonatomic,strong) CSCacheUserInfo *userInfo;
/*-------------------------------解析未读消息-------------------------------*/
@property(nonatomic,strong)NSArray<CSIMUnReadListModel*> * unreadList;

/*-------------------------------消息结构体-------------------------------*/

@property(nonatomic,strong)CSMessageModel * body;
@property(nonatomic,strong)CSMessageModel * result;

- (void)createMsgStatus;

/**
 将成功发送的消息,msgid 同步.替换客户端临时生成的 msgid.更换成服务端返回的msgid.
 */
- (void)syncMsgID:(CSIMSendMessageRequestModel *)message;

- (void)successed;

- (void)failed;
@end


@interface CSIMUnReadListModel : NSObject
@property (nonatomic, assign)int chatType;
@property (nonatomic, assign)int chatId;
@property (nonatomic, assign)int count;
@end


