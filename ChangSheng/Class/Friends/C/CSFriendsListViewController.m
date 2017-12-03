//
//  CSFriendsListViewController.m
//  ChangSheng
//
//  Created by cnepayzx on 2017/11/30.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSFriendsListViewController.h"

#import "CSAddressBookViewController.h"
#import "CSSearchFriendManagerViewController.h"

#import "CSFriendListTableHandler.h"

@interface CSFriendsListViewController ()<TTBaseTableViewHandlerDelegate>
@property(nonatomic,strong)CSFriendListTableHandler * tableHandler;
@end

@implementation CSFriendsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self tt_Title:@"乐友"];
    
    [self createSubviews];
}

- (void)createSubviews
{
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    tableView.tableFooterView = [UIView new];
    _tableHandler = [[CSFriendListTableHandler alloc]initWithTableView:tableView];
    
    [self.view addSubview:tableView];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(64);
        make.left.right.bottom.mas_equalTo(0);
    }];
    
    UIButton * addressBookButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [addressBookButton setBackgroundImage:[UIImage imageNamed:@"添加"] forState:(UIControlStateNormal)];
    [addressBookButton addTarget:self action:@selector(addressBookAction) forControlEvents:(UIControlEventTouchUpInside)];
    
    UIButton * addButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [addButton setBackgroundImage:[UIImage imageNamed:@"添加"] forState:(UIControlStateNormal)];
    [addButton addTarget:self action:@selector(addAction) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.myNavigationBar.rightView addSubview:addressBookButton];
    [self.myNavigationBar.rightView addSubview:addButton];
    [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(22);
        make.bottom.mas_equalTo(-11);
        make.right.mas_equalTo(-19);
    }];
    [addressBookButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(22);
        make.bottom.mas_equalTo(-11);
        make.right.mas_equalTo(addButton.mas_left).offset(-10);
    }];
}
- (void)addressBookAction
{
    DLog(@"通讯录");
    CSAddressBookViewController * addressBookC = [CSAddressBookViewController new];
    
    [self.navigationController pushViewController:addressBookC animated:YES];
}

- (void)addAction
{
    DLog(@"添加好友");
    CSSearchFriendManagerViewController * addFriendC = [CSSearchFriendManagerViewController new];
    
    [self.navigationController pushViewController:addFriendC animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        DLog(@"点击好友请求");
    }
    else
    {
     DLog(@"点击");
    }
}
@end
