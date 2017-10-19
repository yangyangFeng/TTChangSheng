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

#define NOTIFICE_KEY_SOCKET_OPEN @"NOTIFICE_KEY_SOCKET_OPEN"
#define NOTIFICE_KEY_SOCKET_CLOSE @"NOTIFICE_KEY_SOCKET_CLOSE"
#define NOTIFICE_KEY_SOCKET_CANCLE_BET @"NOTIFICE_KEY_SOCKET_CANCLE_BET"

@protocol CSIMReceiveManagerDelegate <NSObject>

- (void)cs_receiveMessage:(CSMessageModel *)message;

- (void)cs_sendMessageCallBlock:(CSMessageModel *)message;
@end
@interface CSIMReceiveManager : NSObject

@property (nonatomic, weak)id<CSIMReceiveManagerDelegate> delegate;

- (void)removeDelegate:(id<CSIMReceiveManagerDelegate>)delegate;

+ (CSIMReceiveManager *)shareInstance;

- (void)receiveMessage:(CSIMSendMessageRequestModel *)message;


- (int)getUnReadMessageNumberChatType:(CSChatType)chatType chatId:(NSString *)chatId;
- (NSString *)keyWithChatType:(CSChatType)chatType chatId:(NSString *)chatId;
- (void)inChatWithChatType:(CSChatType)chatType chatId:(NSString *)chatId;
- (void)outChatWithChatType:(CSChatType)chatType chatId:(NSString *)chatId;
@end


