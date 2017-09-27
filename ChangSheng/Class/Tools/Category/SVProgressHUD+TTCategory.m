//
//  SVProgressHUD+TTCategory.m
//  GoPlay
//
//  Created by 邴天宇 on 3/1/16.
//  Copyright © 2016年 邴天宇. All rights reserved.
//

#import "SVProgressHUD+TTCategory.h"

@implementation SVProgressHUD (TTCategory)
+ (void)TT_showTitle:(NSString *)title
{
    [self showWithStatus:title];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DISMISSTIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismiss];
    });
}
+ (void)TT_showTitle:(NSString *)title delay:(NSTimeInterval)time
{
    [self showWithStatus:title];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismiss];
    });
}
+ (void)TT_showError:(NSString *)title
{
    [self showErrorWithStatus:title];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DISMISSTIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismiss];
    });
}
+ (void)TT_showSuccess:(NSString *)title
{
    [self showSuccessWithStatus:title];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DISMISSTIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismiss];
    });
}
@end
