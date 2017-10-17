#import <Foundation/Foundation.h>

#import "CSNewWorking.h"
@interface CSNetWorkingRequest : NSObject
- (id)initWithRequestType:(TTREQUEST_TYPE)networkType
                      url:(NSString*)url
                paramters:(NSDictionary*)params
                  success:(TTSuccessBlock)successBlock
                  failure:(TTFailureBlock)failureBlock
                  showHUD:(BOOL)showHUD;
- (id)initWithRequestType:(TTREQUEST_TYPE)networkType
                      url:(NSString*)url
                paramters:(NSDictionary*)params
                  success:(TTSuccessBlock)successBlock
                  failure:(TTFailureBlock)failureBlock
       uploadFileProgress:(void(^)(CGFloat uploadProgress))uploadFileProgress
                    image:(NSData *)image
                  showHUD:(BOOL)showHUD;

- (id)_initWithRequestType:(TTREQUEST_TYPE)networkType
                       url:(NSString*)url
                 paramters:(NSDictionary*)params
                   success:(TTSuccessBlock)successBlock
                   failure:(TTFailureBlock)failureBlock
                   showHUD:(UIView *)showHUD;

- (id)initWithRequestType:(TTREQUEST_TYPE)networkType
                      url:(NSString*)url
                paramters:(NSDictionary*)params
                  success:(TTSuccessBlock)successBlock
                  failure:(TTFailureBlock)failureBlock
                  showHUD:(BOOL)showHUD
                  timeOut:(NSInteger)time;

- (id)initWithRequestType:(TTREQUEST_TYPE)networkType
                      url:(NSString*)url
                paramters:(NSDictionary*)params
                  success:(TTSuccessBlock)successBlock
                  failure:(TTFailureBlock)failureBlock
       uploadFileProgress:(void(^)(CGFloat uploadProgress))uploadFileProgress
                    filePath:(NSString *)filePath
                  showHUD:(BOOL)showHUD;

- (id)initWithRequestType:(TTREQUEST_TYPE)networkType
                      url:(NSString*)url
                paramters:(NSDictionary*)params
                  success:(TTSuccessBlock)successBlock
                  failure:(TTFailureBlock)failureBlock
       uploadFileProgress:(void(^)(CGFloat uploadProgress))uploadFileProgress
                 fileData:(NSData *)fileData
                  showHUD:(BOOL)showHUD;
@end
