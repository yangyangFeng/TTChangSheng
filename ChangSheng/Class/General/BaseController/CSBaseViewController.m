//
//  CSBaseViewController.m
//  ChangSheng
//
//  Created by 邴天宇 on 17/9/24.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSBaseViewController.h"

@interface CSBaseViewController ()

@end

@implementation CSBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self tt_SetNaviBarHide:NO withAnimation:NO];
    
    self.tt_navigationBar.contentView.backgroundColor = [UIColor whiteColor];
    self.tt_navigationBar.titleLabel.textColor = [UIColor colorWithHexColorString:@"333333"];
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
