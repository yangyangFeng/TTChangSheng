//
//  CSMineUserInfoView.m
//  ChangSheng
//
//  Created by cnepayzx on 2017/10/19.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSMineUserInfoView.h"


@interface CSMineUserInfoView()

@property(nonatomic,strong)UIImageView * userIcon;

@property(nonatomic,strong)UILabel * userName;

@property(nonatomic,strong)UILabel * userCode;

@end
@implementation CSMineUserInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _userIcon = [UIImageView new];
        _userIcon.layer.masksToBounds = YES;
        _userIcon.layer.cornerRadius = 40;
        _userIcon.contentMode = UIViewContentModeScaleAspectFill;
        _userIcon.layer.borderWidth = 2.0f;
        _userIcon.layer.borderColor =rgba(41, 177, 80,0.75).CGColor;
        
        _userName = [UILabel new];
        _userName.font = [UIFont systemFontOfSize:14];
        _userName.textColor = [UIColor whiteColor];
        _userName.textAlignment = NSTextAlignmentCenter;
        
        _userCode = [UILabel new];
        _userCode.font = [UIFont systemFontOfSize:13];
        _userCode.textColor = [UIColor whiteColor];
        _userCode.textAlignment = NSTextAlignmentCenter;
        _userCode.layer.masksToBounds = YES;
        _userCode.layer.cornerRadius = 10;
        _userCode.layer.borderWidth = 1.5;
        _userCode.layer.borderColor = [UIColor colorWithHexColorString:@"56e18b"].CGColor;
        
        [self addSubview:_userIcon];
        [self addSubview:_userName];
        [self addSubview:_userCode];
        
        [_userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.mas_equalTo(80);
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(0);
        }];
        [_userName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_userIcon.mas_bottom).offset(15);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(16);
        }];
        [_userCode mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_userName.mas_bottom).offset(7);
            make.centerX.mas_equalTo(0);
            make.width.mas_equalTo(110);
            make.height.mas_equalTo(20);
        }];
    }
    return self;
}

- (void)refreshUserInfo
{
    [_userIcon yy_setImageWithURL:[NSURL URLWithString:[CSUserInfo shareInstance].info.avatar] placeholder:[UIImage  imageNamed:@"个人资料头像"]];
    _userCode.text = [CSUserInfo shareInstance].info.code;
    _userName.text = [CSUserInfo shareInstance].info.nickname;
}
@end
