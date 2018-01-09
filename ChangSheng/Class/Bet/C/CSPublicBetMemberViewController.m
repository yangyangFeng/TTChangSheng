//
//  CSPublicBetMemberViewController.m
//  ChangSheng
//
//  Created by 邴天宇 on 2018/1/9.
//  Copyright © 2018年 邴天宇. All rights reserved.
//

#import "CSPublicBetMemberViewController.h"
#import "CSUserListCollectionViewCell.h"

#import "CSUserListResponse.h"
@interface CSPublicBetMemberViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,strong) UICollectionView * collectionView;
@end

@implementation CSPublicBetMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSubviews];
    
    [self loadData];
    
    // Do any additional setup after loading the view.
}

- (void)initSubviews{
    UICollectionViewFlowLayout * layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(50, 70);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    [collectionView registerClass:[CSUserListCollectionViewCell class] forCellWithReuseIdentifier:@"CSUserListCollectionViewCell"];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    _collectionView = collectionView;
    [self.view addSubview:collectionView];
    
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(74);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(405);
    }];
    
}

- (void)loadData
{
    [CSHttpRequestManager request_groupUserList_paramters:@{@"group_id":@"1"} success:^(id responseObject) {
        CSUserListResponse * obj = [CSUserListResponse mj_objectWithKeyValues:responseObject];
        self.dataSource = [NSMutableArray arrayWithArray:obj.result];
        [self.collectionView reloadData];
    } failure:^(NSError *error) {
        
    } showHUD:YES];
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

@end
