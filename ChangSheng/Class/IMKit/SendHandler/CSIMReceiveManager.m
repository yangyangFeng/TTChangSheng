//
//  CSIMReceiveManager.m
//  WebSocketTest
//
//  Created by cnepayzx on 2017/9/27.
//  Copyright © 2017年 bingtianyu. All rights reserved.
//

#import "CSIMReceiveManager.h"
#import "CSIMMessageQueueManager.h"
#import "CSIMSendMessageManager.h"
#import "LLUtils+Audio.h"
#import "CSMessageRecordTool.h"
#import "CSChatRoomInfoManager.h"

static CSIMReceiveManager * _manager = nil;
@interface CSIMReceiveManager ()
@property(nonatomic,strong)dispatch_queue_t  queue;
@property (nonatomic, strong)NSMapTable * messageDelegates;
@property (nonatomic, strong)NSMutableDictionary * unReadMessageList;
@property (nonatomic,copy) NSString *currentChatKey;

@end
@implementation CSIMReceiveManager
-(NSMapTable *)messageDelegates
{
    if (!_messageDelegates) {
        _messageDelegates = [NSMapTable weakToWeakObjectsMapTable];
    }
    return _messageDelegates;
}

-(NSMutableDictionary *)unReadMessageList
{
    if (!_unReadMessageList) {
        _unReadMessageList = [NSMutableDictionary dictionary];
    }
    return _unReadMessageList;
}

-(void)setDelegate:(id<CSIMReceiveManagerDelegate>)delegate
{
    __weak id weakDelegate = delegate;
    if (delegate) {
        [self.messageDelegates setObject:weakDelegate forKey:@(delegate.hash)];
    }
}

- (void)removeDelegate:(id<CSIMReceiveManagerDelegate>)delegate
{
    [self.messageDelegates removeObjectForKey:@(delegate.hash)];
}

+ (CSIMReceiveManager *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [CSIMReceiveManager new];
       
    });
    return _manager;
}



