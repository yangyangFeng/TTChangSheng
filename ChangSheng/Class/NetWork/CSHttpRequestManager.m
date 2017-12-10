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
                            showHUD:(BOOL)showHUD
{
    NSString * url = @"my/upDownScore";

    [self upLoadFileRequestWithUrl:url paramters:params fileData:fileData fileType:fileType success:successBlock failure:failureBlock uploadprogress:progressBlock showHUD:showHUD];
}

#pragma mark -  10.转分
/**
 *  10.转分
 */
+ (void)request_zhuanFen_paramters:(NSDictionary *)params success:(TTSuccessBlock)success failure:(TTFailureBlock)failure showHUD:(BOOL)showHUD
{
    NSString * url = @"my/transferScore";
    [[CSNewWorkHandler sharedInstance] beginHttpRequestType:POST_TTREQUEST_TYPE url:url paramters:params success:^(id responseObject) {
        
        success(responseObject);
        
    } failure:^(NSError *error) {
        failure(error);
    } showHUD:showHUD];
}

#pragma mark -  11.分数操作记录
/**
 *  11.分数操作记录
 */
+ (void)request_fenCaoZuoJiLu_paramters:(NSDictionary *)params success:(TTSuccessBlock)success failure:(TTFailureBlock)failure showHUD:(BOOL)showHUD
{
    NSString * url = @"my/scoreRecord";
    [[CSNewWorkHandler sharedInstance] beginHttpRequestType:POST_TTREQUEST_TYPE url:url paramters:params success:^(id responseObject) {
        
        success(responseObject);
        
    } failure:^(NSError *error) {
        failure(error);
    } showHUD:showHUD];
}

#pragma mark -  12.修改密码
/**
 *  12.修改密码
 */
+ (void)request_changePW_paramters:(NSDictionary *)params success:(TTSuccessBlock)success failure:(TTFailureBlock)failure showHUD:(BOOL)showHUD
{
    NSString * url = @"my/changePwd";
    [[CSNewWorkHandler sharedInstance] beginHttpRequestType:POST_TTREQUEST_TYPE url:url paramters:params success:^(id responseObject) {
        
        success(responseObject);
        
    } failure:^(NSError *error) {
        failure(error);
    } showHUD:showHUD];
}

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
                                    showHUD:(BOOL)showHUD
{
    NSString * url = @"my/changeAvatar";
    
    [self upLoadFileRequestWithUrl:url paramters:params fileData:fileData fileType:fileType success:successBlock failure:failureBlock uploadprogress:progressBlock showHUD:showHUD];
}

#pragma mark -  12.修改昵称
/**
 *  12.修改昵称
 */
+ (void)request_changeNickName_paramters:(NSDictionary *)params success:(TTSuccessBlock)success failure:(TTFailureBlock)failure showHUD:(BOOL)showHUD
{
    NSString * url = @"my/changeNickname";
    [[CSNewWorkHandler sharedInstance] beginHttpRequestType:POST_TTREQUEST_TYPE url:url paramters:params success:^(id responseObject) {
        
        success(responseObject);
        
    } failure:^(NSError *error) {
        failure(error);
    } showHUD:showHUD];
}

#pragma mark -  15 退出群聊
/**
 *  15.退出群聊
 */
+ (void)request_outChatGroup_paramters:(NSDictionary *)params success:(TTSuccessBlock)success failure:(TTFailureBlock)failure showHUD:(BOOL)showHUD
{
    NSString * url = @"chat/quitGroup";
    [[CSNewWorkHandler sharedInstance] beginHttpRequestType:POST_TTREQUEST_TYPE url:url paramters:params success:^(id responseObject) {
        
        success(responseObject);
        
    } failure:^(NSError *error) {
        failure(error);
    } showHUD:showHUD];
}

#pragma mark -  16.添加好友
/**
 *  16.添加好友
 */
+ (void)request_addFriend_paramters:(NSDictionary *)params success:(TTSuccessBlock)success failure:(TTFailureBlock)failure showHUD:(BOOL)showHUD
{
    NSString * url = @"social/addFriend";
    [[CSNewWorkHandler sharedInstance] beginHttpRequestType:POST_TTREQUEST_TYPE url:url paramters:params success:^(id responseObject) {
        
        success(responseObject);
        
    } failure:^(NSError *error) {
        failure(error);
    } showHUD:showHUD];
}

