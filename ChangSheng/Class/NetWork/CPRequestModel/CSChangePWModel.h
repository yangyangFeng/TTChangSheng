//
//  CSChangePWModel.h
//  ChangSheng
//
//  Created by 邴天宇 on 2017/10/18.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSHttpsResModel.h"

@interface CSChangePWModel : CSHttpsResModel
@property (nonatomic,copy) NSString *old_pwd;

@property (nonatomic,copy) NSString *cs_new_pwd;
@end
