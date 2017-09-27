//
//  CSIMSendMessageRequest.h
//  TestAAA
//
//  Created by cnepayzx on 2017/9/25.
//  Copyright © 2017年 bingtianyu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^sendSuccess)(id obj);
typedef void(^sendFail)(NSError * error);
@interface CSIMSendMessageRequest : NSObject

+ (void)sendMessage:(id)message
     successBlock:(sendSuccess)success
        failBlock:(sendFail)fail;

@end
