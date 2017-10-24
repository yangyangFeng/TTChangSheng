//
//  LLMessageCellManager.m
//  LLWeChat
//
//  Created by GYJZH on 9/25/16.
//  Copyright © 2016 GYJZH. All rights reserved.
//

#import "LLMessageCellManager.h"
#import "LLUtils.h"
#import "LLConfig.h"

typedef NSMutableDictionary<NSString *, LLMessageBaseCell *> *DICT_TYPE;

//最多缓存的Cell数
#define MAX_CACHE_CELLS 1300

//当退出会话时，保留的Cell数
#define CACHE_CELLS_RETAINT_NUM 130

#define INITIAL_CAPACITY MAX_CACHE_CELLS

@interface LL_MessageCell_Data : NSObject

@property (nonatomic, copy) NSString *conversationId;

//依照messageModel.timestamp 升序排序
@property (nonatomic) NSMutableArray<LLMessageBaseCell *> *allMessageCells;

@end

@implementation LL_MessageCell_Data


@end


@interface LLMessageCellManager ()

@property (nonatomic, readwrite) DICT_TYPE allMessageCells;

@property (nonatomic) NSMutableArray<LL_MessageCell_Data *> *allMessageCellData;

@end

@implementation LLMessageCellManager

CREATE_SHARED_MANAGER(LLMessageCellManager)

- (instancetype)init {
    self = [super init];
    if (self) {
        _allMessageCellData = [NSMutableArray array];
        _allMessageCells = [NSMutableDictionary dictionaryWithCapacity:INITIAL_CAPACITY];
    }
    
    return self;
}

- (NSDictionary<NSString *, LLMessageBaseCell *> *)allCells {
    return _allMessageCells;
}

- (NSString *)reuseIdentifierForMessegeModel:(CSMessageModel *)model {
//    switch (CS_changeMessageType(model.msgType)) {
    switch (model.body.msgType) {
        case kCSMessageBodyTypeText:
            return model.isSelf ? @"messageTypeTextMe" : @"messageTypeText";
        case kCSMessageBodyTypeImage:
            return model.isSelf ? @"messageTypeImageMe" : @"messageTypeImage";
        case kCSMessageBodyTypeVoice:
            return model.isSelf ? @"messageTypeVoiceMe" : @"messageTypeVoice";
        case kCSMessageBodyTypeLink:
            return model.isSelf ? @"messageTypeImageMe" : @"messageTypeImage";
        case kCSMessageBodyTypeDateTime:
            return @"messageTypeDateTime";
        case kCSMessageBodyTypeGif:
            return model.isSelf ? @"messageTypeGifMe" : @"messageTypeGif";
        case kCSMessageBodyTypeLocation:
            return model.isSelf ? @"messageTypeLocationMe" : @"messageTypeLocation";
        case kCSMessageBodyTypeVideo:
            return model.isSelf ? @"messageTypeVideoMe" : @"messageTypeVideo";
        default:
            break;
    }
    
    return @"messageTypeNone";
}

- (Class)tableViewCellClassForMessegeModel:(CSMessageModel *)model {
//    switch (model.messageBodyType) {
    switch (model.body.msgType) {
        case kCSMessageBodyTypeText:
            return [LLMessageTextCell class];
        case kCSMessageBodyTypeImage:
            return [LLMessageImageCell class];
        case kCSMessageBodyTypeLink:
            return [LLMessageImageCell class];
        case kCSMessageBodyTypeDateTime:
            return [LLMessageDateCell class];
        case kCSMessageBodyTypeVoice:
            return [LLMessageVoiceCell class];
        case kCSMessageBodyTypeGif:
            return [LLMessageGifCell class];
        case kCSMessageBodyTypeLocation:
            return [LLMessageLocationCell class];
        case kCSMessageBodyTypeVideo:
            return [LLMessageVideoCell class];
        default:
            return Nil;
    }
    
    return Nil;
}

- (LLMessageBaseCell *)createMessageCellForMessageModel:(CSMessageModel *)messageModel withReuseIdentifier:(NSString *)reuseId {
    Class cellClass = [self tableViewCellClassForMessegeModel:messageModel];
    LLMessageBaseCell *_cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    
    [_cell prepareForUse:messageModel.isSelf];
    [messageModel setNeedsUpdateForReuse];
    _cell.messageModel = messageModel;
    
    return _cell;
}

