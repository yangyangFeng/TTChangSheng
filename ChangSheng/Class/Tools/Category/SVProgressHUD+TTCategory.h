//
//  SVProgressHUD+TTCategory.h
//  GoPlay
//
//  Created by 邴天宇 on 3/1/16.
//  Copyright © 2016年 邴天宇. All rights reserved.
//

#import <SVProgressHUD/SVProgressHUD.h>

@interface SVProgressHUD (TTCategory)
+ (void)TT_showTitle:(NSString *)title;
+ (void)TT_showTitle:(NSString *)title delay:(NSTimeInterval)time;
+ (void)TT_showError:(NSString *)title;
+ (void)TT_showSuccess:(NSString *)title;
@end
