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
+ (void)request_register_paramters:(NSDictionary*)params
                          fileData:(NSData*)fileData
                          fileType:(CS_UPLOAD_FILE)fileType
                           success:(TTSuccessBlock)successBlock
                           failure:(TTFailureBlock)failureBlock
                    uploadprogress:(TTUploadProgressBlock)progressBlock
                           showHUD:(BOOL)showHUD;
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
#pragma mark -  9.上下分
/**
 *  9.上下分
 */
+ (void)request_updownFen_paramters:(NSDictionary*)params
                          fileData:(NSData*)fileData
                          fileType:(CS_UPLOAD_FILE)fileType
                           success:(TTSuccessBlock)successBlock
                           failure:(TTFailureBlock)failureBlock
                    uploadprogress:(TTUploadProgressBlock)progressBlock
                           showHUD:(BOOL)showHUD;

#pragma mark -  10.转分
/**
 *  10.转分
 */
+ (void)request_zhuanFen_paramters:(NSDictionary *)params success:(TTSuccessBlock)success failure:(TTFailureBlock)failure showHUD:(BOOL)showHUD;

#pragma mark -  11.分数操作记录
/**
 *  11.分数操作记录
 */
+ (void)request_fenCaoZuoJiLu_paramters:(NSDictionary *)params success:(TTSuccessBlock)success failure:(TTFailureBlock)failure showHUD:(BOOL)showHUD;

#pragma mark -  12.修改密码
/**
 *  12.修改密码
 */
+ (void)request_changePW_paramters:(NSDictionary *)params success:(TTSuccessBlock)success failure:(TTFailureBlock)failure showHUD:(BOOL)showHUD;

#pragma mark -  13.修改头像
/**
 *  13.修改头像
 */
+ (void)request_changeHeaderImage_paramters:(NSDictionary*)params
                                   fileData:(NSData*)fileData
                                   fileType:(CS_UPLOAD_FILE)fileType
                                    success:(TTSuccessBlock)successBlock
                                    failure:(TTFailureBlock)failureBlock
                             uploadprogress:(TTUploadProgressBlock)progressBlock
                                    showHUD:(BOOL)showHUD;

#pragma mark -  14.修改昵称
/**
 *  14.修改昵称
 */
+ (void)request_changeNickName_paramters:(NSDictionary *)params success:(TTSuccessBlock)success failure:(TTFailureBlock)failure showHUD:(BOOL)showHUD;

#pragma mark -  15 退出群聊
/**
 *  15.退出群聊
 */
+ (void)request_outChatGroup_paramters:(NSDictionary *)params success:(TTSuccessBlock)success failure:(TTFailureBlock)failure showHUD:(BOOL)showHUD;

#pragma mark -  16.添加好友
/**
 *  16.添加好友
 */
+ (void)request_addFriend_paramters:(NSDictionary *)params success:(TTSuccessBlock)success failure:(TTFailureBlock)failure showHUD:(BOOL)showHUD;


#pragma mark -  17.添加好友
/**
 *  17.添加好友
 */
+ (void)request_findUser_paramters:(NSDictionary *)params success:(TTSuccessBlock)success failure:(TTFailureBlock)failure showHUD:(BOOL)showHUD;

#pragma mark -  18.好友请求列表
/**
 *  18.好友请求列表
 */
+ (void)request_friendRequestList_paramters:(NSDictionary *)params success:(TTSuccessBlock)success failure:(TTFailureBlock)failure showHUD:(BOOL)showHUD;

#pragma mark -  19.同意好友请求
/**
 *  18.同意好友请求
 */
+ (void)request_agreeFriendRequest_paramters:(NSDictionary *)params success:(TTSuccessBlock)success failure:(TTFailureBlock)failure showHUD:(BOOL)showHUD;

#pragma mark -  20.删除好友
/**
 *  20.删除好友
 */
+ (void)request_deleteFriend_paramters:(NSDictionary *)params success:(TTSuccessBlock)success failure:(TTFailureBlock)failure showHUD:(BOOL)showHUD;

#pragma mark -  21.好友请求数量
/**
 *  21.好有请求数量
 */
+ (void)request_friendRequestNum_paramters:(NSDictionary *)params success:(TTSuccessBlock)success failure:(TTFailureBlock)failure showHUD:(BOOL)showHUD;

#pragma mark -  22.获取好友列表
/**
 *  22.获取好友列表
 */
+ (void)request_friendList_paramters:(NSDictionary *)params success:(TTSuccessBlock)success failure:(TTFailureBlock)failure showHUD:(BOOL)showHUD;

#pragma mark -  23.获取好友聊天列表
/**
 *  23.获取好友聊天列表
 */
+ (void)request_friendchartlist_paramters:(NSDictionary *)params success:(TTSuccessBlock)success failure:(TTFailureBlock)failure showHUD:(BOOL)showHUD;


#pragma mark -  24.绑定用户设备
/**
 *  24.绑定用户设备
 */
+ (void)request_deviceBinding_paramters:(NSDictionary *)params success:(TTSuccessBlock)success failure:(TTFailureBlock)failure showHUD:(BOOL)showHUD;

#pragma mark -  25.退出登录
/**
 *  25.退出登录
 */
+ (void)request_logout_paramters:(NSDictionary *)params success:(TTSuccessBlock)success failure:(TTFailureBlock)failure showHUD:(BOOL)showHUD;
@end
