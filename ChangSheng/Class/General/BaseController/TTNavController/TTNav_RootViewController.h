//
//  TTNav_RootViewController.h
//  navcontroller
//
//  Created by 邴天宇 on 17/12/15.
//  Copyright © 2015年 邴天宇. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TTBaseNavigationBar.h"
#import "TTNavigationBar.h"
#import "CSBaseViewController.h"
@interface TTNav_RootViewController : CSBaseViewController
@property (nonatomic,strong)TTNavigationBar * myNavigationBar;
/**
 *  设置Controller Title
 */
- (void)tt_Title:(NSString *)title;

/**
 给title设置颜色
 */
- (void)tt_TitleTextColor:(UIColor *)color;
/**
 *  当前navbar
 */
- (TTNavigationBar *)tt_navigationBar;
/**
 *  左边默认按钮
 */
- (UIButton*)backBarButtonItem;
/**
 *  右边默认按钮
 */
- (UIButton*)rightBarButtonItem;
/**
 *  替换navbar
 */
- (void)tt_ReplaceNaviBarView:(TTBaseNavigationBar*)naviBarView;
/**
 *  设置 自定义 导航栏隐藏
 */
- (void)tt_SetNaviBarHide:(BOOL)hide withAnimation:(BOOL)animation;
/**
 *  设置默认按钮显示 default is YES
 */
- (void)tt_DefaultNaviBarSetLeftViewHidden:(BOOL)hidden;
- (void)tt_DefaultNaviBarSetRightViewHidden:(BOOL)hidden;

- (void)tt_Alpha:(CGFloat)alpha;
/**
 *  右侧按钮触发方法
 */
- (void)tt_DefaultRightBtnClickAction;

- (void)tt_DefaultLeftBtnClickAction;
/**
 *  基类方法
 */
- (UIViewController *)addChildTableViewController:(UIViewController *)childController;
@end
