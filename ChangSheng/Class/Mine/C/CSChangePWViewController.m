//
//  CSChangePWViewController.m
//  ChangSheng
//
//  Created by cnepayzx on 2017/10/19.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSChangePWViewController.h"
#import "StoryBoardController.h"
#import "CSChangePWModel.h"
#import "LLUtils+Popover.h"
@interface CSChangePWViewController ()

@end

@implementation CSChangePWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UITableViewController * tableC =  (UITableViewController*)[StoryBoardController storyBoardName:@"Mine" ViewControllerIdentifiter:@"CSChangePWTableViewController"];
    [self addChildTableViewController:tableC];
    [self tt_Title:@"修改密码"];
    [self.view addSubview:tableC.tableView];
    
    [tableC.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(44);
    }];
    // Do any additional setup after loading the view.
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
@end

@implementation CSChangePWTableViewController
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
    if (!self.inputField0.text.length) {
        CS_HUD(@"请输入旧密码");
        return;
    }
    else if (!self.inputField1.text.length) {
        CS_HUD(@"请入新密码");
        return;
    }
    else if (!self.inputField2.text.length) {
        CS_HUD(@"请确认密码");
        return;
    }
    else if (![self.inputField1.text isEqualToString:self.inputField2.text])
    {
        CS_HUD(@"新密码与确认密码不一致");
        return;
    }
        
    CSChangePWModel * params = [CSChangePWModel new];
    params.old_pwd = self.inputField0.text;
    params.cs_new_pwd = self.inputField1.text;
    

    [LLUtils showCustomIndicatiorHUDWithTitle:@"" inView:self.view];
    [CSHttpRequestManager request_changePW_paramters:params.mj_keyValues success:^(id responseObject) {
//        CSTransferScoreModel * obj = [CSTransferScoreModel mj_objectWithKeyValues:responseObject];

        CS_HUD(@"修改成功");
//        [CSUserInfo shareInstance].info.surplus_score = obj.result.surplus_score.intValue;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(NSError *error) {
        
    } showHUD:YES];
    
}
@end