#pragma mark -  17.添加好友
/**
 *  17.添加好友
 */
+ (void)request_findUser_paramters:(NSDictionary *)params success:(TTSuccessBlock)success failure:(TTFailureBlock)failure showHUD:(BOOL)showHUD
{
    NSString * url = @"social/findUser";
    [[CSNewWorkHandler sharedInstance] beginHttpRequestType:POST_TTREQUEST_TYPE url:url paramters:params success:^(id responseObject) {
        
        success(responseObject);
        
    } failure:^(NSError *error) {
        failure(error);
    } showHUD:showHUD];
}

#pragma mark -  18.好友请求列表
/**
 *  18.好友请求列表
 */
+ (void)request_friendRequestList_paramters:(NSDictionary *)params success:(TTSuccessBlock)success failure:(TTFailureBlock)failure showHUD:(BOOL)showHUD
{
    NSString * url = @"social/friendRequestList";
    [[CSNewWorkHandler sharedInstance] beginHttpRequestType:GET_TTREQUEST_TYPE url:url paramters:params success:^(id responseObject) {
        
        success(responseObject);
        
    } failure:^(NSError *error) {
        failure(error);
    } showHUD:showHUD];
}

#pragma mark -  19.同意好友请求
/**
 *  18.同意好友请求
 */
+ (void)request_agreeFriendRequest_paramters:(NSDictionary *)params success:(TTSuccessBlock)success failure:(TTFailureBlock)failure showHUD:(BOOL)showHUD
{
    NSString * url = @"social/agreeFriendRequest";
    [[CSNewWorkHandler sharedInstance] beginHttpRequestType:POST_TTREQUEST_TYPE url:url paramters:params success:^(id responseObject) {
        
        success(responseObject);
        
    } failure:^(NSError *error) {
        failure(error);
    } showHUD:showHUD];
}

#pragma mark -  20.删除好友
/**
 *  20.删除好友
 */
+ (void)request_deleteFriend_paramters:(NSDictionary *)params success:(TTSuccessBlock)success failure:(TTFailureBlock)failure showHUD:(BOOL)showHUD
{
    NSString * url = @"social/deleteFriend";
    [[CSNewWorkHandler sharedInstance] beginHttpRequestType:POST_TTREQUEST_TYPE url:url paramters:params success:^(id responseObject) {
        
        success(responseObject);
        
    } failure:^(NSError *error) {
        failure(error);
    } showHUD:showHUD];
}

#pragma mark -  21.好友请求数量
/**
 *  21.好有请求数量
 */
+ (void)request_friendRequestNum_paramters:(NSDictionary *)params success:(TTSuccessBlock)success failure:(TTFailureBlock)failure showHUD:(BOOL)showHUD
{
    NSString * url = @"social/friendRequestNum";
    [[CSNewWorkHandler sharedInstance] beginHttpRequestType:GET_TTREQUEST_TYPE url:url paramters:params success:^(id responseObject) {
        
        success(responseObject);
        
    } failure:^(NSError *error) {
        failure(error);
    } showHUD:showHUD];
}

#pragma mark -  22.获取好友列表
/**
 *  22.获取好友列表
 */
+ (void)request_friendList_paramters:(NSDictionary *)params success:(TTSuccessBlock)success failure:(TTFailureBlock)failure showHUD:(BOOL)showHUD
{
    NSString * url = @"social/friendList";
    [[CSNewWorkHandler sharedInstance] beginHttpRequestType:GET_TTREQUEST_TYPE url:url paramters:params success:^(id responseObject) {
        
        success(responseObject);
        
    } failure:^(NSError *error) {
        failure(error);
    } showHUD:showHUD];
}

#pragma mark -  23.获取好友聊天列表
/**
 *  23.获取好友聊天列表
 */
+ (void)request_friendchartlist_paramters:(NSDictionary *)params success:(TTSuccessBlock)success failure:(TTFailureBlock)failure showHUD:(BOOL)showHUD
{
    NSString * url = @"social/friendchartlist";
    [[CSNewWorkHandler sharedInstance] beginHttpRequestType:GET_TTREQUEST_TYPE url:url paramters:params success:^(id responseObject) {
        
        success(responseObject);
        
    } failure:^(NSError *error) {
        failure(error);
    } showHUD:showHUD];
}
@end
