//
//  CSAddressBookViewController.m
//  ChangSheng
//
//  Created by cnepayzx on 2017/12/1.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSAddressBookViewController.h"

#import "CSAddressBookTableViewCell.h"

#import "CSBaseRequestModel.h"
#import "CSFriendListModel.h"
@interface CSAddressBookViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *dataSource;
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation CSAddressBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self tt_Title:@"通讯录"];
    
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    tableView.allowsSelectionDuringEditing = YES;
    tableView.tintColor = CS_TextColor;
    tableView.tableFooterView = [UIView new];
    tableView.sectionIndexColor = CS_TextColor;
    
    tableView.dataSource = self;
    tableView.delegate = self;
    
    [self.view addSubview:tableView];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NavStateBar);
        make.left.right.bottom.mas_equalTo(0);
    }];
    self.tableView = tableView;
    [self loadData];
    // Do any additional setup after loading the view.
}

- (void)loadData
{
    CSBaseRequestModel * param = [CSBaseRequestModel new];

    [CSHttpRequestManager request_friendList_paramters:param.mj_keyValues success:^(id responseObject) {
        CSFriendListModel * obj = [CSFriendListModel mj_objectWithKeyValues:responseObject];
        NSMutableArray * array = [NSMutableArray array];
        for (CSFriendListModel * model in obj.result) {
            if (model.friends.count) {
                [array addObject:model.letter];
            }
        }
        self.dataSource = array;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    } showHUD:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    CSFriendListModel * model = self.dataSource[section];
    
    return model.result.count;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CSAddressBookTableViewCell *cell = [CSAddressBookTableViewCell cellWithTableView:tableView];
    CSFriendListModel * model = self.dataSource[indexPath.section];
    CSFriendListItemModel * item = model.friends[indexPath.row];
    [cell.userIcon yy_setImageWithURL:[NSURL URLWithString:item.avatar] options:(YYWebImageOptionSetImageWithFadeAnimation)];
    cell.userName.text = item.nickname;
    return cell;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray * array = [NSMutableArray array];
    for (CSFriendListModel * model in self.dataSource) {
        
            [array addObject:model.letter];
        
    }
    return array;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSMutableArray * array = [NSMutableArray array];
    for (CSFriendListModel * model in self.dataSource) {
        
            [array addObject:model.letter];
        
    }
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 0, 0)];
    label.textColor = CS_TextColor;
    label.font = [UIFont systemFontOfSize:15];
    NSString * str = [array objectAtIndex:section];
    label.text = [NSString stringWithFormat:@"    %@",str];
    return label;
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSLog(@"===%@  ===%d",title,index);
    
    //点击索引，列表跳转到对应索引的行
    
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:(UITableViewScrollPositionBottom) animated:YES];
//    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    //弹出首字母提示
    
    //[self showLetter:title ];
    return 1;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        DLog(@"删除cell");
    }
}

@end
