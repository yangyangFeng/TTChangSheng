//
//  LLChatViewController.h
//  LLWeChat
//
//  Created by GYJZH on 7/21/16.
//  Copyright © 2016 GYJZH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLViewController.h"
#import "LLConversationModel.h"
#import "LLChatInputDelegate.h"
#import "LLVoiceIndicatorView.h"
#import "TTNav_RootViewController.h"
#import "CSIMConversationModel.h"
NS_ASSUME_NONNULL_BEGIN
@interface LLChatViewController : TTNav_RootViewController <LLChatInputDelegate>

//@property (nonatomic) LLConversationModel *conversationModel;

- (void)fetchMessageList;

- (void)refreshChatControllerForReuse;

/**
 聊天界面进去前必传参数
 */
@property (nonatomic, strong)CSIMConversationModel * conversationModel;

NS_ASSUME_NONNULL_END

@end
