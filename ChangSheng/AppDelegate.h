//
//  AppDelegate.h
//  ChangSheng
//
//  Created by 邴天宇 on 17/9/22.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYLTabBarController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong,readonly) CYLTabBarController * rootViewController;
- (void)joinHomeController;
@end

