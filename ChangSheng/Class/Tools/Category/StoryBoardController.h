//
//  StoryBoardController.h
//  GoPlay
//
//  Created by 邴天宇 on 26/12/15.
//  Copyright © 2015年 邴天宇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoryBoardController : NSObject
/**
 *  从storyboard中获取控制器
 *
 *  @param name        storyborad Name
 *  @param identifiter controller identifiter
 *
 *  @return 控制器
 */
+ (UIViewController *)storyBoardName:(NSString *)name ViewControllerIdentifiter:(NSString *)identifiter;

    

+ (UIViewController *)viewControllerID:(NSString *)identifiter SBName:(NSString *)sb_name;
@end
