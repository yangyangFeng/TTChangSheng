//
//  CSLoginViewController.m
//  ChangSheng
//
//  Created by 邴天宇 on 17/9/24.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSLoginViewController.h"

#import "AppDelegate.h"
#import "TTNavigationController.h"
#import "CSHomeViewController.h"
#import "CSLoginRequestParam.h"
#import "CSLoginHandler.h"
#import "CSUserInfo.h"
#import "LLUtils+Popover.h"
@interface CSLoginViewController ()
    @property (weak, nonatomic) IBOutlet UITextField *accountTextField;
    @property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation CSLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tt_navigationBar setHidden:YES];
    
    [self tt_SetNaviBarHide:YES withAnimation:NO];
    //[self navigationC].barAlpha = 0;
    
    // Do any additional setup after loading the view.
}

- (IBAction)loginAction:(id)sender {
    if (!_accountTextField.text.length) {
        CS_HUD(@"账号不能为空")
        return;
    }
    else if ((_accountTextField.text.length <6) | (_accountTextField.text.length >20))
    {
        CS_HUD(@"账号长度为6-20位之间")
        return;
    }
    else if(!_passwordTextField.text.length)
    {
        CS_HUD(@"密码不能为空")
        return;
    }
    else if ((_passwordTextField.text.length <6) | (_passwordTextField.text.length >20))
    {
        CS_HUD(@"密码长度为6-20位之间")
        return;
    }
    CSLoginRequestParam * param = [CSLoginRequestParam new];
    param.username = _accountTextField.text;
    param.password = _passwordTextField.text;
    [LLUtils showCustomIndicatiorHUDWithTitle:@"" inView:self.view];
    [CSLoginHandler loginWithParams:param.mj_keyValues successBlock:^(id obj) {
        CS_HUD(@"登陆成功")
        NSLog(@"%@",obj);
        CSUserInfoModel * info = [CSUserInfoModel mj_objectWithKeyValues:[[obj mj_JSONObject] objectForKey:@"result"]];
        [CSUserInfo shareInstance].info = info;
        [[CSUserInfo shareInstance] login];
        
     
        
        CSHomeViewController * home = [CSHomeViewController new];
        AppDelegate * appDelegate =  (AppDelegate *)[UIApplication sharedApplication].delegate;
        TTNavigationController * nav = [[TTNavigationController alloc]initWithRootViewController:home];
        appDelegate.window.rootViewController = nav;
    } failBlock:^(NSError *error) {
        
    }];
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
