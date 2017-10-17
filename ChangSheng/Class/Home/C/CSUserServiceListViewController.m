//
//  CPUserServiceListViewController.m
//  ChangSheng
//
//  Created by cnepayzx on 2017/10/11.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSUserServiceListViewController.h"
#import "LLChatViewController.h"
#import "CSPublicBetViewController.h"

#import "CSUserTableViewCell.h"
#import "StoryBoardController.h"
#import "CSMsgHistoryRequestModel.h"

#import "CSMsgHistoryModel.h"
#import "CSMsgRecordModel.h"
#import "CSIMSendMessageRequestModel.h"

static CSUserServiceListViewController * controller = nil;

@interface CSUserServiceListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataSource;
@end

@implementation CSUserServiceListViewController

- (void)loadView
{
    [super loadView];
}

+ (id)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        controller = [[CSUserServiceListViewController alloc]init];
    });
    return controller;
}

+(instancetype)new
{
    return [self shareInstance];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    
    [self createSubviews];
    
    [self.tt_navigationBar.contentView setBackgroundColor:[UIColor whiteColor]];
    
    self.tt_navigationBar.titleLabel.textColor = [UIColor colorWithHexColorString:@"333333"];
    
    self.view.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    
    [self tt_Title:@"客服列表"];
    
    
    // Do any additional setup after loading the view.
}

- (void)loadData
{
 
    
    //    TTSingleChatViewController * vc = [TTSingleChatViewController new];
    //    [self.navigationController pushViewController:vc animated:YES];
    [MBProgressHUD tt_ShowInViewDefaultTitle:self.view];
    [CSHttpRequestManager request_helperList_paramters:nil success:^(id responseObject) {
        CSMsgHistoryModel * obj = [CSMsgHistoryModel mj_objectWithKeyValues:responseObject];
        self.dataSource = [NSMutableArray arrayWithArray:obj.result];
        [self.tableView reloadData];
        [MBProgressHUD tt_HideFromeView:self.view];
    } failure:^(NSError *error) {
        [MBProgressHUD tt_HideFromeView:self.view];
    } showHUD:YES];
}

- (void)createSubviews
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    self.tableView.separatorStyle = 0;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = self.view.backgroundColor;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.tt_navigationBar.mas_bottom).offset(0);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CSUserTableViewCell * cell = [CSUserTableViewCell cellWithTableView:tableView];
    CSMsgHistoryModel * model = self.dataSource[indexPath.row];
    
     [cell.userIcon yy_setImageWithURL:[NSURL URLWithString:model.avatar] placeholder:[UIImage imageNamed:@"聊天自定义头像"]];
    cell.userName.text = model.nickname;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CSMsgHistoryModel * userServiceModel = self.dataSource[indexPath.row];
    CSMsgHistoryRequestModel * param = [CSMsgHistoryRequestModel new];
    param.chat_type = 2;//客服为单聊
    param.ID = userServiceModel.id.intValue;
    
    [MBProgressHUD tt_ShowInViewDefaultTitle:self.tableView];
    [CSHttpRequestManager request_chatRecord_paramters:param.mj_keyValues success:^(id responseObject) {
        CSMsgRecordModel * obj = [CSMsgRecordModel mj_objectWithKeyValues:responseObject];
        
        [MBProgressHUD tt_HideFromeView:self.tableView];
        LLChatViewController * chatC = (LLChatViewController*)[StoryBoardController storyBoardName:@"Main" ViewControllerIdentifiter:@"LLChatViewController"];

        CSIMConversationModel * model = [CSIMConversationModel new];
        model.chatId = [userServiceModel id];
        model.nickName = userServiceModel.nickname;
        model.allMessageModels = [NSMutableArray array];
        
        for (CSMsgRecordModel * msgData in obj.result.data) {
            CSMessageModel * msgModel = [CSMessageModel conversionWithRecordModel:msgData chatType:param.chat_type chatId:userServiceModel.id];
            
            CSIMSendMessageRequestModel * sendMsgModel = [CSIMSendMessageRequestModel new];
            sendMsgModel.body = msgModel;
            [model.allMessageModels addObject:sendMsgModel];
        }
        
        
        chatC.conversationModel = model;
        [self.navigationController pushViewController:chatC animated:YES];
    } failure:^(NSError *error) {
        [MBProgressHUD tt_HideFromeView:self.tableView];
    } showHUD:YES];
}

@end
