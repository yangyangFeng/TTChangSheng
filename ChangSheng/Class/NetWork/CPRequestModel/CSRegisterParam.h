//
//  CSRegisterParam.h
//  ChangSheng
//
//  Created by 邴天宇 on 17/9/24.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSBaseRequestModel.h"

@interface CSRegisterParam : CSBaseRequestModel
@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *nickname;
@property (nonatomic,copy) NSString *password;
@property (nonatomic,copy) NSString *referee_code;

@property (nonatomic,copy) NSString *file;


@end
