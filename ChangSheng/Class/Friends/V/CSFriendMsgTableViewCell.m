//
//  CSFriendMsgTableViewCell.m
//  ChangSheng
//
//  Created by cnepayzx on 2017/11/30.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSFriendMsgTableViewCell.h"

@implementation CSFriendMsgTableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * identifier = @"CSFriendMsgTableViewCell";
    CSFriendMsgTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [CSFriendMsgTableViewCell viewFromXIB];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
