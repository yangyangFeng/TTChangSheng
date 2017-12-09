//
//  CSUserInfoModel.h
//  ChangSheng
//
//  Created by 邴天宇 on 17/9/24.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSHttpsResModel.h"
@interface CSUserInfoModel : NSObject
@property (nonatomic,copy) NSString *avatar;
@property (nonatomic,copy) NSString *nickname;
@property (nonatomic,assign) int surplus_score;
@property (nonatomic,copy) NSString *token;

@property (nonatomic,copy) NSString *code;
@property (nonatomic,copy) NSString *id;
@end
