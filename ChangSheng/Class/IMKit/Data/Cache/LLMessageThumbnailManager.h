//
//  LLMessageThumbnailManager.h
//  LLWeChat
//
//  Created by GYJZH on 22/10/2016.
//  Copyright © 2016 GYJZH. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CSMessageModel;
@class LLConversationModel;

NS_ASSUME_NONNULL_BEGIN

@interface LLMessageThumbnailManager : NSObject

+ (instancetype)sharedManager;

- (nullable UIImage *)thumbnailForMessageModel:(CSMessageModel *)messageModel;

- (void)removeThumbnailForMessageModel:(CSMessageModel *)messageModel removeFromDisk:(BOOL)removeFromDisk;

- (void)removeThumbnailForMessageModelsInArray:(NSArray<CSMessageModel *> *)messageModels removeFromDisk:(BOOL)removeFromDisk;

- (void)addThumbnailForMessageModel:(CSMessageModel *)messageModel thumbnail:(UIImage *)thumbnail toDisk:(BOOL)toDisk;

- (void)cleanCacheWhenConversationExit:(NSString *)conversationId;

- (void)prepareCacheWhenConversationBegin:(NSString *)conversationId;

- (void)clearAllMemCache;

- (void)deleteConversation:(NSString *)conversationId;

//删除date之后未访问过的缩略图
- (void)clearAllDiskCacheBeforeDate:(NSDate *)trimDate;

@end

NS_ASSUME_NONNULL_END
