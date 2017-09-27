//
//  TTNavigationBar.m
//  TTCustomNavicaitonController
//
//  Created by 邴天宇 on 16/12/15.
//  Copyright © 2015年 邴天宇. All rights reserved.
//

#import "TTNavigationBar.h"

@implementation TTNavigationBar

- (void)awakeFromNib
{
    [super awakeFromNib];

    [self commonInit];
}

#pragma mark - Common Init
- (void)commonInit
{
    self.backgroundColor = [UIColor clearColor];
    self.leftView.backgroundColor = [UIColor clearColor];
    self.centerView.backgroundColor = [UIColor clearColor];
    self.rightView.backgroundColor = [UIColor clearColor];

    self.rightView.hidden = NO;
//    [self.customBar setBackgroundImage:IMAGE(@"alpha") forBarMetrics:UIBarMetricsDefault];

//    [self drawRoundCornerAndShadow];
}

- (IBAction)leftButtonAction:(id)sender
{
    if (self.leftBtnPressedHandler) {
        self.leftBtnPressedHandler();
    }
    else {
    }
}
- (IBAction)rightButtonAction:(id)sender
{
    if (self.rightBtnPressedHandler) {
        self.rightBtnPressedHandler();
    }
    else {
    }
}
- (void)drawRoundCornerAndShadow
{
    
    CGRect bounds = self.bounds;
    bounds.size.height += 10;
//    UIBezierPath* maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds
//                                                   byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
//                                                         cornerRadii:CGSizeMake(10.0, 10.0)];
//
    CAShapeLayer* maskLayer = [CAShapeLayer layer];
//    maskLayer.frame = bounds;
//    maskLayer.path = maskPath.CGPath;

//    [self.layer addSublayer:maskLayer];
//    self.layer.mask = maskLayer;
    
    maskLayer.path =  [UIBezierPath bezierPathWithRect:CGRectMake(0, 0 , self.bounds.size.width, self.bounds.size.height)].CGPath;
    maskLayer.frame = bounds;
    maskLayer.strokeColor = [UIColor blackColor].CGColor;
    self.layer.mask = maskLayer;
    
    self.layer.shadowOffset = CGSizeMake(0, 2);
//    self.layer.shadowOpacity = .3;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, self.bounds.size.height -1, self.bounds.size.width, 1)].CGPath;
}

@end
