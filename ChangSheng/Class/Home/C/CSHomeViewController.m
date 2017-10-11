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
#import "TTSingleChatViewController.h"
#import "CSMineViewController.h"
#import "CSNumberKeyboardView.h"
#import "CSBetInputView.h"
#import "CSUserServiceListViewController.h"
@interface CSHomeViewController ()<TTBaseTableViewHandlerDelegate>
@property (nonatomic,strong) CSHomeTableViewHandler *tableHandler;
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
            
        }
            break;
        case 1:
        {
            
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


@end
