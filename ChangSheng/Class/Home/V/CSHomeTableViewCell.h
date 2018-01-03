//
//  CSHomeTableViewCell.h
//  ChangSheng
//
//  Created by 邴天宇 on 17/9/26.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTSubscriptLabel.h"
@interface CSHomeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet TTSubscriptLabel *unReadNumber;
@property (weak, nonatomic) IBOutlet UILabel *cs_title;

@end
