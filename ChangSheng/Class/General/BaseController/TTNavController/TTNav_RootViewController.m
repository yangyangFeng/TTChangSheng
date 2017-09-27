//
//  TTNav_RootViewController.m
//  navcontroller
//
//  Created by 邴天宇 on 17/12/15.
//  Copyright © 2015年 邴天宇. All rights reserved.
//

#import "TTNav_RootViewController.h"


#import "TTNavigationBar.h"
#import "TTBaseNavigationBar.h"

#import "TTNav_RootViewController.h"










@interface TTNav_RootViewController ()
@property (nonatomic, strong) TTNavigationBar * my_navigationBar;
@property (nonatomic, strong) TTBaseNavigationBar * my_base_navigationBar;
@property (nonatomic, weak) TTNavigationBar * output_navigationBar;
@property (nonatomic, strong) NSLayoutConstraint * my_navigationBarTopConstraint;
@end

@implementation TTNav_RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
    }
    return self;
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //TODO: 默认设置.
    if (_my_base_navigationBar) {
        [self.view bringSubviewToFront:_my_navigationBar];
    }
    else{}
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 因为是自定义的 NAV 所以不需要系统自动调整 tableview布局
     self.automaticallyAdjustsScrollViewInsets = NO;
//    self.edgesForExtendedLayout = UIRectEdgeNone; //不向四周延伸
    
    [self initCustomTTNavBar];
    
    [self setNavBarAlpha];
    
    [self initCustomeBarButtonItem];
    // Do any additional setup after loading the view.
    if (self.title) {
        [self tt_Title:self.title];
    }

}
#pragma mark - 修改导航栏颜色
- (void)setNavBarAlpha
{
    //TODO: 同意修改导航栏颜色
    TTNavigationBar * navBar = [self tt_navigationBar];
    //    navBar.centerView = _searchView;
//    [navBar.customBar setBackgroundImage:IMAGE(@"alpha") forBarMetrics:UIBarMetricsDefault];
    navBar.contentView.backgroundColor = NAV_BG_COLOR;
    self.myNavigationBar = navBar;
}
- (void)tt_Alpha:(CGFloat)alpha
{
    TTNavigationBar * navBar = [self tt_navigationBar];
    [navBar.customBar setBackgroundImage:IMAGE(@"alpha") forBarMetrics:UIBarMetricsDefault];
    navBar.contentView.backgroundColor = NAV_BG_COLOR;
    self.myNavigationBar = navBar;
}
#pragma mark - 初始化返回按钮
- (void)initCustomeBarButtonItem
{
    UIButton * gobackButton = [self backBarButtonItem];
    [gobackButton setImage:IMAGE(@"goBackN") forState:(UIControlStateNormal)];
    [gobackButton setImage:IMAGE(@"goBackH") forState:(UIControlStateHighlighted)];
    [gobackButton setTitle:@"" forState:(UIControlStateNormal)];
}

- (void)initCustomTTNavBar
{
    NSAssert(!_my_navigationBar, @" ! ");
    self.my_navigationBar = [TTNavigationBar createNaviBarViewFromXIB];
    _my_navigationBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_my_navigationBar];
    
    _my_base_navigationBar = _my_navigationBar;
    [self setNavBarAutolayout]; //添加约束布局
    
    //如果根师徒控制器是当前视图,那么隐藏左边返回按钮
    if (self.navigationController && (self.navigationController.viewControllers.firstObject!=self)) {
        _my_navigationBar.leftBtn.hidden = NO;
    }
    else{
        _my_navigationBar.leftBtn.hidden = YES;
    }
    //  右边默认按钮默认隐藏
    _my_navigationBar.rightBtn.hidden = YES;
    
    __weak __typeof(self) weakSelf = self;
    
    _my_navigationBar.leftBtnPressedHandler = ^(){
        [weakSelf tt_DefaultLeftBtnClickAction];
    };
    
    _my_navigationBar.rightBtnPressedHandler = ^(){
        [weakSelf tt_DefaultRightBtnClickAction];
    };
    
}

- (void)tt_DefaultLeftBtnClickAction
{   //  默认 pop Controller
    if (self.navigationController && (self.navigationController.viewControllers.firstObject != self)) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
    }
}

- (void)tt_DefaultRightBtnClickAction
{
//     NSAssert(NO, @"  !  must overload method");
}

- (void)tt_Title:(NSString *)title
{
    NSAssert(_my_navigationBar, @"  !  ");
    if (_my_navigationBar) {
        _my_navigationBar.titleLabel.text = title;
    }
    else {
    }
}

