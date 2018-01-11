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
@property (weak, nonatomic) IBOutlet UIImageView *inputBGView;

@end

@implementation CSLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tt_navigationBar setHidden:YES];
    
    [self tt_SetNaviBarHide:YES withAnimation:NO];
    //[self navigationC].barAlpha = 0;
    
    // Do any additional setup after loading the view.
    
//    self.inputBGView.layer.masksToBounds = YES;
    self.inputBGView.layer.cornerRadius = 10;
//    CGPathRef path = CGPathCreateWithRect(self.inputBGView.bounds, nil);
//    self.inputBGView.layer.shadowPath = path;
    
    self.inputBGView.layer.shadowColor = [UIColor colorWithHexColorString:@"9E9E9E"].CGColor;
    
    self.inputBGView.layer.shadowOffset = CGSizeMake(1,3);
    
    self.inputBGView.layer.shadowOpacity = 0.2;
    
//    self.inputBGView.layer.shadowRadius = 1.0;
    
    
}

- (IBAction)loginAction:(id)sender {
    [self.view endEditing:YES];
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
    param.password = _passwordTextField.text.md5;
    MBProgressHUD * hud =  [LLUtils showCustomIndicatiorHUDWithTitle:@"" inView:self.view];
    [CSLoginHandler loginWithParams:param.mj_keyValues successBlock:^(id obj) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [hud hideAnimated:NO];
            [LLUtils showTextHUD:@"登录成功!" inView:self.view];
            
            
            NSLog(@"%@",obj);
            CSUserInfoModel * info = [CSUserInfoModel mj_objectWithKeyValues:[[obj mj_JSONObject] objectForKey:@"result"]];
            
            [CSLoginHandler initAllSets:info];
  
        });
    } failBlock:^(NSError *error) {
        [hud hideAnimated:NO];
//        [LLUtils showTextHUD:error.domain inView:self.view];
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
