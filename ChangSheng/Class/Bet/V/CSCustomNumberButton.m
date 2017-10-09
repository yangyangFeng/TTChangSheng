//
//  CSCustomNumberButton.m
//  ChangSheng
//
//  Created by cnepayzx on 2017/10/9.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSCustomNumberButton.h"

@implementation CSCustomNumberButton

-(void)awakeFromNib
{
    [super awakeFromNib];
    
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitleColor:[UIColor colorWithHexColorString:@"333333"] forState:(UIControlStateNormal)];
        self.titleLabel.font = [UIFont systemFontOfSize:25];
        self.backgroundColor = [UIColor colorWithHexColorString:@"f1f1f1"];
        
        [self setBackgroundImage:[UIImage yy_imageWithColor:[UIColor colorWithHexColorString:@"f1f1f1"] size:CGSizeMake(4, 4)] forState:(UIControlStateNormal)];
//        self.layer.borderColor = rgb(223, 223, 223).CGColor;
//        self.layer.borderWidth = .5;
//        self.adjustsImageWhenHighlighted = YES;
    }
    return self;
}
@end
