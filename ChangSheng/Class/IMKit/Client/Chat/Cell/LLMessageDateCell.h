//
//  LLMessageDateCell.h
//  LLWeChat
//
//  Created by GYJZH on 7/21/16.
//  Copyright © 2016 GYJZH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSMessageModel.h"


@interface LLMessageDateCell : UITableViewCell

@property (nonatomic) CSMessageModel *messageModel;

+ (CGFloat)heightForModel:(CSMessageModel *)model;

@end
