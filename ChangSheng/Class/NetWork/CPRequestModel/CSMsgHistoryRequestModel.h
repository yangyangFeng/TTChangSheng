//
//  CSMsgHistoryRequestModel.h
//  ChangSheng
//
//  Created by 邴天宇 on 17/9/27.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CSBaseRequestModel.h"
@interface CSMsgHistoryRequestModel : CSBaseRequestModel
/**
 chat_type	聊天类型 1 群聊 2 单聊	是	[int]
 */
@property (nonatomic,assign) int chat_type;
/**
 2	id	群组id，或者查看对方用户id	是	[int]
 */
@property (nonatomic,assign) int ID;

/**
 3	last_id	最后一条消息id，第一页可不传或者传0，第二页把我返回给你的传给我就行		[int]
 */
@property (nonatomic,copy) NSString *last_id;
/**
 4	receive_user_type 固定传递2
 */
@property (nonatomic,assign) int receive_user_type;

@end
