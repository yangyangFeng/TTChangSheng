//
//  TTRefresh.m
//  ChangSheng
//
//  Created by cnepayzx on 2017/10/19.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "TTRefresh.h"

@implementation TTRefresh
+ (id)tt_headeRefresh:(MJRefreshComponentRefreshingBlock)block;
{
    return [MJRefreshNormalHeader headerWithRefreshingBlock:block];
}
@end
