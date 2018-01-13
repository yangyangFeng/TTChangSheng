//
//  CSChatRoomInfoManager.m
//  ChangSheng
//
//  Created by 邴天宇 on 2018/1/11.
//  Copyright © 2018年 邴天宇. All rights reserved.
//

#import "CSChatRoomInfoManager.h"

#import <Realm/Realm.h>
#import "CSChatRoomInfo.h"

@implementation CSChatRoomInfoManager
+ (void)setChatGroupMute:(NSString *)group_id isMute:(BOOL)mute
{
    RLMRealm * relm = [RLMRealm defaultRealm];
    NSError * error;
    [relm transactionWithBlock:^{
        RLMResults * result = [CSChatRoomInfo objectsWhere:@"group_id = %@",group_id];
        if (result.count) {
            CSChatRoomInfo * info = [result firstObject];
            info.mute = mute;
            [relm addOrUpdateObject:info];
        }
        else
        {
            CSChatRoomInfo * info = [CSChatRoomInfo new];
            info.group_id = group_id;
            info.mute = mute;
            [relm addObject:info];
        }
    } error:(&error)];
}

+ (BOOL)getChatGroupMute:(NSString *)group_id
{
    RLMResults * result = [CSChatRoomInfo objectsWhere:@"group_id = %@",group_id];
    
    if (result.count) {
        CSChatRoomInfo * info = [result firstObject];
        return info.mute;
    }
    else
    {
        return NO;
    }
}
@end
