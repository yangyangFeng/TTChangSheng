//
//  CSSearchFriendView.m
//  ChangSheng
//
//  Created by cnepayzx on 2017/12/3.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSSearchFriendView.h"

@interface CSSearchFriendView ()<UITextFieldDelegate>

@property(nonatomic,strong)UIImageView * searchIcon;
@property(nonatomic,strong)UITextField * searchInput;
@property(nonatomic,strong)UIButton * searchButton;
@end

@implementation CSSearchFriendView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _searchIcon = [UIImageView new];
        UIImage * image = [UIImage imageNamed:@"搜索"];
        _searchIcon.image = image;
        
        _searchInput = [UITextField new];
        _searchInput.font = [UIFont systemFontOfSize:14];
        _searchInput.placeholder = @"请输入ID昵称";
        _searchInput.textAlignment = NSTextAlignmentLeft;
        _searchInput.clearsOnBeginEditing = YES;
        _searchInput.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchInput.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
        _searchInput.delegate = self;
        
        _searchButton = [UIButton buttonWithName:@"搜索"];
        _searchButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _searchButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_searchButton setTitleColor:CS_TextColor forState:(UIControlStateNormal)];
        [_searchButton addTarget:self action:@selector(searchDidAction) forControlEvents:(UIControlEventTouchUpInside)];
        
        [self addSubview:_searchIcon];
        [self addSubview:_searchInput];
        [self addSubview:_searchButton];
        
        [_searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(22);
            make.left.mas_equalTo(25);
            make.centerY.mas_equalTo(0);
        }];
        
        [_searchInput mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.left.mas_equalTo(_searchIcon.mas_right).offset(20);
            make.right.mas_equalTo(0);
        }];
        
        [_searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.right.mas_equalTo(50);
            make.width.mas_equalTo(50);
        }];
        [self layoutIfNeeded];
    }
    return self;
}

- (void)searchDidAction
{
    DLog(@"搜索  ");
    [self endSacn];
    if ([_delegate respondsToSelector:@selector(searchBarDidSearch:)]) {
        [_delegate searchBarDidSearch:self.searchInput.text];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self beginScan];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    [self endSacn];
    return YES;
}
    // called when clear button pressed. return NO to ignore (no notifications)
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self beginScan];
    if ([_delegate respondsToSelector:@selector(searchBarDidSearch:)]) {
        [_delegate searchBarDidSearch:self.searchInput.text];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [self beginScan];
    return YES;
}

- (void)beginScan
{
    [UIView animateWithDuration:0.25 animations:^{
        [_searchInput mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.left.mas_equalTo(_searchIcon.mas_right).offset(20);
            make.right.mas_equalTo(-50);
        }];
        
        [_searchButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.width.mas_equalTo(50);
        }];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)endSacn
{
    [UIView animateWithDuration:0.25 animations:^{
        [_searchInput mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.left.mas_equalTo(_searchIcon.mas_right).offset(20);
            make.right.mas_equalTo(0);
        }];
        
        [_searchButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.right.mas_equalTo(50);
            make.width.mas_equalTo(50);
        }];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
