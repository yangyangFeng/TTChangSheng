//
//  CSMsgHistoryModel.h
//  ChangSheng
//
//  Created by cnepayzx on 2017/10/11.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSHttpsResModel.h"

@interface CSMsgHistoryModel : CSHttpsResModel

@property(nonatomic,strong)NSArray * result;

@property(nonatomic,copy)NSString * id;
@property(nonatomic,copy)NSString * nickname;
@property(nonatomic,copy)NSString * avatar;
@end
