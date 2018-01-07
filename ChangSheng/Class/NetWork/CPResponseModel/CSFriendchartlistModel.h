//
//  CSFriendchartlistModel.h
//  ChangSheng
//
//  Created by 邴天宇 on 2017/12/9.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSHttpsResModel.h"

@interface CSFriendchartlistModel : CSHttpsResModel

@property (nonatomic,strong) NSArray <CSFriendchartlistModel*> *result;

@property (nonatomic,copy) NSString *type;

@property (nonatomic,copy) NSString *userid;
@property (nonatomic,copy) NSString *nickname;
@property (nonatomic,copy) NSString *headurl;
@property (nonatomic,copy) NSString *lastmsg;
@property (nonatomic,copy) NSString *lastmsgid;
@property (nonatomic,copy) NSString *lastdata;
@property (nonatomic,copy) NSString *unreadmsgnum;

@end
