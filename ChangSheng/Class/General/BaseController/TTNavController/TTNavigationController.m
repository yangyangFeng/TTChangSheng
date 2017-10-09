//
//  TTNavigationController.m
//  TTCustomNavicaitonController
//
//  Created by 邴天宇 on 16/12/15.
//  Copyright © 2015年 邴天宇. All rights reserved.
//

#import "TTNavigationController.h"
#import "UINavigationController+JZExtension.h"
@interface TTNavigationController ()
@property(nonatomic,assign)UIStatusBarStyle ststusBarStyle;
@end

@implementation TTNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationBar.translucent = NO;
    [self setNavigationBarHidden:NO];       // 使导航条有效
    [self.navigationBar setHidden:YES];     // 隐藏导航条，但由于导航条有效，系统的返回按钮页有效，所以可以使用系统的右滑返回手势。
    self.ststusBarStyle = UIStatusBarStyleDefault;
//    [self navigationCanDragBack:NO];    //取消左滑动返回
    self.fullScreenInteractivePopGestureRecognizer = YES;
    
    self.interactivePopGestureRecognizer.delaysTouchesBegan=NO;
    // Do any additional setup after loading the view.
}

- (void)whiteStatusBar
{
    self.ststusBarStyle = UIStatusBarStyleLightContent;
    [self setNeedsStatusBarAppearanceUpdate];
}
- (void)blackStatusBar
{
    self.ststusBarStyle = UIStatusBarStyleDefault;
    [self setNeedsStatusBarAppearanceUpdate];
}

// 是否可右滑返回
- (void)navigationCanDragBack:(BOOL)dragBack
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)
    {
        self.interactivePopGestureRecognizer.enabled = dragBack;
    }else{}
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{

    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{

   return [self popViewControllerAnimated:YES completion:^(BOOL finished) {
    }];
    
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return self.ststusBarStyle;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationFade;
}
@end
