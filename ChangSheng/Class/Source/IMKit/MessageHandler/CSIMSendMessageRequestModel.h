//
//  CSIMSendMessageRequestModel.h
//  TestAAA
//
//  Created by cnepayzx on 2017/9/25.
//  Copyright © 2017年 bingtianyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deferred.h"


#define CSIM_SENDMESSAGE_TIME_OUT 10
#define CS_IM_MAX_RESEND_NUMBER 1
typedef enum {
    IM_Sending = 0,
    IM_SendFailed  = 1,
    IM_SendSuccessed   = 2,
    IM_Send_No = 3
} IM_SEND_STATUS;
@protocol CSIMSendMessageRequestModelDelegate <NSObject>

@required
/*-------------------------------消息发送状态监听-------------------------------*/
@property(nonatomic,strong)Deferred * msgStatus;
//从发次数
@property(nonatomic,assign)int sendNumber;

@property(nonatomic,assign)IM_SEND_STATUS sendStatus;
@end
@interface CSIMSendMessageRequestModel : NSObject<CSIMSendMessageRequestModelDelegate,NSMutableCopying>

@property(nonatomic,strong)Deferred * msgStatus;

@property(nonatomic,assign)int sendNumber;

@property(nonatomic,assign)IM_SEND_STATUS sendStatus;
/*-------------------------------消息结构体-------------------------------*/
//消息id
@property(nonatomic,assign)int msgCode;

- (void)createMsgStatus;
@end