- (void)receiveMessage:(CSIMSendMessageRequestModel *)message
{
    CSIMSendMessageRequestModel * sendMsg = [[CSIMMessageQueueManager shareInstance] checkMessageContains:message];
    if (message.code == 2001) {//需要切入聊天
        [[CSIMSendMessageManager shareInstance] sendMessage:self.currentAction];
    }
    else if(message.code == 1001) {//需要切入聊天
        CS_HUD(message.msg);
    }
    //检查参数
    [message.result cs_checkParams];
    switch (message.result.action) {
            // 1、普通消息 2、消息回执 3、路单图片 4、连接成功回执 5、用户上线 6 、用户下线  7、下注台面信息（前台用户不需要） 8、撤销下注回复  9、用户剩余分通知   99、后台回复前端心跳，100 、后台播放提示音用   10  切入聊天回复  11，切出回复
        case 1://
        {
            
            DLog(@"新消息-------->%@",message.result.body.content);
            [message.result cs_checkParams];
            
            message.result.timestamp = message.result.body.timestamp;
            message.result.isSelf = NO;
            if (message.result.chatType == CSChatTypeGroupChat) {
                message.result.cs_chatType = CS_Message_Record_Type_Group;
                message.result.chatType = CSChatTypeGroupChat;
            }else{
                
                if (message.result.fromUserType == 1) {//普通用户
                    message.result.cs_chatType = CS_Message_Record_Type_Friend;
                    message.result.chatType = CSChatTypeChatFriend;
                }
                else{//客服
                    message.result.cs_chatType = CS_Message_Record_Type_Service;
                    message.result.chatType = CSChatTypeChat;
                }
            }
         
            //记录未读消息
            [self insertMessage:message.result];
            
            if (message.result.chatType != CSChatTypeGroupChat) {
                CSCacheUserInfo * userInfo = [CSCacheUserInfo new];
                userInfo.userId = message.result.chatId;
                userInfo.avatar = message.result.body.avatar;
                userInfo.nickname = message.result.body.nickname;
                message.result.mediaDuration = message.result.body.voice_length;
                //将数据存到本地
                [CSMsgCacheTool cs_cacheMessage:message.result userInfo:userInfo addLast:YES chatType:message.result.cs_chatType];
            }
            
            
            
            for (id<CSIMReceiveManagerDelegate> delegate in self.messageDelegates.objectEnumerator.allObjects) {
                __strong id<CSIMReceiveManagerDelegate> strongDelegate = delegate;
                if ([strongDelegate respondsToSelector:@selector(cs_receiveMessage:)]) {
                    [strongDelegate cs_receiveMessage:message.result];
                }
                
                if ([strongDelegate respondsToSelector:@selector(cs_receiveUpdateUnreadMessage)]) {
                    [strongDelegate cs_receiveUpdateUnreadMessage];
                }
            }
        }
            break;
        case 2:
        {
            message.body.msgCacheKey = message.body.receiptId;
            NSString * msgId = [sendMsg.msgCode copy];
            //            [sendMsg.msgStatus reject:[NSError errorWithDomain:message.msg code:message.code userInfo:nil]];
            //            [sendMsg.msgStatus reject:,[NSError errorWithDomain:message.msg code:message.code userInfo:nil]];
            if (message.code == successCode) {
                [sendMsg syncMsgID:message];
                [sendMsg.msgStatus resolve:nil];
                [sendMsg successed];
            }
            else
            {
                [sendMsg.msgStatus reject:[NSError errorWithDomain:message.msg code:message.code userInfo:nil]];
                [sendMsg failed];
            }
            message.result.body.msgId = msgId;
            [[CSIMMessageQueueManager shareInstance] removeMessages:message];
            for (id<CSIMReceiveManagerDelegate> delegate in
                 self.messageDelegates.objectEnumerator.allObjects) {
                __strong id<CSIMReceiveManagerDelegate> strongDelegate = delegate;
                if ([strongDelegate respondsToSelector:@selector(cs_sendMessageCallBlock:)]) {
                    [strongDelegate cs_sendMessageCallBlock:sendMsg.body];
                }
                
            }
        }
            break;
        case 3:
        {
            [message.result cs_checkParams];
            DLog(@"新消息-------->%@",message.result.body.content);
            //计算数据高度
            //            [message.result processModelForCell];
            //            message.result.msgType = message.result.body.msgType;
            //            [message.result syncMessageBodyType:CS_changeMessageType(message.result.body.msgType)];
            
            message.result.timestamp = message.result.body.timestamp;
            
            //记录未读消息
            [self insertMessage:message.result];
            //            [self.unReadMessageList setObject:message.result forKey: [self keyWithChatType:message.result.chatType chatId:message.result.chatId]];
            
            for (id<CSIMReceiveManagerDelegate> delegate in self.messageDelegates.objectEnumerator.allObjects) {
                __strong id<CSIMReceiveManagerDelegate> strongDelegate = delegate;
                if ([strongDelegate respondsToSelector:@selector(cs_receiveMessage:)]) {
                    [strongDelegate cs_receiveMessage:message.result];
                }
                if ([strongDelegate respondsToSelector:@selector(cs_receiveUpdateUnreadMessage)]) {
                    [strongDelegate cs_receiveUpdateUnreadMessage];
                }
            }
        }
            break;
        case 4:
        {
//            CS_HUD(@"socket已连接");
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICE_KEY_SOCKET_OPEN object:nil];
            for (CSUnreadListModel * tempModel in message.result.unreadList) {
                NSMutableArray * array = [NSMutableArray array];
                if (!tempModel.chatList){
                    continue;
                }
                //                DLog(@"新消息-------->%@",message.result.body.content);
                for (CSMessageBodyModel * body in tempModel.chatList) {
                    CSMessageModel * messageData = [CSMessageModel mj_objectWithKeyValues:tempModel.mj_keyValues];
                    messageData.body = body;
                    [messageData cs_checkParams];
//                    [messageData formaterMessage];
//                    message.msgId = message.id;
//                    message.isSelf = NO;
                    //将数据存到本地
                    if (tempModel.fromUserType == 1) {//普通用户
                        messageData.cs_chatType = CS_Message_Record_Type_Friend;
                        messageData.chatType = CSChatTypeChatFriend;
                    }
                    else{//客服
                        messageData.cs_chatType = CS_Message_Record_Type_Service;
                        messageData.chatType = CSChatTypeChat;
                    }
                    
                    //记录未读消息
                    [self insertMessage:messageData];
                    
                    [array addObject:messageData];
                }
                CSCacheUserInfo * userInfo = [CSCacheUserInfo new];
                userInfo.userId = tempModel.chatId;
                userInfo.avatar = tempModel.avatar;
                userInfo.nickname = tempModel.nickname;
                
                CSMessageModel * item = [array firstObject];
                [CSMsgCacheTool cs_cacheMessages:array userInfo:userInfo addLast:YES chatType:item.chatType];

            }
            for (id<CSIMReceiveManagerDelegate> delegate in self.messageDelegates.objectEnumerator.allObjects) {
                __strong id<CSIMReceiveManagerDelegate> strongDelegate = delegate;
                if ([strongDelegate respondsToSelector:@selector(cs_receiveUpdateUnreadMessage)]) {
                    [strongDelegate cs_receiveUpdateUnreadMessage];
                }
            }
            
        }
            break;
        case 5:
        {
//            CS_HUD(@"用户已上线");
            
        }
            break;
        case 6:
        {
//            CS_HUD(@"用户已下线");
        }
            break;
        case 7:
        {
            //            CS_HUD(@"下注台面信息（前台用户不需要");
        }
            break;
        case 8:
        {
            message.body.msgCacheKey = message.body.receiptId;
            NSString * msgId = [sendMsg.msgCode copy];
            //            [sendMsg.msgStatus reject:[NSError errorWithDomain:message.msg code:message.code userInfo:nil]];
            //            [sendMsg.msgStatus reject:[NSError errorWithDomain:message.msg code:message.code userInfo:nil]];
            
            
            
            if (message.code == successCode) {
                if ([message.result.cancelStatus isEqualToString:@"2"]) {
                    [sendMsg syncMsgID:message];
                    [sendMsg.msgStatus resolve:nil];
                    [sendMsg successed];
                }
                else
                {
                    [sendMsg.msgStatus reject:[NSError errorWithDomain:message.msg code:message.code userInfo:nil]];
                    [sendMsg failed];
                    
                }
                
            }
            else
            {
                [sendMsg.msgStatus reject:[NSError errorWithDomain:message.msg code:message.code userInfo:nil]];
                [sendMsg failed];
            }
            message.result.body.msgId = msgId;
            [[CSIMMessageQueueManager shareInstance] removeMessages:message];
            for (id<CSIMReceiveManagerDelegate> delegate in self.messageDelegates.objectEnumerator.allObjects) {
                if ([delegate respondsToSelector:@selector(cs_sendMessageCallBlock:)]) {
                    [delegate cs_sendMessageCallBlock:sendMsg.body];
                }
            }
            
            //撤销下注回复
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICE_KEY_SOCKET_CANCLE_BET object:nil];
        }
            break;
        case 9:
        {
            if (!message.result.surplusScore.length) {
                return;
            }
            
            [[CSUserInfo shareInstance] syncUserSurplus_score:[message.result.surplusScore integerValue] ];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICE_KEY_SOCKET_CURRENT_SCORE object:nil];
        }
            break;
        case 10://切入回复
        {
            //            message.body.msgCacheKey = message.body.receiptId;
            //            NSString * msgId = [sendMsg.msgCode copy];
            //            //            [sendMsg.msgStatus reject:[NSError errorWithDomain:message.msg code:message.code userInfo:nil]];
            //            //            [sendMsg.msgStatus reject:,[NSError errorWithDomain:message.msg code:message.code userInfo:nil]];
            //            if (message.code == successCode) {
            //                [sendMsg syncMsgID:message];
            //                [sendMsg.msgStatus resolve:nil];
            //                [sendMsg successed];
            //            }
            //            else
            //            {
            //                [sendMsg.msgStatus reject:[NSError errorWithDomain:message.msg code:message.code userInfo:nil]];
            //                [sendMsg failed];
            //            }
            //            message.result.msgId = msgId;
            //            [[CSIMMessageQueueManager shareInstance] removeMessages:message];
            //            for (id<CSIMReceiveManagerDelegate> delegate in
            //                 self.messageDelegates.objectEnumerator.allObjects) {
            //                __strong id<CSIMReceiveManagerDelegate> strongDelegate = delegate;
            //                if ([strongDelegate respondsToSelector:@selector(cs_sendMessageCallBlock:)]) {
            //                    [strongDelegate cs_sendMessageCallBlock:sendMsg.body];
            //                }
            //
            //            }
        }
            //            break;
        case 11://切出回复
        {
            message.body.msgCacheKey = message.body.receiptId;
            NSString * msgId = [sendMsg.msgCode copy];
            //            [sendMsg.msgStatus reject:[NSError errorWithDomain:message.msg code:message.code userInfo:nil]];
            //            [sendMsg.msgStatus reject:,[NSError errorWithDomain:message.msg code:message.code userInfo:nil]];
            if (message.code == successCode) {
                [sendMsg syncMsgID:message];
                [sendMsg.msgStatus resolve:nil];
                [sendMsg successed];
            }
            else
            {
                [sendMsg.msgStatus reject:[NSError errorWithDomain:message.msg code:message.code userInfo:nil]];
                [sendMsg failed];
            }
            message.result.body.msgId = msgId;
            [[CSIMMessageQueueManager shareInstance] removeMessages:message];
            //            for (id<CSIMReceiveManagerDelegate> delegate in
            //                 self.messageDelegates.objectEnumerator.allObjects) {
            //                __strong id<CSIMReceiveManagerDelegate> strongDelegate = delegate;
            //                if ([strongDelegate respondsToSelector:@selector(cs_sendMessageCallBlock:)]) {
            //                    [strongDelegate cs_sendMessageCallBlock:sendMsg.body];
            //                }
            //
            //            }
        }
            break;
        default:
            break;
    }
}

