//
//  UIView+Line.m
//  GoPlay
//
//  Created by 邴天宇 on 11/12/15.
//  Copyright © 2015年 邴天宇. All rights reserved.
//

#import "UIView+Line.h"
#define TAG_LINE 999
@implementation UIView (Line)
- (void)addline:(UIColor *)color width:(CGFloat)width
{
    if ([self viewWithTag:TAG_LINE]) { //如果已添加那么不重复添加
        return;
    }
    UIView * lineTop =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, .5)];
    lineTop.backgroundColor = rgb(208, 208, 208);
    lineTop.tag = TAG_LINE;
    UIView * linebottom =[[UIView alloc]initWithFrame:CGRectMake(0, self.height, self.width, .5)];
    linebottom.backgroundColor = rgb(208, 208, 208);
    if (color) {
        lineTop.backgroundColor = color;
        linebottom.backgroundColor = color;
        linebottom.height =width;
        lineTop.height=width;
    }
    [self addSubview:lineTop];
    [self addSubview:linebottom];
}
@end
