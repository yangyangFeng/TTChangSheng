//
//  CSHomeTableViewCell.m
//  ChangSheng
//
//  Created by 邴天宇 on 17/9/26.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSHomeTableViewCell.h"

@implementation CSHomeTableViewCell

+(id)cellWithTableView:(UITableView *)tableView
{
    static NSString *rid= @"CSHomeTableViewCell";
    
    CSHomeTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:rid];
    
    if(cell==nil){
        
        cell= [CSHomeTableViewCell viewFromXIB];
        
    }
    
    return cell;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:CGRectMake(frame.origin.x + 8, frame.origin.y + 8, frame.size.width - 8*2, frame.size.height - 8*2)];
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
