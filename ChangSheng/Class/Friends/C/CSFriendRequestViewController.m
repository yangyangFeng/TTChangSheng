//
//  CSFriendRequestViewController.m
//  ChangSheng
//
//  Created by 邴天宇 on 2017/12/10.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSFriendRequestViewController.h"


#import "CSFriendRequestTableViewCell.h"
#import "CSAddFriendParam.h"
#import "CSFriendRequestListModel.h"
#import "LLUtils.h"
@interface CSFriendRequestViewController ()<UITableViewDelegate,UITableViewDataSource,CSFriendRequestTableViewCellDelegate>
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation CSFriendRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    
    tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(NavStateBar);
    }];
    
    MBProgressHUD * hud = [LLUtils showCustomIndicatiorHUDWithTitle:@"" inView:self.view];
    [CSHttpRequestManager request_friendRequestList_paramters:nil success:^(id responseObject) {
        [hud hideAnimated:YES];
        CSFriendRequestListModel * model = [CSFriendRequestListModel mj_objectWithKeyValues:responseObject];
        self.dataSource = [NSMutableArray arrayWithArray:model.result];
        [tableView reloadData];
    } failure:^(NSError *error) {
        [hud hideAnimated:YES];
    } showHUD:YES];
    
    UIView * view  =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 10)];
    tableView.tableHeaderView = view;
    tableView.tableFooterView = [UIView new];
    self.tableView = tableView;
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CSFriendRequestTableViewCell * cell = [CSFriendRequestTableViewCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    CSFriendRequestListModel * model =self.dataSource[indexPath.row];
    [cell.userIcon yy_setImageWithURL:[NSURL URLWithString:model.avatar] placeholder:[UIImage imageNamed:@"个人资料头像.png"]];
    cell.nickName.text = model.nickname;
    
    if ([model.status isEqualToString:@"1"]) { //显示接收按钮
        cell.button.hidden = NO;
        cell.addedLabel.hidden = YES;
    }
    else
    {
        cell.button.hidden = YES;
        cell.addedLabel.hidden = NO;
    }
    cell.model = model;
    return cell;
}

-(void)buttonDidActionWithCell:(CSFriendRequestTableViewCell *)cell
{
    CSFriendRequestListModel * model = cell.model;
    CSAddFriendParam * param = [CSAddFriendParam new];
    param.friend_id = model.user_id;
    MBProgressHUD * hud = [LLUtils showCustomIndicatiorHUDWithTitle:@"" inView:self.view];
    [CSHttpRequestManager request_agreeFriendRequest_paramters:param.mj_keyValues success:^(id responseObject) {
        model.status = @"2";
        [self.tableView reloadRowsAtIndexPaths:@[[self.tableView indexPathForCell:cell]] withRowAnimation:(UITableViewRowAnimationFade)];
        [hud hideAnimated:YES];
    } failure:^(NSError *error) {
        [hud hideAnimated:YES];
    } showHUD:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
