//
//  MBProgressHUD+TTHUD.h
//  GoPlay
//
//  Created by 邴天宇 on 22/1/16.
//  Copyright © 2016年 邴天宇. All rights reserved.
//

#import "MBProgressHUD.h"
static NSString* defaultTitle = @"  Loading  ";
@interface MBProgressHUD (TTHUD)
/**
 *  是否是显示状态
 */
@property (nonatomic, assign, readonly) BOOL isShow;
+ (void)tt_Show;
/**
 *  在window 中显示title
 */
+ (void)tt_ShowWithTitle:(NSString *)title;
/**
 *  改变title
 */
+ (void)tt_TitleChange:(NSString *)title;

+ (MBProgressHUD *)tt_progressShowInView:(UIView *)view;
/**
 *  从当前视图中显示title
 */
+ (void)tt_ShowInView:(UIView *)view WithTitle:(NSString *)title;

+ (void)tt_ShowInView:(UIView*)view WithTitle:(NSString*)title after:(CGFloat)time;
/**
 *  从当前视图中显示title -----> 自定义背景颜色
 *
 */
+ (void)tt_ShowInView:(UIView*)view WithTitle:(NSString*)title backColor:(UIColor *)color;
/**
 *  在当前视图中添加默认 文字的HUD 不自动隐藏
 */
+ (void)tt_ShowInViewDefaultTitle:(UIView *)view;
/**
 *  1秒后从 WINDOW 中隐藏
 */
+ (void)tt_Hide;
/**
 *  立即从当前视图中隐藏 HUD
 */
+ (void)tt_HideFromeView:(UIView *)view;
/**
 *  将当前视图中的HUD 隐藏
 */
+ (void)tt_HideFromeView:(UIView *)view after:(CGFloat)time;

/**
 *  直接在当前hud 上修改title
 */
+ (void)tt_ErrorTitle:(NSString *)title;
/**
 *  直接在当前hud 上修改
 */
+ (void)tt_SuccessTitle:(NSString *)title;

/**
 *  在当前视图上修改title
 */
+ (void)tt_ErrorInView:(UIView*)view WithTitle:(NSString*)title;
/**
 *  在当前视图上修改title
 *
 */
+ (void)tt_SuccessInView:(UIView*)view WithTitle:(NSString*)title;
@end
