//
//  CSNetWorkingRequest.m
//  GoPlay
//
//  Created by 邴天宇 on 29/12/15.
//  Copyright © 2015年 邴天宇. All rights reserved.
//

#import "CSNetWorkingRequest.h"

//#import "TT_RSA.h"
#import "CSHttpsResModel.h"
#import "CSUserInfo.h"
#import <AFNetworking.h>
@interface CSNetWorkingRequest ()
@property (nonatomic, strong) AFHTTPSessionManager* manager;
@end
@implementation CSNetWorkingRequest
+ (AFSecurityPolicy*)customSecurityPolicy
{
    
    
    // /先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"goplayServer" ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    
    //先导入证书
    NSData * cerData = [NSData dataWithContentsOfFile:cerPath];
    SecCertificateRef certificate = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)(cerData));
//    self.trustedCertificates = @[CFBridgingRelease(certificate)];
    
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    //如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = YES;
    
    //validatesCertificateChain 是否验证整个证书链，默认为YES
    //设置为YES，会将服务器返回的Trust Object上的证书链与本地导入的证书进行对比，这就意味着，假如你的证书链是这样的：
    //GeoTrust Global CA
    //    Google Internet Authority G2
    //        *.google.com
    //那么，除了导入*.google.com之外，还需要导入证书链上所有的CA证书（GeoTrust Global CA, Google Internet Authority G2）；
    //如是自建证书的时候，可以设置为YES，增强安全性；假如是信任的CA所签发的证书，则建议关闭该验证，因为整个证书链一一比对是完全没有必要（请查看源代码）；
//    securityPolicy.validatesCertificateChain = NO;
    
//    securityPolicy.pinnedCertificates = [[NSSet alloc] initWithObjects:certData, nil];
//    [self aaaademo];
    return securityPolicy;
}

