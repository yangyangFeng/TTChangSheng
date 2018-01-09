//
//  CSIMReceiveManager.h
//  WebSocketTest
//
//  Created by cnepayzx on 2017/9/27.
//  Copyright © 2017年 bingtianyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSIMSendMessageRequestModel.h"

#import "CSMessageModel.h"
@class CSIMSendMessageRequestModel;
#define CS_MESSAGE_KEY_SINGLE @"single"
#define CS_MESSAGE_KEY_GROUP @"group"
#define CS_MESSAGE_KEY_FEIEND @"friend"

#define NOTIFICE_KEY_SOCKET_OPEN @"NOTIFICE_KEY_SOCKET_OPEN"
#define NOTIFICE_KEY_SOCKET_CLOSE @"NOTIFICE_KEY_SOCKET_CLOSE"
#define NOTIFICE_KEY_SOCKET_UNREAD_NUMBER @"NOTIFICE_KEY_SOCKET_UNREAD_NUMBER"
#define NOTIFICE_KEY_SOCKET_CANCLE_BET @"NOTIFICE_KEY_SOCKET_CANCLE_BET"
#define NOTIFICE_KEY_SOCKET_CURRENT_SCORE @"NOTIFICE_KEY_SOCKET_CURRENT_SCORE"

@protocol CSIMReceiveManagerDelegate <NSObject>

- (void)cs_receiveMessage:(CSMessageModel *)message;

- (void)cs_sendMessageCallBlock:(CSMessageModel *)message;

- (void)cs_receiveUpdateUnreadMessage;
@end
@interface CSIMReceiveManager : NSObject

@property (nonatomic, weak)id<CSIMReceiveManagerDelegate> delegate;

- (void)removeDelegate:(id<CSIMReceiveManagerDelegate>)delegate;

+ (CSIMReceiveManager *)shareInstance;

- (void)receiveMessage:(CSIMSendMessageRequestModel *)message;


- (int)getUnReadMessageNumberChatType:(CSChatType)chatType chatId:(NSString *)chatId;
- (int)getAllUnReadMessageNumberChatType:(CSChatType)chatType;
- (NSString *)keyWithChatType:(CSChatType)chatType chatId:(NSString *)chatId;
- (void)inChatWithChatType:(CSChatType)chatType chatId:(NSString *)chatId;
- (void)inChatWithChatType:(CSChatType)chatType chatId:(NSString *)chatId status:(void(^)(NSError*))status;
- (void)outChatWithChatType:(CSChatType)chatType chatId:(NSString *)chatId;

@property (nonatomic,strong) CSIMSendMessageRequestModel *currentAction;
@end






