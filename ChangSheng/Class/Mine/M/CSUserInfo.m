//
//  CSUserInfo.m
//  ChangSheng
//
//  Created by 邴天宇 on 17/9/24.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSUserInfo.h"

static CSUserInfo * info = nil;
@implementation CSUserInfo

{
    BOOL isOnline;
}

+ (CSUserInfo *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        info = [CSUserInfo new];
    });
    return info;
}

-(void)login
{
    self->isOnline = YES;
}

-(void)logout
{
    self->isOnline = NO;
}

-(BOOL)isOnline
{
    return self->isOnline;
}
@end
