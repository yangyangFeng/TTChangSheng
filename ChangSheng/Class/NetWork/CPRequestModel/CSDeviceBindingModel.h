//
//  CSDeviceBindingModel.h
//  ChangSheng
//
//  Created by 邴天宇 on 2018/1/2.
//  Copyright © 2018年 邴天宇. All rights reserved.
//

#import "CSBaseRequestModel.h"

@interface CSDeviceBindingModel : CSBaseRequestModel
@property (nonatomic,copy) NSString *device_id;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *system_version;

@end
