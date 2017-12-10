//
//  CSSearchFriendViewController.m
//  ChangSheng
//
//  Created by cnepayzx on 2017/12/3.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSSearchFriendViewController.h"

#import "CSSearchFriendView.h"
#import "CSFindUserParam.h"
#import "LLUtils.h"
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
    
}

-(void)searchBarDidSearch:(NSString *)text
{
    MBProgressHUD * hud = [LLUtils showCustomIndicatiorHUDWithTitle:@"" inView:self.view];
    CSFindUserParam * param = [CSFindUserParam new];
    param.usermark = text;
    [CSHttpRequestManager request_findUser_paramters:param.mj_keyValues success:^(id responseObject) {
        CSFindUserParam * obj = [CSFindUserParam mj_objectWithKeyValues:responseObject];
        if (obj.code.intValue == successCode) {
            if (self.callblock) {
                self.callblock(obj.result);
            }
            self.alertLabel.hidden = YES;
        }
        else
        {
            self.alertLabel.hidden = NO;
        }
        [hud hideAnimated:YES];
    } failure:^(NSError *error) {
        self.alertLabel.hidden = NO;
        [hud hideAnimated:YES];
    } showHUD:NO];
    
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