+ (void)aaaademo
{
    // /先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"goplayServer" ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    
    //先导入证书
    NSData * cerData = [NSData dataWithContentsOfFile:cerPath];
    CFDataRef myCertData = (__bridge CFDataRef)certData;                 // 1
    
    SecCertificateRef myCert;
    myCert = SecCertificateCreateWithData(NULL, myCertData);    // 2
    
    SecPolicyRef myPolicy = SecPolicyCreateBasicX509();         // 3
    
    SecCertificateRef certArray[1] = { myCert };
    CFArrayRef myCerts = CFArrayCreate(
                                       NULL, (void *)certArray,
                                       1, NULL);
    SecTrustRef myTrust;
    OSStatus status = SecTrustCreateWithCertificates(
                                                     myCerts,
                                                     myPolicy,
                                                     &myTrust);  // 4
    
    SecTrustResultType trustResult;
    if (status == noErr) {
        status = SecTrustEvaluate(myTrust, &trustResult);       // 5
        NSLog(@"%d",status);
        
    }
    //...                                                             // 6
    if (trustResult == kSecTrustResultRecoverableTrustFailure) {
        // ...;
    }
    // ...
    if (myPolicy)
        CFRelease(myPolicy);
}
- (id)initWithRequestType:(TTREQUEST_TYPE)networkType
                      url:(NSString*)url
                paramters:(NSDictionary*)params
                  success:(TTSuccessBlock)successBlock
                  failure:(TTFailureBlock)failureBlock
                  showHUD:(BOOL)showHUD
{

    if (self = [super init]) {
        //        WEAKSELF;
        //        if (showHUD==YES) {
        //            [MBProgressHUD showHUDAddedTo:nil animated:YES];
        //        }
        _manager = [AFHTTPSessionManager manager];
        //        manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObject:@"text/html"];
        _manager.requestSerializer = [AFJSONRequestSerializer serializer]; //申明请求的数据是json类型
        //        _manager.responseSerializer = [AFJSONResponseSerializer serializer];//申明返回的结果是json类型
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/html", nil];
        _manager.requestSerializer.timeoutInterval = HTTP_TIME_OUT;
        _manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
        
#pragma mark - 登陆后已token作为用户标示.
        if ([CSUserInfo shareInstance].isOnline) {
            [_manager.requestSerializer setValue:[CSUserInfo shareInstance].info.token forHTTPHeaderField:@"token"];
        }
        
//        _manager.securityPolicy.allowInvalidCertificates = YES;
        //        AFJSONResponseSerializer* jsonSer = (AFJSONResponseSerializer*)manager.responseSerializer;
        //        jsonSer.removesKeysWithNullValues = YES;
        //        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];

 
//        NSLog(@"%@",(__bridge_transfer id)SecCertificateCreateWithData(NULL, (__bridge CFDataRef)baseCertData));
//        _manager.securityPolicy = [CSNetWorkingRequest customSecurityPolicy];
//        _manager.securityPolicy.allowInvalidCertificates = YES;
//        _manager.securityPolicy.validatesDomainName = YES;
        if (networkType == GET_TTREQUEST_TYPE) {
            
            [_manager GET:url parameters:params
             
                success:^(NSURLSessionDataTask* _Nonnull task, id _Nullable responseObject) {

                    CSHttpsResModel* back = [CSHttpsResModel mj_objectWithKeyValues:responseObject];
                    if (back.code == successCode) {
                        if (successBlock) {
                            NSDictionary* json;

                            json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
#if SWITCH_OPEN_LOG
                            DLog(@"--------------------------------------------------------------------------------------\n🍎🍎🍎GET.url--->👇👇👇\n%@\n--------------------------------------------------------------------------------------\n%@\n======================================================================================",
                                task.response.URL, json);
#endif
                            successBlock(responseObject);
                        }
                    }
                    else {

                        NSError* error = [NSError errorWithDomain:@"连接失败!" code:201 userInfo:nil];

                        if (showHUD) {

                            if (back.msg) {
                                [MBProgressHUD tt_ErrorTitle:back.msg];
                                error = [NSError errorWithDomain:back.msg code:201 userInfo:nil];
                            }
                            else {
                                [MBProgressHUD tt_ErrorTitle:@"无错误描述"];
                            }
                        }
                        else {
                            if (back.msg) {

                                error = [NSError errorWithDomain:back.msg code:201 userInfo:nil];
                            }
                            else {
                            }
                        }
                        if (failureBlock) {
                            DLog(@"%@", error);
                            failureBlock(error);
                        }
                    }
                }
                failure:^(NSURLSessionDataTask* _Nullable task, NSError* _Nonnull error) {
                    if (showHUD) {
                        [MBProgressHUD tt_ErrorTitle:@"连接失败"];
                    }
                    else {
                    }
                    if (failureBlock) {
                        NSError* myerror = [NSError errorWithDomain:@"连接失败!" code:201 userInfo:nil];
                        DLog(@"%@", error);
                        failureBlock(myerror);
                    }

                }];
        }
        else {
          
            
            
            
            [_manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {

            }
             
                success:^(NSURLSessionDataTask* _Nonnull task, id _Nullable responseObject) {
                    NSDictionary* json;

                    json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
#if SWITCH_OPEN_LOG
                    DLog(@"--------------------------------------------------------------------------------------\n🍎🍎🍎POST.url--->👇👇👇\n%@\n--------------------------------------------------------------------------------------\n%@\n======================================================================================",
                        task.response.URL, [responseObject mj_JSONString]);
#endif
                    CSHttpsResModel* back = [CSHttpsResModel mj_objectWithKeyValues:json];
                    if (back.code == successCode) {
                        if (successBlock) {
                            successBlock(responseObject);
                        }
                    }
                    else {

                        if (showHUD) {
                            if (back.msg) {
                                [MBProgressHUD tt_ErrorTitle:back.msg];
                            }
                            else {
                                [MBProgressHUD tt_ErrorTitle:@"程序猿哥哥正在紧急修复!"];
                            }
                        }

                        NSError* error = [NSError errorWithDomain:back.msg.length ? back.msg : @"程序猿哥哥正在紧急修复" code:201 userInfo:nil];
                        if (failureBlock) {
                            DLog(@"%@", error);
                            failureBlock(error);
                        }
                    }
                    DLog(@"---> %@", json);

                }
                failure:^(NSURLSessionDataTask* _Nullable task, NSError* _Nonnull error) {
                    if (showHUD) {
                        [MBProgressHUD tt_ErrorTitle:@"连接失败"];
                    }
                    else {
                        //                        [MBProgressHUD tt_Hide];
                    }
                    if (failureBlock) {
                        if (error.code == -1009) {
                            error = [NSError errorWithDomain:@"连接失败" code:201 userInfo:nil];
                        }
                        DLog(@"%@", error);
                        failureBlock(error);
                    }
                }];
        }
    }
    return self;
}


