//
//  CSRegisterViewController.m
//  ChangSheng
//
//  Created by 邴天宇 on 17/9/24.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSRegisterViewController.h"

#import "CSUserInfo.h"
#import "GPLoginInfoModel.h"
#import "CSRegisterParam.h"
#import "CSHttpRequestManager.h"
@interface CSRegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *accountField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *againPasswordField;
@property (weak, nonatomic) IBOutlet UITextField *referrerField;
@property (weak, nonatomic) IBOutlet UIButton *readBtn;


@end

@implementation CSRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self tt_Title:@"注册"];
    
    [self tt_TitleTextColor:[UIColor colorWithHexColorString:@"0x333333"]];
    
    self.tt_navigationBar.contentView.backgroundColor = [UIColor whiteColor];
    
    self.view.backgroundColor = rgb(244, 244, 244);
    // Do any additional setup after loading the view.
}
- (IBAction)registerAction:(id)sender {
    
    
    
 
    
    if (!self.accountField.text.length) {
        [MBProgressHUD tt_ErrorTitle:@"账号不能为空"];
        return;
    }
    else if (self.accountField.text.length<6 | self.accountField.text.length > 20){
        [MBProgressHUD tt_ErrorTitle:@"账号为6到20位数字和字母"];
        return;
    }
    else if (!self.passwordField.text.length) {
        [MBProgressHUD tt_ErrorTitle:@"密码不能为空"];
        return;
    }
    else if (self.passwordField.text.length<6 | self.passwordField.text.length > 20){
        [MBProgressHUD tt_ErrorTitle:@"密码为6到20位数字和字母"];
        return;
    }
    else if (!self.againPasswordField.text.length) {
        [MBProgressHUD tt_ErrorTitle:@"密码不能为空"];
        return;
    }
    else if (self.againPasswordField.text.length<6 | self.againPasswordField.text.length > 20){
        [MBProgressHUD tt_ErrorTitle:@"密码为6到20位数字和字母"];
        return;
    }
    else if (![self.passwordField.text isEqualToString:self.againPasswordField.text]){
        [MBProgressHUD tt_ErrorTitle:@"密码不一致"];
        return;
    }
    else if (!self.readBtn.selected){
        [MBProgressHUD tt_ErrorTitle:@"请阅读并同意用户协议"];
        return;
    }
    
    CSRegisterParam * param = [CSRegisterParam new];
    param.username = self.accountField.text;
    param.password = self.passwordField.text;
    param.referee_code = self.referrerField.text;
    
    [MBProgressHUD tt_Show];
    
    [CSHttpRequestManager request_register_paramters:param.mj_keyValues success:^(id responseObject) {
        NSLog(@"成功%@",responseObject);
        GPLoginInfoModel *obj = [GPLoginInfoModel mj_objectWithKeyValues:responseObject];
        CSUserInfo * info = [CSUserInfo shareInstance];
        info.info = obj.result;
        [[CSUserInfo shareInstance] login];
        CS_HUD(obj.msg);
    } failure:^(NSError *error) {
        
    } showHUD:YES];
}
    
- (IBAction)readUserInfoAction:(id)sender {
    self.readBtn.selected = !self.readBtn.selected;
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