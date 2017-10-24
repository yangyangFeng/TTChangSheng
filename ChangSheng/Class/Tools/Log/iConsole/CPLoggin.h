//
//  Loggin.h
//  cnepay_sdk
//
//  Created by BlackAnt on 17/3/27.
//  Copyright © 2017年 cne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iConsole.h"

#define LOG_INFO_NEW_FMT(fmt) \
[NSString stringWithFormat:@"[LOG] %s(%d) %@", \
__FUNCTION__, \
__LINE__, \
fmt]

#define SYSTEM_LOG
#ifdef  SYSTEM_LOG
#define NSLog(fmt,...) NSLog(LOG_INFO_NEW_FMT(fmt),##__VA_ARGS__,nil)
#else
#define NSLog(fmt,...)
#endif

@interface CPLoggin : NSObject

+ (void)cp_infoLog:(NSString *)format, ...;
+ (void)cp_errorLog:(NSString *)format, ...;
+ (void)cp_warnLog:(NSString *)format, ...;
+ (void)cp_inputLog:(NSString *)format, ...;

@end