- (id)_initWithRequestType:(TTREQUEST_TYPE)networkType
                      url:(NSString*)url
                paramters:(NSDictionary*)params
                  success:(TTSuccessBlock)successBlock
                  failure:(TTFailureBlock)failureBlock
                  showHUD:(UIView *)showHUD
{
    
    if (self = [super init]) {
        //        WEAKSELF;
        //        if (showHUD==YES) {
        //            [MBProgressHUD showHUDAddedTo:nil animated:YES];
        //        }
        _manager = [AFHTTPSessionManager manager];
        //        manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObject:@"text/html"];
        _manager.requestSerializer = [AFJSONRequestSerializer serializer]; //申明请求的数据是json类型
        //        _manager.responseSerializer = [AFJSONResponseSerializer serializer];//申明返回的结果是json类型
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/html", nil];
        _manager.requestSerializer.timeoutInterval = HTTP_TIME_OUT;
        _manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;

#pragma mark - 登陆后已token作为用户标示.
        if ([CSUserInfo shareInstance].isOnline) {
            [_manager.requestSerializer setValue:[CSUserInfo shareInstance].info.token forHTTPHeaderField:@"token"];
        }
        
//        _manager.securityPolicy = [CSNetWorkingRequest customSecurityPolicy];

        if (networkType == GET_TTREQUEST_TYPE) {
            
            [_manager GET:url parameters:params
             
                  success:^(NSURLSessionDataTask* _Nonnull task, id _Nullable responseObject) {
                      
                      CSHttpsResModel* back = [CSHttpsResModel mj_objectWithKeyValues:responseObject];
                      if (back.code == successCode) {
                          if (successBlock) {
                              NSDictionary* json;
                              
                              json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
#if SWITCH_OPEN_LOG
                              DLog(@"--------------------------------------------------------------------------------------\n🍎🍎🍎GET.url--->👇👇👇\n%@\n--------------------------------------------------------------------------------------\n%@\n======================================================================================",
                                   task.response.URL, json);
#endif
                              successBlock(responseObject);
                          }
                      }
                      else {
                          
                          NSError* error = [NSError errorWithDomain:@"连接失败!" code:201 userInfo:nil];
                          
                          if (showHUD) {
                              
                              if (back.msg) {
                                  
                                  [MBProgressHUD tt_ShowInView:showHUD WithTitle:back.msg after:1];
                                  error = [NSError errorWithDomain:back.msg code:201 userInfo:nil];
                              }
                              else {
//                                  [MBProgressHUD tt_ErrorTitle:@"无错误描述"];
                              }
                          }
                          else {
                              if (back.msg) {
                                  
                                  error = [NSError errorWithDomain:back.msg code:201 userInfo:nil];
                              }
                              else {
                              }
                          }
                          if (failureBlock) {
                              DLog(@"%@", error);
                              failureBlock(error);
                          }
                      }
                  }
                  failure:^(NSURLSessionDataTask* _Nullable task, NSError* _Nonnull error) {
                      if (showHUD) {
                          [MBProgressHUD tt_ShowInView:showHUD WithTitle:@"连接失败" after:1];
                      }
                      else {
                      }
                      if (failureBlock) {
                          NSError* myerror = [NSError errorWithDomain:@"连接失败!" code:201 userInfo:nil];
                          DLog(@"%@", error);
                          failureBlock(myerror);
                      }
                      
                  }];
        }
        else {
            [_manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
                
            }
             
                   success:^(NSURLSessionDataTask* _Nonnull task, id _Nullable responseObject) {
                       NSDictionary* json;
                       
                       json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
#if SWITCH_OPEN_LOG
                       DLog(@"--------------------------------------------------------------------------------------\n🍎🍎🍎POST.url--->👇👇👇\n%@\n--------------------------------------------------------------------------------------\n%@\n======================================================================================",
                            task.response.URL, [responseObject mj_JSONString]);
#endif
                       CSHttpsResModel* back = [CSHttpsResModel mj_objectWithKeyValues:json];
                       if (back.code == successCode) {
                           if (successBlock) {
                               successBlock(responseObject);
                           }
                       }
                       else {
                           
                           if (showHUD) {
                               if (back.msg) {
                                   
                                   [MBProgressHUD tt_ShowInView:showHUD WithTitle:back.msg after:1];
                               }
                               else {
//                                   [MBProgressHUD tt_ErrorTitle:@"程序猿哥哥正在紧急修复!"];
                               }
                           }
                           
                           NSError* error = [NSError errorWithDomain:back.msg.length ? back.msg : @"程序猿哥哥正在紧急修复" code:201 userInfo:nil];
                           if (failureBlock) {
                               DLog(@"%@", error);
                               failureBlock(error);
                           }
                       }
                       DLog(@"---> %@", json);
                       
                   }
                   failure:^(NSURLSessionDataTask* _Nullable task, NSError* _Nonnull error) {
                       if (showHUD) {
//                           [MBProgressHUD tt_ErrorTitle:@"连接失败"];
                           [MBProgressHUD tt_ShowInView:showHUD WithTitle:@"连接失败" after:1];
                       }
                       else {
                           //                        [MBProgressHUD tt_Hide];
                       }
                       if (failureBlock) {
                           if (error.code == -1009) {
                               error = [NSError errorWithDomain:@"连接失败" code:201 userInfo:nil];
                           }
                           DLog(@"%@", error);
                           failureBlock(error);
                       }
                   }];
        }
    }
    return self;
}

