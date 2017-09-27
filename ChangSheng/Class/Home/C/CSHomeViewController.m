//
//  CSHomeViewController.m
//  ChangSheng
//
//  Created by 邴天宇 on 17/9/26.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSHomeViewController.h"

#import "CSHomeTableViewHandler.h"
@interface CSHomeViewController ()
@property (nonatomic,strong) CSHomeTableViewHandler *tableHandler;
@end

@implementation CSHomeViewController

//- (void)loadView
//{
//    UITableView * tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
//    self.view = tableView;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self tt_SetNaviBarHide:YES withAnimation:NO];
    
    [self createSubviews];
    // Do any additional setup after loading the view.
}

- (void)createSubviews
{
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    tableView.backgroundColor = [UIColor blackColor];
    _tableHandler = [[CSHomeTableViewHandler alloc]initWithTableView:tableView];
    
    [self.view addSubview:tableView];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
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
