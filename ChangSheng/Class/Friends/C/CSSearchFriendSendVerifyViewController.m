//
//  CSSearchFriendSendVerifyViewController.m
//  ChangSheng
//
//  Created by cnepayzx on 2017/12/3.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSSearchFriendSendVerifyViewController.h"

@interface CSSearchFriendSendVerifyViewController ()

@end

@implementation CSSearchFriendSendVerifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(30, 154, 391, 26);
    label.text = @"您需要发送验证申请，等对方通过";
    label.font = [UIFont fontWithName:@"HiraginoSansGB-W3" size:26];
    label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];

    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NavStateBar);
        make.bottom.mas_equalTo(self.contentView.mas_top).offset(0);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(0);
    }];
    
    UITextField * textField = [UITextField new];
    textField.text = @"您好！我是来自长圣的君";
    textField.font = [UIFont fontWithName:@"HiraginoSansGB-W3" size:30];
    textField.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    textField.clearsOnBeginEditing = YES;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    
    [self.contentView addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.nextBtn setTitle:@"发送" forState:(UIControlStateNormal)];
    // Do any additional setup after loading the view.
}

-(void)nextBtnDidAction
{
    if (self.callblock) {
        self.callblock(@"发送验证吗");
    }
}

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
