//
//  MJRefreshAutoNormalFooter+TTFooter.m
//  GoPlay
//
//  Created by 邴天宇 on 11/4/16.
//  Copyright © 2016年 邴天宇. All rights reserved.
//

#import "MJRefreshAutoNormalFooter+TTFooter.h"

@implementation MJRefreshAutoNormalFooter (TTFooter)
+ (MJRefreshAutoNormalFooter *)tt_footerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock
{
    MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:refreshingBlock];

    footer.refreshingTitleHidden = YES;

    footer.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    return footer;
}

@end