- (NSString *)keyWithChatType:(CSChatType)chatType chatId:(NSString *)chatId
{
    NSString * key;
    switch (chatType) {
        case CSChatTypeChat:
        {
            key = CS_MESSAGE_KEY_SINGLE;
        }
            break;
        case CSChatTypeGroupChat:
        {
            key = CS_MESSAGE_KEY_GROUP;
        }
            break;
        case CSChatTypeChatFriend:
        {
            key = CS_MESSAGE_KEY_FEIEND;
        }
            break;
        default:
            break;
    }
    return key = [NSString stringWithFormat:@"%@-%@",key,chatId];
}

- (int)getUnReadMessageNumberChatType:(CSChatType)chatType chatId:(NSString *)chatId
{
    NSString *key = [self keyWithChatType:chatType chatId:chatId];
    NSString * number =[self.unReadMessageList objectForKey:key];
    if (number) {
        return number.intValue;
    }
    return 0;
}

- (int)getAllUnReadMessageNumberChatType:(CSChatType)chatType
{
    NSString * key;
    switch (chatType) {
        case CSChatTypeChat:
        {
            key = CS_MESSAGE_KEY_SINGLE;
        }
            break;
        case CSChatTypeGroupChat:
        {
            key = CS_MESSAGE_KEY_GROUP;
        }
            break;
        case CSChatTypeChatFriend:
        {
            key = CS_MESSAGE_KEY_FEIEND;
            RLMRealm * realm = [RLMRealm defaultRealm];
            NSPredicate * pred = [NSPredicate predicateWithFormat:@"chatType CONTAINS %@ AND isRead = NO",CS_MESSAGE_KEY_FEIEND];//CONTAINS
//            NSString * pred = [NSString stringWithFormat:@"chatType = %@",CS_MESSAGE_KEY_FEIEND];
            RLMResults * results = [CSMsg_User_Msg objectsInRealm:realm withPredicate:pred];
//                                    bjectsInRealm:realm where:pred];
            return results.count;
        }
            break;
        default:
            break;
    }
    int count = 0;
    for (NSString * dic_key in self.unReadMessageList.allKeys) {
        if ([dic_key hasPrefix:key]) {
            count += [self.unReadMessageList[dic_key] intValue];
        }
    }
    return count;
}

