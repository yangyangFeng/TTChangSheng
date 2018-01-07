//
//  AppDelegate.m
//  ChangSheng
//
//  Created by 邴天宇 on 17/9/22.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "AppDelegate.h"

#import "TTSocketChannelManager.h"
#import "StoryBoardController.h"
#import "TTNavigationController.h"
#import "IQKeyboardManager.h"
#import "CSMessageModel.h"
#import "CSHomeViewController.h"
#import "CSLoginHandler.h"
#import <JhtGuidePages/JhtGradientGuidePageVC.h>
#import <Bugly/Bugly.h>

#import "CSUserServiceListViewController.h"
#import "CSMineViewController.h"
#import "CSFriendsListViewController.h"
#import "TTNavigationController.h"
#import "AppDelegate+JPush.h"
#import "CSBaseTabBarViewController.h"
@interface AppDelegate ()
/** 引导页VC */
@property (nonatomic, strong) JhtGradientGuidePageVC *introductionView;
@property (nonatomic, strong) CSBaseTabBarViewController * rootViewController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self thirdService_application:application launchOptions:launchOptions];
    // Override point for customization after application launch.
    [Bugly startWithAppId:@"7392769854"];
#ifdef DEBUG
    [iConsole sharedConsole].delegate = self;
    // 日志提交邮箱
    [iConsole sharedConsole].logSubmissionEmail = @"bingty@cnepay.com";
    // 摇晃手机显示日志
    [iConsole sharedConsole].deviceShakeToShow = YES;
#else
    UIWindow * window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window = window;
    
#endif
    if ([CSUserInfo shareInstance].isOnline) {
        [self setupViewControllers];
        
//        CSHomeViewController * home = [CSHomeViewController new];
//         TTNavigationController * nav = [[TTNavigationController alloc]initWithRootViewController:home];
////        self.window.rootViewController = nav;
//        self.rootViewController = nav;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [CSLoginHandler openSocket];
//        });
        [CSLoginHandler initDB];
    }
    else
    {
        UIViewController * rootC = [StoryBoardController viewControllerID:@"CSLoginViewController" SBName:@"CSLoginSB"];
        TTNavigationController * nav = [[TTNavigationController alloc]initWithRootViewController:rootC];
//        self.window.rootViewController = nav;
        self.rootViewController = nav;
    }
//    [self.window makeKeyAndVisible];
//    self.rootViewController = self.window.rootViewController;
    
    // 创建引导页
    [self createGuideVC];

    
 
    IQKeyboardManager * IQKManager = [IQKeyboardManager sharedManager];
    
    [IQKeyboardManager sharedManager].shouldToolbarUsesTextFieldTintColor = NO;
    [IQKeyboardManager sharedManager].toolbarTintColor = [UIColor brownColor];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    IQKManager.enableAutoToolbar = NO; // 控制是否显示键盘上的工具条
    IQKManager.toolbarTintColor = [UIColor greenColor];
//    CSMessageModel * as = [CSMessageModel new];
//    NSLog(@"%@",as.mj_JSONString);
//    sleep(1);
    return YES;
}

