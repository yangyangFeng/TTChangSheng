//
//  CSUserTableViewCell.m
//  ChangSheng
//
//  Created by cnepayzx on 2017/10/11.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSUserTableViewCell.h"

@implementation CSUserTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * identifier = @"CSUserTableViewCell";
    CSUserTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [CSUserTableViewCell viewFromXIB];
        cell.layer.masksToBounds = YES;
        cell.layer.cornerRadius = 3.0;
        cell.userIcon.layer.masksToBounds = YES;
        cell.userIcon.layer.cornerRadius = 3.0;
    }
    return cell;
}

-(void)setFrame:(CGRect)frame
{
    int width = 12.5;
    int height = 10;
    [super setFrame:CGRectMake(frame.origin.x + width, frame.origin.y + height, frame.size.width - width*2, frame.size.height - height)];
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
