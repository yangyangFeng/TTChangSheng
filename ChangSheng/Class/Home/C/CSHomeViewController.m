//
//  CSHomeViewController.m
//  ChangSheng
//
//  Created by 邴天宇 on 17/9/26.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSHomeViewController.h"
#import "CSPublicBetViewController.h"

#import "CSMessageRecordTool.h"

#import "CSLoginHandler.h"
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
#import "LLUtils+Popover.h"
#import "CSHomeConnectionStatusView.h"
#import "TTSocketChannelManager.h"
@interface CSHomeViewController ()<TTBaseTableViewHandlerDelegate>
@property (nonatomic,strong) CSHomeTableViewHandler *tableHandler;
@property (nonatomic,strong) NSArray *betGroupArray;
@property(nonatomic,strong)MBProgressHUD * hud;
@property(nonatomic,strong)CSHomeConnectionStatusView * connectionStatusView;
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
    
    _connectionStatusView = [CSHomeConnectionStatusView viewFromXIB];
    [self.tt_navigationBar.centerView addSubview:_connectionStatusView];
    [_connectionStatusView.indicatorView startAnimating];
    
    [_connectionStatusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self createSubviews];
    
    if ([CSUserInfo shareInstance].isOnline) {
        [CSLoginHandler openSocket];
    }
    [self loadData];
 
    [self.KVOController observe:[TTSocketChannelManager shareInstance] keyPath:@"connectionStatus" options:(NSKeyValueObservingOptionNew) block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        TTSocketChannelManager * socket = object;
        dispatch_async(dispatch_get_main_queue(), ^{
        if (socket.connectionStatus == CS_IM_Connection_Ststus_Connectioning) {
            self.connectionStatusView.indicatorView.hidden = NO;
            [self.connectionStatusView.indicatorView startAnimating];
            self.connectionStatusView.statusLabel.text = @"连接中...";
        }
        else if (socket.connectionStatus == CS_IM_Connection_Ststus_Connectioned) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.connectionStatusView.indicatorView.hidden = YES;
                [self.connectionStatusView.indicatorView stopAnimating];
                self.connectionStatusView.statusLabel.text = @"长圣";
            });
        }
        else
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.connectionStatusView.indicatorView.hidden = YES;
                [self.connectionStatusView.indicatorView stopAnimating];
                self.connectionStatusView.statusLabel.text = @"未连接";
            });
        }
        });
    }];
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
    [userCenterBtn sizeToFit];
}

- (void)loadData
{

    
    [CSHttpRequestManager request_groupList_paramters:nil success:^(id responseObject) {
        CSHttpGroupResModel * obj = [CSHttpGroupResModel mj_objectWithKeyValues:responseObject];
        self.betGroupArray = obj.result;
        self.tableHandler.betGroupArray = self.betGroupArray;
        
    } failure:^(NSError *error) {
        
    } showHUD:NO];
}

- (void)tt_DefaultRightBtnClickAction
{
    DLog(@"跳转个人中心,我没做");
//    UIView *view;
//    view.clipsToBounds
    CSMineViewController * mineC = [CSMineViewController new];
    [self.navigationController pushViewController:mineC animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.row) {
        case 0:
        {
            CSHttpGroupResModel * model =self.betGroupArray[0];
            NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
            NSString * key = [NSString stringWithFormat:@"vip%@",[CSUserInfo shareInstance].info.code];
            if (![user objectForKey:key]) { //如果未加入该群组
                [CSHttpRequestManager request_joinGroup_paramters:@{@"group_id":@(model.id)} success:^(id responseObject) {
                    [user setObject:@(1) forKey:key];
                    [self pushBetGroupControllerWithChatId:model.id index:0];
                } failure:^(NSError *error) {
                    
                } showHUD:YES];
            }
            else
            {
                [self pushBetGroupControllerWithChatId:model.id index:0];
            }
        }
            break;
        case 1:
        {
            CSHttpGroupResModel * model =self.betGroupArray[1];
            
            
            NSString * key = [NSString stringWithFormat:@"public%@",[CSUserInfo shareInstance].info.code];
            NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
            if (![user objectForKey:key]) { //如果未加入该群组
                [CSHttpRequestManager request_joinGroup_paramters:@{@"group_id":@(model.id)} success:^(id responseObject) {
                    [user setObject:@(1) forKey:key];
                    [self pushBetGroupControllerWithChatId:model.id index:1];
                } failure:^(NSError *error) {
                    
                } showHUD:YES];
            }
            else
            {
                [self pushBetGroupControllerWithChatId:model.id index:1];
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
            UIViewController * caiwuController = [StoryBoardController viewControllerID:@"CSCaiwuViewController" SBName:@"Mine"];
            [self.navigationController pushViewController:caiwuController animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)pushBetGroupControllerWithChatId:(int)chatId index:(int)index
{
    CSMsgHistoryRequestModel * param = [CSMsgHistoryRequestModel new];
    param.chat_type = 1;//1为群聊
    param.ID = chatId;
//    [MBProgressHUD tt_ShowInViewDefaultTitle:self.tableHandler.tableView];
    MBProgressHUD *hud = [LLUtils showCustomIndicatiorHUDWithTitle:@"" inView:self.tableHandler.tableView];
    [CSHttpRequestManager request_chatRecord_paramters:param.mj_keyValues success:^(id responseObject) {
        CSMsgRecordModel * obj = [CSMsgRecordModel mj_objectWithKeyValues:responseObject];
        
        [hud hideAnimated:YES];
//        [MBProgressHUD tt_HideFromeView:self.tableHandler.tableView];
        //        LLChatViewController * chatC = (LLChatViewController*)[StoryBoardController storyBoardName:@"Main" ViewControllerIdentifiter:@"LLChatViewController"];
        CSPublicBetViewController * chatC = [CSPublicBetViewController new];
        CSIMConversationModel * model = [CSIMConversationModel new];
        model.group_tips = obj.result.group_tips;
        
        model.chatId = [NSString stringWithFormat:@"%d",param.ID];
        model.nickName = index ? @"大众厅" : @"VIP厅";
        model.allMessageModels = [NSMutableArray array];
        
        for (CSMsgRecordModel * msgData in obj.result.data) {
            CSMessageModel * msgModel = [CSMessageModel conversionWithRecordModel:msgData chatType:param.chat_type chatId:[NSString stringWithFormat:@"%d",model.chatId]];
            
//            CSIMSendMessageRequestModel * sendMsgModel = [CSIMSendMessageRequestModel new];
//            sendMsgModel.body = msgModel;
            [model.allMessageModels addObject:msgModel];
        }
        
        
        chatC.conversationModel = model;
        [self.navigationController pushViewController:chatC animated:YES];
    } failure:^(NSError *error) {
        [hud hideAnimated:YES];
    } showHUD:YES];
}
@end
