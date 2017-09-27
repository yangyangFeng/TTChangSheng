//
//  TTWebSocketChannel.m
//  TestChat
//
//  Created by cnepayzx on 2017/9/27.
//  Copyright © 2017年 bingtianyu. All rights reserved.
//

#import "TTWebSocketChannel.h"


@interface TTWebSocketChannel ()

@end

@implementation TTWebSocketChannel

- (instancetype)initWithURL:(NSString *)aURL
{
    if (self = [super init]) {
        _urlString = aURL;
    }
    return self;
}

- (void)openConnection
{
    [self closeConnection];
    
    NSAssert(_urlString.length > 0, @"URL string is nil");
    
    //ws://115.29.193.48:8088
    _webSocket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:_urlString]];
    _webSocket.delegate = self;
    [_webSocket open];
}

- (void)closeConnection
{
    if (_webSocket) {
        _webSocket.delegate = nil;
        [_webSocket close];
    }
}

- (BOOL)isConnected
{
    return _webSocket.readyState == SR_OPEN;
}

#pragma mark - SRWebSocketDelegate

// message will either be an NSString if the server is using text
// or NSData if the server is using binary.
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
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
