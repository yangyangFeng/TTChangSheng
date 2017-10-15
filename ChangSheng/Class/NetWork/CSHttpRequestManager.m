//
//  CSHttpRequestManager.m
//  GoPlay
//
//  Created by 邴天宇 on 29/12/15.
//  Copyright © 2015年 邴天宇. All rights reserved.
//

#import "CSHttpsResModel.h"
#import "CSNewWorkHandler.h"
@implementation CSHttpRequestManager
+ (instancetype)allocWithZone:(struct _NSZone*)zone
{
    static CSHttpRequestManager* _manager;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [super allocWithZone:zone];
    });
    return _manager;
}
-(void)dealloc
{
    DLog(@"-------------");
}

/// 返回单例
+ (instancetype)sharedInstance
{
    return [[super alloc] init];
}

+ (BOOL)isSuccessWithResponseObject:(id)responseObject
{
    CSHttpsResModel * back = [CSHttpsResModel mj_objectWithKeyValues:responseObject];
    if (back.code ==successCode) {
        return YES;
    }
    else{
        return NO;
    }
}

+ (NSString *)redesWithResponseObject:(id)responseObject
{
    CSHttpsResModel * back = [CSHttpsResModel mj_objectWithKeyValues:responseObject];
    return back.msg;
}

+ (void)getRequstWithURL:(NSString*)url
               paramters:(NSDictionary*)params
                 success:(TTSuccessBlock)successBlock
                 failure:(TTFailureBlock)failureBlock
                 showHUD:(BOOL)showHUD
{
    [[CSNewWorkHandler sharedInstance] beginHttpRequestType:GET_TTREQUEST_TYPE url:url paramters:params success:successBlock failure:failureBlock showHUD:showHUD];
}
+ (void)postRequestWithUrl:(NSString*)url
                 paramters:(NSDictionary*)params
                   success:(TTSuccessBlock)successBlock
                   failure:(TTFailureBlock)failureBlock
                   showHUD:(BOOL)showHUD
{
    [[CSNewWorkHandler sharedInstance] beginHttpRequestType:POST_TTREQUEST_TYPE url:url paramters:params success:successBlock failure:failureBlock showHUD:showHUD];
}


+ (void)upLoadFileRequestWithUrl:(NSString*)url
                       paramters:(NSDictionary*)params
                        filePath:(NSString*)filePath
                        fileType:(CS_UPLOAD_FILE)fileType
                         success:(TTSuccessBlock)successBlock
                         failure:(TTFailureBlock)failureBlock
                  uploadprogress:(TTUploadProgressBlock)progressBlock
                         showHUD:(BOOL)showHUD
{
    [[CSNewWorkHandler sharedInstance] uploadFileHttpRequestType:(TTREQUEST_TYPE)fileType
                                                             url:url
                                                       paramters:params
                                                         success:successBlock
                                                         failure:failureBlock
                                                  uploadprogress:progressBlock
                                                        filePath:filePath
                                                         showHUD:showHUD];
}
+ (void)upLoadFileRequestParamters:(NSDictionary*)params
                          filePath:(NSString*)filePath
                          fileType:(CS_UPLOAD_FILE)fileType
                           success:(TTSuccessBlock)successBlock
                           failure:(TTFailureBlock)failureBlock
                    uploadprogress:(TTUploadProgressBlock)progressBlock
                           showHUD:(BOOL)showHUD
{
    NSString * url;
    if (fileType == CS_UPLOAD_FILE_VOICE) {
        url = @"chat/uploadVoice";
    }
    else
    {
        url = @"chat/uploadImage";
    }
    [self upLoadFileRequestWithUrl:url paramters:params filePath:filePath fileType:fileType success:successBlock failure:failureBlock uploadprogress:progressBlock showHUD:showHUD];
}

+ (void)upLoadFileRequestWithUrl:(NSString*)url
                       paramters:(NSDictionary*)params
                        fileData:(NSData*)fileData
                        fileType:(CS_UPLOAD_FILE)fileType
                         success:(TTSuccessBlock)successBlock
                         failure:(TTFailureBlock)failureBlock
                  uploadprogress:(TTUploadProgressBlock)progressBlock
                         showHUD:(BOOL)showHUD
{
    [[CSNewWorkHandler sharedInstance] uploadFileHttpRequestType:(TTREQUEST_TYPE)fileType
                                                             url:url
                                                       paramters:params
                                                         success:successBlock
                                                         failure:failureBlock
                                                  uploadprogress:progressBlock
                                                        fileData:fileData
                                                         showHUD:showHUD];
}

