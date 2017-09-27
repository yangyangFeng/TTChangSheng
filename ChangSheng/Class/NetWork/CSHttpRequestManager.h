//
//  CSHttpRequestManager.h
//  GoPlay
//
//  Created by 邴天宇 on 29/12/15.
//  Copyright © 2015年 邴天宇. All rights reserved.
//
#import "CSNewWorking.h"
#import <Foundation/Foundation.h>

@interface CSHttpRequestManager : NSObject
+ (void)getRequstWithURL:(NSString*)url
               paramters:(NSDictionary*)params
                 success:(TTSuccessBlock)successBlock
                 failure:(TTFailureBlock)failureBlock
                 showHUD:(BOOL)showHUD;
+ (void)postRequestWithUrl:(NSString*)url
                 paramters:(NSDictionary*)params
                   success:(TTSuccessBlock)successBlock
                   failure:(TTFailureBlock)failureBlock
                   showHUD:(BOOL)showHUD;
#pragma mark - 1.获取验证码
/**
 *  1.获取验证码
 */
+ (void)request_verification_paramters:(NSDictionary *)params success:(TTSuccessBlock)success failure:(TTFailureBlock)failure showHUD:(BOOL)showHUD;
#pragma mark - 2.注册
/**
 *  2.注册
 */
+ (void)request_register_paramters:(NSDictionary *)params success:(TTSuccessBlock)success failure:(TTFailureBlock)failure showHUD:(BOOL)showHUD;
#pragma mark -  3.登录
/**
 *  3.登录
 */
+ (void)request_login_paramters:(NSDictionary *)params success:(TTSuccessBlock)success failure:(TTFailureBlock)failure showHUD:(BOOL)showHUD;

#pragma mark -  4.大厅列表
/**
 *  4.大厅列表
 */
+ (void)request_groupList_paramters:(NSDictionary *)params success:(TTSuccessBlock)success failure:(TTFailureBlock)failure showHUD:(BOOL)showHUD;

#pragma mark -  5.获取聊天记录
/**
 *  5.获取聊天记录
 */
+ (void)request_chatRecord_paramters:(NSDictionary *)params success:(TTSuccessBlock)success failure:(TTFailureBlock)failure showHUD:(BOOL)showHUD;

#pragma mark -  6.获取客服列表
/**
 *  6.获取客服列表
 */
+ (void)request_helperList_paramters:(NSDictionary *)params success:(TTSuccessBlock)success failure:(TTFailureBlock)failure showHUD:(BOOL)showHUD;
@end
