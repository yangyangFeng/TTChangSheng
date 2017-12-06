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
    //检查参数
    [message.result cs_checkParams];
    switch (message.result.action) {
        // 1、普通消息 2、消息回执 3、路单图片 4、连接成功回执 5、用户上线 6 、用户下线  7、下注台面信息（前台用户不需要） 8、撤销下注回复  9、用户剩余分通知  99、后台回复前端心跳
        case 1://
        {
            [LLUtils playNewMessageSound];
            DLog(@"新消息-------->%@",message.result.body.content);
            [message.result cs_checkParams];
            //计算数据高度
//            [message.result processModelForCell];
//            message.result.msgType = message.result.body.msgType;
//            [message.result syncMessageBodyType:CS_changeMessageType(message.result.body.msgType)];
            
            message.result.timestamp = message.result.body.timestamp;
            
            //记录未读消息
            [self insertMessage:message.result];
           
            
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
            message.result.msgId = msgId;
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
            CS_HUD(@"socket已连接");
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICE_KEY_SOCKET_OPEN object:nil];
            for (CSIMUnReadListModel * tempModel in message.result.unreadList) {
                [self insertChatWithChatType:tempModel.chatType chatId:[NSString stringWithFormat:@"%d",tempModel.chatId] unReadCount:[NSString stringWithFormat:@"%d",tempModel.count]];
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
            CS_HUD(@"用户已上线");
     
        }
            break;
            case 6:
        {
            CS_HUD(@"用户已下线");
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
            message.result.msgId = msgId;
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
            
            [CSUserInfo shareInstance].info.surplus_score = [message.result.surplusScore integerValue];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICE_KEY_SOCKET_CURRENT_SCORE object:nil];
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
    for (id<CSIMReceiveManagerDelegate> delegate in self.messageDelegates.objectEnumerator.allObjects) {
        __strong id<CSIMReceiveManagerDelegate> strongDelegate = delegate;
        if ([strongDelegate respondsToSelector:@selector(cs_receiveUpdateUnreadMessage)]) {
            [strongDelegate cs_receiveUpdateUnreadMessage];
        }
    }
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
}

- (void)insertMessage:(CSMessageModel *)messageModel
{
    NSString * key = [self keyWithChatType:messageModel.chatType chatId:messageModel.chatId];
    if (!(self.currentChatKey.length && [self.currentChatKey isEqualToString:key])) {
        //如果当前未处于聊天室 取出 原有 数目累加
        [self.unReadMessageList setObject:[NSString stringWithFormat:@"%d",messageModel.body.unreadCount] forKey: key];
    }
}

- (void)insertChatWithChatType:(CSChatType)chatType chatId:(NSString *)chatId unReadCount:(NSString *)count
{
    NSString * key = [self keyWithChatType:chatType chatId:chatId];
    if (!(self.currentChatKey.length && [self.currentChatKey isEqualToString:key])) {
        //如果当前未处于聊天室 取出 原有 数目累加
        [self.unReadMessageList setObject:count forKey: key];
    }
}
@end


