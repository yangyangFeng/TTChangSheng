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
#import "CSFriendRequestViewController.h"
#import "CSFriendListTableHandler.h"
#import "CSFriendchartlistParam.h"
#import "CSFriendRequestNumModel.h"
#import "CSFriendchartlistModel.h"
#import "CSFriendchartlistModel.h"
#import "LLUtils.h"
#import "CSMessageRecordTool.h"
#import "LLChatViewController.h"
#import "StoryBoardController.h"
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)createSubviews
{
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    tableView.tableFooterView = [UIView new];
    _tableHandler = [[CSFriendListTableHandler alloc]initWithTableView:tableView];
    _tableHandler.delegate = self;
    
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

- (void)loadData
{
    NSArray * friends = [CSMsgCacheTool AccessToChatFriendWith:(CS_Message_Record_Type_Friend)];
    self.tableHandler.dataSource = [NSMutableArray arrayWithArray:friends];
    [self.tableHandler.tableView reloadData];
    CSFriendchartlistParam * param = [CSFriendchartlistParam new];
//    param.userid = [CSUserInfo shareInstance].info.id;
//    [CSHttpRequestManager request_friendchartlist_paramters:param.mj_keyValues success:^(id responseObject) {
//        CSFriendchartlistModel * obj = [CSFriendchartlistModel mj_objectWithKeyValues:responseObject];
//        self.tableHandler.dataSource = [NSMutableArray arrayWithArray:obj.result];
//        [self.tableHandler.tableView reloadData];
//    } failure:^(NSError *error) {
//
//    } showHUD:NO];
    
    [CSHttpRequestManager request_friendRequestNum_paramters:param.mj_keyValues success:^(id responseObject) {
        CSFriendRequestNumModel * obj = [CSFriendRequestNumModel mj_objectWithKeyValues:responseObject];
        
        self.tableHandler.friendRequestNum = [obj.result.count intValue];
        [self.tableHandler.tableView reloadData];
    } failure:^(NSError *error) {
        
    } showHUD:NO];
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
        CSFriendRequestViewController * friendRequestC = [CSFriendRequestViewController new];
        [self.navigationController pushViewController:friendRequestC animated:YES];
    }
    else
    {
        CSFriendchartlistModel * friendInfo = self.tableHandler.dataSource[indexPath.row];
        
        
//        param.chat_type = 2;//客服为单聊
//        param.ID = model.userid.intValue;
        
        MBProgressHUD *hud = [LLUtils showCustomIndicatiorHUDWithTitle:@"" inView:self.tableHandler.tableView];
        [CSMsgCacheTool loadCacheMessageWithUserId:friendInfo.userid loadDatas:^(NSArray *msgs) {
            if (msgs.count) {
                [hud hideAnimated:YES afterDelay:1];
                LLChatViewController * chatC = (LLChatViewController*)[StoryBoardController storyBoardName:@"Main" ViewControllerIdentifiter:@"LLChatViewController"];
                
                CSIMConversationModel * model = [CSIMConversationModel new];
                chatC.chatType = CS_Message_Record_Type_Friend;
                model.chatId = [friendInfo userid];
                model.nickName = friendInfo.nickname;
                model.allMessageModels = [NSMutableArray arrayWithArray:msgs];
                
                chatC.conversationModel = model;
                [self.navigationController pushViewController:chatC animated:YES];
            }
            else
            {
                LLChatViewController * chatC = (LLChatViewController*)[StoryBoardController storyBoardName:@"Main" ViewControllerIdentifiter:@"LLChatViewController"];
                
                CSIMConversationModel * model = [CSIMConversationModel new];
                chatC.chatType = CS_Message_Record_Type_Friend;
                model.chatId = friendInfo.userid;
                model.nickName = friendInfo.nickname;
                
                
                chatC.conversationModel = model;
                [self.navigationController pushViewController:chatC animated:YES];
            }
        }
                                            LastId:nil count:CS_Message_Count chatType:(CS_Message_Record_Type_Friend)];
    }
}
@end
