//
//  UIScrollView+MJFooterHeader.m
//  GoPlay
//
//  Created by 邴天宇 on 11/4/16.
//  Copyright © 2016年 邴天宇. All rights reserved.
//

#import "UIScrollView+MJFooterHeader.h"

@implementation UIScrollView (MJFooterHeader)
- (void)tt_checkFooterState:(NSInteger)dataCount size:(NSInteger)size
{
    if (dataCount >= size)
    {
        [self.mj_footer resetNoMoreData];
    }
    else if (dataCount < size)
    {
        [self.mj_footer endRefreshingWithNoMoreData];
    }
}
@end
