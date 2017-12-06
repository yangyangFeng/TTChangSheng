//
//  CSZhuanFenViewController.m
//  ChangSheng
//
//  Created by cnepayzx on 2017/10/19.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSZhuanFenViewController.h"
#import "StoryBoardController.h"
#import "CSTransferScoreModel.h"
#import "LLUtils+Popover.h"
#import "CSOperationListViewController.h"
@interface CSZhuanFenViewController ()

@end

@implementation CSZhuanFenViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UITableViewController * tableC =  (UITableViewController*)[StoryBoardController storyBoardName:@"Mine" ViewControllerIdentifiter:@"CSZhuanFenTableViewController"];
    [self addChildTableViewController:tableC];
    [self tt_Title:@"转分"];
    [self.view addSubview:tableC.tableView];
    
    [tableC.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(44);
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self blackStatusBar];
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

@implementation CSZhuanFenTableViewController 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (IBAction)confirmDidAction:(id)sender {
    [self.view endEditing:YES];
    if (!self.inputField0.text.length) {
        CS_HUD(@"请输入ID");
        return;
    }
    else if (!self.inputField1.text.length) {
        CS_HUD(@"请输入分数");
        return;
    }
    else if (!self.inputField2.text.length) {
        CS_HUD(@"请输入登录密码");
        return;
    }
    
    CSTransferScoreModel * params = [CSTransferScoreModel new];
    params.score = self.inputField1.text;
    params.to_code = self.inputField0.text;
    params.password = self.inputField2.text;
//    [MBProgressHUD tt_Show];
    MBProgressHUD * hud =  [LLUtils showCustomIndicatiorHUDWithTitle:@"" inView:self.view];
    [CSHttpRequestManager request_zhuanFen_paramters:params.mj_keyValues success:^(id responseObject) {
        [hud hideAnimated:YES];
        CSTransferScoreModel * obj = [CSTransferScoreModel mj_objectWithKeyValues:responseObject];
//        [MBProgressHUD tt_SuccessTitle:obj.msg];
        [[CSUserInfo shareInstance] syncUserSurplus_score:obj.result.surplus_score.intValue];
//        [MBProgressHUD tt_SuccessTitle:@"转分成功!"];
        CS_HUD(@"转分成功!");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSArray * array = [self.navigationController viewControllers];
            NSMutableArray * popViewControllers = [NSMutableArray arrayWithArray:array];
            CSOperationListViewController * operationC = [CSOperationListViewController new];
            [popViewControllers replaceObjectAtIndex:popViewControllers.count - 1 withObject:operationC];
            [self.navigationController setViewControllers:popViewControllers animated:YES];
        });
    } failure:^(NSError *error) {
        [hud hideAnimated:YES];
    } showHUD:YES];
    
    
    
}

@end
