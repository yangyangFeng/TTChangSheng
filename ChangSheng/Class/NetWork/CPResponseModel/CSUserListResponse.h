//
//  CSUserListResponse.h
//  ChangSheng
//
//  Created by 邴天宇 on 2018/1/9.
//  Copyright © 2018年 邴天宇. All rights reserved.
//

#import "CSHttpsResModel.h"

@interface CSUserListResponse : CSHttpsResModel

@property (nonatomic,strong) NSArray<CSUserListResponse *> *result;

@property (nonatomic,copy) NSString *nickname;
@property (nonatomic,copy) NSString *avatar;
@property (nonatomic,copy) NSString *user_id;

@end
