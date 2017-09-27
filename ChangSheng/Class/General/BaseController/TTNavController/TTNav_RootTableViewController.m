//
//  TTNav_RootTableViewController.m
//  GoPlay
//
//  Created by 邴天宇 on 24/12/15.
//  Copyright © 2015年 邴天宇. All rights reserved.
//

#import "TTNav_RootTableViewController.h"

@interface TTNav_RootTableViewController ()
@property (nonatomic, strong) TTNavigationBar * my_navigationBar;
@property (nonatomic, strong) TTBaseNavigationBar * my_base_navigationBar;
@property (nonatomic, weak) TTNavigationBar * output_navigationBar;
@property (nonatomic, strong) NSLayoutConstraint * my_navigationBarTopConstraint;
@end

@implementation TTNav_RootTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    [self tt_Title:title];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_my_base_navigationBar) {
        [self.view bringSubviewToFront:_my_navigationBar];
    }
    else{}
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initCustomTTNavBar];
    
    [self setNavBarAlpha];
    
    [self initCustomeBarButtonItem];
    // Do any additional setup after loading the view.
}
#pragma mark - 修改导航栏颜色
- (void)setNavBarAlpha
{
    //TODO: 同意修改导航栏颜色
    TTNavigationBar * navBar = [self tt_navigationBar];
    //    navBar.centerView = _searchView;
    //    [navBar.customBar setBackgroundImage:IMAGE(@"alpha") forBarMetrics:UIBarMetricsDefault];
    navBar.contentView.backgroundColor = [UIColor colorWithHexColorString:@"28a7fa" alpha:1.0];
    self.myNavigationBar = navBar;
}
#pragma mark - 初始化返回按钮
- (void)initCustomeBarButtonItem
{
    UIButton * gobackButton = [self backBarButtonItem];
    gobackButton = [UIButton buttonWithNormalImage:@"back" andHilightImage:@"back"];
    [gobackButton setImage:IMAGE(@"back") forState:(UIControlStateNormal)];
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
    NSAssert(NO, @"  !  must overload method");
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
