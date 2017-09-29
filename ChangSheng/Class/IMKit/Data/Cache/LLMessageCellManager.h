//
//  LLMessageCellManager.h
//  LLWeChat
//
//  Created by GYJZH on 9/25/16.
//  Copyright © 2016 GYJZH. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LLMessageBaseCell.h"
#import "LLMessageImageCell.h"
#import "LLMessageTextCell.h"
#import "LLMessageGifCell.h"
#import "LLMessageLocationCell.h"
#import "LLMessageDateCell.h"
#import "LLMessageVoiceCell.h"
#import "LLMessageVideoCell.h"
#import "LLMessageRecordingCell.h"
#import "LLConversationModel.h"

#import "CSMessageModel.h"
typedef NSMutableDictionary<NSString *, LLMessageBaseCell *> *DICT_TYPE;

@interface LLMessageCellManager : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, readonly) NSDictionary<NSString *, LLMessageBaseCell *> * allCells;

- (void)deleteAllCells;

- (void)cleanCacheWhenConversationExit:(NSString *)conversationId;

- (void)prepareCacheWhenConversationBegin:(NSString *)conversationId;

- (LLMessageBaseCell *)messageCellForMessageModel:(CSMessageModel *)messageModel tableView:(UITableView *)tableView;

- (NSString *)reuseIdentifierForMessegeModel:(CSMessageModel *)model;

- (LLMessageBaseCell *)cellForMessageId:(NSString *)messageId;

- (LLMessageBaseCell *)removeCellForMessageModel:(CSMessageModel *)messageModel ;

- (void)removeCellsForMessageModelsInArray:(NSArray<CSMessageModel *> *)messageModels;

- (void)updateMessageModel:(CSMessageModel *)messageModel toMessageId:(NSString *)newMessageId;

- (void)deleteConversation:(NSString *)conversationId;

@end
