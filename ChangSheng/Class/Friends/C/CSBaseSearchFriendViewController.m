//
//  CSBaseSearchFriendViewController.m
//  ChangSheng
//
//  Created by cnepayzx on 2017/12/3.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSBaseSearchFriendViewController.h"

@interface CSBaseSearchFriendViewController ()

@end

@implementation CSBaseSearchFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setSubviews];
    // Do any additional setup after loading the view.
}

- (void)setSubviews
{
    self.contentView = [UIView new];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.nextBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.nextBtn setTitle:@"添加到通讯录" forState:(UIControlStateNormal)];
    [self.nextBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    
    [self.nextBtn setBackgroundImage:[UIImage yy_imageWithColor:[UIColor colorWithHexColorString:@"24BC7F"]] forState:(UIControlStateNormal)];
    [self.nextBtn addTarget:self action:@selector(nextBtnDidAction) forControlEvents:(UIControlEventTouchUpInside)];
    self.nextBtn.layer.masksToBounds = YES;
    self.nextBtn.layer.cornerRadius = 44/2.0;
    
    [self.view addSubview:self.contentView];
    [self.view addSubview:self.nextBtn];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NavStateBar + 32);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44);
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.contentView.mas_bottom).offset(75);
        make.left.mas_equalTo(75/2.0);
        make.right.mas_equalTo(-75/2.0);
    }];
}

- (void)nextBtnDidAction{}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
