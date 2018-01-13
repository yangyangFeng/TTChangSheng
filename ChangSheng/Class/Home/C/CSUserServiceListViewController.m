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

#import "CSIMReceiveManager.h"
#import "LLUtils+Popover.h"

#import "CSMessageRecordTool.h"
static CSUserServiceListViewController * controller = nil;

@interface CSUserServiceListViewController ()<UITableViewDelegate,UITableViewDataSource,CSIMReceiveManagerDelegate>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataSource;
@end

@implementation CSUserServiceListViewController


//+ (void)load
//{
//    [super load];
//    [CSUserServiceListViewController new];
//}
- (void)loadView
{
    [super loadView];
    
}

+ (id)shareInstance
{
    controller = [[CSUserServiceListViewController alloc]init];
    return controller;
}

+ (void)clear
{
    controller = [[CSUserServiceListViewController alloc]init];
}

+(instancetype)new
{
    return [self shareInstance];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.dataSource.count) {
        [self loadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    
    [self createSubviews];
    
    [self.tt_navigationBar.contentView setBackgroundColor:[UIColor whiteColor]];
    
    self.tt_navigationBar.titleLabel.textColor = [UIColor colorWithHexColorString:@"333333"];
    
    self.view.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    
    [self tt_Title:@"客服列表"];
    
    [CSIMReceiveManager shareInstance].delegate = self;
    // Do any additional setup after loading the view.
}

- (void)cs_receiveUpdateUnreadMessage
{
    [self updateUnreadMessageRefreshUI];
}

- (void)updateUnreadMessageRefreshUI
{
    for (int i =0; i<self.dataSource.count; i++) {
        CSMsgHistoryModel * model = [self.dataSource objectAtIndex:i];
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        CSUserTableViewCell * cell = (CSUserTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        int count = [[CSIMReceiveManager shareInstance] getUnReadMessageNumberChatType:(CSChatTypeChat) chatId:model.id];
        cell.unReadNumber.text = [NSString stringWithFormat:@"%d",count];
    }
}

-(void)dealloc
{
    [[CSIMReceiveManager shareInstance] removeDelegate:self];
}

- (void)loadData
{

    MBProgressHUD * hud = [LLUtils showCustomIndicatiorHUDWithTitle:@"" inView:self.view];
    [CSHttpRequestManager request_helperList_paramters:nil success:^(id responseObject) {
        CSMsgHistoryModel * obj = [CSMsgHistoryModel mj_objectWithKeyValues:responseObject];
        self.dataSource = [NSMutableArray arrayWithArray:obj.result];
        [self.tableView reloadData];
//        [MBProgressHUD tt_HideFromeView:self.view];
        [hud hideAnimated:YES afterDelay:1];
        [self updateUnreadMessageRefreshUI];
    } failure:^(NSError *error) {
        [hud hideAnimated:YES afterDelay:1];
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
//    cell.model = model;
     [cell.userIcon yy_setImageWithURL:[NSURL URLWithString:model.avatar] placeholder:[UIImage imageNamed:@"聊天自定义头像"]];
    cell.userName.text = model.nickname;
    if (model.is_online) {//如果客服在线
        cell.isOnlineLabel.text = @"在线";
        cell.isOnlineLabel.textColor = [UIColor colorWithHexColorString:@"333333"];
    }
    else
    {
        cell.isOnlineLabel.text = @"离线";
        cell.isOnlineLabel.textColor = [UIColor colorWithHexColorString:@"666666"];
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CSMsgHistoryModel * userServiceModel = self.dataSource[indexPath.row];
    CSMsgHistoryRequestModel * param = [CSMsgHistoryRequestModel new];
    param.chat_type = 2;//客服为单聊
    param.ID = userServiceModel.id.intValue;
    
    MBProgressHUD *hud = [LLUtils showCustomIndicatiorHUDWithTitle:@"" inView:self.tableView];
    [CSMsgCacheTool loadCacheMessageWithUserId:userServiceModel.id loadDatas:^(NSArray *msgs) {
        if (msgs.count) {
            
            LLChatViewController * chatC = (LLChatViewController*)[StoryBoardController storyBoardName:@"Main" ViewControllerIdentifiter:@"LLChatViewController"];
            chatC.chatType = CS_Message_Record_Type_Service;
            CSIMConversationModel * model = [CSIMConversationModel new];
            model.chatId = [userServiceModel id];
            model.avatarImageURL = userServiceModel.avatar;
            model.nickName = userServiceModel.nickname;
            model.allMessageModels = [NSMutableArray arrayWithArray:msgs];
            
            chatC.conversationModel = model;
//            [self.navigationController pushViewController:chatC animated:YES];
            [LLChatViewController joinStatus:^(NSError * _Nonnull error) {
                if (!error) {
                    [self.navigationController pushViewController:chatC animated:YES];
                }
                [hud hideAnimated:YES afterDelay:1];
            } chatId:model.chatId chatType:CS_Message_Record_Type_Service];
        }
        else
        {
            [CSHttpRequestManager request_chatRecord_paramters:param.mj_keyValues success:^(id responseObject) {
                CSMsgRecordModel * obj = [CSMsgRecordModel mj_objectWithKeyValues:responseObject];
                
                
                LLChatViewController * chatC = (LLChatViewController*)[StoryBoardController storyBoardName:@"Main" ViewControllerIdentifiter:@"LLChatViewController"];
                chatC.chatType = CS_Message_Record_Type_Service;
                CSIMConversationModel * model = [CSIMConversationModel new];
                model.chatId = [userServiceModel id];
                model.nickName = userServiceModel.nickname;
                model.allMessageModels = [NSMutableArray array];
                
                for (CSMsgRecordModel * msgData in obj.result.data) {
                    CSMessageModel * msgModel = [CSMessageModel conversionWithRecordModel:msgData chatType:param.chat_type chatId:userServiceModel.id];
                    
                    //            CSIMSendMessageRequestModel * sendMsgModel = [CSIMSendMessageRequestModel new];
                    //            sendMsgModel.body = msgModel;
                    [model.allMessageModels addObject:msgModel];
                }
                
                
                chatC.conversationModel = model;
                [LLChatViewController joinStatus:^(NSError * _Nonnull error) {
                    if (!error) {
                        
                        CSCacheUserInfo * userInfo = [CSCacheUserInfo new];
                        
                        userInfo.userId = model.chatId;
                        userInfo.avatar = model.avatarImageURL;
                        userInfo.nickname = model.nickName;
                        
                        [CSMsgCacheTool cs_cacheMessages:model.allMessageModels userInfo:userInfo addLast:YES chatType:CS_Message_Record_Type_Service];
                        
                        [self.navigationController pushViewController:chatC animated:YES];
                    }
                    [hud hideAnimated:YES afterDelay:1];
                } chatId:model.chatId chatType:CS_Message_Record_Type_Service];
               
            } failure:^(NSError *error) {
                [hud hideAnimated:YES afterDelay:1];
            } showHUD:YES];
        }
    }
     LastId:nil count:CS_Message_Count chatType:(CS_Message_Record_Type_Service)];
    
    
    
}
- (CSCacheUserInfo *)chatUserInfo
{
    CSCacheUserInfo * userInfo = [CSCacheUserInfo new];
    
//    userInfo.userId = self.conversationModel.chatId;
//    userInfo.avatar = self.conversationModel.avatarImageURL;
    return  userInfo;
}
@end
