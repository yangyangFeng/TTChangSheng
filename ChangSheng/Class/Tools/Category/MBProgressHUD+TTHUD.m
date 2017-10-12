//
//  MBProgressHUD+TTHUD.m
//  GoPlay
//
//  Created by 邴天宇 on 22/1/16.
//  Copyright © 2016年 邴天宇. All rights reserved.
//

#import "MBProgressHUD+TTHUD.h"


static UIImageView* imageview = nil;

static MBProgressHUD* shareHUD = nil;
static BOOL _isShow;


@implementation MBProgressHUD (TTHUD)

@dynamic isShow;

+ (MBProgressHUD*)initTTHUD:(MBProgressHUD*)hud
{

    hud.animationType = MBProgressHUDAnimationFade;
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    
    shareHUD = hud;
    return hud;
}
+ (MBProgressHUD *)tt_progressShowInView:(UIView *)view
{
    MBProgressHUD* hud = [self getProgressHUDView:view];

    [hud showAnimated:YES];
    hud.isShow = YES;
    shareHUD = hud;
    return hud;
}

+ (void)tt_Show
{
    UIWindow* keyWindow = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.label.text = defaultTitle;
    [hud showAnimated:YES];
    hud.isShow = YES;
    shareHUD = hud;
}

+ (void)tt_ShowWithTitle:(NSString*)title
{
    UIWindow* keyWindow = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD* hud = [MBProgressHUD getCurrentHUDView:keyWindow];
    
    hud.mode = MBProgressHUDModeText;
    hud.label.text = title;
    [hud showAnimated:YES];
    hud.isShow = YES;
}

+ (void)tt_ShowInView:(UIView*)view WithTitle:(NSString*)title
{
    MBProgressHUD* hud = [MBProgressHUD getCurrentHUDView:view];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = title;
    //    hud.backgroundColor = GROUNDCOLOR;
    [hud showAnimated:YES];
    hud.isShow = YES;
}

+ (void)tt_ShowInView:(UIView*)view WithTitle:(NSString*)title after:(CGFloat)time
{
    MBProgressHUD* hud = [self getCurrentHUDView:view];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = title;
    //    hud.backgroundColor = GROUNDCOLOR;
    [hud showAnimated:YES];
    hud.isShow = YES;
    
    [self tt_HideFromeView:view after:time];
    
}

+ (void)tt_TitleChange:(NSString *)title
{
    shareHUD.label.text = title;
}
+ (void)tt_ShowInView:(UIView*)view WithTitle:(NSString*)title backColor:(UIColor*)color
{
    MBProgressHUD* hud = [self getCurrentHUDView:view];
    //    hud = [self initTTHUD:hud];
    hud.label.text = title;
    hud.backgroundColor = color;
    [hud showAnimated:YES];
    hud.isShow = YES;
}
+ (void)tt_ShowInViewDefaultTitle:(UIView*)view
{
    MBProgressHUD* hud = [self getCurrentHUDView:view];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = defaultTitle;
    hud.userInteractionEnabled = YES;
    [hud showAnimated:YES];
    hud.isShow = YES;
}
+ (void)tt_Hide
{
    if (shareHUD.isShow) {
        shareHUD.isShow = NO;
        [shareHUD hideAnimated:YES afterDelay:1];
    }
    else {
        UIWindow* keyWindow = [UIApplication sharedApplication].keyWindow;
        shareHUD.isShow = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:keyWindow animated:YES];
            //        [imageview stopAnimating];
        });
    }
}

+ (void)tt_HideFromeView:(UIView*)view after:(CGFloat)time
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self tt_HideFromeView:view];
    });
}

+ (void)tt_HideFromeView:(UIView*)view
{
    shareHUD.isShow = NO;
    [MBProgressHUD hideHUDForView:view animated:YES];
//    [imageview stopAnimating];
}

+ (MBProgressHUD *)showTextInView:(UIView *)view
{
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.animationType = MBProgressHUDAnimationFade;
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.mode = MBProgressHUDModeText;
    shareHUD = hud;
    return hud;
}

+ (void)tt_ErrorTitle:(NSString*)title
{
    [shareHUD hideAnimated:YES];
    UIWindow* view = [UIApplication sharedApplication].keyWindow;
    
    [self tt_ErrorInView:view WithTitle:title];
}

+ (void)tt_SuccessTitle:(NSString*)title
{
    [self tt_ErrorTitle:title];
}

+ (void)tt_ErrorInView:(UIView*)view WithTitle:(NSString*)title
{    
    MBProgressHUD * hud = [MBProgressHUD showTextInView:view];
    hud.label.text = title;
    [hud showAnimated:YES];
    hud.isShow = YES;
    [self tt_HideFromeView:view after:DISMISSTIME];
}

+ (void)tt_SuccessInView:(UIView*)view WithTitle:(NSString*)title
{
    MBProgressHUD* hud = [self getCurrentHUDView:view];
    hud.label.text = title;
        
    if (!hud.isShow) {
        [hud showAnimated:YES];
    }
    
    [self tt_HideFromeView:view after:DISMISSTIME];
}

+ (MBProgressHUD*)getCurrentHUDView:(UIView*)view
{
    MBProgressHUD* hud = [MBProgressHUD HUDForView:view];
    if (!hud) {
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud = [self initTTHUD:hud];
    }
    else {
       
    }
    shareHUD = hud;
    return hud;
}

+ (MBProgressHUD*)getProgressHUDView:(UIView*)view
{
    MBProgressHUD* hud = [MBProgressHUD HUDForView:view];
    if (!hud) {
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.label.text = @"";
        
        hud.progress = 0;
        hud.label.text = @"0%";
        hud.removeFromSuperViewOnHide = YES;
        hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
    }
    else {
        
    }
    shareHUD = hud;
    return hud;
}

-(void)setIsShow:(BOOL)isShow
{
//    if (isShow) {
//        NSLog(@"显示");
//    }
//    else{
//        NSLog(@"隐藏");
//    }
    _isShow = isShow;
}
-(BOOL)isShow{
    return _isShow;
}
@end
