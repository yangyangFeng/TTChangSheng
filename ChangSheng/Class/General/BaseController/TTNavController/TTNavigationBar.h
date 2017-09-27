//
//  TTNavigationBar.h
//  TTCustomNavicaitonController
//
//  Created by 邴天宇 on 16/12/15.
//  Copyright © 2015年 邴天宇. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TTNaviBarLeftBtnPressed)();
typedef void(^TTNaviBarRightBtnPressed)();

#import "TTBaseNavigationBar.h"

@interface TTNavigationBar : TTBaseNavigationBar
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UINavigationBar *customBar;

@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *centerView;

@property (nonatomic, copy) void(^leftBtnPressedHandler)();
@property (nonatomic, copy) void(^rightBtnPressedHandler)();

@end
