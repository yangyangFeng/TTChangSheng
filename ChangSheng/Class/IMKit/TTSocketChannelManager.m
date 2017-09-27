//
//  TTSocketChannelManager.m
//  WebSocketTest
//
//  Created by cnepayzx on 2017/9/27.
//  Copyright © 2017年 bingtianyu. All rights reserved.
//

#import "TTSocketChannelManager.h"

#import "CSIMReceiveManager.h"
#import "CSIMSendMessageRequestModel.h"

static TTSocketChannelManager * _manager = nil;

@interface TTSocketChannelManager ()<TTWebSocketChannelDelegate>
@property(nonatomic,strong)TTWebSocketChannel * socketChannel;
@end
@implementation TTSocketChannelManager
+ (TTSocketChannelManager *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [TTSocketChannelManager new];
    });
    return _manager;
}

- (void)configUrlString:(NSString *)url;
{
    self.socketChannel = [[TTWebSocketChannel alloc]initWithURL:url];
    self.socketChannel.delegate = self;
}
- (void)openConnection
{
    [self.socketChannel openConnection];
}
- (void)closeConnection
{
    [self.socketChannel closeConnection];
}
-(void)closeConnectionWithError:(NSError *)error
{
    [self.socketChannel.webSocket closeWithCode:error.code reason:error.domain];
}
- (BOOL)isConnected
{
    return [self.socketChannel isConnected];
}


/**
 发送消息
 
 @param message CSIMSendMessageRequestModel
 */
- (void)sendMessage:(id)message
{
    //只有在连接状态才能通过 socket 通道发送消息
    if (self.webSocket.readyState == SR_OPEN) {
        [self.webSocket send:message];
    }
}

/**
 发送心跳请求
 */
- (void)sendPing
{
    [self.webSocket sendPing:nil];
}
#pragma mark - SRWebSocketDelegate

// message will either be an NSString if the server is using text
// or NSData if the server is using binary.
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    [[CSIMReceiveManager shareInstance] receiveMessage:[CSIMSendMessageRequestModel new]];
    if (_delegate && [_delegate respondsToSelector:@selector(webSocket:didReceiveMessage:)]) {
        [_delegate webSocket:webSocket didReceiveMessage:message];
    }
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    if (_delegate && [_delegate respondsToSelector:@selector(webSocketDidOpen:)]) {
        [_delegate webSocketDidOpen:webSocket];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    if (_delegate && [_delegate respondsToSelector:@selector(webSocket:didFailWithError:)]) {
        [_delegate webSocket:webSocket didFailWithError:error];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    if (_delegate && [_delegate respondsToSelector:@selector(webSocket:didCloseWithCode:reason:wasClean:)]) {
        [_delegate webSocket:webSocket didCloseWithCode:code reason:reason wasClean:wasClean];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload
{
    if (_delegate && [_delegate respondsToSelector:@selector(webSocket:didReceivePong:)]) {
        [_delegate webSocket:webSocket didReceivePong:pongPayload];
    }
}
@end
