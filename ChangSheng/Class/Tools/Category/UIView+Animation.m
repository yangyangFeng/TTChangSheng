//
//  UIView+Animation.m
//  bjsgecl
//
//  Created by Rocky on 15/7/19.
//  Copyright (c) 2015年 zcbl. All rights reserved.
//

#import "UIView+Animation.h"

@implementation UIView (Animation)
+ (void)addAnimationToView:(UIView *)view{
    
    view.hidden = NO;
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:2.0];
    scaleAnimation.toValue = [NSNumber numberWithFloat:1.0];
    scaleAnimation.duration = 0.8f;
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    opacityAnimation.toValue = [NSNumber numberWithFloat:1.0];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 0.8f;
    animationGroup.autoreverses = NO;   //是否重播，原动画的倒播
    animationGroup.repeatCount = 1;//HUGE_VALF;     //HUGE_VALF,源自math.h
    [animationGroup setAnimations:[NSArray arrayWithObjects:scaleAnimation, opacityAnimation, nil]];
    
    [view.layer addAnimation:animationGroup forKey:@"animationGroup"];
    
}

- (void)popOutsideWithDuration:(NSTimeInterval)duration {
    __weak typeof(self) weakSelf = self;
    self.transform = CGAffineTransformIdentity;
    [UIView animateKeyframesWithDuration:duration delay:0 options:0 animations: ^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1 / 3.0 animations: ^{
            typeof(self) strongSelf = weakSelf;
            strongSelf.transform = CGAffineTransformMakeScale(1.5, 1.5);
        }];
        [UIView addKeyframeWithRelativeStartTime:1/3.0 relativeDuration:1/3.0 animations: ^{
            typeof(self) strongSelf = weakSelf;
            strongSelf.transform = CGAffineTransformMakeScale(0.8, 0.8);
        }];
        [UIView addKeyframeWithRelativeStartTime:2/3.0 relativeDuration:1/3.0 animations: ^{
            typeof(self) strongSelf = weakSelf;
            strongSelf.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
    } completion:nil];
    
}
@end
