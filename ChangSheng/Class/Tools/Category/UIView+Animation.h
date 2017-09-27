//
//  UIView+Animation.h
//  bjsgecl
//
//  Created by Rocky on 15/7/19.
//  Copyright (c) 2015年 zcbl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Animation)
//添加出现和缩放动画
+ (void)addAnimationToView:(UIView *)view;
//点赞按钮动画
- (void)popOutsideWithDuration:(NSTimeInterval)duration;
@end
