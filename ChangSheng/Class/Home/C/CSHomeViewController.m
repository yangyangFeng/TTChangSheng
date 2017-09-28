//
//  CSHomeViewController.m
//  ChangSheng
//
//  Created by 邴天宇 on 17/9/26.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSHomeViewController.h"

#import "CSHomeTableViewHandler.h"
#import "LLChatViewController.h"
#import "StoryBoardController.h"
#import "CSMsgHistoryRequestModel.h"
@interface CSHomeViewController ()<TTBaseTableViewHandlerDelegate>
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
    _tableHandler.delegate = self;
    [self.view addSubview:tableView];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController * chatC = [StoryBoardController storyBoardName:@"Main" ViewControllerIdentifiter:@"LLChatViewController"];
 
    [self.navigationController pushViewController:chatC animated:YES];
    CSMsgHistoryRequestModel * param = [CSMsgHistoryRequestModel new];
    param.chat_type = 2;
    param.ID = 3;
    
    [CSHttpRequestManager request_chatRecord_paramters:param.mj_keyValues success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    } showHUD:YES];
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
