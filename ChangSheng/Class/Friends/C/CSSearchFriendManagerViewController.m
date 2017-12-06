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
@interface CSSearchFriendManagerViewController ()

@end

@implementation CSSearchFriendManagerViewController
-(void)loadView
{
    UIScrollView * scrollView = [UIScrollView new];
    scrollView.contentSize = CGSizeMake(WIDTH * 3, 0);
//    scrollView.bouncesZoom = YES;
    scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.view = scrollView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self tt_Title:@"添加好友"];
    
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
    
    resultC.view.x = WIDTH * 1;
    sendVerifyC.view.x = WIDTH * 2;
    searchC.view.width = self.view.width;
    resultC.view.width = self.view.width;
    sendVerifyC.view.width = self.view.width;
    
    [self.view addSubview:searchC.view];
    [self.view addSubview:resultC.view];
    [self.view addSubview:sendVerifyC.view];
    
    [searchC setCallblock:^(id obj) {
        UIScrollView * scrollView = (UIScrollView*)self.view;
        [UIView animateWithDuration:0.15 animations:^{
            scrollView.contentOffset = CGPointMake(WIDTH, 0);
        }];
    }];
    
    [resultC setCallblock:^(id obj) {
        [self tt_Title:@"详细资料"];
        UIScrollView * scrollView = (UIScrollView*)self.view;
        [UIView animateWithDuration:0.15 animations:^{
            scrollView.contentOffset = CGPointMake(WIDTH * 2, 0);
        }];
    }];
    
    [sendVerifyC setCallblock:^(id obj) {
        [self.navigationController popViewControllerAnimated:YES];
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
