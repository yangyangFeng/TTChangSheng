//
//  CSIMSendMessageManager.h
//  TestAAA
//
//  Created by cnepayzx on 2017/9/25.
//  Copyright © 2017年 bingtianyu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CSIMSendMessageRequest.h"
#import "TTSocketChannelManager.h"
#import "CSIMMessageQueueManager.h"
#import "CSIMSendMessageRequestModel.h"

#define CS_SWITCH_RESEND_MESSAGE NO

@interface CSIMSendMessageManager : NSObject
+ (CSIMSendMessageManager *)shareInstance;

@property(nonatomic,strong)dispatch_queue_t  queue;

/**
 发送第一条消息时自动打开定时器
 */
- (void)createGCDTimer;
/**
 *  断开连接,退出登录.要关闭计时器
 */
- (void)stopGCDTimer;

- (void)sendMessage:(id)message;
@end
