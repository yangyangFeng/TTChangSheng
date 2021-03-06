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
#import "CSHttpGroupResModel.h"
#import "CSIMReceiveManager.h"
#import "UIImageView+WebCache.h"
NSString* Home_GetBgImageNameWithIndex(NSInteger index) {
    switch (index) {
        case 0:
            return @"长龙vip";
            break;
        case 1:
            return @"长龙1厅";
            break;
        case 2:
            return @"长龙2厅";
            break;
        case 3:
            return @"长龙vip";
            break;
        default:
            break;
    }
    return @"长龙vip";
}

@interface CSHomeTableViewCell()<CSIMReceiveManagerDelegate>
@end

@implementation CSHomeTableViewHandler

-(void)awakeFromNib
{
    [super awakeFromNib];
}

-(void)dealloc
{
    [[CSIMReceiveManager shareInstance] removeDelegate:self];
}


-(id)initWithTableView:(UITableView *)tableView
{
    if (self = [super initWithTableView:tableView]) {
        [CSIMReceiveManager shareInstance].delegate = self;
    }
    return self;
}

- (void)cs_receiveUpdateUnreadMessage
{
    [self updateUnreadMessageUI];
}

- (void)updateUnreadMessageUI
{
    for (int i =0; i<self.betGroupArray.count; i++) {
        CSHttpGroupResModel * model = [self.betGroupArray objectAtIndex:i];
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        CSHomeTableViewCell * cell = (CSHomeTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        int count = [[CSIMReceiveManager shareInstance] getUnReadMessageNumberChatType:(CSChatTypeGroupChat) chatId:[NSString stringWithFormat:@"%d",model.id]];
        cell.unReadNumber.text = [NSString stringWithFormat:@"%d",count];
    }
    {
        CSHomeTableViewCell * cell = (CSHomeTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        int count = [[CSIMReceiveManager shareInstance] getAllUnReadMessageNumberChatType:(CSChatTypeChat)];
        cell.unReadNumber.text = [NSString stringWithFormat:@"%d",count];
    }
}

- (void)setBetGroupArray:(NSArray *)betGroupArray
{
    _betGroupArray = betGroupArray;
    [self.tableView reloadData];
//    [self updateUnreadMessageUI];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.betGroupArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height =  125;
    return IPhone4_5_6_6P_X(height+20, height+20, height+20, height*1.1 + 20, height+20);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CSHomeTableViewCell * cell = [CSHomeTableViewCell cellWithTableView:tableView];
    CSHttpGroupResModel * model = [self.betGroupArray objectAtIndex:indexPath.row];
    [cell.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.img_url]];
    cell.cs_title.text = model.name;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
//    if (indexPath.row < self.betGroupArray.count) {
//        CSHttpGroupResModel * model = [self.betGroupArray objectAtIndex:i];
//        [[CSIMReceiveManager shareInstance] inChatWithChatType:(CSChatTypeGroupChat) chatId:[NSString stringWithFormat:@"%d",model.code]];
//    }
}

@end
