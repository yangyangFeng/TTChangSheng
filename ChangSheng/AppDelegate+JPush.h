//
//  AppDelegate+JPush.h
//  ChangSheng
//
//  Created by 邴天宇 on 2018/1/2.
//  Copyright © 2018年 邴天宇. All rights reserved.
//

#import <Bugly/Bugly.h>

#import "AppDelegate.h"

@interface AppDelegate (JPush)
- (void)thirdService_application:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions;
- (void)applicationDidBecomeActive:(UIApplication *)application;
- (void)redirectNSLogToDocumentFolder;
@end
