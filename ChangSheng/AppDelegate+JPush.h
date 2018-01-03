////
////  AppDelegate+JPush.h
////  ChangSheng
////
////  Created by 邴天宇 on 2018/1/2.
////  Copyright © 2018年 邴天宇. All rights reserved.
////
//
//#import <Bugly/Bugly.h>
//
//@interface AppDelegate (JPush)
//- (void)thirdService_application:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions
//{
//
//    
//    //  Bugly的初始化要放到友盟统计的后面 当bugly使用完handler的时候会返回给友盟，防止bugly没有捕获到bug
//    BuglyConfig *config = [[BuglyConfig alloc]init];
//    config.blockMonitorEnable = YES;
//    config.channel = CHANNEL_STRING;
//    config.blockMonitorTimeout = 1.0;
//    config.viewControllerTrackingEnable = NO;
//    [Bugly startWithAppId:@"0c0be2e975" config:config];
//    
//    //极光推送
//    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
//    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
//        // 可以添加自定义categories
//        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
//        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
//    }
//    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
//    
//    
//    [JPUSHService setupWithOption:launchOptions appKey:@"4d0729fa2433c8242bb3ce7c"
//                          channel:nil
//                 apsForProduction:isForProduction
//            advertisingIdentifier:nil];
//}
//
////- (void)redirectNSLogToDocumentFolder
////{
////    //如果已经连接Xcode调试则不输出到文件
////    if(isatty(STDOUT_FILENO)) {
////        return;
////    }
////    UIDevice *device = [UIDevice currentDevice];
////    if([[device model] hasSuffix:@"Simulator"]){ //在模拟器不保存到文件中
////        return;
////    }
////    //将NSlog打印信息保存到Document目录下的Log文件夹下
////    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
////    NSString *logDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Log"];
////    NSFileManager *fileManager = [NSFileManager defaultManager];
////    BOOL fileExists = [fileManager fileExistsAtPath:logDirectory];
////    if (!fileExists) {
////        [fileManager createDirectoryAtPath:logDirectory  withIntermediateDirectories:YES attributes:nil error:nil];
////    }
////    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
////    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
////    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; //每次启动后都保存一个新的日志文件中
////    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
////    NSString *logFilePath = [logDirectory stringByAppendingFormat:@"/%@.log",dateStr];
////    // 将log输入到文件
////    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
////    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
////}
//
//#pragma mark- JPUSHRegisterDelegate
//
//- (void)application:(UIApplication *)application
//didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
//    
//    /// Required - 注册 DeviceToken
//    [JPUSHService registerDeviceToken:deviceToken];
//}
//
//- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
//    //Optional
//    CPLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
//}
//
//// iOS 10 Support
//- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
//    // Required
//    NSDictionary * userInfo = notification.request.content.userInfo;
//    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        [JPUSHService handleRemoteNotification:userInfo];
//    }
//    completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionSound); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
//}
//
//// iOS 10 Support
//- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
//    // Required
//    NSDictionary * userInfo = response.notification.request.content.userInfo;
//    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        [JPUSHService handleRemoteNotification:userInfo];
//    }
//    completionHandler();  // 系统要求执行这个方法
//}
//
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
//    
//    // Required, iOS 7 Support
//    [JPUSHService handleRemoteNotification:userInfo];
//    
//    completionHandler(UIBackgroundFetchResultNewData);
//}
//
//- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
//    
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
//        
//    } else {
//        
//        [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
//    }
//    
//}
//
//- (void)applicationDidBecomeActive:(UIApplication *)application {
//    
//    [application setApplicationIconBadgeNumber:0];
//    [JPUSHService setBadge:0];
//    return;
//}
//@end

