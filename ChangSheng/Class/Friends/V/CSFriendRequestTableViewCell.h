//
//  CSFriendRequestTableViewCell.h
//  ChangSheng
//
//  Created by 邴天宇 on 2017/12/10.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CSFriendRequestTableViewCell;

#import "CSFriendRequestListModel.h"
@protocol CSFriendRequestTableViewCellDelegate <NSObject>
- (void)buttonDidActionWithCell:(CSFriendRequestTableViewCell *)cell;
@end

@interface CSFriendRequestTableViewCell : UITableViewCell

@property (nonatomic,weak) id<CSFriendRequestTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *addedLabel;

@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UILabel *nickName;

@property (nonatomic,strong) CSFriendRequestListModel *model;
@end
