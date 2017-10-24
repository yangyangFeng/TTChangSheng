//
//  CSHomeTableViewHandler.h
//  ChangSheng
//
//  Created by 邴天宇 on 17/9/26.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "TTBaseTableViewHandler.h"

@interface CSHomeTableViewHandler : TTBaseTableViewHandler
@property (nonatomic,strong) NSArray *betGroupArray;
/**
 刷新未读消息
 */
- (void)updateUnreadMessageUI;
@end
