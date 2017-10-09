//
//  CSMineTableViewCell.m
//  ChangSheng
//
//  Created by cnepayzx on 2017/10/9.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSMineTableViewCell.h"

@implementation CSMineTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * identifier = @"CSMineTableViewCell";
    CSMineTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [CSMineTableViewCell viewFromXIB];
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
