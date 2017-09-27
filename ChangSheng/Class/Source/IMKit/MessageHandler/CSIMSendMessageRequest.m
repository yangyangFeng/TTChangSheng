//
//  CSIMSendMessageRequest.m
//  TestAAA
//
//  Created by cnepayzx on 2017/9/25.
//  Copyright © 2017年 bingtianyu. All rights reserved.
//

#import "CSIMSendMessageRequest.h"
#import "CSIMSendMessageRequestModel.h"
#import "Deferred.h"
#import "CSIMMessageQueueManager.h"
#import "CSIMSendMessageManager.h"
@implementation CSIMSendMessageRequest
+ (void)sendMessage:(id)message
     successBlock:(sendSuccess)success
        failBlock:(sendFail)fail
{
//    NSLog(@"消息正在发送");
    CSIMSendMessageRequestModel * msgRequestModel = (CSIMSendMessageRequestModel *)message;
    
    msgRequestModel.sendNumber += 1;
    
    
    
    msgRequestModel.sendStatus = IM_Sending;
//    msgRequestModel.msgStatus 
    Deferred * sendMsgDeferred = (Deferred *)[msgRequestModel.msgStatus on:[CSIMSendMessageManager shareInstance].queue];
//    (Deferred*)[[Deferred alloc]timeout:10];
//    msgRequestModel.msgStatus;
    
    
    
    [sendMsgDeferred when:^(id obj) {
        NSLog(@"消息已发送成功--request");
        msgRequestModel.sendStatus = IM_SendSuccessed;
        [[CSIMMessageQueueManager shareInstance] removeCacheMessage:msgRequestModel];
        if (success) {
            success(obj);
        }
    } failed:^(NSError *error) {
        NSLog(@"发送失败   count%d",msgRequestModel.sendNumber              );
        
        msgRequestModel.sendStatus = IM_SendFailed;
        [msgRequestModel.msgStatus clearPromiseState];
        if (msgRequestModel.sendNumber == 1)
        {
            
            return [[CSIMSendMessageManager shareInstance] sendMessage:message];
            
        }
        
        else if (msgRequestModel.sendNumber < CS_IM_MAX_RESEND_NUMBER ) {
            if (msgRequestModel.sendNumber == 2) {
                if (fail) {
                    fail(error);
                }
            }
            [[CSIMMessageQueueManager shareInstance] cacheMessage:msgRequestModel];
        }
        else
        {
            if (fail) {
                fail(error);
            }
        }
    }];

    
}





@end
