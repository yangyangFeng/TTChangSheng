//
//  UITabBar+Badge.h
//  ChangSheng
//
//  Created by 邴天宇 on 2018/1/7.
//  Copyright © 2018年 邴天宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (Badge)
- (void)showBadgeOnItemIndex:(int)index badge:(int)badge;
- (void)hideBadgeOnItemIndex:(int)index badge:(int)badge;
@end
