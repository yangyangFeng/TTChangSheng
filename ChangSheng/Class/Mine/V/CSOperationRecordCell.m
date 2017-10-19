//
//  CSOperationRecordCell.m
//  ChangSheng
//
//  Created by cnepayzx on 2017/10/19.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSOperationRecordCell.h"

@implementation CSOperationRecordCell
+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * identifier = @"CSOperationRecordCell";
    CSOperationRecordCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [CSOperationRecordCell viewFromXIB];
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
