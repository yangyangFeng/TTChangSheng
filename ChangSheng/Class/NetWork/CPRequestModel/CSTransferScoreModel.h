//
//  CSTransferScoreModel.h
//  ChangSheng
//
//  Created by 邴天宇 on 2017/10/18.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSHttpsResModel.h"

@interface CSTransferScoreModel : CSHttpsResModel
@property (nonatomic,copy) NSString *score;
@property (nonatomic,copy) NSString *to_code;
@property (nonatomic,copy) NSString *password;

@property (nonatomic,copy) NSString *surplus_score;
@end