- (LLMessageBaseCell *)messageCellForMessageModel:(CSMessageModel *)messageModel tableView:(UITableView *)tableView {
//    LLMessageBaseCell *_cell = _allMessageCells[messageModel.msgId];
//    if (_cell) {
//        return _cell;
//    }
//    
//    LL_MessageCell_Data *data = [self messageCellDataForConversationId:messageModel.msgId];
//    //有空余名额
//    if (_allMessageCells.count < MAX_CACHE_CELLS) {
//        _cell = [self createMessageCellForMessageModel:messageModel withReuseIdentifier:nil];
//        _allMessageCells[messageModel.msgId] = _cell;
//        [self addMessageCellToCellData:_cell cellData:data];
//        
//        while (_allMessageCells.count == MAX_CACHE_CELLS && self.allMessageCellData.count > 1) {
//            [self deleteConversation:self.allMessageCellData[0].conversationId];
//        }
//    }else {
//        //缓存最新消息
//        if (messageModel.timestamp > [data.allMessageCells lastObject].messageModel.timestamp) {
//            LLMessageBaseCell *firstCell = data.allMessageCells[0];
//            [_allMessageCells removeObjectForKey:firstCell.messageModel.msgId];
//            [data.allMessageCells removeObjectAtIndex:0];
//            
//            _cell = [self createMessageCellForMessageModel:messageModel withReuseIdentifier:nil];
//            _allMessageCells[messageModel.msgId] = _cell;
//            [self addMessageCellToCellData:_cell cellData:data];
//        //采用TableView重用
//        }else {
//            NSString *reuseId = [self reuseIdentifierForMessegeModel:messageModel];
//            _cell = (LLMessageBaseCell *)[tableView dequeueReusableCellWithIdentifier:reuseId];
//            if (!_cell) {
//                _cell = [self createMessageCellForMessageModel:messageModel withReuseIdentifier:reuseId];
//            }else {
//                [messageModel setNeedsUpdateForReuse];
//            }
//        }
//        
//    }
    
    LLMessageBaseCell *_cell ;
    NSString *reuseId = [self reuseIdentifierForMessegeModel:messageModel];
    _cell = (LLMessageBaseCell *)[tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!_cell) {
        _cell = [self createMessageCellForMessageModel:messageModel withReuseIdentifier:reuseId];
    }else {
        [messageModel setNeedsUpdateForReuse];
        _cell.messageModel = messageModel;
    }
    
    return _cell;
}


- (void)cleanCacheWhenConversationExit:(NSString *)conversationId {
    LL_MessageCell_Data *data = [self messageCellDataForConversationId:conversationId];
    if (data.allMessageCells.count > CACHE_CELLS_RETAINT_NUM) {
        NSRange range = NSMakeRange(0, data.allMessageCells.count - CACHE_CELLS_RETAINT_NUM);
        NSArray<LLMessageBaseCell *> *deleteCells = [data.allMessageCells subarrayWithRange:range];
        [data.allMessageCells removeObjectsInRange:range];
        
        for (LLMessageBaseCell *cell in deleteCells) {
            [_allMessageCells removeObjectForKey:cell.messageModel.msgId];
        }
        
    }

}

//创建Data，并把它放到数组最后
- (void)prepareCacheWhenConversationBegin:(NSString *)conversationId {
    LL_MessageCell_Data *data = [self messageCellDataForConversationId:conversationId];
    [self.allMessageCellData removeObject:data];
    [self.allMessageCellData addObject:data];
}

- (void)deleteAllCells {
    [_allMessageCells removeAllObjects];
    [_allMessageCellData removeAllObjects];
}

- (LLMessageBaseCell *)cellForMessageId:(NSString *)msgid {
    return self.allCells[msgid];
}

- (LLMessageBaseCell *)removeCellForMessageModel:(CSMessageModel *)messageModel {
    LL_MessageCell_Data *data = [self messageCellDataForConversationId:messageModel.chatId];
    
    LLMessageBaseCell *cell = self.allCells[messageModel.msgId];
    if (cell) {
        [_allMessageCells removeObjectForKey:messageModel.msgId];
        [data.allMessageCells removeObject:cell];
    }
    
    return cell;
}

- (void)updateMessageModel:(CSMessageModel *)messageModel toMessageId:(NSString *)newMessageId {
    LLMessageBaseCell *cell = self.allCells[messageModel.msgId];
    if (cell) {
        [_allMessageCells removeObjectForKey:messageModel.msgId];
        _allMessageCells[newMessageId] = cell;
    }

}

- (void)removeCellsForMessageModelsInArray:(NSArray<CSMessageModel *> *)messageModels {
    if (messageModels.count == 0)
        return;
    
    LL_MessageCell_Data *data = [self messageCellDataForConversationId:messageModels[0].msgId];
    
    for (CSMessageModel *model in messageModels) {
        LLMessageBaseCell *cell = self.allCells[model.msgId];
        if (cell) {
            [_allMessageCells removeObjectForKey:model.msgId];
            [data.allMessageCells removeObject:cell];
        }
    }
    
}


- (void)deleteConversation:(NSString *)conversationId {
    NSMutableArray<NSString *> *keys = [NSMutableArray array];
    for (NSString *key in self.allCells) {
        LLMessageBaseCell *cell = self.allCells[key];
        if ([cell.messageModel.chatId isEqualToString:conversationId]) {
            [keys addObject:key];
        }
    }
    
    if (keys.count > 0)
        [_allMessageCells removeObjectsForKeys:keys];
    
    LL_MessageCell_Data *data = [self messageCellDataForConversationId:conversationId];
    [self.allMessageCellData removeObject:data];
    
}

#pragma mark -内部方法 -

- (LL_MessageCell_Data *)messageCellDataForConversationId:(NSString *)conversationId {
    for (LL_MessageCell_Data *data in self.allMessageCellData) {
        if ([data.conversationId isEqualToString:conversationId]) {
            return data;
        }
    }
    
    LL_MessageCell_Data *data = [[LL_MessageCell_Data alloc] init];
    data.conversationId = conversationId;
    data.allMessageCells = [NSMutableArray array];
    [self.allMessageCellData addObject:data];
    
    return data;
}

- (void)addMessageCellToCellData:(LLMessageBaseCell *)cell cellData:(LL_MessageCell_Data *)data {
    if (![cell.messageModel.chatId isEqualToString:data.conversationId]) {
        return;
    }
    
    NSInteger i = 0, count = data.allMessageCells.count;
    for (; i < count; i++) {
        if (cell.messageModel.timestamp < data.allMessageCells[i].messageModel.timestamp) {
            break;
        }
    }
    
    [data.allMessageCells insertObject:cell atIndex:i];
}


@end
