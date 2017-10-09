//
//  CSIMConversationModel.h
//  ChangSheng
//
//  Created by 邴天宇 on 17/9/28.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSIMSendMessageRequestModel.h"
/**
 聊天消息管理类,用来储存聊天每条消息
 */
@interface CSIMConversationModel : NSObject
//该Conversation已经获取到的消息数组，按照时间从过去到现在排序，最近的消息在数组最后面
@property (nonatomic, strong)NSMutableArray <CSIMSendMessageRequestModel*>*allMessageModels;


//以下三个属性SDK不存储,需要由服务器提供,此处采用假数据
@property (nonatomic) NSString *avatarImageURL;
@property (nonatomic) UIImage *avatarImage;
@property (nonatomic) NSString *nickName;

@property (nonatomic,copy) NSString *chatId;

//@property (nonatomic) NSString *latestMessageTimeString;;
//
//@property (nonatomic) NSTimeInterval latestMessageTimestamp;
//
//@property (nonatomic) NSInteger unreadMessageNumber;
//@property (nonatomic, copy, readonly) NSString *conversationId;
//
@property (nonatomic, readonly) CSChatType conversationType;
//
//@property (nonatomic) NSString *draft;
@end
