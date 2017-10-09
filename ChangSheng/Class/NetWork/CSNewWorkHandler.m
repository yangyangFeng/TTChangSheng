//
//  CSNewWorkHandler.m
//  GoPlay
//
//  Created by 邴天宇 on 29/12/15.
//  Copyright © 2015年 邴天宇. All rights reserved.
//

#import "CSNewWorkHandler.h"

@implementation CSNewWorkHandler
+ (CSNewWorkHandler*)sharedInstance
{
    static CSNewWorkHandler* handler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handler = [[CSNewWorkHandler alloc] init];
        handler.baseurl = baseUrl;
    });
    return handler;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.networkError = NO;
    }
    return self;
}
- (id)beginHttpRequestType:(TTREQUEST_TYPE)networkType
                       url:(NSString*)url
                 paramters:(NSDictionary*)params
                   success:(TTSuccessBlock)successBlock
                   failure:(TTFailureBlock)failureBlock
                   showHUD:(BOOL)showHUD
{
    [CSNewWorkHandler startMonitoring];
    if (self.networkError == YES) {
//        SHOW_ALERT(@"网络连接断开,请检查网络!");
         NSError * error = [NSError errorWithDomain:@"连接失败!" code:201 userInfo:nil];
        [MBProgressHUD tt_Hide];
        [MBProgressHUD tt_ErrorTitle:@"网络连接断开,请检查网络!"];
        if (failureBlock) {
            failureBlock(error);
        }
        return nil;
    }
    NSDictionary * RSA_params = [self RSADIC:params];
    
    NSString * all_url = [NSString stringWithFormat:@"%@/%@",baseUrl,url];
#if SWITCH_OPEN_LOG
    NSLog(@"url = %@ \n %@",all_url,RSA_params);
#endif

    /// 如果有一些公共处理，可以写在这里
    //    NSUInteger hashValue = [delegate hash];
    self.netWorkItem = [[CSNetWorkingRequest alloc] initWithRequestType:networkType
                                                                    url:all_url
                                                              paramters:RSA_params
                                                                success:successBlock
                                                                failure:^(NSError *error) {
                                                                    failureBlock(error);
                                                                }
                                                                showHUD:showHUD];
    //    [[MHAsiNetworkItem alloc]initWithtype:networkType url:url params:params delegate:delegate target:target action:action hashValue:hashValue showHUD:showHUD successBlock:successBlock failureBlock:failureBlock];
    //    self.netWorkItem.delegate = self;
    [self.items addObject:self.netWorkItem];
    return self.netWorkItem;
}

- (id)beginHttpRequestType:(TTREQUEST_TYPE)networkType
                       url:(NSString*)url
                 paramters:(NSDictionary*)params
                   success:(TTSuccessBlock)successBlock
                   failure:(TTFailureBlock)failureBlock
                   showHUD:(BOOL)showHUD
                   timeOut:(NSInteger)time
{
    [CSNewWorkHandler startMonitoring];
    if (self.networkError == YES) {
//        SHOW_ALERT(@"网络连接断开,请检查网络!");
        NSError * error = [NSError errorWithDomain:@"连接失败!" code:201 userInfo:nil];
        [MBProgressHUD tt_Hide];
        if (failureBlock) {
            failureBlock(error);
        }
        return nil;
    }
    NSDictionary * RSA_params = [self RSADIC:params];
    
    NSString * all_url = [NSString stringWithFormat:@"%@/%@",baseUrl,url];
#if SWITCH_OPEN_LOG
    NSLog(@"url = %@ \n %@",all_url,RSA_params);
#endif
    
    /// 如果有一些公共处理，可以写在这里
    //    NSUInteger hashValue = [delegate hash];
    self.netWorkItem = [[CSNetWorkingRequest alloc] initWithRequestType:networkType
                                                                    url:all_url
                                                              paramters:RSA_params
                                                                success:successBlock
                                                                failure:^(NSError *error) {
                                                                    failureBlock(error);
                                                                }
                                                                showHUD:showHUD
                                                                timeOut:time];
    //    [[MHAsiNetworkItem alloc]initWithtype:networkType url:url params:params delegate:delegate target:target action:action hashValue:hashValue showHUD:showHUD successBlock:successBlock failureBlock:failureBlock];
    //    self.netWorkItem.delegate = self;
    [self.items addObject:self.netWorkItem];
    return self.netWorkItem;
}

- (id)uploadHttpRequestType:(TTREQUEST_TYPE)networkType
                        url:(NSString*)url
                  paramters:(NSDictionary*)params
                    success:(TTSuccessBlock)successBlock
                    failure:(TTFailureBlock)failureBlock
             uploadprogress:(TTUploadProgressBlock)progressBlock
                      image:(NSData *)image
                    showHUD:(BOOL)showHUD
{
     [CSNewWorkHandler startMonitoring];
    if (self.networkError == YES) {
//        SHOW_ALERT(@"网络连接断开,请检查网络!");
        NSError * error = [NSError errorWithDomain:@"连接失败!" code:201 userInfo:nil];
        if (failureBlock) {
            failureBlock(error);
        }
        
        return nil;
    }
    NSDictionary * RSA_params = [self RSADIC:params];
    
    NSString * all_url = [NSString stringWithFormat:@"%@/%@",baseUrl,url];
#if SWITCH_OPEN_LOG
    NSLog(@"url = %@ \n %@",all_url,RSA_params);
#endif
    /// 如果有一些公共处理，可以写在这里
    //    NSUInteger hashValue = [delegate hash];
    self.netWorkItem = [[CSNetWorkingRequest alloc] initWithRequestType:networkType
                                                                    url:all_url
                                                              paramters:RSA_params
                                                                success:successBlock
                                                                failure:failureBlock
                                                     uploadFileProgress:progressBlock
                                                                  image:image
                                                                showHUD:showHUD];

    [self.items addObject:self.netWorkItem];
    return self.netWorkItem;
}

