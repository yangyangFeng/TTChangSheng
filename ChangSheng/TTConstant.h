//
//  TTConstant.h
//  GoPlay
//
//  Created by 邴天宇 on 14/1/16.
//  Copyright © 2016年 邴天宇. All rights reserved.
//

#ifndef TTConstant_h
#define TTConstant_h

//typedef id(^_IMP)(id,SEL,...);
//typedef void(^_VIMP)(id,SEL,...);


//是否是单点触控  default is YES.
#define SWITCH_ExclusiveTouch 0

//红包 概念 开关
#define SWITCH_HONGBAO 0

#define SWITCH_YINGYAN 1

#define city_path  [NSString stringWithFormat:@"%@/city.plist",NSHomeDirectory()]
#define kCITYPATH @"citymessagedatapath"

//错误提示
#define CS_HUD(msg) [MBProgressHUD tt_ErrorTitle:msg];
//密码长度
#define PASSWORDLENGTH 16
//TODO: 输入框 默认长度
#define kLimitTextLength 20  //全部输入框长度限制
/**
 *  提醒默认隐藏时间 //TODO: 提醒隐藏时间
 */
#define DISMISSTIME 1

#define CS_IMAGE_DATA_SIZE 450*1000
// 默认 占位符 颜色
#define TEXTFIELD_PLACE_COLOR [UIColor colorWithHexColorString:@"999999"]
//TODO: 默认 cell高度
#define GP_CELL_HEIGHT 80

//TODO: 版本号
#define APPVERSION [[[NSBundle mainBundle] infoDictionary]  objectForKey:@"CFBundleShortVersionString"]

#define APPBuild [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
//************************************************************************//

//系统版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

//第一次引导
#define kAPPFIRSTGUIDE @"firstCouponBoard_iPhone"

#define PLACEHOLDERIMAGE IMAGE(@"banner_zw")

//************************************************************************//
#define SINGLE_LINE_WIDTH           (1 / [UIScreen mainScreen].scale)
#define SINGLE_LINE_ADJUST_OFFSET   ((1 / [UIScreen mainScreen].scale) / 2)


#define WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define HEIGHT ([[UIScreen mainScreen] bounds].size.height)
//TODO: 抽屉宽度
#define GPDRAWER_WIDTH 70
#define NavBarHeaght 44
#define NavStateBar 64
// 导航栏颜色
#define NAV_BG_COLOR [UIColor colorWithHexColorString:@"121212" alpha:1.0]
//主色调
#define MAIN_COLOR [UIColor colorWithHexColorString:@"1ab6af" alpha:1.0]

#define Highlighted_COLOR [UIColor colorWithHexColorString:@"939393" alpha:1.0]
#define CONTENTVIEW_COLOR [UIColor colorWithHexColorString:@"171717" alpha:1.0]
//新背景颜色
#define NEW_BG_COLOR [UIColor colorWithHexColorString:@"232323" alpha:1.0]
//#define GETWIDTH_AUTO(a) (((a) / 320.0) * WIDTH)
//#define GETHEIGHT_AUTO(a) (((a) / 568.0) * HEIGHT)
#define GETWIDTH_AUTO(a) (a)
#define GETHEIGHT_AUTO(a) (a)

#define GETWIDTH_AUTO6(a) (((a) / 375.0) * WIDTH)
#define GETHEIGHT_AUTO6(a) (((a) / 667.0) * HEIGHT)
//TODO: 所有背景颜色
//#define GROUNDCOLOR RGBCOLOR(234, 234, 234)
//TODO: tableview背景颜色
#define TABLEVIEWCOLOR group_table_color
//************************************************************************//
#define IPhone4_5_6_6P(a,b,c,d) (CGSizeEqualToSize(CGSizeMake(320, 480), [[UIScreen mainScreen] bounds].size) ?(a) :(CGSizeEqualToSize(CGSizeMake(320, 568), [[UIScreen mainScreen] bounds].size) ? (b) : (CGSizeEqualToSize(CGSizeMake(375, 667), [[UIScreen mainScreen] bounds].size) ?(c) : (CGSizeEqualToSize(CGSizeMake(414, 736), [[UIScreen mainScreen] bounds].size) ?(d) : 0))))
#define autoSizeScaleX WIDTH/320
#define autoSizeScaleY HEIGHT/568
#define IPhone6P_SCALE 1.2f
//************************************************************************//
#define TTViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]
// 加载图片
#define TT_SetImage(ImageView, url,placeHolderImage)\
[ImageView yy_setImageWithURL:[NSURL URLWithString:url] placeholder:placeHolderImage options:YYWebImageOptionProgressiveBlur |YYWebImageOptionSetImageWithFadeAnimation completion:nil]

