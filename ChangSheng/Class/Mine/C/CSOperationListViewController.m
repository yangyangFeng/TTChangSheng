//
//  CSOperationListViewController.m
//  ChangSheng
//
//  Created by cnepayzx on 2017/10/19.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSOperationListViewController.h"

#import "CSOperationRecordCell.h"
#import "CSOperationRecordsHeaderView.h"
#import "CSScoreRecordModel.h"
@interface CSOperationListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataSource;
@end

@implementation CSOperationListViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self blackStatusBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createSubviews];
    
    [self tt_Title:@"操作记录"];
    
    [self addRefreshTool];
    // Do any additional setup after loading the view.
}

- (void)createSubviews
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    self.tableView.separatorStyle = 0;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedSectionHeaderHeight = 55;
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(64);
    }];
    
}

- (void)addRefreshTool
{
    self.tableView.mj_header = [TTRefresh tt_headeRefresh:^{
        [CSHttpRequestManager request_fenCaoZuoJiLu_paramters:nil success:^(id responseObject) {
            CSScoreRecordModel * obj = [CSScoreRecordModel mj_objectWithKeyValues:responseObject];
            self.dataSource = [NSMutableArray arrayWithArray:obj.result];
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            [self.tableView.mj_header endRefreshing];
        } showHUD:NO];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CSOperationRecordsHeaderView * headerView = [CSOperationRecordsHeaderView viewFromXIB];
    headerView.frame = CGRectMake(0, 0, WIDTH, 55);
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section
{
    return 55;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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
    CSOperationRecordCell * cell = [CSOperationRecordCell cellWithTableView:tableView];
    CSScoreRecordModel * model = self.dataSource[indexPath.row];
    cell.cs_title_0.text = model.create_time;
    cell.cs_title_1.text = model.type_name;
    cell.cs_title_2.text = model.score;
    cell.cs_title_3.text = model.code;
    cell.cs_title_4.text = model.status_name;
    cell.selectedBackgroundView = [TTCellSelectionView new];
    return  cell;
}

@end