- (id)initWithRequestType:(TTREQUEST_TYPE)networkType
                      url:(NSString*)url
                paramters:(NSDictionary*)params
                  success:(TTSuccessBlock)successBlock
                  failure:(TTFailureBlock)failureBlock
       uploadFileProgress:(void (^)(NSProgress* uploadProgress))uploadFileProgress
                    image:(NSData*)image
                  showHUD:(BOOL)showHUD

{

    if (self = [super init]) {

        _manager = [AFHTTPSessionManager manager];
        //        manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObject:@"text/html"];
        _manager.requestSerializer = [AFJSONRequestSerializer serializer]; //申明请求的数据是json类型
        //        _manager.responseSerializer = [AFJSONResponseSerializer serializer];//申明返回的结果是json类型
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/html", nil];
        _manager.requestSerializer.timeoutInterval = 30;
        _manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;

//        _manager.securityPolicy = [CSNetWorkingRequest customSecurityPolicy];
#pragma mark - 登陆后已token作为用户标示.
        if ([CSUserInfo shareInstance].isOnline) {
            [_manager.requestSerializer setValue:[CSUserInfo shareInstance].info.token forHTTPHeaderField:@"token"];
        }
        
        [_manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName;
            NSString * mimeType;
            switch (networkType) {
                case UpLoad_Image:
                {
                    fileName = [NSString stringWithFormat:@"%@.png", str];
                    mimeType = @"image/png";
                }
                break;
                case UpLoad_Video:
                {
                    fileName = [NSString stringWithFormat:@"%@.mp4", str];
                    mimeType = @"video/mpeg4";
                }
                break;
                default:
                break;
            }
            
            [formData appendPartWithFileData:image name:[params objectForKey:@"fileKey"] fileName:fileName mimeType:mimeType];
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
#if SWITCH_OPEN_LOG
            DLog(@"--------------------------------------------------------------------------------------\n🍎🍎🍎POST.url--->👇👇👇\n%@\n--------------------------------------------------------------------------------------\n%@\n======================================================================================",
                 task.response.URL, [responseObject mj_JSONString]);
#endif
            CSHttpsResModel* back = [CSHttpsResModel mj_objectWithKeyValues:responseObject];
            if (back.code == successCode) {
                if (successBlock) {
                    successBlock(responseObject);
                }
            }
            else {
                
                if (showHUD) {
                    if (back.msg) {
                        [MBProgressHUD tt_ErrorTitle:back.msg];
                    }
                    else {
                        [MBProgressHUD tt_ErrorTitle:@"程序猿哥哥正在紧急修复!"];
                    }
                }
                
                NSError* error = [NSError errorWithDomain:back.msg.length ? back.msg : @"程序猿哥哥正在紧急修复" code:201 userInfo:nil];
                if (failureBlock) {
                    DLog(@"%@", error);
                    failureBlock(error);
                }
            }
            DLog(@"---> %@", back.mj_keyValues);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (error.code == -1009) {
                [MBProgressHUD tt_ErrorTitle:@"网络已断开"];
            }
            else if (error.code == -1005) {
                [MBProgressHUD tt_ErrorTitle:@"网络连接已中断"];
            }
            else if (error.code == -1001) {
                [MBProgressHUD tt_ErrorTitle:@"请求超时"];
            }
            else if (error.code == -1003) {
                [MBProgressHUD tt_ErrorTitle:@"未能找到使用指定主机名的服务器"];
            }
            else {
                [MBProgressHUD tt_ErrorTitle:[NSString stringWithFormat:@"code:%ld %@", error.code, error.localizedDescription]];
            }
            if (showHUD) {
                [MBProgressHUD tt_ErrorTitle:@"连接失败"];
            }
            else {
                //                        [MBProgressHUD tt_Hide];
            }
            if (failureBlock) {
                if (error.code == -1009) {
                    error = [NSError errorWithDomain:@"连接失败" code:201 userInfo:nil];
                }
                DLog(@"%@", error);
                failureBlock(error);
            }
        }];
        
              /**
         *  将cookie通过请求头的形式传到服务器，比较是否和服务器一致
         */

        //        NSData *cookiesData = [[NSUserDefaults standardUserDefaults] objectForKey:@"Cookie"];
        //
        //        if([cookiesData length]) {
        //            /**
        //             *  拿到所有的cookies
        //             */
        //            NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesData];
        //
        //            for (NSHTTPCookie *cookie in cookies) {
        //                /**
        //                 *  判断cookie是否等于服务器约定的ECM_ID
        //                 */
        //                if ([cookie.name isEqualToString:@"ECM_ID"]) {
        //                    //实现了一个管理cookie的单例对象,每个cookie都是NSHTTPCookie类的实例,将cookies传给服务器
        //                    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        //                }
        //            }
        //        }
    }
    return self;
}

