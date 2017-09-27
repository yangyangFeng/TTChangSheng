//
//  CSHomeTableViewHandler.m
//  ChangSheng
//
//  Created by 邴天宇 on 17/9/26.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSHomeTableViewHandler.h"
#import "UIView+Extend.h"
#import "CSHomeTableViewCell.h"
@implementation CSHomeTableViewHandler


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CSHomeTableViewCell * cell = [CSHomeTableViewCell cellWithTableView:tableView];
    
    return cell;
}

@end
