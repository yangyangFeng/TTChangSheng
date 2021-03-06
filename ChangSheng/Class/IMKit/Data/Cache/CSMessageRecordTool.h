//
//  CSMessageRecordTool.h
//  ChangSheng
//
//  Created by cnepayzx on 2017/11/10.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSMessageDBModel.h"


#import "CSFriendchartlistModel.h"

#import "CSMessageModel.h"


typedef void(^loadDatas)(NSArray *msgs);




#define CSMsgCacheTool [CSMessageRecordTool shareInstance]

@interface CSMessageRecordTool : NSObject
/**
 *当前聊天对象ID
 */
@property (nonatomic,copy) NSString *currentChatId;
+ (CSMessageRecordTool *)shareInstance;
+ (void)setDefaultRealmForUser:(NSString *)username;
/**
 *将数据缓存 从末尾添加
 */
- (CSMessageRecordTool *)cs_cacheMessage:(CSMessageModel *)model userInfo:(CSCacheUserInfo *)userInfo addLast:(BOOL)addLast chatType:(CS_Message_Record_Type)chatType;
//- (CSMessageRecordTool *)cs_cacheMessage:(CSMessageModel *)model userId:(NSString *)userId addLast:(BOOL)addLast chatType:(CS_Message_Record_Type)chatType;
- (CSMessageRecordTool *)cs_cacheMessages:(NSArray<CSMessageModel*> *)models userInfo:(CSCacheUserInfo *)userInfo addLast:(BOOL)addLast chatType:(CS_Message_Record_Type)chatType;

/**
 * default count 20.
 */
- (CSMessageRecordTool *)loadCacheMessageWithUserId:(NSString *)userId loadDatas:(loadDatas)loadDatas chatType:(CS_Message_Record_Type)chatType;

- (CSMessageRecordTool *)loadCacheMessageWithUserId:(NSString *)userId loadDatas:(loadDatas)loadDatas LastId:(NSString *)lastId count:(NSInteger)count chatType:(CS_Message_Record_Type)chatType;

- (NSArray <CSFriendchartlistModel*> *)AccessToChatFriendWith:(CS_Message_Record_Type)chatType;

/**
 根据 useid 和聊天类型转换DB userid

 @param userId <#userId description#>
 @param chatType <#chatType description#>
 @return <#return value description#>
 */
- (NSString *)userId:(NSString *)userId chatType:(CS_Message_Record_Type)chatType;
@end
