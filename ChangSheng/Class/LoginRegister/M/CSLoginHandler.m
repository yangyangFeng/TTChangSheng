//
//  CSLoginHandler.m
//  ChangSheng
//
//  Created by 邴天宇 on 17/9/24.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSLoginHandler.h"
#import "CSHttpRequestManager.h"
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
                                          } failure:^(NSError *error) {
                                              if (fail) {
                                                  fail(error);
                                              }
                                          } showHUD:YES];
}

+ (void)registerWithParams:(NSDictionary *)params
              successBlock:(successBlock)success
                 failBlock:(errorBlock)fail
{
    [CSHttpRequestManager request_register_paramters:params
                                          success:^(id responseObject) {
                                              if (success) {
                                                  success(responseObject);
                                              }
                                          } failure:^(NSError *error) {
                                              if (fail) {
                                                  fail(error);
                                              }
                                          } showHUD:YES];
}

@end
