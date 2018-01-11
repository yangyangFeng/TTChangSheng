//
//  CSLoginHandler.m
//  ChangSheng
//
//  Created by 邴天宇 on 17/9/24.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSLoginHandler.h"
#import "CSHttpRequestManager.h"
#import "TTSocketChannelManager.h"
#import "CSMessageRecordTool.h"
#import "CSDeviceBindingModel.h"
#import "JPUSHService.h"
#import "AppDelegate.h"
@implementation CSLoginHandler
+ (void)loginWithParams:(NSDictionary *)params
                successBlock:(successBlock)success
                   failBlock:(errorBlock)fail
{
    [CSHttpRequestManager request_login_paramters:params.mj_keyValues
                                          success:^(id responseObject) {
                                              if (success) {
                                                  success(responseObject);
                                              }
//                                              [self initDB];
//                                              [self openSocket];
                                          } failure:^(NSError *error) {
                                              if (fail) {
                                                  fail(error);
                                              }
                                          } showHUD:YES];
}

+ (void)request_register_paramters:(NSDictionary*)params
                          fileData:(NSData*)fileData
                          fileType:(CS_UPLOAD_FILE)fileType
                      successBlock:(successBlock)success
                         failBlock:(errorBlock)fail
{
    [CSHttpRequestManager request_register_paramters:params fileData:fileData fileType:fileType success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
        //                                              [self openSocket];
//        [self initDB];
    } failure:^(NSError *error) {
        if (fail) {
            fail(error);
        }
    }uploadprogress:nil showHUD:YES];
}

#pragma mark - 登陆后所有配置项
+ (void)initAllSets:(CSUserInfoModel *)info
{
    [CSUserInfo shareInstance].info = info;
    [[CSUserInfo shareInstance] login];
    
    AppDelegate * appDelegate =  (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate joinHomeController];
    
    //#mark - DB配置
    [CSLoginHandler initDB];
    [CSLoginHandler bindingDeviceRegister];
}

+ (void)bindingDeviceRegister
{
    CSDeviceBindingModel * param = [CSDeviceBindingModel new];
    param.device_id = [JPUSHService registrationID];
    param.system_version = APPVERSION;
    param.type = @"ios";
    [CSHttpRequestManager request_deviceBinding_paramters:param.mj_keyValues success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    } showHUD:NO];
}

//开启socket链接通道
+ (void)openSocket
{
NSString * url = [NSString stringWithFormat:@"%@?token=%@",webSocketUrl,[CSUserInfo shareInstance].info.token];
    [[TTSocketChannelManager shareInstance] configUrlString:url];
    [[TTSocketChannelManager shareInstance] openConnection];
}

+ (void)initDB
{
    [CSMessageRecordTool setDefaultRealmForUser:[CSUserInfo shareInstance].info.token];
}
@end
