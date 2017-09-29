
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
@property(nonatomic,strong)NSMutableDictionary * allSendMessages;
@end
@implementation CSIMMessageQueueManager

+ (CSIMMessageQueueManager *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queueManager = [CSIMMessageQueueManager new];
        queueManager.allSendMessages = [NSMutableDictionary dictionary];
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

- (void)insertMessage:(CSIMSendMessageRequestModel *)message
{
    [self.allSendMessages setObject:message forKey:message.msgCode];
}

- (void)removeMessages:(CSIMSendMessageRequestModel *)message
{
    if (message.msgCode.length) {
        [self.allSendMessages removeObjectForKey:message.msgCode];
    }
    
}

- (void)cacheMessage:(CSIMSendMessageRequestModel *)message
{
    [self.messages setObject:message forKey:message.msgCode];
}

- (void)removeCacheMessage:(CSIMSendMessageRequestModel *)message
{
    if (message.msgCode) {
        [self.messages removeObjectForKey:message.msgCode];
    }
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

- (CSIMSendMessageRequestModel *)checkMessageContains:(CSIMSendMessageRequestModel *)message
{
    CSIMSendMessageRequestModel * msg = [self.allSendMessages objectForKey:message.msgCode];
    if (msg) {
        return msg;
    }
    return msg;
}

- (void)clean
{
    [self.messages removeAllObjects];
    [self.allSendMessages removeAllObjects];
}
@end
