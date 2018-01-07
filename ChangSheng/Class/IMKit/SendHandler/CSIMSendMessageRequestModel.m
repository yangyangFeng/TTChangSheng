//
//  CSIMSendMessageRequestModel.m
//  TestAAA
//
//  Created by cnepayzx on 2017/9/25.
//  Copyright © 2017年 bingtianyu. All rights reserved.
//

#import "CSIMSendMessageRequestModel.h"

@implementation CSIMSendMessageRequestModel

- (id)initWithChatType:(CS_Message_Record_Type)chatType
{
    if (self = [super init]) {
        self.chatType = chatType;
    }
    return self;
}

-(instancetype)init
{
    if (self = [super init]) {
        //        _msgStatus = (Deferred*)[[Deferred alloc] timeout:CSIM_SENDMESSAGE_TIME_OUT];
        _sendNumber = 0;
        _sendStatus = IM_Send_No;
    }
    return self;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"body":@"result"};
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"unreadList" : [CSIMUnReadListModel class]};
}

-(void)setBody:(CSMessageModel *)body
{
    _body = body;
    _body.cs_chatType = self.chatType;
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
    self.body.body.msgId = message.body.receiptId;
}

- (void)successed
{
    [self.body internal_setMessageStatus:kCSMessageStatusSuccessed];
}

- (void)failed
{
    [self.body internal_setMessageStatus:kCSMessageStatusFailed];
}

- (NSString *)msgId
{
    return _body.body.msgId;
}
- (NSString *)msgCode
{
    return _body.body.msgId;
}
- (NSString *)msgCacheKey
{
    return _body.msgCacheKey;
}

-(Deferred *)msgStatus
{
    if (!_msgStatus) {
        _msgStatus = (Deferred*)[[Deferred alloc] timeout:CSIM_SENDMESSAGE_TIME_OUT];
    }
    return _msgStatus;
}
@end

@implementation CSIMUnReadListModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"chatList" : [CSMessageModel class]};
}
@end

