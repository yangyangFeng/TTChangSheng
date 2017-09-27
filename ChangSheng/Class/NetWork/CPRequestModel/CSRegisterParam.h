//
//  CSRegisterParam.h
//  ChangSheng
//
//  Created by 邴天宇 on 17/9/24.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CPBaseRequestModel.h"

@interface CSRegisterParam : CPBaseRequestModel
@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *password;
@property (nonatomic,copy) NSString *referee_code;
@end
