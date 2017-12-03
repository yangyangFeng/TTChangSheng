//
//  CSBaseSearchFriendViewController.h
//  ChangSheng
//
//  Created by cnepayzx on 2017/12/3.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "TTNav_RootViewController.h"

@interface CSBaseSearchFriendViewController : TTNav_RootViewController


@property(nonatomic,strong)UIView * contentView;
@property(nonatomic,strong)UIButton * nextBtn;

@property(nonatomic,copy)void (^sendMessagblock)(id obj);

@property(nonatomic,copy)void (^callblock)(id obj);
- (void)nextBtnDidAction;
@end
