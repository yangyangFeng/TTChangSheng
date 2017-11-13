//
//  CSMessageRecordTool.h
//  ChangSheng
//
//  Created by cnepayzx on 2017/11/10.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSMessageDBModel.h"



typedef void(^loadDatas)(NSArray *msgs);

@class CSMessageModel;

#define CSMsgCacheTool [CSMessageRecordTool shareInstance]

@interface CSMessageRecordTool : NSObject
+ (CSMessageRecordTool *)shareInstance;
+ (void)setDefaultRealmForUser:(NSString *)username;
/**
 *将数据缓存 从末尾添加
 */
- (CSMessageRecordTool *)cs_cacheMessage:(CSMessageModel *)model userId:(NSString *)userId addLast:(BOOL)addLast;
- (CSMessageRecordTool *)cs_cacheMessages:(NSArray<CSMessageModel*> *)models userId:(NSString *)userId addLast:(BOOL)addLast;

/**
 * default count 20.
 */
- (CSMessageRecordTool *)loadCacheMessageWithUserId:(NSString *)userId loadDatas:(loadDatas)loadDatas;

- (CSMessageRecordTool *)loadCacheMessageWithUserId:(NSString *)userId loadDatas:(loadDatas)loadDatas LastId:(NSString *)lastId count:(NSInteger)count;
@end
