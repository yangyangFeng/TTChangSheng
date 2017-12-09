//
//  CSFriendListModel.m
//  ChangSheng
//
//  Created by 邴天宇 on 2017/12/9.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSFriendListModel.h"


@implementation CSFriendListModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"result":[self class],
             @"friends":[CSFriendListItemModel class]
             };
}
@end

@implementation CSFriendListItemModel

@end
