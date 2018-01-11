//
//  CSChatRoomInfoManager.h
//  ChangSheng
//
//  Created by 邴天宇 on 2018/1/11.
//  Copyright © 2018年 邴天宇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSChatRoomInfoManager : NSObject
+ (void)setChatGroupMute:(NSString *)group_id isMute:(BOOL)mute;
+ (BOOL)getChatGroupMute:(NSString *)group_id;
@end
