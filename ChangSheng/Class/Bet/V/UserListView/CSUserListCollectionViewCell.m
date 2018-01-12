//
//  CSUserListCollectionViewCell.m
//  ChangSheng
//
//  Created by 邴天宇 on 2018/1/9.
//  Copyright © 2018年 邴天宇. All rights reserved.
//

#import "CSUserListCollectionViewCell.h"

@interface CSUserListCollectionViewCell()
@property (nonatomic,strong) UILabel *userName;
@property (nonatomic,strong) UIImageView *userIcon;
@end

@implementation CSUserListCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView * userIcon = [UIImageView new];
        UILabel * userName = [UILabel new];
        userName.text = @"用户名";
        userName.textColor = [UIColor colorWithHexColorString:@"666666"];
        userName.font = [UIFont systemFontOfSize:13];
        userName.textAlignment = NSTextAlignmentCenter;
        
        [self.contentView addSubview:userIcon];
        [self.contentView addSubview:userName];
        
        [userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.height.mas_equalTo(50);
        }];
        [userName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(userIcon.mas_bottom).offset(7.5);
        }];
        _userIcon = userIcon;
        _userName = userName;
    }
    return self;
}

-(void)setModel:(CSUserListResponse *)model
{
    _model = model;
    _userName.text = model.nickname;
    [_userIcon sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"聊天自定义头像.png"]];
}
@end
