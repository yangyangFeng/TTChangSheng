//
//  TTNavigationController.h
//  TTCustomNavicaitonController
//
//  Created by 邴天宇 on 16/12/15.
//  Copyright © 2015年 邴天宇. All rights reserved.
//

#import <UIKit/UIKit.h>

//@protocol TTDrawerChild;

@interface TTNavigationController : UINavigationController 

// 是否可右滑返回
- (void)navigationCanDragBack:(BOOL)dragBack;

@end
