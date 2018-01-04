//
//  CSFriendListModel.h
//  ChangSheng
//
//  Created by 邴天宇 on 2017/12/9.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSHttpsResModel.h"

@class CSFriendListItemModel;
@interface CSFriendListModel : CSHttpsResModel
@property (nonatomic, strong)NSMutableArray<CSFriendListModel*>*result;

@property (nonatomic,copy) NSString *letter;
@property (nonatomic, strong)NSMutableArray <CSFriendListItemModel*>* friends;
@end

@interface CSFriendListItemModel : NSObject
@property (nonatomic,copy) NSString *nickname;
@property (nonatomic,copy) NSString *avatar;
@property (nonatomic,copy) NSString *letter;
@property (nonatomic,copy) NSString *user_id;

@end
