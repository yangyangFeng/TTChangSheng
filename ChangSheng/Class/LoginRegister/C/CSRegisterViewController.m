//
//  CSRegisterViewController.m
//  ChangSheng
//
//  Created by 邴天宇 on 17/9/24.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSRegisterViewController.h"
#import "LLWebViewController.h"
#import "TTNavigationController.h"

#import "FSMediaPicker.h"
#import "AppDelegate.h"
#import "LLUtils+Popover.h"
#import "CSUserInfo.h"
#import "GPLoginInfoModel.h"
#import "CSRegisterParam.h"
#import "CSHttpRequestManager.h"
#import "CSHomeViewController.h"
#import "LLUtils+Popover.h"
#import "CSLoginHandler.h"
@interface CSRegisterViewController ()<FSMediaPickerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *referrerField;
@property (weak, nonatomic) IBOutlet UIButton *readBtn;
@property (weak, nonatomic) IBOutlet UITextField *password;

@property (weak, nonatomic) IBOutlet UITextField *nickName;
@property (weak, nonatomic) IBOutlet UITextField *account;
@property (weak, nonatomic) IBOutlet UIButton *headBtn;
@property (nonatomic, strong)NSData * imageData;
@end

@implementation CSRegisterViewController

- (IBAction)uploadDidAction:(id)sender {
    FSMediaPicker* mediaPicker = [[FSMediaPicker alloc] init];
    mediaPicker.mediaType = FSMediaTypePhoto;
    mediaPicker.editMode = FSEditModeNone;
    mediaPicker.delegate = self;
    
    [mediaPicker showFromView:self.headBtn];
}

- (void)mediaPicker:(FSMediaPicker*)mediaPicker didFinishWithMediaInfo:(NSDictionary*)mediaInfo
{
    if (mediaInfo.mediaType == FSMediaTypeVideo) {
        //        self.player.contentURL = mediaInfo.mediaURL;
        //        [self.player play];
    }
    else
    {
        UIImage * newimage = [mediaInfo.originalImage fixOrientation];
        
        _imageData = [newimage tt_compressToDataLength:CS_IMAGE_DATA_SIZE];
        
        [self.headBtn setBackgroundImage:newimage forState:(UIControlStateNormal)];

    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self tt_Title:@"注册"];
    
    [self tt_TitleTextColor:[UIColor colorWithHexColorString:@"0x333333"]];
    
    self.tt_navigationBar.contentView.backgroundColor = [UIColor whiteColor];
    
    self.view.backgroundColor = rgb(244, 244, 244);
    
    self.headBtn.layer.cornerRadius = self.headBtn.width/2.0;
    self.headBtn.layer.masksToBounds = YES;
    // Do any additional setup after loading the view.
}
- (IBAction)registerAction:(id)sender {
    
    
    [self.view endEditing:YES];
 
    
    if (!self.nickName.text.length) {
        CS_HUD(@"昵称不能为空");
        return;
    }
    else if (!self.account.text.length) {
        CS_HUD(@"账号不能为空");
        return;
    }
    else if (self.account.text.length<6 | self.account.text.length > 20){
        CS_HUD(@"账号为6到20位数字和字母");
        return;
    }
    else if (!self.password.text.length) {
        CS_HUD(@"密码不能为空");
        return;
    }
    else if (self.password.text.length<6 | self.password.text.length > 20){
        CS_HUD(@"密码为6到20位数字和字母");
        return;
    }
//    else if (![self.passwordField.text isEqualToString:self.againPasswordField.text]){
//        CS_HUD(@"密码不一致");
//        return;
//    }
    else if (!self.readBtn.selected){
        CS_HUD(@"请阅读并同意用户协议");
        return;
    }
    else if (!self.imageData){
        CS_HUD(@"请上传用户头像");
        return;
    }
    
    CSRegisterParam * param = [CSRegisterParam new];
    param.nickname = self.nickName.text;
    param.username = self.account.text;
    param.password = self.password.text.md5;
    param.referee_code = self.referrerField.text;
    param.file = @"avatar";
    
    MBProgressHUD * hud = [LLUtils showCustomIndicatiorHUDWithTitle:@"" inView:self.view];
    
    [CSLoginHandler request_register_paramters:param.mj_keyValues fileData:_imageData fileType:CS_UPLOAD_FILE_IMAGE | CS_UPLOAD_FILE_CUSTOME successBlock:^(id obj) {
        GPLoginInfoModel *res = [GPLoginInfoModel mj_objectWithKeyValues:obj];
        
        //        CSUserInfo * info = [CSUserInfo shareInstance];
        //        info.info = obj.result;
        //        [[CSUserInfo shareInstance] login];
        [hud hideAnimated:NO];
        [LLUtils showTextHUD:res.msg inView:self.view];
        CSUserInfoModel * info = [CSUserInfoModel mj_objectWithKeyValues:[[obj mj_JSONObject] objectForKey:@"result"]];
        
        [CSLoginHandler initAllSets:info];
        
    } failBlock:^(NSError *error) {
        [hud hideAnimated:NO];
    }];
    
}
    
- (IBAction)readUserInfoAction:(id)sender {
    self.readBtn.selected = !self.readBtn.selected;
}
- (IBAction)openWebViewAction:(id)sender {
    LLWebViewController * webC = [LLWebViewController new];
    webC.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/html/reg_pact.html",baseUrl]];
    [self.navigationController pushViewController:webC animated:YES];
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
