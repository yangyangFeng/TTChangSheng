
//  CSIMMessageQueueManager.m
//  TestAAA
//
//  Created by cnepayzx on 2017/9/25.
//  Copyright © 2017年 bingtianyu. All rights reserved.
//

#import "CSIMMessageQueueManager.h"

#import "CSIMSendMessageRequestModel.h"



static CSIMMessageQueueManager * queueManager = nil;
@interface CSIMMessageQueueManager ()
@property(nonatomic,strong)NSMutableDictionary * messages;
@end
@implementation CSIMMessageQueueManager

+ (CSIMMessageQueueManager *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queueManager = [CSIMMessageQueueManager new];
    });
    return queueManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _messages = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)cacheMessage:(CSIMSendMessageRequestModel *)message
{
    //从发次数+1
//    message.sendNumber++;
    [self.messages setObject:message forKey:@(message.msgCode)];
}

- (void)removeCacheMessage:(CSIMSendMessageRequestModel *)message
{
    [self.messages removeObjectForKey:@(message.msgCode)];
}

- (NSArray *)resendCacheMessage
{
    NSMutableArray * messagesArray = [NSMutableArray array];
    for (NSNumber * key in self.messages.allKeys) {
        CSIMSendMessageRequestModel * message = self.messages[key];
        if (message.sendNumber <= CS_IM_MAX_RESEND_NUMBER) {
            if ((message.msgStatus.isRejected) | (!message.msgStatus.isRejected && !message.msgStatus.isResolved)) {
                NSLog(@"重发这条消息");
                if (message.sendStatus == IM_SendFailed) {
                    [messagesArray addObject:message ];
                }
                
            }            
        }
    }
    return messagesArray;
}
@end
