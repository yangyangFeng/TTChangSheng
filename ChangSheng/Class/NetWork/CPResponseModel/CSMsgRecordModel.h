//
//  CSMsgRecordModel.h
//  ChangSheng
//
//  Created by cnepayzx on 2017/10/12.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSHttpsResModel.h"


@interface CSMsgRecordModel : CSHttpsResModel
@property(nonatomic,strong)CSMsgRecordModel * result;

/**
 消息数据
 */
@property(nonatomic,strong)NSArray * data;
/**
 上一条信息 id
 */
@property(nonatomic,copy)NSString * last_id;

@property (nonatomic,copy) NSString *msg_id;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *timestamp;
@property (nonatomic,copy) NSString *nickname;
@property (nonatomic,copy) NSString *avatar;
@property (nonatomic,copy) NSString *is_self;

@end
