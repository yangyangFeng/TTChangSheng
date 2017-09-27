//
//  UIStoryboard+VireController.m
//  GoPlay
//
//  Created by 邴天宇 on 29/12/15.
//  Copyright © 2015年 邴天宇. All rights reserved.
//

#import "UIStoryboard+VireController.h"

@implementation UIStoryboard (VireController)
+(UIViewController *)storyboardName:(NSString *)boardName andIdentifiter:(NSString *)identifiter
{
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:boardName bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:identifiter];
}
@end
