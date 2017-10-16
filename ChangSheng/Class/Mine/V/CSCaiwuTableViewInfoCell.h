//
//  CSCaiwuTableViewInfoCell.h
//  ChangSheng
//
//  Created by 邴天宇 on 2017/10/16.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSCaiwuTableViewInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *upBtn;
@property (weak, nonatomic) IBOutlet UIButton *downBtn;
@property (weak, nonatomic) IBOutlet UILabel *my_fenLabel;
@property (weak, nonatomic) IBOutlet UITextField *inputField_fen;
@property (weak, nonatomic) IBOutlet UITextField *inputField_name;
@end