/** 创建引导页 */
- (void)createGuideVC {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *firstKey = [NSString stringWithFormat:@"isFirst%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    NSString *isFirst = [defaults objectForKey:firstKey];
    NSArray * imageArray = @[@"1引导页1080", @"2引导页1080", @"3引导页1080"];
    if (!isFirst.length) {
   
        UIButton *enterButton = [[UIButton alloc] init];
        [enterButton setTitle:@"立即进入" forState:UIControlStateNormal];
        [enterButton setBackgroundColor:rgb(41, 177, 80)];
        enterButton.layer.cornerRadius = 5.0;
  
        
        self.introductionView = [[JhtGradientGuidePageVC alloc]initWithGuideImageNames:imageArray withLastRootViewController:self.rootViewController];

        self.introductionView.enterButton =  enterButton;
        // 添加《跳过》按钮
        self.introductionView.isNeedSkipButton = YES;
        /******** 更多个性化配置见《JhtGradientGuidePageVC.h》 ********/
        
        self.window.rootViewController = self.introductionView;
        
        __weak AppDelegate *weakSelf = self;
        self.introductionView.didClickedEnter = ^() {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *firstKey = [NSString stringWithFormat:@"isFirst%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
            NSString *isFirst = [defaults objectForKey:firstKey];
            if (!isFirst) {
                [defaults setObject:@"notFirst" forKey:firstKey];
                [defaults synchronize];
            }

            weakSelf.introductionView = nil;
        };
    } else {
        self.window.rootViewController = self.rootViewController;
    }
}

- (void)joinHomeController
{
    [self setupViewControllers];
    self.window.rootViewController = self.rootViewController;
}

- (void)setupViewControllers {
    
    CSHomeViewController * home = [CSHomeViewController new];
    TTNavigationController * nav0 = [[TTNavigationController alloc]initWithRootViewController:home];
    
    CSFriendsListViewController * friend = [CSFriendsListViewController new];
    TTNavigationController * nav1 = [[TTNavigationController alloc]initWithRootViewController:friend];
    
    CSUserServiceListViewController * userSer = [CSUserServiceListViewController new];
    TTNavigationController * nav2 = [[TTNavigationController alloc]initWithRootViewController:userSer];
    
    UIViewController * zhangfang = [StoryBoardController viewControllerID:@"CSZhangFangViewController" SBName:@"ZhangFang"];
    TTNavigationController * nav3 = [[TTNavigationController alloc]initWithRootViewController:zhangfang];
    
    CSMineViewController * mine = [CSMineViewController new];
    TTNavigationController * nav4 = [[TTNavigationController alloc]initWithRootViewController:mine];
    
    CSBaseTabBarViewController *tabBarController = [[CSBaseTabBarViewController alloc] init];
    [self customizeTabBarForController:tabBarController];
    
    [tabBarController setViewControllers:@[
                                           nav0,
                                           nav1,
                                           nav2,
                                           nav3,
                                           nav4
                                           ]];
    self.rootViewController = tabBarController;
}

/*
 *
 在`-setViewControllers:`之前设置TabBar的属性，
 *
 */
- (void)customizeTabBarForController:(CYLTabBarController *)tabBarController {
    
    NSDictionary *dict0 = @{
                            CYLTabBarItemTitle : @"娱乐场",
                            CYLTabBarItemImage : @"娱乐场",
                            CYLTabBarItemSelectedImage : @"娱乐场点击",
                            };
    NSDictionary *dict1 = @{
                            CYLTabBarItemTitle : @"乐友",
                            CYLTabBarItemImage : @"乐友",
                            CYLTabBarItemSelectedImage : @"乐友点击",
                            };
    NSDictionary *dict2 = @{
                            CYLTabBarItemTitle : @"客服",
                            CYLTabBarItemImage : @"客服",
                            CYLTabBarItemSelectedImage : @"客服点击",
                            };
    NSDictionary *dict3 = @{
                            CYLTabBarItemTitle : @"账房",
                            CYLTabBarItemImage : @"账房",
                            CYLTabBarItemSelectedImage : @"账房点击",
                            };
    NSDictionary *dict4 = @{
                            CYLTabBarItemTitle : @"我的",
                            CYLTabBarItemImage : @"我的",
                            CYLTabBarItemSelectedImage : @"我的点击",
                            };
    NSArray *tabBarItemsAttributes = @[ dict0, dict1, dict2 ,dict3, dict4];
    tabBarController.tabBarItemsAttributes = tabBarItemsAttributes;
    tabBarController.tabBar.tintColor = [UIColor colorWithHexColorString:@"24BC7F"];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    if ([CSUserInfo shareInstance].isOnline) {
        [[TTSocketChannelManager shareInstance] checkSocketStatus];//检测socker连接状态
    }
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - getting

- (UIWindow *)window {
    if (_window == nil) {
        _window = [[iConsoleWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

        [_window setBackgroundColor:[UIColor whiteColor]];
        [_window makeKeyAndVisible];
    }
    return _window;
}
@end
