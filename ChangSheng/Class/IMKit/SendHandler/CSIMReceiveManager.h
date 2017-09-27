//
//  CSIMReceiveManager.h
//  WebSocketTest
//
//  Created by cnepayzx on 2017/9/27.
//  Copyright © 2017年 bingtianyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSIMSendMessageRequestModel.h"
@interface CSIMReceiveManager : NSObject

+ (CSIMReceiveManager *)shareInstance;

- (void)receiveMessage:(CSIMSendMessageRequestModel *)message;

@end
