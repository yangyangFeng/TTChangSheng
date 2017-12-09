//
//  CSAddFriendParam.h
//  ChangSheng
//
//  Created by 邴天宇 on 2017/12/9.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSBaseRequestModel.h"

@interface CSAddFriendParam : CSBaseRequestModel
@property (nonatomic,copy) NSString *friend_id;
@property (nonatomic,copy) NSString *msg;
@end
