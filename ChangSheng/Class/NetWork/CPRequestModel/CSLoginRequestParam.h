//
//  CSLoginRequestParam.h
//  ChangSheng
//
//  Created by 邴天宇 on 17/9/25.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CPBaseRequestModel.h"

@interface CSLoginRequestParam : CPBaseRequestModel
@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *password;
@end
