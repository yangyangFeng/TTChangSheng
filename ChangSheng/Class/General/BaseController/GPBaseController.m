//
//  GPBaseController.m
//  GoPlay
//
//  Created by 邴天宇 on 7/12/15.
//  Copyright © 2015年 邴天宇. All rights reserved.
//

#import "GPBaseController.h"

#define SWITCH_AFTER 0
#define ERROR_VIEW_TAG 4819
@interface GPBaseController ()
@property (nonatomic, strong) UIView* hudView;

@property (nonatomic, assign) BOOL HUD_Showing;
@property (nonatomic, assign) BOOL isClean_Error; //是否重置错误状态
@property (nonatomic, copy) void (^errorCallBlock)();
@end

@implementation GPBaseController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        //TODO: PUSH 隐藏 tabbar
        self.hidesBottomBarWhenPushed = YES;
        
        _currentPage = 2;
    }
    return self;
}




-(UIView *)hudView
{
    if (!_hudView) {
        _hudView = [UIView new];
        _hudView.backgroundColor = [UIColor whiteColor];
        _hudView.frame = CGRectMake(0, NavStateBar, WIDTH, HEIGHT - NavStateBar);
        _hudView.userInteractionEnabled = YES;
    }
    return _hudView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setExclusiveTouch:YES];
    self.view.backgroundColor = [UIColor blackColor];

}


// 重载状态栏方法
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)dealloc
{
    DLog(@"已释放  class-->%@",[self class]);
}

- (void)didReceiveMemoryWarning
{
    //In earlier versions of iOS, the system automatically attempts to unload a view controller's views when memory is low
    [super didReceiveMemoryWarning];
    //didReceiveMemoryWarining 会判断当前ViewController的view是否显示在window上，如果没有显示在window上，则didReceiveMemoryWarining 会自动将viewcontroller 的view以及其所有子view全部销毁，然后调用viewcontroller的viewdidunload方法。
    DLog(@"内存警告 class-->%@",[self class]);
  
//    SHOW_ALERT(@"内存警告");
}
@end
