//
//  CSFriendRequestListModel.h
//  ChangSheng
//
//  Created by 邴天宇 on 2017/12/9.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSHttpsResModel.h"

@interface CSFriendRequestListModel : CSHttpsResModel
@property (nonatomic,copy) NSString *user_id;
@property (nonatomic,copy) NSString *nickname;
@property (nonatomic,copy) NSString *avatar;
@property (nonatomic,copy) NSString *greet;
/**
 1:未通过，移动端显示“接受”，2:已通过，移动端显示“已添加”
 */
@property (nonatomic,copy) NSString *status;


@property (nonatomic, strong)NSArray<CSFriendRequestListModel*>*result;
@end
