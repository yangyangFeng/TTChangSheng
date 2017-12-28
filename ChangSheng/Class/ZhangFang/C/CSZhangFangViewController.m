//
//  CSZhangFangViewController.m
//  ChangSheng
//
//  Created by 邴天宇 on 2017/12/28.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSZhangFangViewController.h"
#import "CSZhuanFenViewController.h"
#import "StoryBoardController.h"
#import "CSCaiwuViewController.h"
@interface CSZhangFangViewController ()
@property (weak, nonatomic) IBOutlet UIButton *shangfenBtn;
@property (weak, nonatomic) IBOutlet UIButton *xiafenBtn;
@property (weak, nonatomic) IBOutlet UIButton *zhuanfenBtn;

@end

@implementation CSZhangFangViewController
- (IBAction)shangfenDidAction:(id)sender {
    CSCaiwuViewController * caiwuController = (CSCaiwuViewController*)[StoryBoardController viewControllerID:@"CSCaiwuViewController" SBName:@"Mine"];
    caiwuController.status = Up;
    [self.navigationController pushViewController:caiwuController animated:YES];
}
- (IBAction)xiafenDIdAction:(id)sender {
    CSCaiwuViewController * caiwuController = (CSCaiwuViewController*)[StoryBoardController viewControllerID:@"CSCaiwuViewController" SBName:@"Mine"];
    caiwuController.status = Down;
    [self.navigationController pushViewController:caiwuController animated:YES];
}
- (IBAction)zhuanfenDidAction:(id)sender {
    CSZhuanFenViewController * zhuanfenC = [CSZhuanFenViewController new];
    [self.navigationController pushViewController:zhuanfenC animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _shangfenBtn.layer.masksToBounds = YES;
    _shangfenBtn.layer.cornerRadius = 5;
    [_shangfenBtn setBackgroundImage:[UIImage yy_imageWithColor:_shangfenBtn.backgroundColor] forState:(UIControlStateNormal)];
    
    _xiafenBtn.layer.masksToBounds = YES;
    _xiafenBtn.layer.cornerRadius = 5;
     [_xiafenBtn setBackgroundImage:[UIImage yy_imageWithColor:_xiafenBtn.backgroundColor] forState:(UIControlStateNormal)];
    
    _zhuanfenBtn.layer.masksToBounds = YES;
    _zhuanfenBtn.layer.cornerRadius = 5;
     [_zhuanfenBtn setBackgroundImage:[UIImage yy_imageWithColor:_zhuanfenBtn.backgroundColor] forState:(UIControlStateNormal)];
    
    [self tt_Title:@"账房"];
    // Do any additional setup after loading the view.
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