//头像 显示人脸
#define TT_SetFaceImage(ImageView)\
[ImageView setContentMode:UIViewContentModeScaleAspectFill];\
[ImageView setNeedsBetterFace:YES];\
[ImageView setFast:NO];

//刷新控件 宏
#pragma mark - 刷新控件 宏
#define TT_Refresh_Header(block) [MJRefreshGifHeader tt_headerWithRefreshingBlock:block]
#define TT_Footer_Refresh(block) [MJRefreshAutoNormalFooter TTfooterWithRefreshingBlock:block]

#ifdef DEBUG
#define DLog(fmt, ...)           \
    NSLog((@"[文件名:%s]\n"   \
            "[函数名:%s]\n"   \
            "[行号:%d] \n" fmt), \
        __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(fmt, ...) ((void)0);
#endif
#define WEAKSELF __weak typeof(self) weakSelf = self
//************************************************************************//

#define RGBCOLOR(r, g, b) [UIColor colorWithRed:r / 255.f green:g / 255.f blue:b / 255.f alpha:1.f]

#define RGBACOLOR(r, g, b, a) [UIColor colorWithRed:r / 255.f green:g / 255.f blue:b / 255.f alpha:a]

#define LINE_COLOR rgb(208, 208, 208)

//********************************************************************//
#define DocumentsDirectory \
    ([NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0])

#define LibraryDirectory \
    ([NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0])

#define DocumentsSubDirectory(dir)                                                                      \
    ([[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] \
        stringByAppendingPathComponent:dir])

#define LibrarySubDirectory(dir)                                                                       \
    ([[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0] \
        stringByAppendingPathComponent:dir])

#define CacheDirectory ([NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0])

#define CacheSubDirectory(dir)                                                                        \
    ([[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] \
        stringByAppendingPathComponent:dir])

#define TempDirectory (NSTemporaryDirectory())

#define TempSubDirectory(dir) ([NSTemporaryDirectory() stringByAppendingPathComponent:dir])

/******************************************************************/
#define IMAGE(name) [UIImage imageNamed:name]
#define pngWithName(name) \
    [UIImage imageWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:@"png"]]]
#define MAIN_BUNDLE [NSBundle mainBundle]
#define getImageWithFileNameOfPNG(name) \
    [UIImage imageWithContentsOfFile:[MAIN_BUNDLE pathForResource:name ofType:@"png"]]
#define getImageWithFileNameOfJPG(name) \
    [UIImage imageWithContentsOfFile:[MAIN_BUNDLE pathForResource:name ofType:@"jpg"]]
#define getImageWithFileName(name) [UIImage imageWithContentsOfFile:[MAIN_BUNDLE pathForResource:name ofType:nil]]
#define ImagePathWithFileNameOfPNG(name) [MAIN_BUNDLE pathForResource:name ofType:@"png"]
#define ImagePathWithFileNameOfJPG(name) [MAIN_BUNDLE pathForResource:name ofType:@"jpg"]

/******************************************************************/
#if !defined(MIN)
#define MIN(a, b) ((a) < (b) ? (a) : (b))
#endif
#if !defined(MAX)
#define MAX(a, b) ((a) > (b) ? (a) : (b))
#endif

#define SHOW_ALERT(_msg_)                                                                                                                                 \
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:_msg_ delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil]; \
    [alert show];
#endif /* TTConstant_h */
