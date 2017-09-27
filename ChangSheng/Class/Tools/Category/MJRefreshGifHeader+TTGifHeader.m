//
//  MJRefreshGifHeader+TTGifHeader.m
//  GoPlay
//
//  Created by 邴天宇 on 21/1/16.
//  Copyright © 2016年 邴天宇. All rights reserved.
//

#import "MJRefreshGifHeader+TTGifHeader.h"

@implementation MJRefreshGifHeader (TTGifHeader)
+ (MJRefreshGifHeader *)tt_headerWithRefreshingBlock:(void(^)())block
{
    MJRefreshGifHeader* headerRefresh = [MJRefreshGifHeader headerWithRefreshingBlock:block];
    headerRefresh.lastUpdatedTimeLabel.hidden = YES;

    return headerRefresh;
}
@end

