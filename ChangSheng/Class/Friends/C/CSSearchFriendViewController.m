//
//  CSSearchFriendViewController.m
//  ChangSheng
//
//  Created by cnepayzx on 2017/12/3.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSSearchFriendViewController.h"

#import "CSSearchFriendView.h"
@interface CSSearchFriendViewController ()<CSSearchFriendViewDelegate>
@property(nonatomic,strong)UILabel * alertLabel;
@end

@implementation CSSearchFriendViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setSubviews];
    // Do any additional setup after loading the view.
}

- (void)setSubviews
{
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    

    
    CSSearchFriendView * searchView = [CSSearchFriendView new];
    searchView.delegate = self;
    searchView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:searchView];
    
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(45);
        make.top.mas_equalTo(NavStateBar + 10);
    }];
    
    [self.view addSubview:self.alertLabel];
    [self.alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(22);
        make.top.mas_equalTo(searchView.mas_bottom).offset(50);
    }];
    
    self.alertLabel.hidden = NO;
}

-(void)searchBarDidSearch:(NSString *)text
{
    if (self.callblock) {
        self.callblock(text);
    }
}
-(UILabel *)alertLabel
{
    if (!_alertLabel) {
        _alertLabel = [UILabel new];
        _alertLabel.font = [UIFont systemFontOfSize:14];
        _alertLabel.textColor = [UIColor colorWithHexColorString:@"666666"];
        _alertLabel.textAlignment = NSTextAlignmentCenter;
        _alertLabel.hidden=YES;
        
        _alertLabel.text = @"该用户不存在";
    }
    return _alertLabel;
}
@end
