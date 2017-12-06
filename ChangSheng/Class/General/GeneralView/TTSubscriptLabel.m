//
//  TTSubscriptLabel.m
//  ChangSheng
//
//  Created by 邴天宇 on 2017/10/18.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "TTSubscriptLabel.h"

@implementation TTSubscriptLabel

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 10.0f;
    self.textColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor redColor];
    self.font = [UIFont systemFontOfSize:10];
    self.textAlignment = NSTextAlignmentCenter;
    self.adjustsFontSizeToFitWidth = YES;
//    self.minimumScaleFactor = 10;
    self.alpha = 0;
}

-(void)setText:(NSString *)text
{
    [super setText:text];
    if (text.length && [text intValue] <= 0) {
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 0;
        }];
    }
    else if (text.length && [text intValue] > 0)
    {
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 1;
        }];
    }
}

@end
