//
//  StoryBoardController.m
//  GoPlay
//
//  Created by 邴天宇 on 26/12/15.
//  Copyright © 2015年 邴天宇. All rights reserved.
//

#import "StoryBoardController.h"

@implementation StoryBoardController
+ (UIViewController *)storyBoardName:(NSString *)name ViewControllerIdentifiter:(NSString *)identifiter
{
    UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:name bundle:nil];
    UIViewController * viewController = [storyBoard instantiateViewControllerWithIdentifier:identifiter];
    return viewController;
}
    
+ (UIViewController *)viewControllerID:(NSString *)identifiter SBName:(NSString *)sb_name
{
    UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:sb_name bundle:nil];
    UIViewController * viewController = [storyBoard instantiateViewControllerWithIdentifier:identifiter];
    return viewController;
}
@end
