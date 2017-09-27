//
//  CSLoginHandler.h
//  ChangSheng
//
//  Created by 邴天宇 on 17/9/24.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^voidBlock)();
typedef void(^successBlock)(id obj);
typedef void(^errorBlock)(NSError *error);

@interface CSLoginHandler : NSObject
/**
 * 成功
 */
+ (void)loginWithParams:(NSDictionary *)params
           successBlock:(successBlock)success
              failBlock:(errorBlock)fail;
/**
 *  注册
 */
+ (void)registerWithParams:(NSDictionary *)params
              successBlock:(successBlock)success
                 failBlock:(errorBlock)fail;
@end
