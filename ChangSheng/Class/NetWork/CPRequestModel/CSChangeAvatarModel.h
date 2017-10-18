//
//  CSChangeAvatarModel.h
//  ChangSheng
//
//  Created by 邴天宇 on 2017/10/18.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSHttpsResModel.h"

@interface CSChangeAvatarModel : CSHttpsResModel
@property (nonatomic,strong) CSChangeAvatarModel *result;
@property (nonatomic,copy) NSString *avatar;

@property (nonatomic,copy) NSString *nickname;
@end
