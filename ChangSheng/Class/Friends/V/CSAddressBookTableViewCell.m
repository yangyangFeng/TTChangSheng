//
//  CSAddressBookTableViewCell.m
//  ChangSheng
//
//  Created by cnepayzx on 2017/12/1.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSAddressBookTableViewCell.h"

@implementation CSAddressBookTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * identifier = @"CSAddressBookTableViewCell";
    CSAddressBookTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [CSAddressBookTableViewCell viewFromXIB];
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
