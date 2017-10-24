//
//  CSPublicBetTableViewHandler.m
//  ChangSheng
//
//  Created by 邴天宇 on 2017/10/14.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSPublicBetTableViewHandler.h"

@implementation CSPublicBetTableViewHandler
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height =  125;
    return IPhone4_5_6_6P(height+20, height+20, height+20, height*1.1 + 20);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    CSHomeTableViewCell * cell = [CSHomeTableViewCell cellWithTableView:tableView];
//    cell.bgImageView.image = [UIImage imageNamed:Home_GetBgImageNameWithIndex(indexPath.row)];
//    return cell;
    return  nil;
}

@end
