//
//  UIButton+TTExtend.m
//  GoPlay
//
//  Created by 邴天宇 on 9/3/16.
//  Copyright © 2016年 邴天宇. All rights reserved.
//

#import "UIButton+TTExtend.h"
#import "MMAlertView.h"
@implementation UIButton (TTExtend)
-(void)addClickNormalColor:(UIColor *)NormalColor HighlightedColor:(UIColor *)HighlightedColor
{
    if (!HighlightedColor) {
        HighlightedColor = [self.backgroundColor colorWithAlphaComponent:0.3];
    }
    else if (!NormalColor)
    {
        NormalColor = self.backgroundColor;
    }
    [self setBackgroundImage:[self imageFromContextWithColor:NormalColor size:CGSizeMake(4, 4)] forState:(UIControlStateNormal)];
    UIImage * bgImage = [self imageFromContextWithColor:HighlightedColor size:CGSizeMake(4, 4)];
    [self setBackgroundImage:bgImage forState:(UIControlStateHighlighted)];
    [self setBackgroundImage:bgImage forState:(UIControlStateSelected)];
}
-(void)addClickNormalColor:(UIColor *)NormalColor
{
    [self addClickNormalColor:NormalColor HighlightedColor:NormalColor];
}
-(UIImage *)imageFromContextWithColor:(UIColor *)color size:(CGSize)size{
    
    CGRect rect=(CGRect){{0.0f,0.0f},size};
    
    //开启一个图形上下文
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0f);
    
    //获取图形上下文
    CGContextRef context=UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    
    CGContextFillRect(context, rect);
    
    //获取图像
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭上下文
    UIGraphicsEndImageContext();
    
    return image;
}
@end
