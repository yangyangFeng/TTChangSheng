//
//  CSUserListResponse.m
//  ChangSheng
//
//  Created by 邴天宇 on 2018/1/9.
//  Copyright © 2018年 邴天宇. All rights reserved.
//

#import "CSUserListResponse.h"

@implementation CSUserListResponse
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"result":[self class]};
}
@end
