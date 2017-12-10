//
//  CSFriendRequestTableViewCell.m
//  ChangSheng
//
//  Created by 邴天宇 on 2017/12/10.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSFriendRequestTableViewCell.h"

@implementation CSFriendRequestTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static  NSString * identifiter = @"CSFriendRequestTableViewCell";
    CSFriendRequestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifiter];
    if (!cell) {
        cell = [CSFriendRequestTableViewCell viewFromXIB];
        
    }
    return cell;
}
- (IBAction)buttonDidAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(buttonDidActionWithCell:)]) {
        [_delegate buttonDidActionWithCell:self];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.button setBackgroundImage:[UIImage yy_imageWithColor:[UIColor colorWithHexColorString:@"24BC7F"]] forState:(UIControlStateNormal)];
    self.button.layer.masksToBounds = YES;
    self.button.layer.cornerRadius = 3;
    self.addedLabel.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
