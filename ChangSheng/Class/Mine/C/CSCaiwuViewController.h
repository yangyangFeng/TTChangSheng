//
//  CSCaiwuViewController.h
//  ChangSheng
//
//  Created by 邴天宇 on 2017/10/16.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "TTNav_RootViewController.h"

typedef enum : NSUInteger {
    Up,
    Down,
} CSFenStatus;

@interface CSCaiwuViewController : TTNav_RootViewController

@property (nonatomic, assign)CSFenStatus status;

@end