- (id)TTbeginHttpRequestType:(TTREQUEST_TYPE)networkType
                       url:(NSString*)url
                 paramters:(NSDictionary*)params
                   success:(TTSuccessBlock)successBlock
                   failure:(TTFailureBlock)failureBlock
                   showHUD:(UIView *)showHUD
{
    [CSNewWorkHandler startMonitoring];
    if (self.networkError == YES) {
        //        SHOW_ALERT(@"网络连接断开,请检查网络!");
        NSError * error = [NSError errorWithDomain:@"连接失败!" code:201 userInfo:nil];
        [MBProgressHUD tt_Hide];
        if (failureBlock) {
            failureBlock(error);
        }
        return nil;
    }
    NSDictionary * RSA_params = [self RSADIC:params];
    
    NSString * all_url = [NSString stringWithFormat:@"%@/%@",baseUrl,url];
#if SWITCH_OPEN_LOG
    NSLog(@"url = %@ \n %@",all_url,RSA_params);
#endif
    
    /// 如果有一些公共处理，可以写在这里
    //    NSUInteger hashValue = [delegate hash];
    self.netWorkItem = [[CSNetWorkingRequest alloc] _initWithRequestType:networkType
                                                                    url:all_url
                                                              paramters:RSA_params
                                                                success:successBlock
                                                                failure:^(NSError *error) {
                                                                    failureBlock(error);
                                                                }
                                                                showHUD:showHUD];
    //    [[MHAsiNetworkItem alloc]initWithtype:networkType url:url params:params delegate:delegate target:target action:action hashValue:hashValue showHUD:showHUD successBlock:successBlock failureBlock:failureBlock];
    //    self.netWorkItem.delegate = self;
    [self.items addObject:self.netWorkItem];
    return self.netWorkItem;
 
}

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
                        showHUD:(BOOL)showHUD
{
    [CSNewWorkHandler startMonitoring];
    if (self.networkError == YES) {
        //        SHOW_ALERT(@"网络连接断开,请检查网络!");
        NSError * error = [NSError errorWithDomain:@"连接失败!" code:201 userInfo:nil];
        if (failureBlock) {
            failureBlock(error);
        }
        
        return nil;
    }
    NSDictionary * RSA_params = [self RSADIC:params];
    
    NSString * all_url = [NSString stringWithFormat:@"%@/%@",baseUrl,url];
#if SWITCH_OPEN_LOG
    NSLog(@"url = %@ \n %@",all_url,RSA_params);
#endif
    /// 如果有一些公共处理，可以写在这里
    //    NSUInteger hashValue = [delegate hash];
    self.netWorkItem = [[CSNetWorkingRequest alloc] initWithRequestType:networkType url:url paramters:RSA_params success:successBlock failure:failureBlock uploadFileProgress:progressBlock filePath:filePath showHUD:showHUD];
//                        initWithRequestType:networkType
//                                                                    url:all_url
//                                                              paramters:RSA_params
//                                                                success:successBlock
//                                                                failure:failureBlock
//                                                     uploadFileProgress:progressBlock
//                                                                  image:image
//                                                                showHUD:showHUD];
    
    [self.items addObject:self.netWorkItem];
    return self.netWorkItem;
}


#pragma makr - 开始监听网络连接

+ (void)startMonitoring
{
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager* mgr = [AFNetworkReachabilityManager sharedManager];
    // 2.设置网络状态改变后的处理
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        switch (status) {
        case AFNetworkReachabilityStatusUnknown: // 未知网络
            DLog(@"未知网络");
            [CSNewWorkHandler sharedInstance].networkError = NO;
            break;
        case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
            [CSNewWorkHandler sharedInstance].networkError = YES;
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
            DLog(@"手机自带网络");
            [CSNewWorkHandler sharedInstance].networkError = NO;
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
            DLog(@"WIFI");
            [CSNewWorkHandler sharedInstance].networkError = NO;
            break;
        }
    }];
    [mgr startMonitoring];
}

/**
 *   懒加载网络请求项的 items 数组
 *
 *   @return 返回一个数组
 */
- (NSMutableArray*)items
{
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}

/**
 *   取消所有正在执行的网络请求项
 */
+ (void)cancelAllNetItems
{
    CSNewWorkHandler* handler = [CSNewWorkHandler sharedInstance];
    [handler.items removeAllObjects];
    handler.netWorkItem = nil;
}

- (void)netWorkWillDealloc:(CSNetWorkingRequest*)itme
{
    [self.items removeObject:itme];
    self.netWorkItem = nil;
}

-(void)dealloc
{
    DLog(@"----------");
}
#pragma mark - RSA 验证添加
- (NSDictionary *)RSADIC:(NSDictionary *)paramter
{
    /*
    NSString * str_10 = [NSString TT_ret10bitString];
    
    NSMutableDictionary * new_paramter = [NSMutableDictionary dictionaryWithDictionary:paramter];

    NSString * rsastring;

    rsastring = [TT_RSA encryptString:str_10 publicKey:kPublicString];
    [new_paramter setObject:rsastring  forKey:@"_sign"];
    [new_paramter setObject:str_10.md5 forKey:@"_token"];
    */
    NSMutableDictionary * new_paramter = [NSMutableDictionary dictionaryWithDictionary:paramter];
    if ([CSUserInfo shareInstance].isOnline) {
        [new_paramter setObject:[CSUserInfo shareInstance].info.token forKey:@"token"];
    }
    return new_paramter;
}

@end
