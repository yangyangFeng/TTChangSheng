//
//  CSSearchFriendSendVerifyViewController.m
//  ChangSheng
//
//  Created by cnepayzx on 2017/12/3.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSSearchFriendSendVerifyViewController.h"

#import "CSAddFriendParam.h"
#import "LLUtils.h"
@interface CSSearchFriendSendVerifyViewController ()
@property (nonatomic,strong) UITextField *textField;
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
    _textField = textField;
    
    [self.contentView addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.nextBtn setTitle:@"发送" forState:(UIControlStateNormal)];
    // Do any additional setup after loading the view.
}

-(void)nextBtnDidAction
{
    CSAddFriendParam * param = [CSAddFriendParam new];
    param.friend_id = self.userId;
    param.msg = self.textField.text;

    MBProgressHUD * hud = [LLUtils showCustomIndicatiorHUDWithTitle:@"" inView:self.view];
    
    [CSHttpRequestManager request_addFriend_paramters:param.mj_keyValues success:^(id responseObject) {
        [hud hideAnimated:YES];
        
        [LLUtils showActionSuccessHUD:@"发送成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.callblock) {
                self.callblock(@"发送验证吗");
            }
        });
    } failure:^(NSError *error) {
        [hud hideAnimated:YES];
        
    } showHUD:YES];
    
    
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
