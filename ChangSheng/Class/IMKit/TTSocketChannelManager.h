//
//  TTSocketChannelManager.h
//  WebSocketTest
//
//  Created by cnepayzx on 2017/9/27.
//  Copyright © 2017年 bingtianyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTWebSocketChannel.h"

typedef enum : NSUInteger {
    CS_IM_Connection_Ststus_Close,
    CS_IM_Connection_Ststus_Connectioning,
    CS_IM_Connection_Ststus_Connectioned,
    CS_IM_Connection_Ststus_Fail,
} CS_IM_Connection_Ststus;

@interface TTSocketChannelManager : NSObject

@property (nonatomic, strong, readonly) SRWebSocket *webSocket;

/** ws://115.29.193.48:8088 */
@property (nonatomic, copy, readonly) NSString *urlString;

@property (nonatomic, weak) id<TTWebSocketChannelDelegate> delegate;

- (void)configUrlString:(NSString *)url;

- (void)openConnection;
- (void)closeConnection;
- (void)closeConnectionWithError:(NSError *)error;
- (BOOL)isConnected;

/**
 检测当Socket连接 如果短线自动发起一次从连
 */
- (void)checkSocketStatus;

/**
 发送消息

 @param message CSIMSendMessageRequestModel
 */
- (void)sendMessage:(id)message;

/**
 发送心跳请求
 */
- (void)sendPing;
/**
 获取socket连接
 */
+ (TTSocketChannelManager *)shareInstance;
@end