- (id)initWithRequestType:(TTREQUEST_TYPE)networkType
                      url:(NSString*)url
                paramters:(NSDictionary*)params
                  success:(TTSuccessBlock)successBlock
                  failure:(TTFailureBlock)failureBlock
                  showHUD:(BOOL)showHUD
                  timeOut:(NSInteger)time
{

    if (self = [super init]) {
        //        WEAKSELF;
        //        if (showHUD==YES) {
        //            [MBProgressHUD showHUDAddedTo:nil animated:YES];
        //        }
        _manager = [AFHTTPSessionManager manager];
        //        manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObject:@"text/html"];
        _manager.requestSerializer = [AFJSONRequestSerializer serializer]; //申明请求的数据是json类型
        //        _manager.responseSerializer = [AFJSONResponseSerializer serializer];//申明返回的结果是json类型
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/html", nil];
        _manager.requestSerializer.timeoutInterval = time;
        _manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;

#pragma mark - 登陆后已token作为用户标示.
        if ([CSUserInfo shareInstance].isOnline) {
            [_manager.requestSerializer setValue:[CSUserInfo shareInstance].info.token forHTTPHeaderField:@"token"];
        }

//        _manager.securityPolicy = [CSNetWorkingRequest customSecurityPolicy];

        if (networkType == GET_TTREQUEST_TYPE) {

            [_manager GET:url parameters:params
             
                success:^(NSURLSessionDataTask* _Nonnull task, id _Nullable responseObject) {

                    CSHttpsResModel* back = [CSHttpsResModel mj_objectWithKeyValues:responseObject];
                    if (back.code == successCode) {
                        if (successBlock) {
                            NSDictionary* json;

                            json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
#if SWITCH_OPEN_LOG
                            DLog(@"--------------------------------------------------------------------------------------\n🍎🍎🍎GET.url--->👇👇👇\n%@\n--------------------------------------------------------------------------------------\n%@\n======================================================================================",
                                task.response.URL, json);
#endif
                            successBlock(responseObject);
                        }
                    }
                    else {

                        NSError* error = [NSError errorWithDomain:@"连接失败!" code:201 userInfo:nil];

                        if (showHUD) {

                            if (back.msg) {
                                [MBProgressHUD tt_ErrorTitle:back.msg];
                                error = [NSError errorWithDomain:back.msg code:201 userInfo:nil];
                            }
                            else {
                                [MBProgressHUD tt_ErrorTitle:@"无错误描述"];
                            }
                        }
                        else {
                            if (back.msg) {

                                error = [NSError errorWithDomain:back.msg code:201 userInfo:nil];
                            }
                            else {
                            }
                        }
                        if (failureBlock) {
                            DLog(@"%@", error);
                            failureBlock(error);
                        }
                    }
                }
                failure:^(NSURLSessionDataTask* _Nullable task, NSError* _Nonnull error) {
                    if (showHUD) {
                        [MBProgressHUD tt_ErrorTitle:@"连接失败"];
                    }
                    else {
                    }
                    if (failureBlock) {
                        NSError* myerror = [NSError errorWithDomain:@"连接失败!" code:201 userInfo:nil];
                        DLog(@"%@", error);
                        failureBlock(myerror);
                    }

                }];
        }
        else {
            [_manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {

            }
             
                success:^(NSURLSessionDataTask* _Nonnull task, id _Nullable responseObject) {
                    NSDictionary* json;

                    json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
#if SWITCH_OPEN_LOG
                    DLog(@"--------------------------------------------------------------------------------------\n🍎🍎🍎POST.url--->👇👇👇\n%@\n--------------------------------------------------------------------------------------\n%@\n======================================================================================",
                        task.response.URL, [responseObject mj_JSONString]);
#endif
                    CSHttpsResModel* back = [CSHttpsResModel mj_objectWithKeyValues:json];
                    if (back.code == successCode) {
                        if (successBlock) {
                            successBlock(responseObject);
                        }
                    }
                    else {

                        if (showHUD) {
                            if (back.msg) {
                                [MBProgressHUD tt_ErrorTitle:back.msg];
                            }
                            else {
                                [MBProgressHUD tt_ErrorTitle:@"无错误描述"];
                            }
                        }

                        NSError* error = [NSError errorWithDomain:back.msg.length ? back.msg : @"程序猿哥哥正在紧急修复" code:201 userInfo:nil];
                        //                            if (failureBlock) {
                        //                                DLog(@"%@", error);
                        //                                failureBlock(error);
                        //                            }
                        //                           NSError * error = [NSError errorWithDomain:@"连接失败!" code:201 userInfo:nil];

                        failureBlock(error);
                    }
                    DLog(@"---> %@", json);

                }
                failure:^(NSURLSessionDataTask* _Nullable task, NSError* _Nonnull error) {
                    if (showHUD) {
                        [MBProgressHUD tt_ErrorTitle:@"连接失败"];
                    }
                    else {
                        //                        [MBProgressHUD tt_Hide];
                    }
                    if (failureBlock) {
                        DLog(@"%@", error);
                        failureBlock(error);
                    }
                }];
        }
    }
    return self;
}

