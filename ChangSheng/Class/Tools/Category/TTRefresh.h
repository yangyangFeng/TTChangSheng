//
//  TTRefresh.h
//  ChangSheng
//
//  Created by cnepayzx on 2017/10/19.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MJRefresh.h>
@interface TTRefresh : NSObject
+ (id)tt_headeRefresh:(MJRefreshComponentRefreshingBlock)block;
@end
