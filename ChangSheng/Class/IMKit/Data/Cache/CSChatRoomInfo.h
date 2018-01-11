//
//  CSChatRoomInfo.h
//  ChangSheng
//
//  Created by 邴天宇 on 2018/1/11.
//  Copyright © 2018年 邴天宇. All rights reserved.
//

#import <Realm/Realm.h>

@interface CSChatRoomInfo : RLMObject
@property (nonatomic,copy) NSString *group_id;
/**
 是否静音
 */
@property (nonatomic, assign) BOOL mute;
@end
