//
//  CSPublicBetViewController.h
//  ChangSheng
//
//  Created by 邴天宇 on 2017/10/14.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "TTNav_RootViewController.h"
#import "CSIMConversationModel.h"
@interface CSPublicBetViewController : TTNav_RootViewController
/**
 聊天界面进去前必传参数
 */
@property (nonatomic, strong)CSIMConversationModel * conversationModel;
@end