- (void)tt_TitleTextColor:(UIColor *)color
{
    if (_my_navigationBar) {
        _my_navigationBar.titleLabel.textColor = color;
    }
    else {
    }
}

- (TTNavigationBar *)tt_navigationBar
{
//    _output_navigationBar = _my_navigationBar;
    return _my_navigationBar;
}

- (UIButton*)backBarButtonItem
{
    NSAssert(_my_navigationBar, @"  !  ");
    UIButton* backBtn;
    if (_my_navigationBar) {
        backBtn = _my_navigationBar.leftBtn;
    }
    else {
    }
    
    return backBtn;
}

- (UIButton*)rightBarButtonItem
{
    NSAssert(_my_navigationBar, @"  !  ");
    UIButton* rightBtn;
    if (_my_navigationBar) {
        rightBtn = _my_navigationBar.rightBtn;
    }
    else {
    }
    
    return rightBtn;
}

- (void)tt_DefaultNaviBarSetLeftViewHidden:(BOOL)hidden
{
    NSAssert(_my_navigationBar, @"  !  ");
    if (_my_navigationBar) {
        _my_navigationBar.leftView.hidden = hidden;
    }
    else {
    }
}

- (void)tt_DefaultNaviBarSetRightViewHidden:(BOOL)hidden
{
    NSAssert(_my_navigationBar, @"  !  ");
    if (_my_navigationBar) {
        _my_navigationBar.rightBtn.hidden = hidden;
    }
    else {
    }
}

- (void)tt_SetNaviBarHide:(BOOL)hide withAnimation:(BOOL)animation
{
    NSAssert(_my_base_navigationBar && _my_navigationBarTopConstraint, @"  !  ");
    
    if (animation) {
        [_my_base_navigationBar setNeedsLayout];
        [UIView animateWithDuration:0.3f animations:^() {
            _my_navigationBarTopConstraint.constant = (hide ? -1 * _my_base_navigationBar.bounds.size.height : 0);
            [_my_base_navigationBar layoutIfNeeded];
        }
                         completion:^(BOOL f){
        }];
    }
    else {
        [_my_base_navigationBar setNeedsLayout];
        _my_navigationBarTopConstraint.constant = (hide ? -1 * _my_base_navigationBar.bounds.size.height : 0);
        [_my_base_navigationBar layoutIfNeeded];
    }
}

- (void)tt_ReplaceNaviBarView:(TTBaseNavigationBar*)naviBarView
{
    NSAssert(naviBarView, @"  !  ");
    if (naviBarView) {
        [naviBarView removeFromSuperview];
        if (_my_base_navigationBar) {
            [_my_base_navigationBar removeFromSuperview];
            _my_base_navigationBar = nil;
            _my_navigationBarTopConstraint = nil;
        }
        else {
        }
        
        [self.view addSubview:naviBarView];
        _my_base_navigationBar = naviBarView;
        [self setNavBarAutolayout];
    }
    else {
    }
}










- (void)setNavBarAutolayout
{
    if (_my_base_navigationBar) {
        _my_base_navigationBar.translatesAutoresizingMaskIntoConstraints = NO;
        
        _my_navigationBarTopConstraint = [NSLayoutConstraint constraintWithItem:_my_base_navigationBar
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.view
                                                                attribute:NSLayoutAttributeTop
                                                               multiplier:1.0
                                                                 constant:0];
        
        [self.view addConstraints:@[
                                    _my_navigationBarTopConstraint,
                                    
                                    [NSLayoutConstraint constraintWithItem:_my_base_navigationBar
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.view
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:0],
                                    
                                    [NSLayoutConstraint constraintWithItem:_my_base_navigationBar
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.view
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1
                                                                  constant:0],
                                    
                                    ]];
        [_my_base_navigationBar addConstraint:[NSLayoutConstraint
                                              constraintWithItem:_my_base_navigationBar
                                              attribute:NSLayoutAttributeHeight
                                              relatedBy:NSLayoutRelationEqual
                                              toItem:nil
                                              attribute:NSLayoutAttributeNotAnAttribute
                                              multiplier:1
                                              constant:_my_base_navigationBar.bounds.size.height]];
    }
    else {
    }
}

- (UIViewController *)addChildTableViewController:(UIViewController *)childController
{
    
    
    
    [(UITableViewController*)childController tableView].backgroundColor = NEW_BG_COLOR;
    [(UITableViewController*)childController tableView].separatorStyle = 0;
    [self addChildViewController:childController];
    return childController;
}
@end
