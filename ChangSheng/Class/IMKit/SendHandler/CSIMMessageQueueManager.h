//
//  CSIMMessageQueueManager.h
//  TestAAA
//
//  Created by cnepayzx on 2017/9/25.
//  Copyright © 2017年 bingtianyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CSIMSendMessageRequestModel;

@interface CSIMMessageQueueManager : NSObject
+ (CSIMMessageQueueManager *)shareInstance;

/**
 所有发出的消息都存到缓存里

 @param message 消息体
 */
- (void)insertMessage:(CSIMSendMessageRequestModel *)message;

/**
 移除已发送成功,或者失败的消息

 @param message 消息体
 */
- (void)removeMessages:(CSIMSendMessageRequestModel *)message;

/**
 发送失败的消息存到 失败消息的缓存中

 @param message 消息体
 */
- (void)cacheMessage:(CSIMSendMessageRequestModel *)message;

/**
 从新发送成功后从缓存当中移除本条信息
 
 @param message 消息体
 */
- (void)removeCacheMessage:(CSIMSendMessageRequestModel *)message;

/**
 将发送失败的消息全部返回

 @return <#return value description#>
 */
- (NSArray *)resendCacheMessage;
/**
 检测此条消息是否在缓存中

 @param message 消息体
 */
- (CSIMSendMessageRequestModel *)checkMessageContains:(CSIMSendMessageRequestModel *)message;


@end
