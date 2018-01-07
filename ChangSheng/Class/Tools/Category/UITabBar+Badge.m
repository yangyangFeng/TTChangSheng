//
//  UITabBar+Badge.m
//  ChangSheng
//
//  Created by 邴天宇 on 2018/1/7.
//  Copyright © 2018年 邴天宇. All rights reserved.
//

#import "UITabBar+Badge.h"

#define TabbarItemNums 5

@implementation UITabBar (Badge)
//显示红点
- (void)showBadgeOnItemIndex:(int)index badge:(int)badge{
    [self removeBadgeOnItemIndex:index];
    if (!badge) {
        return;
    }
    //新建小红点
    UILabel *bview = [[UILabel alloc]init];
    bview.text = [NSString stringWithFormat:@"%d",badge];
    bview.textAlignment = NSTextAlignmentCenter;
    bview.textColor = [UIColor whiteColor];
    bview.font = [UIFont systemFontOfSize:9];
    bview.tag = 888+index;
    bview.layer.cornerRadius = 15/2.0;
    bview.clipsToBounds = YES;
    bview.backgroundColor = [UIColor redColor];
    CGRect tabFram = self.frame;
    
    float percentX = (index+0.6)/TabbarItemNums;
    CGFloat x = ceilf(percentX*tabFram.size.width);
    CGFloat y = ceilf(0.1*tabFram.size.height);
    bview.frame = CGRectMake(x, y, 15, 15);
    [self addSubview:bview];
    [self bringSubviewToFront:bview];
}
//隐藏红点
-(void)hideBadgeOnItemIndex:(int)index badge:(int)badge{
    [self removeBadgeOnItemIndex:index];
}
//移除控件
- (void)removeBadgeOnItemIndex:(int)index{
    for (UIView*subView in self.subviews) {
        if (subView.tag == 888+index) {
            [subView removeFromSuperview];
        }
    }
}

@end
