
//  CSIMMessageQueueManager.m
//  TestAAA
//
//  Created by cnepayzx on 2017/9/25.
//  Copyright © 2017年 bingtianyu. All rights reserved.
//

#import "CSIMMessageQueueManager.h"

#import "CSIMSendMessageRequestModel.h"

#import "CSMessageRecordTool.h"
#import "MCDownloader.h"
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
    [self.allSendMessages setObject:message forKey:message.body.msgCacheKey];
}

- (void)removeMessages:(CSIMSendMessageRequestModel *)message
{
    if (message.msgCacheKey.length) {
        [self.allSendMessages removeObjectForKey:message.msgCacheKey];
    }
//    //#TODO:消息存入数据库
//    if (message.body.action == 4) {
//        [CSMsgCacheTool cs_cacheMessage:message.body userId:message.body.chatId addLast:YES];
//    }
}

- (void)cacheMessage:(CSIMSendMessageRequestModel *)message
{
    [self.messages setObject:message forKey:message.body.msgCacheKey];
    //#TODO:消息存入数据库
    if (message.body.action == 4) {
        [CSMsgCacheTool cs_cacheMessage:message.body userId:message.body.chatId addLast:YES];
    }
}

- (void)removeCacheMessage:(CSIMSendMessageRequestModel *)message
{
    if (message.body.msgCacheKey) {
        [self.messages removeObjectForKey:message.body.msgCacheKey];
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
    CSIMSendMessageRequestModel * msg = [self.allSendMessages objectForKey:message.body.receiptId];
    if (msg) {
        return msg;
    }
    return msg;
}

- (void)asynsDownLoaderVoiceWithModel:(CSMessageModel *)messageModel
                            success:(TTSuccessBlock)success
                                 fail:(TTFailureBlock)fail
{
    MCDownloadReceipt * downloader = [[MCDownloader sharedDownloader] downloadDataWithURL:[NSURL URLWithString:messageModel.body.content] progress:^(NSInteger receivedSize, NSInteger expectedSize, NSInteger speed, NSURL * _Nullable targetURL) {
        
    } completed:^(MCDownloadReceipt * _Nullable receipt, NSError * _Nullable error, BOOL finished) {
        if (error && fail) {
            fail(error);
        }
        else
        {
            if (success) {
                messageModel.fileLocalPath = receipt.filePath;
                success(messageModel);
            }
        }
    }];
    
}

- (void)clean
{
    [self.messages removeAllObjects];
    [self.allSendMessages removeAllObjects];
}
@end
