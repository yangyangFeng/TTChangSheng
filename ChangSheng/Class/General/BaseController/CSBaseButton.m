//
//  CSBaseButton.m
//  ChangSheng
//
//  Created by 邴天宇 on 2018/1/10.
//  Copyright © 2018年 邴天宇. All rights reserved.
//

#import "CSBaseButton.h"

@implementation CSBaseButton

+ (CSBaseButton *)buttonWithTitle:(NSString *)title
{
    CSBaseButton * btn = [CSBaseButton buttonWithType:(UIButtonTypeSystem)];
    [btn setTitle:title forState:(UIControlStateNormal)];
    return btn;
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if(self){
        
        [self setBackgroundImage:[UIImage yy_imageWithColor:[UIColor colorWithHexColorString:@"24BC7F"]] forState:(UIControlStateNormal)];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5;
    }
    
    return self;
}

@end
