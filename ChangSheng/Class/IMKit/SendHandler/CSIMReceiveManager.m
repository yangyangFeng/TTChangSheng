//
//  CSIMReceiveManager.m
//  WebSocketTest
//
//  Created by cnepayzx on 2017/9/27.
//  Copyright © 2017年 bingtianyu. All rights reserved.
//

#import "CSIMReceiveManager.h"
#import "CSIMMessageQueueManager.h"
static CSIMReceiveManager * _manager = nil;
@interface CSIMReceiveManager ()
@property(nonatomic,strong)dispatch_queue_t  queue;
@end
@implementation CSIMReceiveManager

+ (CSIMReceiveManager *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [CSIMReceiveManager new];
    });
    return _manager;
}

- (void)receiveMessage:(CSIMSendMessageRequestModel *)message
{
    CSIMSendMessageRequestModel * sendMsg = [[CSIMMessageQueueManager shareInstance] checkMessageContains:message];
    int msgId = sendMsg.msgCode;
    if (message.msgCode == 1000) {
        [sendMsg syncMsgID:message];
        [sendMsg.msgStatus resolve:nil];
    }
    else
    {
        [sendMsg.msgStatus reject:[NSError errorWithDomain:message.msg code:message.code userInfo:nil]];
    }
    message.result.msgId = msgId;
    [[CSIMMessageQueueManager shareInstance] removeMessages:message];
}
@end
