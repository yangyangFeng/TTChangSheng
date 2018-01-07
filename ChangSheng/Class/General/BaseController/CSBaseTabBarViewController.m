//
//  CSBaseTabBarViewController.m
//  ChangSheng
//
//  Created by 邴天宇 on 2018/1/7.
//  Copyright © 2018年 邴天宇. All rights reserved.
//

#import "CSBaseTabBarViewController.h"

#import "CSIMReceiveManager.h"
#import "UITabBar+Badge.h"
@interface CSBaseTabBarViewController ()<CSIMReceiveManagerDelegate>

@end

@implementation CSBaseTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [CSIMReceiveManager shareInstance].delegate = self;
    
    [self cs_receiveUpdateUnreadMessage];
    // Do any additional setup after loading the view.
}

- (void)cs_receiveUpdateUnreadMessage
{
    int groupNums = [[CSIMReceiveManager shareInstance] getAllUnReadMessageNumberChatType:(CSChatTypeGroupChat)];
    int friendNums = [[CSIMReceiveManager shareInstance] getAllUnReadMessageNumberChatType:(CSChatTypeChatFriend)];
    int seviceNums = [[CSIMReceiveManager shareInstance] getAllUnReadMessageNumberChatType:(CSChatTypeChat)];
    [self.tabBar showBadgeOnItemIndex:0 badge:groupNums];
    [self.tabBar showBadgeOnItemIndex:1 badge:friendNums];
    [self.tabBar showBadgeOnItemIndex:2 badge:seviceNums];
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
