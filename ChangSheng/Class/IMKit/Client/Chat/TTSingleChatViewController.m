//
//  TTSingleChatViewController.m
//  ChangSheng
//
//  Created by cnepayzx on 2017/9/29.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "TTSingleChatViewController.h"

#import "TTChatInputToolBar.h"
@interface TTSingleChatViewController ()
@property(nonatomic,strong)TTChatInputToolBar * chatToolBar;
@end

@implementation TTSingleChatViewController
#pragma mark - Getter and Setter

- (TTChatInputToolBar *) chatToolBar
{
    if (_chatToolBar == nil) {
        _chatToolBar = [[TTChatInputToolBar alloc] initWithFrame:CGRectMake(0, HEIGHT - 49, WIDTH, 49)];
        _chatToolBar.delegate = self;
    }
    return _chatToolBar;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.chatToolBar];
    // Do any additional setup after loading the view.
}

/**
 *  输入框状态(位置)改变
 *
 *  @param chatBox    chatBox
 *  @param fromStatus 起始状态
 *  @param toStatus   目的状态
 */
- (void)chatBox:(TTChatInputToolBar *)chatBox changeStatusForm:(TTChatInputToolBarStatus)fromStatus to:(TTChatInputToolBarStatus)toStatus
{
    
}

/**
 *  发送消息
 *
 *  @param chatBox     chatBox
 *  @param textMessage 消息
 */
- (void)chatBox:(TTChatInputToolBar *)chatBox sendTextMessage:(NSString *)textMessage
{
    DLog(@"---->:%@",textMessage);
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
