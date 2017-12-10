//
//  CSFriendListTableViewCell.m
//  ChangSheng
//
//  Created by cnepayzx on 2017/11/30.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSFriendListTableViewCell.h"

#import "TTSubscriptLabel.h"
#import "NSDate+LLExt.h"
@interface CSFriendListTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet TTSubscriptLabel *number;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *date;

@end

@implementation CSFriendListTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * identifier = @"CSFriendListTableViewCell";
    CSFriendListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [CSFriendListTableViewCell viewFromXIB];
    }
    return cell;
}

-(void)setModel:(CSFriendchartlistModel *)model
{
    _model = model;
    [_userIcon yy_setImageWithURL:[NSURL URLWithString:model.headurl] options:(YYWebImageOptionSetImageWithFadeAnimation)];
    _number.text = model.unreadmsgnum;
    _nickName.text = model.nickname;
    _content.text = model.lastmsg;
    _date.text = model.lastdata;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_date.text.integerValue];
    _date.text = [date timeIntervalBeforeNowLongDescription];
    
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
