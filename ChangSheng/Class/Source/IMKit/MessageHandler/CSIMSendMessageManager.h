//
//  CSIMSendMessageManager.h
//  TestAAA
//
//  Created by cnepayzx on 2017/9/25.
//  Copyright © 2017年 bingtianyu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CSIMSendMessageRequest.h"
#import "CSIMMessageQueueManager.h"
#import "CSIMSendMessageRequestModel.h"


@interface CSIMSendMessageManager : NSObject
+ (CSIMSendMessageManager *)shareInstance;

@property(nonatomic,strong)dispatch_queue_t  queue;

- (void)createGCDTimer;
- (void)stopGCDTimer;

- (void)sendMessage:(id)message;
@end
