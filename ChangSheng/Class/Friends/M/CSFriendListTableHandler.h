//
//  CSFriendListTableHandler.h
//  ChangSheng
//
//  Created by cnepayzx on 2017/11/30.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "TTBaseTableViewHandler.h"

@interface CSFriendListTableHandler : TTBaseTableViewHandler
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,assign) int friendRequestNum;
@end
