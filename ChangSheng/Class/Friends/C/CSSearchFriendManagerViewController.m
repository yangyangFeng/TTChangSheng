//
//  CSSearchFriendManagerViewController.m
//  ChangSheng
//
//  Created by cnepayzx on 2017/12/3.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSSearchFriendManagerViewController.h"

#import "CSSearchFriendViewController.h"
#import "CSSearchFriendResultViewController.h"
#import "CSSearchFriendSendVerifyViewController.h"

#import "CSFindUserParam.h"
@interface CSSearchFriendManagerViewController ()
@property (nonatomic,strong) UIScrollView *scrollView;
@end

@implementation CSSearchFriendManagerViewController
//-(void)loadView
//{
//    UIScrollView * scrollView = [UIScrollView new];
//    scrollView.contentSize = CGSizeMake(WIDTH * 3, 0);
////    scrollView.bouncesZoom = YES;
//    scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
//
//    self.view = scrollView;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self tt_Title:@"添加好友"];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.contentSize = CGSizeMake(WIDTH * 3, 0);
    _scrollView.bouncesZoom = YES;
    _scrollView.scrollEnabled = NO;
    _scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_scrollView];

    // Do any additional setup after loading the view.
    [self initSubControllers];
}

- (void)initSubControllers
{
    CSSearchFriendViewController * searchC = [CSSearchFriendViewController new];
    CSSearchFriendResultViewController * resultC = [CSSearchFriendResultViewController new];
    CSSearchFriendSendVerifyViewController * sendVerifyC = [CSSearchFriendSendVerifyViewController new];
    
    [self addChildViewController:searchC];
    [self addChildViewController:resultC];
    [self addChildViewController:sendVerifyC];
//    resultC.view.x = WIDTH * 1;
//    sendVerifyC.view.x = WIDTH * 2;
//    searchC.view.width = self.view.width;
//    resultC.view.width = self.view.width;
//    sendVerifyC.view.width = self.view.width;

    
    [self.scrollView addSubview:searchC.view];
    [self.scrollView addSubview:resultC.view];
    [self.scrollView addSubview:sendVerifyC.view];
    
        searchC.view.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
        resultC.view.frame = CGRectMake(WIDTH, 0, WIDTH, HEIGHT);
        sendVerifyC.view.frame = CGRectMake(WIDTH*2, 0, WIDTH, HEIGHT);
    
    [searchC setCallblock:^(id obj) {
        
        [UIView animateWithDuration:0.15 animations:^{
            self.scrollView.contentOffset = CGPointMake(WIDTH, 0);
        }];
        [resultC setModel:obj];
    }];
    
    [resultC setCallblock:^(id obj) {
        sendVerifyC.userId = obj;
        [self tt_Title:@"详细资料"];
        
        [UIView animateWithDuration:0.15 animations:^{
            self.scrollView.contentOffset = CGPointMake(WIDTH * 2, 0);
        }];
    }];
    
    [sendVerifyC setCallblock:^(id obj) {
        self.scrollView.contentOffset = CGPointMake(WIDTH, 0);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
