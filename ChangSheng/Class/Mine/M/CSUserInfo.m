//
//  CSUserInfo.m
//  ChangSheng
//
//  Created by 邴天宇 on 17/9/24.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSUserInfo.h"
#import "CSUserServiceListViewController.h"
#define USER_CACHE_KEY @"cs_user_login_info"
static CSUserInfo * info = nil;
@implementation CSUserInfo

{
    BOOL isOnline;
}

+ (CSUserInfo *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        NSDictionary * userInfo;
        if ((userInfo = [userDefaults objectForKey:USER_CACHE_KEY])) {
            info = [CSUserInfo mj_objectWithKeyValues:userInfo];
        }
        else
        {
            info = [CSUserInfo new];
        }
    });
    return info;
}

-(void)login
{
    self->isOnline = YES;
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.mj_keyValues forKey:USER_CACHE_KEY];
}

-(void)logout
{
    self->isOnline = NO;
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:USER_CACHE_KEY];
    
    [CSUserServiceListViewController clear];
}

-(BOOL)isOnline
{
    return self->isOnline;
}

- (void)syncUserNickName:(NSString *)nickName
{
    self.info.nickname = nickName;
    [self syncSave];
}
- (void)syncUserAvatar:(NSString *)avatar
{
    self.info.avatar = avatar;
    [self syncSave];
}
- (void)syncUserSurplus_score:(int )surplus_score
{
    self.info.surplus_score = surplus_score;
    [self syncSave];
}

- (void)syncSave
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.mj_keyValues forKey:USER_CACHE_KEY];
}
@end
