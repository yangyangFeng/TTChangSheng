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

- (void)cacheMessage:(CSIMSendMessageRequestModel *)message;

- (void)removeCacheMessage:(CSIMSendMessageRequestModel *)message;

- (NSArray *)resendCacheMessage;
@end
