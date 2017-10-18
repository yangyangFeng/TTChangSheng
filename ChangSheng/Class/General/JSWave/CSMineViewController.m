//
//  CSMineViewController.m
//  ChangSheng
//
//  Created by cnepayzx on 2017/10/9.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSMineViewController.h"
#import "JSWave.h"
#import "CSMineTableViewCell.h"
#import "CSUserInfoViewController.h"
#import "StoryBoardController.h"
#import "CSBaseViewController.h"
#import "CSCaiwuViewController.h"
@interface CSMineViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) JSWave *headerView;

@property (nonatomic, strong) UIImageView *iconImageView;

@property(nonatomic,strong)NSArray * items;
@end

@implementation CSMineViewController

//- (void)loadView
//{
//    self.view = self.tableView;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tt_navigationBar.contentView.backgroundColor = [UIColor clearColor];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(-20);
    }];
   
    
    [self.tt_navigationBar.leftBtn setImage:[UIImage imageNamed:@"goBackH"] forState:(UIControlStateNormal)];
    [self.tt_navigationBar.leftBtn setImage:[UIImage imageNamed:@"goBackN"] forState:(UIControlStateHighlighted)];
    
    UITapGestureRecognizer * tap= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headDidAction)];
    [self.headerView addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [self.navigationController performSelector:@selector(whiteStatusBar)];
}

- (void)headDidAction
{
//    UIViewController * userInfoC = [StoryBoardController storyBoardName:@"Mine" ViewControllerIdentifiter:@"CSUserInfoViewController"];
    CSUserInfoSuperViewController * supC = [CSUserInfoSuperViewController new];
//    [supC addChildTableViewController:userInfoC];
//    supC.title = @"个人资料";
    [self.navigationController pushViewController:supC animated:YES];
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
    UIView * view = [UIView new];
    view.backgroundColor = self.headerView.backgroundColor;
    cell.selectedBackgroundView = view;
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
            CSCaiwuViewController *caiwuC = [CSCaiwuViewController new];
            [self.navigationController pushViewController:caiwuC animated:YES];
        }
            break;
        case 1:
            {}
            break;
        case 2:
            {}
            break;
        case 3:
            {}
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
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell1"];
        _tableView.tableHeaderView = self.headerView;
        
    }
    return _tableView;
}

- (UIImageView *)iconImageView{
    
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.headerView.frame.size.width/2-30, 0, 60, 60)];
        _iconImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _iconImageView.layer.borderWidth = 2;
        _iconImageView.layer.cornerRadius = 20;
    }
    return _iconImageView;
}

- (JSWave *)headerView{
    
    if (!_headerView) {
        _headerView = [[JSWave alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
        _headerView.backgroundColor = XNColor(41, 177, 80, 1);
        [_headerView addSubview:self.iconImageView];
        __weak typeof(self)weakSelf = self;
        _headerView.waveBlock = ^(CGFloat currentY){
            CGRect iconFrame = [weakSelf.iconImageView frame];
            iconFrame.origin.y = CGRectGetHeight(weakSelf.headerView.frame)-CGRectGetHeight(weakSelf.iconImageView.frame)+currentY-weakSelf.headerView.waveHeight - 20;
            weakSelf.iconImageView.frame  =iconFrame;
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
