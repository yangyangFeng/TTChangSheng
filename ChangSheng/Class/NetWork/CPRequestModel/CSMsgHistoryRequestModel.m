//
//  CSMsgHistoryRequestModel.m
//  ChangSheng
//
//  Created by 邴天宇 on 17/9/27.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSMsgHistoryRequestModel.h"

@implementation CSMsgHistoryRequestModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        //客户端固定传2
        _receive_user_type = 2;
    }
    return self;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id"};
}
@end