+ (void)upLoadFileRequestParamters:(NSDictionary*)params
                          fileData:(NSData*)fileData
                          fileType:(CS_UPLOAD_FILE)fileType
                           success:(TTSuccessBlock)successBlock
                           failure:(TTFailureBlock)failureBlock
                    uploadprogress:(TTUploadProgressBlock)progressBlock
                           showHUD:(BOOL)showHUD
{
    NSString * url;
    if (fileType == CS_UPLOAD_FILE_VOICE) {
        url = @"chat/uploadVoice";
    }
    else
    {
        url = @"chat/uploadImage";
    }
    [self upLoadFileRequestWithUrl:url paramters:params fileData:fileData fileType:fileType success:successBlock failure:failureBlock uploadprogress:progressBlock showHUD:showHUD];
}
#pragma mark - 1.获取验证码
+ (void)request_verification_paramters:(NSDictionary *)params success:(TTSuccessBlock)success failure:(TTFailureBlock)failure showHUD:(BOOL)showHUD
{
    NSString * url = @"Member/verification";
    [[CSNewWorkHandler sharedInstance] beginHttpRequestType:POST_TTREQUEST_TYPE url:url paramters:params success:^(id responseObject) {
 
            success(responseObject);
        
    } failure:^(NSError *error) {
       
        failure(error);
    } showHUD:showHUD];
    /**
     *  1：手机号登录；2：注册；3：修改密码
     4: 身份认证
     5: 提现密码
     6：提现申请
     7：提现修改密码
     8：提现忘记密码
     */
}

#pragma mark - 2.注册
+ (void)request_register_paramters:(NSDictionary *)params success:(TTSuccessBlock)success failure:(TTFailureBlock)failure showHUD:(BOOL)showHUD
{
    NSString * url = @"entrance/register";
    [[CSNewWorkHandler sharedInstance] beginHttpRequestType:POST_TTREQUEST_TYPE url:url paramters:params success:^(id responseObject) {

            success(responseObject);
   
    } failure:^(NSError *error) {
       
        failure(error);
    } showHUD:showHUD];
}

#pragma mark - 3.登录
+ (void)request_login_paramters:(NSDictionary *)params success:(TTSuccessBlock)success failure:(TTFailureBlock)failure showHUD:(BOOL)showHUD
{
    
    NSString * url = @"entrance/login";
    [[CSNewWorkHandler sharedInstance] beginHttpRequestType:POST_TTREQUEST_TYPE url:url paramters:params success:^(id responseObject) {
       
            success(responseObject);
    
    } failure:^(NSError *error) {
        failure(error);
    } showHUD:showHUD];
}


+ (void)request_groupList_paramters:(NSDictionary *)params success:(TTSuccessBlock)success failure:(TTFailureBlock)failure showHUD:(BOOL)showHUD
{
    NSString * url = @"chat/groupList";
    [[CSNewWorkHandler sharedInstance] beginHttpRequestType:GET_TTREQUEST_TYPE url:url paramters:params success:^(id responseObject) {
        
        success(responseObject);
        
    } failure:^(NSError *error) {
        failure(error);
    } showHUD:showHUD];
}

+ (void)request_chatRecord_paramters:(NSDictionary *)params success:(TTSuccessBlock)success failure:(TTFailureBlock)failure showHUD:(BOOL)showHUD
{
    NSString * url = @"chat/chatRecord";
    [[CSNewWorkHandler sharedInstance] beginHttpRequestType:GET_TTREQUEST_TYPE url:url paramters:params success:^(id responseObject) {
        
        success(responseObject);
        
    } failure:^(NSError *error) {
        failure(error);
    } showHUD:showHUD];
}

#pragma mark -  6.获取客服列表
/**
 *  6.获取客服列表
 */
+ (void)request_helperList_paramters:(NSDictionary *)params success:(TTSuccessBlock)success failure:(TTFailureBlock)failure showHUD:(BOOL)showHUD
{
    NSString * url = @"chat/csList";
    [[CSNewWorkHandler sharedInstance] beginHttpRequestType:GET_TTREQUEST_TYPE url:url paramters:params success:^(id responseObject) {
        
        success(responseObject);
        
    } failure:^(NSError *error) {
        failure(error);
    } showHUD:showHUD];
}

#pragma mark -  7.加入群组
/**
 *  7.加入群组
 */
+ (void)request_joinGroup_paramters:(NSDictionary *)params success:(TTSuccessBlock)success failure:(TTFailureBlock)failure showHUD:(BOOL)showHUD
{
    NSString * url = @"chat/joinGroup";
    [[CSNewWorkHandler sharedInstance] beginHttpRequestType:POST_TTREQUEST_TYPE url:url paramters:params success:^(id responseObject) {
        
        success(responseObject);
        
    } failure:^(NSError *error) {
        failure(error);
    } showHUD:showHUD];
}

#pragma mark -  8.加入群组
/**
 *  8.加入群组
 */
+ (void)request_quitGroup_paramters:(NSDictionary *)params success:(TTSuccessBlock)success failure:(TTFailureBlock)failure showHUD:(BOOL)showHUD
{
    NSString * url = @"chat/quitGroup";
    [[CSNewWorkHandler sharedInstance] beginHttpRequestType:POST_TTREQUEST_TYPE url:url paramters:params success:^(id responseObject) {
        
        success(responseObject);
        
    } failure:^(NSError *error) {
        failure(error);
    } showHUD:showHUD];
}
@end
