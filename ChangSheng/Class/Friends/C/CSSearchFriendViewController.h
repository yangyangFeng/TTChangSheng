//
//  CSSearchFriendViewController.h
//  ChangSheng
//
//  Created by cnepayzx on 2017/12/3.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "TTNav_RootViewController.h"

@interface CSSearchFriendViewController : TTNav_RootViewController
@property(nonatomic,copy)void (^sendMessagblock)(id obj);
@property(nonatomic,copy)void (^callblock)(id obj);
@end
