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


NSString* Home_GetBgImageNameWithIndex(NSInteger index) {
    switch (index) {
        case 0:
            return @"vip";
            break;
        case 1:
            return @"大众厅";
            break;
        case 2:
            return @"客服";
            break;
        case 3:
            return @"财务";
            break;
        default:
            break;
    }
    return @"vip";
}

@implementation CSHomeTableViewHandler
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height =  (WIDTH - 50 * 2)/2.3 ;
    return IPhone4_5_6_6P(height+20, height+20, height+20, height*1.2 + 20);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CSHomeTableViewCell * cell = [CSHomeTableViewCell cellWithTableView:tableView];
    cell.bgImageView.image = [UIImage imageNamed:Home_GetBgImageNameWithIndex(indexPath.row)];
    return cell;
}

@end