- (void)inChatWithChatType:(CSChatType)chatType chatId:(NSString *)chatId
{
    self.currentChatKey = [self keyWithChatType:chatType chatId:chatId];
    [self.unReadMessageList setObject:@"0" forKey:self.currentChatKey];
    
    CSIMSendMessageRequestModel * messageRequest = [CSIMSendMessageRequestModel new];
    CSMessageModel * msg = [CSMessageModel inChatWithChatType:chatType chatId:chatId];
    messageRequest.body = msg;
    [[CSIMSendMessageManager shareInstance] sendMessage:messageRequest];
    
    [messageRequest.msgStatus when:^(id obj) {
        DLog(@"-------------------->进群成功");
    } failed:^(NSError *error) {
        DLog(@"-------------------->进群失败\n失败原因:%@",error.domain);
    }];
    //更新消息未读条数
    [self updateAllUnreadMessageNum];
}

- (void)inChatWithChatType:(CSChatType)chatType chatId:(NSString *)chatId status:(void(^)(NSError*))status
{
    
    
    CSIMSendMessageRequestModel * messageRequest = [CSIMSendMessageRequestModel new];
    CSMessageModel * msg = [CSMessageModel inChatWithChatType:chatType chatId:chatId];
    messageRequest.body = msg;
    [[CSIMSendMessageManager shareInstance] sendMessage:messageRequest];
    
    [messageRequest.msgStatus when:^(id obj) {
        self.currentChatKey = [self keyWithChatType:chatType chatId:chatId];
        [self.unReadMessageList setObject:@"0" forKey:self.currentChatKey];
        DLog(@"-------------------->进群成功");
        if (status) {
            status(nil);
        }
    } failed:^(NSError *error) {
        if (status) {
            status(error);
        }
        DLog(@"-------------------->进群失败\n失败原因:%@",error.domain);
    }];
    //更新消息未读条数
    [self updateAllUnreadMessageNum];
}

