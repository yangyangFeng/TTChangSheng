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
        cell.layer.masksToBounds = NO;
        cell.layer.cornerRadius = 8.0;
    }
    
    return cell;
}

-(void)setFrame:(CGRect)frame
{
    int width = 30;
    int height = 20;
    [super setFrame:CGRectMake(frame.origin.x + width, frame.origin.y + height, frame.size.width - width*2, frame.size.height - height)];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization cod
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
