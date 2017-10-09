//
//  CSCustomBetButton.m
//  ChangSheng
//
//  Created by cnepayzx on 2017/10/9.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSCustomBetButton.h"

@implementation CSCustomBetButton

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 2.0f;
    self.layer.borderWidth = 1;
    self.layer.borderColor = rgb(24, 184, 46).CGColor;
}

@end