- (void)outChatWithChatType:(CSChatType)chatType chatId:(NSString *)chatId
{
    self.currentChatKey = [self keyWithChatType:chatType chatId:chatId];
    [self.unReadMessageList setObject:@"0" forKey:self.currentChatKey];
    self.currentChatKey = @"";
    CSIMSendMessageRequestModel * messageRequest = [CSIMSendMessageRequestModel new];
    CSMessageModel * msg = [CSMessageModel outChatWithChatType:chatType chatId:chatId];
    messageRequest.body = msg;
    [[CSIMSendMessageManager shareInstance] sendMessage:messageRequest];
    
    [messageRequest.msgStatus when:^(id obj) {
        DLog(@"-------------------->退群成功");
    } failed:^(NSError *error) {
        DLog(@"-------------------->退群失败\n失败原因:%@",error.domain);
    }];
    //更新消息未读条数
    [self updateAllUnreadMessageNum];
}

- (void)insertMessage:(CSMessageModel *)messageModel
{
    NSString * key = [self keyWithChatType:messageModel.chatType chatId:messageModel.chatId];
    
    if (!(self.currentChatKey.length && [self.currentChatKey isEqualToString:key])) {
        //如果当前未处于聊天室 取出 原有 数目累加
        [self.unReadMessageList setObject:[NSString stringWithFormat:@"%d",messageModel.body.unreadCount] forKey: key];
        if (messageModel.chatType == CSChatTypeGroupChat &&
            ![CSChatRoomInfoManager getChatGroupMute:messageModel.chatId]) {
            [LLUtils playNewMessageSound];
        }else if(messageModel.chatType == CSChatTypeChat ||
                 messageModel.chatType == CSChatTypeChatFriend)
        {
            [LLUtils playNewMessageSound];
        }
            
    }
    //更新消息未读条数
    [self updateAllUnreadMessageNum];
}

- (void)insertChatWithChatType:(CSChatType)chatType chatId:(NSString *)chatId unReadCount:(NSString *)count
{
    NSString * key = [self keyWithChatType:chatType chatId:chatId];
    if (!(self.currentChatKey.length && [self.currentChatKey isEqualToString:key])) {
        //如果当前未处于聊天室 取出 原有 数目累加
        [self.unReadMessageList setObject:count forKey: key];
    }
    //更新消息未读条数
    [self updateAllUnreadMessageNum];
}
//更新消息未读条数
- (void)updateAllUnreadMessageNum
{
    for (id<CSIMReceiveManagerDelegate> delegate in self.messageDelegates.objectEnumerator.allObjects) {
//        __strong id<CSIMReceiveManagerDelegate> strongDelegate = delegate;
        if ([delegate respondsToSelector:@selector(cs_receiveUpdateUnreadMessage)]) {
            [delegate cs_receiveUpdateUnreadMessage];
        }
    }
}
@end


