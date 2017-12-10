//
//  CSSearchFriendResultViewController.m
//  ChangSheng
//
//  Created by cnepayzx on 2017/12/3.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSSearchFriendResultViewController.h"

@interface CSSearchFriendResultViewController ()

@property(nonatomic,strong)UIImageView * userIcon;
@property(nonatomic,strong)UILabel * userName;

@end

@implementation CSSearchFriendResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _userIcon = [UIImageView new];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"用户名";
    label.font = [UIFont fontWithName:@"HiraginoSansGB-W3" size:28];
    label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    _userName = label;
    
    [self.contentView addSubview:_userIcon];
    [self.contentView addSubview:_userName];
    
    [_userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40);
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
    }];
    
    [_userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_userIcon.mas_right).offset(15);
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-50);
    }];
    
    [self.nextBtn setTitle:@"添加到通讯录" forState:(UIControlStateNormal)];
    // Do any additional setup after loading the view.
}

-(void)setModel:(CSFindUserParam *)model
{
    _model = model;
    [_userIcon yy_setImageWithURL:[NSURL URLWithString:model.avatar] placeholder:[UIImage imageNamed:@"个人资料头像.png"]];
    _userName.text = model.nickname;
}

-(void)nextBtnDidAction
{
    DLog(@"添加好友");
    if (self.callblock) {
        self.callblock(self.model.id);
    }
}


@end
