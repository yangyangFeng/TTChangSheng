//
//  CSNewWorkHandler.h
//  GoPlay
//
//  Created by 邴天宇 on 29/12/15.
//  Copyright © 2015年 邴天宇. All rights reserved.
//

#import "AFNetworking.h"
#import "CSNetWorkingRequest.h"
#import <Foundation/Foundation.h>
#import "CSNewWorking.h"
@interface CSNewWorkHandler : NSObject
/**
 *  单例
 *
 *  @return BMNetworkHandler的单例对象
 */
+ (CSNewWorkHandler*)sharedInstance;
@property (nonatomic, copy) NSString* baseurl;

/**
 *  items
 */
@property (nonatomic, strong) NSMutableArray* items;

/**
 *   单个网络请求项
 */
@property (nonatomic, strong) CSNetWorkingRequest* netWorkItem;

/**
 *  networkError
 */
@property (nonatomic, assign) BOOL networkError;

#pragma mark - 创建一个网络请求项
/**
 *  创建一个网络请求项
 *
 *  @param url          网络请求URL
 *  @param networkType  网络请求方式
 *  @param params       网络请求参数
 *  @param delegate     网络请求的委托，如果没有取消网络请求的需求，可传nil
 *  @param showHUD      是否显示HUD
 *  @param successBlock 请求成功后的block
 *  @param failureBlock 请求失败后的block
 *
 *  @return 根据网络请求的委托delegate而生成的唯一标示
 */
//- (MHAsiNetworkItem*)conURL:(NSString *)url
//                networkType:(MHAsiNetWorkType)networkType
//                     params:(NSMutableDictionary *)params
//                   delegate:(id)delegate
//                    showHUD:(BOOL)showHUD
//                     target:(id)target
//                     action:(SEL)action
//               successBlock:(MHAsiSuccessBlock)successBlock
//               failureBlock:(MHAsiFailureBlock)failureBlock;
- (id)beginHttpRequestType:(TTREQUEST_TYPE)networkType
                       url:(NSString*)url
                 paramters:(NSDictionary*)params
                   success:(TTSuccessBlock)successBlock
                   failure:(TTFailureBlock)failureBlock
                   showHUD:(BOOL)showHUD;

- (id)beginHttpRequestType:(TTREQUEST_TYPE)networkType
                       url:(NSString*)url
                 paramters:(NSDictionary*)params
                   success:(TTSuccessBlock)successBlock
                   failure:(TTFailureBlock)failureBlock
                   showHUD:(BOOL)showHUD
                   timeOut:(NSInteger)time;

- (id)TTbeginHttpRequestType:(TTREQUEST_TYPE)networkType
                         url:(NSString*)url
                   paramters:(NSDictionary*)params
                     success:(TTSuccessBlock)successBlock
                     failure:(TTFailureBlock)failureBlock
                     showHUD:(UIView *)showHUD;
/**
 *  头像上车
 *
 */
- (id)uploadHttpRequestType:(TTREQUEST_TYPE)networkType
                       url:(NSString*)url
                 paramters:(NSDictionary*)params
                   success:(TTSuccessBlock)successBlock
                   failure:(TTFailureBlock)failureBlock
            uploadprogress:(TTUploadProgressBlock)progressBlock
                     image:(NSData *)image
                   showHUD:(BOOL)showHUD;

/**
 *  图片,语音上传
 *
 */
- (id)uploadFileHttpRequestType:(TTREQUEST_TYPE)networkType
                        url:(NSString*)url
                  paramters:(NSDictionary*)params
                    success:(TTSuccessBlock)successBlock
                    failure:(TTFailureBlock)failureBlock
             uploadprogress:(TTUploadProgressBlock)progressBlock
                      filePath:(NSString *)filePath
                    showHUD:(BOOL)showHUD;

- (id)uploadFileHttpRequestType:(TTREQUEST_TYPE)networkType
                            url:(NSString*)url
                      paramters:(NSDictionary*)params
                        success:(TTSuccessBlock)successBlock
                        failure:(TTFailureBlock)failureBlock
                 uploadprogress:(TTUploadProgressBlock)progressBlock
                       fileData:(NSData *)fileData
                        showHUD:(BOOL)showHUD;

/**
 *   监听网络状态的变化
 */
+ (void)startMonitoring;
/**
 *   取消所有正在执行的网络请求项
 */
+ (void)cancelAllNetItems;

@end
