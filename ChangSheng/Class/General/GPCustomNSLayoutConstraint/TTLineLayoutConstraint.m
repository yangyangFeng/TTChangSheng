//
//  TTLineLayoutConstraint.m
//  GoPlay
//
//  Created by 邴天宇 on 25/12/15.
//  Copyright © 2015年 邴天宇. All rights reserved.
//

#import "TTLineLayoutConstraint.h"

@implementation TTLineLayoutConstraint
-(void)awakeFromNib
{
    [super awakeFromNib];
    if (self.constant ==1) {
        self.constant=1/[UIScreen mainScreen].scale;
    }
}
@end
