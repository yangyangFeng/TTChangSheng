//
//  CSMessageDBModel.m
//  ChangSheng
//
//  Created by cnepayzx on 2017/11/13.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSMessageDBModel.h"

@implementation CSMessageDBModel

@end

@implementation CSMsg_User
+ (NSString *)primaryKey
{
    return @"ID";
}
+ (NSArray *)indexedProperties {
    return @[@"userId"];
}

@end


@implementation CSMsg_User_Msg
- (instancetype)init
{
    self = [super init];
    if (self) {
        _isRead = NO;
    }
    return self;
}
+ (NSDictionary *)defaultPropertyValues {
    return @{@"img_width":@(0),
             @"img_height":@(0),
             @"voice_length":@(0),
             @"isMediaPlayed":@(NO)
             };
}
+ (NSString *)primaryKey
{
    return @"msg_id";
}
+ (NSArray *)indexedProperties {
    return @[@"content",@"msg_id"];
}
@end

@implementation CSCacheUserInfo

@end

