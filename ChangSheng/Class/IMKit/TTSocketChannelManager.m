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
#import "CSIMSendMessageManager.h"
#import "AFNetworkReachabilityManager.h"

#import "CSNewWorkHandler.h"
static TTSocketChannelManager * _manager = nil;

@interface TTSocketChannelManager ()<TTWebSocketChannelDelegate>
@property(nonatomic,strong)TTWebSocketChannel * socketChannel;
@property(nonatomic,assign)CS_IM_Connection_Ststus connectionStatus;
@end
@implementation TTSocketChannelManager

+(void)load
{
    [super load];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startMonitoring];
    });
}

+ (TTSocketChannelManager *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [TTSocketChannelManager new];
        _manager.connectionStatus = CS_IM_Connection_Ststus_Close;
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
    self.connectionStatus = CS_IM_Connection_Ststus_Connectioning;
}
- (void)closeConnection
{
    [self.socketChannel closeConnection];
    self.connectionStatus = CS_IM_Connection_Ststus_Close;
}
-(void)closeConnectionWithError:(NSError *)error
{
    [self.socketChannel.webSocket closeWithCode:error.code reason:error.domain];
    self.connectionStatus = CS_IM_Connection_Ststus_Close;
}
- (BOOL)isConnected
{
    return [self.socketChannel isConnected];
}

- (SRWebSocket *)webSocket
{
    return self.socketChannel.webSocket;
}

/**
 发送消息
 
 @param message CSIMSendMessageRequestModel
 */
- (void)sendMessage:(id)message
{
    //只有在连接状态才能通过 socket 通道发送消息
    if (self.webSocket.readyState == SR_OPEN) {
        NSLog(@"发送\n-------------------------------------------\n%@\n---------------------------------------",message);
        [self.webSocket send:message];
    }
}

/**
 发送心跳请求
 */
- (void)sendPing
{
    if (self.connectionStatus == CS_IM_Connection_Ststus_Connectioned && self.webSocket.readyState == SR_OPEN) {
        [self.webSocket sendPing:nil];
    }
    else if (self.connectionStatus == CS_IM_Connection_Ststus_Fail)
    {
        [self openConnection];
        dispatch_async(dispatch_get_main_queue(), ^{
            CS_HUD(@"socket正在重连");
        });
    }
}

/**
 检测当Socket连接 如果短线自动发起一次从连
 */
- (void)checkSocketStatus
{    
    if ( self.webSocket.readyState != SR_OPEN && self.connectionStatus != CS_IM_Connection_Ststus_Connectioning) {
        [self openConnection];
        dispatch_async(dispatch_get_main_queue(), ^{
            CS_HUD(@"socket正在重连");
        });
    }
}
#pragma mark - SRWebSocketDelegate

// message will either be an NSString if the server is using text
// or NSData if the server is using binary.
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    DLog(@"收到消息\n-------------------------------------------\n%@\n---------------------------------------",[self dictionaryWithJsonString:message]);
//     NSLog(@"收到消息\n-------------------------------------------\n%@\n---------------------------------------",message);
    [[CSIMReceiveManager shareInstance] receiveMessage:[CSIMSendMessageRequestModel mj_objectWithKeyValues:message]];
    if (_delegate && [_delegate respondsToSelector:@selector(webSocket:didReceiveMessage:)]) {
        [_delegate webSocket:webSocket didReceiveMessage:message];
    }
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    if (_delegate && [_delegate respondsToSelector:@selector(webSocketDidOpen:)]) {
        [_delegate webSocketDidOpen:webSocket];
    }
    [[CSIMSendMessageManager shareInstance] createGCDTimer];
    self.connectionStatus = CS_IM_Connection_Ststus_Connectioned;
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    if (_delegate && [_delegate respondsToSelector:@selector(webSocket:didFailWithError:)]) {
        [_delegate webSocket:webSocket didFailWithError:error];
    }
    self.connectionStatus = CS_IM_Connection_Ststus_Fail;
 
    dispatch_async(dispatch_get_main_queue(), ^{
    CS_HUD(@"socket异常断开");
    });
                   
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    if (_delegate && [_delegate respondsToSelector:@selector(webSocket:didCloseWithCode:reason:wasClean:)]) {
        [_delegate webSocket:webSocket didCloseWithCode:code reason:reason wasClean:wasClean];
    }
    self.connectionStatus = CS_IM_Connection_Ststus_Fail;
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload
{
    if (_delegate && [_delegate respondsToSelector:@selector(webSocket:didReceivePong:)]) {
        [_delegate webSocket:webSocket didReceivePong:pongPayload];
    }
    self.connectionStatus = CS_IM_Connection_Ststus_Connectioned;
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        
        return nil;
        
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        
        return nil;
        
    }
    return dic;
}

#pragma makr - 开始监听网络连接

+ (void)startMonitoring
{
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager* mgr = [AFNetworkReachabilityManager sharedManager];
    // 2.设置网络状态改变后的处理
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
                DLog(@"-----😴😴😴😴-------->未知网络");
                [CSNewWorkHandler sharedInstance].networkError = NO;
                break;
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                [CSNewWorkHandler sharedInstance].networkError = YES;
                DLog(@"-------😴😴😴😴------>断网");
                if ([CSUserInfo shareInstance].isOnline) {
                    [[self shareInstance] closeConnection];
                }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                DLog(@"-------😴😴😴😴------>手机自带网络");
                if ([CSUserInfo shareInstance].isOnline) {
                    [[self shareInstance] checkSocketStatus];
                }
                [CSNewWorkHandler sharedInstance].networkError = NO;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                DLog(@"------😴😴😴😴------->WIFI");
                if ([CSUserInfo shareInstance].isOnline) {
                    [[self shareInstance] checkSocketStatus];
                }
                [CSNewWorkHandler sharedInstance].networkError = NO;
                break;
        }
    }];
    [mgr startMonitoring];
}

@end