- (id)initWithRequestType:(TTREQUEST_TYPE)networkType
                      url:(NSString*)url
                paramters:(NSDictionary*)params
                  success:(TTSuccessBlock)successBlock
                  failure:(TTFailureBlock)failureBlock
       uploadFileProgress:(void(^)(NSProgress *uploadProgress))uploadFileProgress
                 filePath:(NSString *)filePath
                  showHUD:(BOOL)showHUD
{
    
    if (self = [super init]) {
        
        _manager = [AFHTTPSessionManager manager];
        //        manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObject:@"text/html"];
        _manager.requestSerializer = [AFJSONRequestSerializer serializer]; //申明请求的数据是json类型
        //        _manager.responseSerializer = [AFJSONResponseSerializer serializer];//申明返回的结果是json类型
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/html", nil];
        _manager.requestSerializer.timeoutInterval = 30;
        _manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
        
        //        _manager.securityPolicy = [CSNetWorkingRequest customSecurityPolicy];
#pragma mark - 登陆后已token作为用户标示.
        if ([CSUserInfo shareInstance].isOnline) {
            [_manager.requestSerializer setValue:[CSUserInfo shareInstance].info.token forHTTPHeaderField:@"token"];
        }
        
        [_manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName;
            NSString * mimeType;
            switch (networkType) {
                case UpLoad_Image:
                {
                    fileName = [NSString stringWithFormat:@"%@.png", str];
                    mimeType = @"image/png";
                }
                    break;
                case UpLoad_Voice:
                {
                    fileName = [NSString stringWithFormat:@"%@.mp3", str];
                    mimeType = @"audio/mpeg";
                }
                    break;
                default:
                    break;
            }
            [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath] name:@"file" fileName:fileName mimeType:mimeType error:nil];
//            [formData appendPartWithFileData:image name:[params objectForKey:@"fileKey"] fileName:fileName mimeType:mimeType];
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
#if SWITCH_OPEN_LOG
            DLog(@"--------------------------------------------------------------------------------------\n🍎🍎🍎POST.url--->👇👇👇\n%@\n--------------------------------------------------------------------------------------\n%@\n======================================================================================",
                 task.response.URL, [responseObject mj_JSONString]);
#endif
            CSHttpsResModel* back = [CSHttpsResModel mj_objectWithKeyValues:responseObject];
            if (back.code == successCode) {
                if (successBlock) {
                    successBlock(responseObject);
                }
            }
            else {
                
                if (showHUD) {
                    if (back.msg) {
                        [MBProgressHUD tt_ErrorTitle:back.msg];
                    }
                    else {
                        [MBProgressHUD tt_ErrorTitle:@"程序猿哥哥正在紧急修复!"];
                    }
                }
                
                NSError* error = [NSError errorWithDomain:back.msg.length ? back.msg : @"程序猿哥哥正在紧急修复" code:201 userInfo:nil];
                if (failureBlock) {
                    DLog(@"%@", error);
                    failureBlock(error);
                }
            }
            DLog(@"---> %@", back.mj_keyValues);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (error.code == -1009) {
                [MBProgressHUD tt_ErrorTitle:@"网络已断开"];
            }
            else if (error.code == -1005) {
                [MBProgressHUD tt_ErrorTitle:@"网络连接已中断"];
            }
            else if (error.code == -1001) {
                [MBProgressHUD tt_ErrorTitle:@"请求超时"];
            }
            else if (error.code == -1003) {
                [MBProgressHUD tt_ErrorTitle:@"未能找到使用指定主机名的服务器"];
            }
            else {
                [MBProgressHUD tt_ErrorTitle:[NSString stringWithFormat:@"code:%ld %@", error.code, error.localizedDescription]];
            }
            if (showHUD) {
                [MBProgressHUD tt_ErrorTitle:@"连接失败"];
            }
            else {
                //                        [MBProgressHUD tt_Hide];
            }
            if (failureBlock) {
                if (error.code == -1009) {
                    error = [NSError errorWithDomain:@"连接失败" code:201 userInfo:nil];
                }
                DLog(@"%@", error);
                failureBlock(error);
            }
        }];
    }
    return self;
}

