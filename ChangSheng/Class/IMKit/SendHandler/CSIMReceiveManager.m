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
    switch (message.body.action) {
        // 1、普通消息 2、消息回执 3、路单图片 4、连接成功回执 5、用户上线 6 、用户下线
        case 1://
        {
            //计算数据高度
            [message.result processModelForCell];
            message.result.msgType = message.result.body.msgType;
            message.result.timestamp = message.result.body.timestamp;
            
            if ([self.delegate respondsToSelector:@selector(cs_receiveMessage:)]) {
                [self.delegate cs_receiveMessage:message.result];
            }
        }
            break;
        case 2:
        {
            NSString * msgId = [sendMsg.msgCode copy];
            if ([message.msgCode isEqualToString:@"1000"]) {
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
            break;
        case 3:
        {
            
        }
            break;
        case 4:
        {
            CS_HUD(@"socket已连接");
        }
            break;
        case 5:
        {
            CS_HUD(@"用户已上线");
        }
            break;
            case 6:
        {
            CS_HUD(@"用户已下线");
        }
            break;
        default:
            break;
    }
    
    
 
    
    
}
@end
