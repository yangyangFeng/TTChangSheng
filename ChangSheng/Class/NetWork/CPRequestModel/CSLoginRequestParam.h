//
//  CSLoginRequestParam.h
//  ChangSheng
//
//  Created by 邴天宇 on 17/9/25.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSBaseRequestModel.h"

@interface CSLoginRequestParam : CSBaseRequestModel
@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *password;
@end
