//
//  CSFriendListTableHandler.m
//  ChangSheng
//
//  Created by cnepayzx on 2017/11/30.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSFriendListTableHandler.h"

#import "CSFriendListTableViewCell.h"
#import "CSFriendMsgTableViewCell.h"
#import "CSFriendchartlistModel.h"
@implementation CSFriendListTableHandler

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 0) {
        if (self.friendRequestNum != 0) {
            return 1;
        }
        else{
            return 0;
        }
    }
    else
    {
        return self.dataSource.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (self.friendRequestNum != 0) {
            return 40;
        }
        else{
            return 0;
        }
    }
    else
    {
        return 70;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        CSFriendMsgTableViewCell * cell = [CSFriendMsgTableViewCell cellWithTableView:tableView];
        NSString * str = [NSString stringWithFormat:@"您有%d位好友申请，请查看",self.friendRequestNum];
        cell.friendRequestNumLabel.text = str;
        return cell;
    }
    else
    {
        CSFriendListTableViewCell * cell = [CSFriendListTableViewCell cellWithTableView:tableView];
        cell.model = self.dataSource[indexPath.row];
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

@end
