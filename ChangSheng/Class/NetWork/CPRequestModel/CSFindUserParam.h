//
//  CSFindUserParam.h
//  ChangSheng
//
//  Created by 邴天宇 on 2017/12/9.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSBaseRequestModel.h"

@interface CSFindUserParam : CSBaseRequestModel
@property (nonatomic,copy) NSString *usermark;

@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSString *nickname;
@property (nonatomic,copy) NSString *avatar;
@property (nonatomic,assign) BOOL is_friend;

@property (nonatomic,strong) CSFindUserParam *result;

@property (nonatomic,copy) NSString *code;
@property (nonatomic,copy) NSString *msg;
@end
