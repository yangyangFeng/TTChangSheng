//
//  CSHomeViewController.m
//  ChangSheng
//
//  Created by 邴天宇 on 17/9/26.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSHomeViewController.h"
#import "CSPublicBetViewController.h"

#import "CSHomeTableViewHandler.h"
#import "LLChatViewController.h"
#import "StoryBoardController.h"
#import "CSMsgHistoryRequestModel.h"
#import "TTSingleChatViewController.h"
#import "CSMineViewController.h"
#import "CSNumberKeyboardView.h"
#import "CSBetInputView.h"
#import "CSHttpGroupResModel.h"
#import "CSUserServiceListViewController.h"
@interface CSHomeViewController ()<TTBaseTableViewHandlerDelegate>
@property (nonatomic,strong) CSHomeTableViewHandler *tableHandler;
@property (nonatomic,strong) NSArray *betGroupArray;
@end

@implementation CSHomeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController performSelector:@selector(whiteStatusBar)];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController performSelector:@selector(blackStatusBar)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self tt_Title:@"长圣"];
//    [self tt_SetNaviBarHide:YES withAnimation:NO];
    self.edgesForExtendedLayout = UIRectEdgeNone;


    self.tt_navigationBar.contentView.backgroundColor = [UIColor blackColor];
    [self createSubviews];
    
//    CSBetInputView * topView = [CSBetInputView viewFromXIB];
//    CSNumberKeyboardView * keyboardView = [CSNumberKeyboardView new];
//    
//    [self.view addSubview:keyboardView];
//    [self.view addSubview:topView];
//    
//    [keyboardView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.mas_equalTo(0);
//        make.height.mas_equalTo(45*4);
//    }];
//    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(0);
//        make.bottom.mas_equalTo(keyboardView.mas_top).offset(0);
//        make.height.mas_equalTo(35+44*2);
//    }];
    [self loadData];
}

- (void)createSubviews
{
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectZero style:(UITableViewStylePlain)];
//    tableView.backgroundColor = [UIColor blackColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIImageView * bg_view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"主页背景"]];
    tableView.backgroundView = bg_view;
    
    _tableHandler = [[CSHomeTableViewHandler alloc]initWithTableView:tableView];
    _tableHandler.delegate = self;
    [self.view addSubview:tableView];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(0);
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.myNavigationBar.mas_bottom).offset(0);
    }];
    
    UIButton * userCenterBtn = self.tt_navigationBar.rightBtn;
    [userCenterBtn setHidden:NO];
    [userCenterBtn setImage:[UIImage imageNamed:@"个人中心"] forState:(UIControlStateNormal)];
    [userCenterBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
}

- (void)loadData
{
    [CSHttpRequestManager request_groupList_paramters:nil success:^(id responseObject) {
        CSHttpGroupResModel * obj = [CSHttpGroupResModel mj_objectWithKeyValues:responseObject];
        self.betGroupArray = obj.result;
    } failure:^(NSError *error) {
        
    } showHUD:NO];
}

- (void)tt_DefaultRightBtnClickAction
{
    DLog(@"跳转个人中心,我没做");
    CSMineViewController * mineC = [CSMineViewController new];
    [self.navigationController pushViewController:mineC animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.row) {
        case 0:
        {
            CSHttpGroupResModel * model =self.betGroupArray[0];
        }
            break;
        case 1:
        {
            CSHttpGroupResModel * model =self.betGroupArray[1];
            
            
            
            NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
            if (![user objectForKey:@"public"]) { //如果未加入该群组
                [CSHttpRequestManager request_joinGroup_paramters:@{@"group_id":@(model.id)} success:^(id responseObject) {
                    [user setObject:@(1) forKey:@"public"];
                    [self pushBetGroupControllerWithChatId:model.id];
                } failure:^(NSError *error) {
                    
                } showHUD:YES];
            }
            else
            {
                [self pushBetGroupControllerWithChatId:model.id];
            }
            
        }
            break;
        case 2:
        {
            CSUserServiceListViewController * C = [CSUserServiceListViewController new];
            [self.navigationController pushViewController:C animated:YES];
        }
            break;
        case 3:
        {
            
        }
            break;
        default:
            break;
    }
}

- (void)pushBetGroupControllerWithChatId:(int)chatId
{
    CSMsgHistoryRequestModel * param = [CSMsgHistoryRequestModel new];
    param.chat_type = 1;//客服为单聊
    param.ID = chatId;
    [MBProgressHUD tt_ShowInViewDefaultTitle:self.tableHandler.tableView];
    [CSHttpRequestManager request_chatRecord_paramters:param.mj_keyValues success:^(id responseObject) {
        CSMsgRecordModel * obj = [CSMsgRecordModel mj_objectWithKeyValues:responseObject];
        
        [MBProgressHUD tt_HideFromeView:self.tableHandler.tableView];
        //        LLChatViewController * chatC = (LLChatViewController*)[StoryBoardController storyBoardName:@"Main" ViewControllerIdentifiter:@"LLChatViewController"];
        CSPublicBetViewController * chatC = [CSPublicBetViewController new];
        CSIMConversationModel * model = [CSIMConversationModel new];
        model.chatId = [NSString stringWithFormat:@"%d",param.ID];
        model.nickName = @"大众厅";
        model.allMessageModels = [NSMutableArray array];
        
        for (CSMsgRecordModel * msgData in obj.result.data) {
            CSMessageModel * msgModel = [CSMessageModel conversionWithRecordModel:msgData chatType:param.chat_type chatId:[NSString stringWithFormat:@"%d",model.chatId]];
            
            CSIMSendMessageRequestModel * sendMsgModel = [CSIMSendMessageRequestModel new];
            sendMsgModel.body = msgModel;
            [model.allMessageModels addObject:sendMsgModel];
        }
        
        
        chatC.conversationModel = model;
        [self.navigationController pushViewController:chatC animated:YES];
    } failure:^(NSError *error) {
        [MBProgressHUD tt_HideFromeView:self.tableHandler.tableView];
    } showHUD:YES];
}
@end
