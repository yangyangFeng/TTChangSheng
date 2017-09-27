//
//  GPLoginInfoModel.h
//  ChangSheng
//
//  Created by 邴天宇 on 17/9/24.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSHttpsResModel.h"
#import "CSUserInfoModel.h"
@interface GPLoginInfoModel : CSHttpsResModel
@property (nonatomic, strong)CSUserInfoModel *result;
@end