- (id)initWithRequestType:(TTREQUEST_TYPE)networkType
                      url:(NSString*)url
                paramters:(NSDictionary*)params
                  success:(TTSuccessBlock)successBlock
                  failure:(TTFailureBlock)failureBlock
       uploadFileProgress:(void(^)(NSProgress *uploadProgress))uploadFileProgress
                 fileData:(NSData *)fileData
                  showHUD:(BOOL)showHUD
{
    if (self = [super init]) {
        
        _manager = [AFHTTPSessionManager manager];
        //        manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObject:@"text/html"];
        _manager.requestSerializer = [AFJSONRequestSerializer serializer]; //申明请求的数据是json类型
        //        _manager.responseSerializer = [AFJSONResponseSerializer serializer];//申明返回的结果是json类型
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/html", nil];
        _manager.requestSerializer.timeoutInterval = 30;
        _manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
        
        //        _manager.securityPolicy = [CSNetWorkingRequest customSecurityPolicy];
#pragma mark - 登陆后已token作为用户标示.
        if ([CSUserInfo shareInstance].isOnline) {
            [_manager.requestSerializer setValue:[CSUserInfo shareInstance].info.token forHTTPHeaderField:@"token"];
        }
        
        [_manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName;
            NSString * mimeType;
            switch (networkType) {
                case UpLoad_Image:
                {
                    fileName = [NSString stringWithFormat:@"%@.png", str];
                    mimeType = @"image/png";
                }
                    break;
                case UpLoad_Voice:
                {
                    fileName = [NSString stringWithFormat:@"%@.mp3", str];
                    mimeType = @"audio/mpeg";
                }
                    break;
                default:
                    break;
            }
            [formData appendPartWithFileData:fileData name:@"file" fileName:fileName mimeType:mimeType];
//            [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath] name:@"file" fileName:fileName mimeType:mimeType error:nil];
//                        [formData appendPartWithFileData:image name:[params objectForKey:@"fileKey"] fileName:fileName mimeType:mimeType];
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
#if SWITCH_OPEN_LOG
            DLog(@"--------------------------------------------------------------------------------------\n🍎🍎🍎POST.url--->👇👇👇\n%@\n--------------------------------------------------------------------------------------\n%@\n======================================================================================",
                 task.response.URL, [responseObject mj_JSONString]);
#endif
            CSHttpsResModel* back = [CSHttpsResModel mj_objectWithKeyValues:responseObject];
            if (back.code == successCode) {
                if (successBlock) {
                    successBlock(responseObject);
                }
            }
            else {
                
                if (showHUD) {
                    if (back.msg) {
                        [MBProgressHUD tt_ErrorTitle:back.msg];
                    }
                    else {
                        [MBProgressHUD tt_ErrorTitle:@"程序猿哥哥正在紧急修复!"];
                    }
                }
                
                NSError* error = [NSError errorWithDomain:back.msg.length ? back.msg : @"程序猿哥哥正在紧急修复" code:201 userInfo:nil];
                if (failureBlock) {
                    DLog(@"%@", error);
                    failureBlock(error);
                }
            }
            DLog(@"---> %@", back.mj_keyValues);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (error.code == -1009) {
                [MBProgressHUD tt_ErrorTitle:@"网络已断开"];
            }
            else if (error.code == -1005) {
                [MBProgressHUD tt_ErrorTitle:@"网络连接已中断"];
            }
            else if (error.code == -1001) {
                [MBProgressHUD tt_ErrorTitle:@"请求超时"];
            }
            else if (error.code == -1003) {
                [MBProgressHUD tt_ErrorTitle:@"未能找到使用指定主机名的服务器"];
            }
            else {
                [MBProgressHUD tt_ErrorTitle:[NSString stringWithFormat:@"code:%ld %@", error.code, error.localizedDescription]];
            }
            if (showHUD) {
                [MBProgressHUD tt_ErrorTitle:@"连接失败"];
            }
            else {
                //                        [MBProgressHUD tt_Hide];
            }
            if (failureBlock) {
                if (error.code == -1009) {
                    error = [NSError errorWithDomain:@"连接失败" code:201 userInfo:nil];
                }
                DLog(@"%@", error);
                failureBlock(error);
            }
        }];
    }
    return self;
}

- (NSString *)mimeTypeForFileAtPath:(NSString *)path
{
    if (![[[NSFileManager alloc] init] fileExistsAtPath:path]) {
        return nil;
    }
    
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)[path pathExtension], NULL);
    CFStringRef MIMEType = UTTypeCopyPreferredTagWithClass (UTI, kUTTagClassMIMEType);
    CFRelease(UTI);
    if (!MIMEType) {
        return @"application/octet-stream";
    }
    return (__bridge NSString *)(MIMEType);
}

- (void)dealloc
{
    DLog(@"---------");
}

@end
