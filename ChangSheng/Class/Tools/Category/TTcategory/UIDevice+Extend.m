//
//  UIDevice+Extend.m
//  CoreCategory
//
//  Created by 成林 on 15/5/6.
//  Copyright (c) 2015年 沐汐. All rights reserved.
//

#import "UIDevice+Extend.h"

@implementation UIDevice (Extend)
+ (BOOL)isSystemVersioniOS8
{
    //check systemVerson of device
    UIDevice* device = [UIDevice currentDevice];
    float sysVersion = [device.systemVersion floatValue];

    if (sysVersion >= 8.0f) {
        return YES;
    }
    return NO;
}

/**
  *  check if user allow local notification of system setting
    *
  *  @return YES-allowed,otherwise,NO.
    */
+ (BOOL)isAllowedNotification
{
    //iOS8 check if user allow notification
    if ([UIDevice isSystemVersioniOS8]) { // system is iOS8
        UIUserNotificationSettings* setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (UIUserNotificationTypeNone != setting.types) {
            return YES;
        }
    }
    else { //iOS7
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if (UIRemoteNotificationTypeNone != type)
            return YES;
    }

    return NO;
}
@end
