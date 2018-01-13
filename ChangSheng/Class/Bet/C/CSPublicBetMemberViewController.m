//
//  CSPublicBetMemberViewController.m
//  ChangSheng
//
//  Created by 邴天宇 on 2018/1/9.
//  Copyright © 2018年 邴天宇. All rights reserved.
//

#import "CSPublicBetMemberViewController.h"
#import "CSUserListCollectionViewCell.h"
#import "CSSearchFriendManagerViewController.h"

#import "CSChatRoomInfoManager.h"

#import "CSBaseButton.h"
#import "CSUserListResponse.h"
#import "CSUserListSwitchView.h"
@interface CSPublicBetMemberViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,strong) UICollectionView * collectionView;
@end

@implementation CSPublicBetMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self tt_Title:@"用户列表"];
    
    [self initSubviews];
    
    [self loadData];
    
    // Do any additional setup after loading the view.
}

- (void)initSubviews{
    
    
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UICollectionViewFlowLayout * layout = [UICollectionViewFlowLayout new];
    layout.sectionInset =UIEdgeInsetsMake(10, 20, 20, 20);
    layout.itemSize = CGSizeMake(50, 70);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    [collectionView registerClass:[CSUserListCollectionViewCell class] forCellWithReuseIdentifier:@"CSUserListCollectionViewCell"];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    _collectionView = collectionView;
    [self.view addSubview:collectionView];
    
    
    CSUserListSwitchView * switchView = [CSUserListSwitchView new];
    switchView.switchBtn.on = [CSChatRoomInfoManager getChatGroupMute:self.group_id];
    [switchView.switchBtn addTarget:self action:@selector(switchAction:) forControlEvents:(UIControlEventValueChanged)];
    [self.view addSubview:switchView];
    
    CSBaseButton * logoutBtn = [CSBaseButton buttonWithTitle:@"删除并退出"];
    [logoutBtn addTarget:self action:@selector(gobackAction) forControlEvents:(UIControlEventTouchUpInside)];
    logoutBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [logoutBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.view addSubview:logoutBtn];
    
    [logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(45);
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(-50);
    }];
    [switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(logoutBtn.mas_top).offset(-25);
        make.height.mas_equalTo(45);
    }];
    
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(74);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(switchView.mas_top).offset(-15);
    }];
    
}

- (void)loadData
{
    [CSHttpRequestManager request_groupUserList_paramters:@{@"group_id":self.group_id} success:^(id responseObject) {
        CSUserListResponse * obj = [CSUserListResponse mj_objectWithKeyValues:responseObject];
        self.dataSource = [NSMutableArray arrayWithArray:obj.result];
        [self.collectionView reloadData];
    } failure:^(NSError *error) {
        
    } showHUD:YES];
}

- (void)switchAction:(UISwitch *)btn
{
    [CSChatRoomInfoManager setChatGroupMute:self.group_id isMute:btn.isOn];
}

- (void)gobackAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [CSChatRoomInfoManager setChatGroupMute:self.group_id isMute:YES];
}

#pragma makr - delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CSUserListCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CSUserListCollectionViewCell" forIndexPath:indexPath];
    cell.model =self.dataSource[indexPath.row];
    return  cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CSUserListResponse * model = self.dataSource[indexPath.row];
    CSSearchFriendManagerViewController * addFriendC = [CSSearchFriendManagerViewController new];
    CSFindUserParam * param = [CSFindUserParam new];
    param.id = model.user_id;
    param.avatar = model.avatar;
    param.nickname = model.nickname;
    addFriendC.userParam = param;
    [self.navigationController pushViewController:addFriendC animated:YES];
}
@end
