//
//  CSHttpRequestManager.h
//  GoPlay
//
//  Created by 邴天宇 on 29/12/15.
//  Copyright © 2015年 邴天宇. All rights reserved.
//
#import "CSNewWorking.h"
#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    CS_UPLOAD_FILE_IMAGE = UpLoad_Image,
    CS_UPLOAD_FILE_VOICE = UpLoad_Voice,
    CS_UPLOAD_FILE_CUSTOME = 1<<5,
} CS_UPLOAD_FILE;
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

+ (void)upLoadFileRequestWithUrl:(NSString*)url
                 paramters:(NSDictionary*)params
                        filePath:(NSString*)filePath
                        fileType:(CS_UPLOAD_FILE)fileType
                   success:(TTSuccessBlock)successBlock
                   failure:(TTFailureBlock)failureBlock
            uploadprogress:(TTUploadProgressBlock)progressBlock
                   showHUD:(BOOL)showHUD;

/**
 上传IM语音和图片
 @param filePath 文件路径
 @param fileType 文件类型
 */
+ (void)upLoadFileRequestParamters:(NSDictionary*)params
                        filePath:(NSString*)filePath
                        fileType:(CS_UPLOAD_FILE)fileType
                         success:(TTSuccessBlock)successBlock
                         failure:(TTFailureBlock)failureBlock
                  uploadprogress:(TTUploadProgressBlock)progressBlock
                         showHUD:(BOOL)showHUD;
+ (void)upLoadFileRequestParamters:(NSDictionary*)params
                        fileData:(NSData*)fileData
                        fileType:(CS_UPLOAD_FILE)fileType
                         success:(TTSuccessBlock)successBlock
                         failure:(TTFailureBlock)failureBlock
                  uploadprogress:(TTUploadProgressBlock)progressBlock
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

#pragma mark -  7.加入群组
/**
 *  7.加入群组
 */
+ (void)request_joinGroup_paramters:(NSDictionary *)params success:(TTSuccessBlock)success failure:(TTFailureBlock)failure showHUD:(BOOL)showHUD;

#pragma mark -  8.加入群组
/**
 *  8.加入群组
 */
+ (void)request_quitGroup_paramters:(NSDictionary *)params success:(TTSuccessBlock)success failure:(TTFailureBlock)failure showHUD:(BOOL)showHUD;
@end
