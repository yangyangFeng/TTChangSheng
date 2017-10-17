//
//  CSIMReceiveManager.m
//  WebSocketTest
//
//  Created by cnepayzx on 2017/9/27.
//  Copyright © 2017年 bingtianyu. All rights reserved.
//

#import "CSIMReceiveManager.h"
#import "CSIMMessageQueueManager.h"
static CSIMReceiveManager * _manager = nil;
@interface CSIMReceiveManager ()
@property(nonatomic,strong)dispatch_queue_t  queue;
@property (nonatomic, strong)NSMutableDictionary * messageDelegates;
@property (nonatomic, strong)NSMutableDictionary * unReadMessageList;
@property (nonatomic,copy) NSString *currentChatKey;
@end
@implementation CSIMReceiveManager
-(NSMutableDictionary *)messageDelegates
{
    if (!_messageDelegates) {
        _messageDelegates = [NSMutableDictionary dictionary];
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
    _messageDelegates = delegate;
    if (delegate) {
        [self.messageDelegates setObject:delegate forKey:@(delegate.hash)];
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
    switch (message.body.action) {
        // 1、普通消息 2、消息回执 3、路单图片 4、连接成功回执 5、用户上线 6 、用户下线
        case 1://
        {
            DLog(@"新消息-------->%@",message.result.body.content);
            //计算数据高度
            [message.result processModelForCell];
            message.result.msgType = message.result.body.msgType;
            [message.result syncMessageBodyType:CS_changeMessageType(message.result.body.msgType)];
            
            message.result.timestamp = message.result.body.timestamp;
            
            //记录未读消息
            [self insertMessage:message.result];
           
            
            for (id<CSIMReceiveManagerDelegate> delegate in self.messageDelegates.allKeys) {
                if ([delegate respondsToSelector:@selector(cs_receiveMessage:)]) {
                    [delegate cs_receiveMessage:message.result];
                }
            }
        }
            break;
        case 2:
        {
            message.body.msgCacheKey = message.body.receiptId;
            NSString * msgId = [sendMsg.msgCode copy];
//            [sendMsg.msgStatus reject:[NSError errorWithDomain:message.msg code:message.code userInfo:nil]];
//            [sendMsg.msgStatus reject:[NSError errorWithDomain:message.msg code:message.code userInfo:nil]];
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
            for (id<CSIMReceiveManagerDelegate> delegate in self.messageDelegates.allKeys) {
                if ([delegate respondsToSelector:@selector(cs_sendMessageCallBlock:)]) {
                    [delegate cs_sendMessageCallBlock:sendMsg.body];
                }
            }
        }
            break;
        case 3:
        {
            DLog(@"新消息-------->%@",message.result.body.content);
            //计算数据高度
            [message.result processModelForCell];
            message.result.msgType = message.result.body.msgType;
            [message.result syncMessageBodyType:CS_changeMessageType(message.result.body.msgType)];
            
            message.result.timestamp = message.result.body.timestamp;
            
            //记录未读消息
            [self insertMessage:message.result];
//            [self.unReadMessageList setObject:message.result forKey: [self keyWithChatType:message.result.chartType chatId:message.result.chatId]];
            
            for (id<CSIMReceiveManagerDelegate> delegate in self.messageDelegates.allKeys) {
                if ([delegate respondsToSelector:@selector(cs_receiveMessage:)]) {
                    [delegate cs_receiveMessage:message.result];
                }
            }
            
        }
            break;
        case 4:
        {
            CS_HUD(@"socket已连接");
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
            //撤销下注回复
            CS_HUD(message.msg);
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
            key = @"single";
        }
            break;
        case CSChatTypeGroupChat:
        {
            key = @"group";
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

- (void)inChatWithChatType:(CSChatType)chatType chatId:(NSString *)chatId
{
    self.currentChatKey = [self keyWithChatType:chatType chatId:chatId];
    [self.unReadMessageList setObject:@"0" forKey:self.currentChatKey];
}
- (void)outChatWithChatType:(CSChatType)chatType chatId:(NSString *)chatId
{
    self.currentChatKey = [self keyWithChatType:chatType chatId:chatId];
    [self.unReadMessageList setObject:@"0" forKey:self.currentChatKey];
    self.currentChatKey = @"";
}

- (void)insertMessage:(CSMessageModel *)messageModel
{
    NSString * key = [self keyWithChatType:messageModel.chartType chatId:messageModel.chatId];
    if (!(self.currentChatKey.length && [self.currentChatKey isEqualToString:key])) {
        //如果当前未处于聊天室 取出 原有 数目累加
        [self.unReadMessageList setObject:[NSString stringWithFormat:@"%d",messageModel.body.unreadCount] forKey: [self keyWithChatType:messageModel.chartType chatId:messageModel.chatId]];
    }
}
@end
