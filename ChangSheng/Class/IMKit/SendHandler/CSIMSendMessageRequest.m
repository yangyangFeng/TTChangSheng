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
#import "TTSocketChannelManager.h"
@implementation CSIMSendMessageRequest
+ (void)sendMessage:(id)message
     successBlock:(sendSuccess)success
        failBlock:(sendFail)fail
{
    CSIMSendMessageRequestModel * msgRequestModel = (CSIMSendMessageRequestModel *)message;
    //将发送的消息缓存
    [[CSIMMessageQueueManager shareInstance] insertMessage:message];
    
    [[TTSocketChannelManager shareInstance] sendMessage:[msgRequestModel.body changeParams].mj_JSONString];
    
    
    msgRequestModel.sendNumber += 1;
    
    msgRequestModel.sendStatus = IM_Sending;
//    msgRequestModel.msgStatus 
    Deferred * sendMsgDeferred = (Deferred *)[msgRequestModel.msgStatus on:[CSIMSendMessageManager shareInstance].queue];
//    (Deferred*)[[Deferred alloc]timeout:10];
//    msgRequestModel.msgStatus;
    
    
    [sendMsgDeferred when:^(id obj) {
        //发送成功后,将此条消息移除缓存
        [[CSIMMessageQueueManager shareInstance] removeMessages:message];
        NSLog(@"消息已发送成功--request");
        msgRequestModel.sendStatus = IM_SendSuccessed;
        [[CSIMMessageQueueManager shareInstance] removeCacheMessage:msgRequestModel];
        if (success) {
            success(obj);
        }
        
    } failed:^(NSError *error) {
        //发送失败后,将此条消息移除缓存
        [[CSIMMessageQueueManager shareInstance] removeMessages:message];
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
