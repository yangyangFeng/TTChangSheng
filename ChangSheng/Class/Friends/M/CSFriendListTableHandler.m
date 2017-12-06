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
@implementation CSFriendListTableHandler

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 0) {
        return 1;
    }
    else
    {
        return 5;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 40;
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
        
        return cell;
    }
    else
    {
        CSFriendListTableViewCell * cell = [CSFriendListTableViewCell cellWithTableView:tableView];
        
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

@end
