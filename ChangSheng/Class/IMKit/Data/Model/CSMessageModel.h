//
//  CSMessageModel.h
//  TestChat
//
//  Created by cnepayzx on 2017/9/27.
//  Copyright © 2017年 bingtianyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CSMessageBodyModel;
@class CSUnreadListModel;
@interface CSMessageModel : NSObject


//:1|2, //1,群聊 2,单聊
@property(nonatomic,assign)int chartType;
//: 1|2 //消息接收方用户类型 1 代表 普通用户 2 代表 系统客户（主持人） //chartType == 2 && action ==4 需要
@property(nonatomic,assign)int receiveUserType;
//如果chartType=1 代表群组id 如果chartType=2 代表用户id
@property(nonatomic,assign)int chatId;
//消息id （如果action=1 不需要， =2 || ==5 代表服务器返回的消息自增id, ==3 || ==4 代表客户端生成的唯一id  *
@property(nonatomic,assign)int  msgId;
//:1|2|3|4|5, // 1、进群 2、出群 3、下注 4、普通消息 5、撤销 6、加群 7、退群 ps: 1 暂时不用
@property(nonatomic,assign)int action;
//:1|2|3|4, 1,文字 2,图片 3,语音, 4点击跳转外部连接 // action=4 需要
@property(nonatomic,assign)int msgType;
//"消息内容" // action=3 || ==4 需要
@property(nonatomic,copy)NSString * content;
//后台客服或者主持人发消息的时候需要，前台用不到 可以忽略;
@property(nonatomic,copy)NSString * linkUrl;

//1|2|3|4|5|6|7 //玩法 1、庄 2、闲 3、和 4、庄对 5、闲对 6、双对（庄对、闲对） 7、三宝（闲对、庄对、和）
@property(nonatomic,assign)int playType;
//:100 //下注分数 action=2 需要
@property(nonatomic,assign)int score;


/*---------------------------服务端发给客户端-----------------------------------*/
//@property(nonatomic,copy)NSString * msg;
//@property(nonatomic,assign)int code;
//回执ID
@property(nonatomic,copy)NSString * receiptId;
@property(nonatomic,strong)NSArray<CSUnreadListModel*> * unreadList;
@property(nonatomic,strong)CSMessageBodyModel * body;
@end

@interface CSMessageBodyModel : NSObject
//:1|2|3|4, //1,文字 2,图片 3,语音, 4点击跳转外部连接
@property(nonatomic,assign)int msgType;
//"消息内容", //action==3 只需要content 和 linkUrl 其他不需要
@property(nonatomic,copy)NSString * content;

@property(nonatomic,copy)NSString * linkUrl;
// : 0 //未读消息条数
@property(nonatomic,assign)int unreadCount;
//:"", //头像地址
@property(nonatomic,copy)NSString * avatar;

@property(nonatomic,copy)NSString * nickname;
//发送时间
@property(nonatomic,copy)NSString * time;

@end

@interface CSUnreadListModel : NSObject
// chartType:1|2 //1,群聊 2,单聊
@property(nonatomic,assign)int chartType;
//:10 //未读数量
@property(nonatomic,assign)int count;
//如果chartType=1 代表群组id 如果chartType=2 代表用户id
@property(nonatomic,assign)int chatId;

@end
