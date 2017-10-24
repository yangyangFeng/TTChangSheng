//
//  CSUserNameInputViewController.h
//  ChangSheng
//
//  Created by 邴天宇 on 2017/10/18.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "TTNav_RootTableViewController.h"

@interface CSUserNameInputViewController : UITableViewController
@property (nonatomic,copy) void(^callBlock)(NSString * nickName);
@end

@interface CSUserNameInputSuperViewController : CSBaseViewController
@property (nonatomic,copy) void(^callBlock)(NSString * nickName);
@end
