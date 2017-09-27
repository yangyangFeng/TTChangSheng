//
//  UIScrollView+MJFooterHeader.h
//  GoPlay
//
//  Created by 邴天宇 on 11/4/16.
//  Copyright © 2016年 邴天宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (MJFooterHeader)
/**
 *  检测 foot 状态
 *
 *  @param dataCount 返回数据 count
 *  @param size      pagesize
 */
- (void)tt_checkFooterState:(NSInteger)dataCount size:(NSInteger)size;
@end
