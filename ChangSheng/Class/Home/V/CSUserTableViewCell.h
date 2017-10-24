//
//  CSUserTableViewCell.h
//  ChangSheng
//
//  Created by cnepayzx on 2017/10/11.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTSubscriptLabel.h"
#import "CSMsgHistoryModel.h"
@interface CSUserTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet TTSubscriptLabel *unReadNumber;

@property (nonatomic,strong) CSMsgHistoryModel *model;
@end
