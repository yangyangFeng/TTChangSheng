//
//  CSIMSendMessageRequestModel.m
//  TestAAA
//
//  Created by cnepayzx on 2017/9/25.
//  Copyright © 2017年 bingtianyu. All rights reserved.
//

#import "CSIMSendMessageRequestModel.h"

@implementation CSIMSendMessageRequestModel
-(instancetype)init
{
    if (self = [super init]) {
        _msgStatus = (Deferred*)[[Deferred alloc] timeout:CSIM_SENDMESSAGE_TIME_OUT];
        _sendNumber = 0;
        _sendStatus = IM_Send_No;
    }
    return self;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"body":@"result"};
}
- (id)mutableCopyWithZone:(NSZone * )zone
{
    CSIMSendMessageRequestModel * model = [CSIMSendMessageRequestModel new];
    model.msgCode = self.msgCode;
    model.sendNumber = self.sendNumber;
    model.msgStatus = self.msgStatus;
    return model;
}

- (void)createMsgStatus
{
    self.msgStatus = (Deferred*)[[Deferred alloc] timeout:CSIM_SENDMESSAGE_TIME_OUT];
}

- (void)syncMsgID:(CSIMSendMessageRequestModel *)message;
{
    self.result.msgId = message.result.msgId;
}

- (int)msgCode
{
    return _result.msgId;
}
@end
