//
//  CSZFShangXiaFenViewController.m
//  ChangSheng
//
//  Created by cnepayzx on 2017/12/3.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSZFShangXiaFenViewController.h"

@interface CSZFShangXiaFenViewController ()
@property (weak, nonatomic) IBOutlet UILabel *shenshangfen;
@property (weak, nonatomic) IBOutlet UILabel *daishenhe;
@property (weak, nonatomic) IBOutlet UIButton *shangfenBtn;
@property (weak, nonatomic) IBOutlet UIButton *xiafenBtn;

@end

@implementation CSZFShangXiaFenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self tt_Title:@"上下分"];
    
    self.shangfenBtn.layer.masksToBounds = YES;
    self.shangfenBtn.layer.cornerRadius = 22;
    
    self.xiafenBtn.layer.masksToBounds = YES;
    self.xiafenBtn.layer.cornerRadius = 22;
    
    [self.shangfenBtn setBackgroundImage:[UIImage yy_imageWithColor:[UIColor colorWithHexColorString:@"24BC7F"]] forState:(UIControlStateNormal)];
    [self.xiafenBtn setBackgroundImage:[UIImage yy_imageWithColor:[UIColor colorWithHexColorString:@"24BC7F"]] forState:(UIControlStateNormal)];
    // Do any additional setup after loading the view.
}

- (IBAction)shangfenDIdAction:(id)sender {
    
}


- (IBAction)xiafenDidAction:(id)sender {
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
