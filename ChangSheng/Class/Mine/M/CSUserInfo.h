//
//  CSUserInfo.h
//  ChangSheng
//
//  Created by 邴天宇 on 17/9/24.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CSUserInfoModel.h"

@interface CSUserInfo : NSObject

+ (CSUserInfo *)shareInstance;


@property (nonatomic, strong)CSUserInfoModel* info;
/**
 *  获取登录状态
 */
@property (nonatomic,assign,readonly) BOOL isOnline;
/**
 *  登陆成功
 */
- (void)login;
/**
 *  注销登陆
 */
- (void)logout;

- (void)syncUserNickName:(NSString *)nickName;
- (void)syncUserAvatar:(NSString *)avatar;
- (void)syncUserSurplus_score:(int )surplus_score;
@end
