//
//  CSMineViewController.m
//  ChangSheng
//
//  Created by cnepayzx on 2017/10/9.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSMineViewController.h"
#import "CSOperationListViewController.h"
#import "TTNavigationController.h"
#import "AppDelegate.h"
#import "TTSocketChannelManager.h"
#import "JSWave.h"
#import "CSMineUserInfoView.h"
#import "CSMineTableViewCell.h"
#import "CSUserInfoViewController.h"
#import "StoryBoardController.h"
#import "CSCaiwuViewController.h"
#import "CSZhuanFenViewController.h"
#import "CSChangePWViewController.h"
#import "LLUtils+Popover.h"
@interface CSMineViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@property(nonatomic,strong)CSMineUserInfoView * userInfoView;

@property (nonatomic, strong) JSWave *headerView;

//@property (nonatomic, strong) UIImageView *iconImageView;

@property(nonatomic,strong)NSArray * items;
@end

@implementation CSMineViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tt_navigationBar.contentView.backgroundColor = [UIColor clearColor];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(IPhone4_5_6_6P_X(-20,-20,-20,-20,-40));
    }];
   
   
    [self.tt_navigationBar.leftBtn setImage:[UIImage imageNamed:@"goBackH"] forState:(UIControlStateNormal)];
    [self.tt_navigationBar.leftBtn setImage:[UIImage imageNamed:@"goBackN"] forState:(UIControlStateHighlighted)];
    
    UITapGestureRecognizer * tap= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headDidAction)];
    [self.headerView addGestureRecognizer:tap];
    
//    [self.iconImageView yy_setImageWithURL:[NSURL URLWithString:[CSUserInfo shareInstance].info.avatar] placeholder:[UIImage imageNamed:@"个人资料头像.png"]];
    
    self.myNavigationBar.rightBtn.hidden = NO;
    [self.myNavigationBar.rightBtn setImage:[UIImage imageNamed:@"个人中心设置"] forState:(UIControlStateNormal)];
    
    self.userInfoView = [CSMineUserInfoView new];
    [self.headerView addSubview:self.userInfoView];
    
    [self.userInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(45);
        make.height.mas_equalTo(140);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-20);
    }];
    
    [self createFooterView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.userInfoView refreshUserInfo];
    [self.navigationController performSelector:@selector(whiteStatusBar)];
}

-(void)tt_DefaultRightBtnClickAction
{
    CSUserInfoSuperViewController * supC = [CSUserInfoSuperViewController new];
    [self.navigationController pushViewController:supC animated:YES];
}

- (void)headDidAction
{
    CSUserInfoSuperViewController * supC = [CSUserInfoSuperViewController new];
    [self.navigationController pushViewController:supC animated:YES];
}

- (void)createFooterView
{
    UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 200)];
    bgView.backgroundColor = [UIColor clearColor];
    
    UIButton * logoutBtn = [UIButton buttonWithName:@"退出登录"];
    logoutBtn.titleLabel.textColor = [UIColor whiteColor];
    logoutBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [logoutBtn addTarget:self action:@selector(logoutDidAction) forControlEvents:(UIControlEventTouchUpInside)];
    [logoutBtn setBackgroundColor:rgb(41, 177, 80)];
//    [logoutBtn setImage:[UIImage imageFromContextWithColor:rgb(41, 177, 80)] forState:(UIControlStateNormal)];
    logoutBtn.layer.masksToBounds = YES;
    logoutBtn.layer.cornerRadius = 22.0f;
    
    [bgView addSubview:logoutBtn];
    [logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(30);
        make.width.mas_equalTo(275);
        make.height.mas_equalTo(44);
    }];
    
    self.tableView.tableFooterView = bgView;
}

- (void)logoutDidAction
{
//    [MBProgressHUD tt_Show];
    
    [LLUtils showConfirmAlertWithTitle:@"" message:@"您是否要退出登录?" yesTitle:@"确认" yesAction:^{
        [LLUtils showCustomIndicatiorHUDWithTitle:@"" inView:self.view];
        [[CSUserInfo shareInstance] logout];
        [[TTSocketChannelManager shareInstance] closeConnection];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIViewController * rootC = [StoryBoardController viewControllerID:@"CSLoginViewController" SBName:@"CSLoginSB"];
            TTNavigationController * nav = [[TTNavigationController alloc]initWithRootViewController:rootC];
            AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
            appDelegate.window.rootViewController = nav;
            [LLUtils showTextHUD:@"已退出登录" inView:self.view];
        });
    }];
}

#pragma tab del  /  sour

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CSMineTableViewCell * cell = [CSMineTableViewCell cellWithTableView:tableView];
    cell.selectedBackgroundView = [TTCellSelectionView new];
    cell.cs_icon.image = [UIImage imageNamed:self.items[indexPath.row][@"icon"]];
    cell.cs_title.text = self.items[indexPath.row][@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            
            UIViewController * caiwuController = [StoryBoardController viewControllerID:@"CSZFShangXiaFenViewController" SBName:@"ZhangFang"];
            [self.navigationController pushViewController:caiwuController animated:YES];
//            UIViewController * caiwuController = [StoryBoardController viewControllerID:@"CSCaiwuViewController" SBName:@"Mine"];
//            [self.navigationController pushViewController:caiwuController animated:YES];
        }
            break;
        case 1:
            {
                CSZhuanFenViewController * zhuanfenC = [CSZhuanFenViewController new];
                [self.navigationController pushViewController:zhuanfenC animated:YES];
            }
            break;
        case 2:
            {
                CSOperationListViewController * operationListC = [CSOperationListViewController new];
                [self.navigationController pushViewController:operationListC animated:YES];
            }
            break;
        case 3:
            {
                CSChangePWViewController * changePWC = [CSChangePWViewController new];
                [self.navigationController pushViewController:changePWC animated:YES];
            }
            break;
            
        default:
            break;
    }
}

- (UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell1"];
        _tableView.tableHeaderView = self.headerView;
        
    }
    return _tableView;
}

//- (UIImageView *)iconImageView{
//
//    if (!_iconImageView) {
//        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.headerView.frame.size.width/2-30, 0, 60, 60)];
//        _iconImageView.layer.borderColor = [UIColor whiteColor].CGColor;
//        _iconImageView.layer.borderWidth = 2;
//        _iconImageView.layer.cornerRadius = 20;
//        _iconImageView.layer.masksToBounds = YES;
//    }
//    return _iconImageView;
//}

- (JSWave *)headerView{
    
    if (!_headerView) {
        _headerView = [[JSWave alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
        _headerView.backgroundColor = XNColor(41, 177, 80, 1);
//        [_headerView addSubview:self.iconImageView];
        
        _headerView.waveBlock = ^(CGFloat currentY){
//            CGRect iconFrame = [weakSelf.iconImageView frame];
//            iconFrame.origin.y = CGRectGetHeight(weakSelf.headerView.frame)-CGRectGetHeight(weakSelf.iconImageView.frame)+currentY-weakSelf.headerView.waveHeight - 20;
//            weakSelf.iconImageView.frame  =iconFrame;
        };
        [_headerView startWaveAnimation];
    }
    return _headerView;
}

-(NSArray *)items
{
    if (!_items) {
        _items = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CSMineItem" ofType:@"plist"]];
    }
    return _items;
}

@end
