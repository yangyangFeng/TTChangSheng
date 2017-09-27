//
//  UIButton+TTExtend.h
//  GoPlay
//
//  Created by 邴天宇 on 9/3/16.
//  Copyright © 2016年 邴天宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (TTExtend)
/**
 *  添加button 按下颜色
 *
 *  @param NormalColor      常态
 *  @param HighlightedColor 高亮
 */
-(void)addClickNormalColor:(UIColor *)NormalColor HighlightedColor:(UIColor *)HighlightedColor;
/**
 *  按钮颜色,高亮默认使用 0.3 alpha
 *
 *  @param NormalColor
 */
-(void)addClickNormalColor:(UIColor *)NormalColor;
@end
