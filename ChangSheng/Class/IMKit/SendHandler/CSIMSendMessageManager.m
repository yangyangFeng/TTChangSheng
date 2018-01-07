//
//  CSIMSendMessageManager.m
//  TestAAA
//
//  Created by cnepayzx on 2017/9/25.
//  Copyright © 2017年 bingtianyu. All rights reserved.
//

#import "CSIMSendMessageManager.h"
#import "CSNewWorkHandler.h"

static CSIMSendMessageManager * msgManager = nil;

@interface CSIMSendMessageManager ()

/** 定时器(这里不用带*，因为dispatch_source_t就是个类，内部已经包含了*) */
@property (nonatomic, strong) dispatch_source_t timer;
@property(nonatomic,strong)NSThread * sendDeviceCommondThread;
@end

@implementation CSIMSendMessageManager
+ (CSIMSendMessageManager *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        msgManager = [CSIMSendMessageManager new];
        [msgManager createMsgQueue];
    });
    return msgManager;
}

- (void)sendMessage:(id)message
{
    if (!self.timer) {
        [self createGCDTimer];
    }
    @synchronized(self) {
//        NSLog(@"正在转发");
        [self performSelector:@selector(forwardMessage:) onThread:[[self class] sendDeviceCommondThread] withObject:message waitUntilDone:NO modes:@[NSRunLoopCommonModes]];
    }
}

- (void)sendMessages:(NSArray *)messages
{
    @synchronized(self) {
        for (id message in messages) {
            [self performSelector:@selector(forwardMessage:) onThread:[[self class] sendDeviceCommondThread] withObject:message waitUntilDone:NO modes:@[NSRunLoopCommonModes]];
        }
    }
}

- (void)sendMessage:(id)message
       successBlock:(sendSuccess)success
          failBlock:(sendFail)fail
{
    @synchronized(self) {
//        NSLog(@"正在转发");
        [self performSelector:@selector(forwardMessage:successBlock:failBlock:) onThread:[[self class] sendDeviceCommondThread] withObject:message waitUntilDone:NO modes:@[NSRunLoopCommonModes]];
    }
}


- (void)forwardMessage:(id)message
{
    if (([TTSocketChannelManager shareInstance].webSocket.readyState != SR_OPEN) ||
        [CSNewWorkHandler sharedInstance].networkError) {
        NSLog(@"发送\n-------------------------------------------\n%@\n---------------------------------------",message);
        CSIMSendMessageRequestModel * request = (CSIMSendMessageRequestModel *)message;
        [request.msgStatus reject:[NSError errorWithDomain:@"网络连接已断开." code:201 userInfo:nil]];
        return;
    }

//    NSLog(@"转发消息%@\n当前线程->%@",message,[NSThread currentThread]);
    [CSIMSendMessageRequest sendMessage:message successBlock:^(id obj) {
        
    } failBlock:^(NSError *error) {
        
    }];
}

- (void)forwardMessage:(id)message
       successBlock:(sendSuccess)success
          failBlock:(sendFail)fail
{
    
}
+ (NSThread *)sendDeviceCommondThread
{
    static NSThread *_sendDeviceCommondThread = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sendDeviceCommondThread = [[NSThread alloc] initWithTarget:self selector:@selector(sendDeviceCommondThreadEntryPoint:) object:nil];
        [_sendDeviceCommondThread start];
    });
    return _sendDeviceCommondThread;
}

- (void)createGCDTimer
{
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, self.queue);
    
    // GCD的时间参数，一般是纳秒（1秒 == 10的9次方纳秒）
    // 何时开始执行第一个任务
    // dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC) 比当前时间晚3秒
    //起始时间
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15.0 * NSEC_PER_SEC));
    //间隔时间
    uint64_t interval = (uint64_t)(5.0 * NSEC_PER_SEC);
    dispatch_source_set_timer(self.timer, start, interval, 0);
    
    // 设置回调
    dispatch_source_set_event_handler(self.timer, ^{
        
#ifdef CS_SWITCH_RESEND_MESSAGE
        //发送失败的消息从发
//        NSArray * messages = [[CSIMMessageQueueManager shareInstance] resendCacheMessage];
//        [self sendMessages:messages];
#endif
        //心跳设置
        [self postPingRequest];
    });
    
    // 启动定时器
    dispatch_resume(self.timer);
}

- (void)stopGCDTimer
{
    // 取消定时器
    dispatch_cancel(self.timer);
    self.timer = nil;
}
//发送心跳请求
- (void)postPingRequest
{
    [[TTSocketChannelManager shareInstance] sendPing];
}

+ (void) sendDeviceCommondThreadEntryPoint:(id)object
{
    @autoreleasepool {
        [[NSThread currentThread] setName:@"SendMessage"];
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        [runLoop run];
    }
}

-(id)initWithQueue:(dispatch_queue_t)queue
{
    if (self = [super init]) {
        
    }
    return self;
}

- (dispatch_queue_t)createMsgQueue
{
    dispatch_queue_t quque = dispatch_queue_create("sendmsg.queue", DISPATCH_QUEUE_CONCURRENT);
    return quque;
}
@end
