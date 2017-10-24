//
//  CSUploadFenRequestModel.h
//  ChangSheng
//
//  Created by 邴天宇 on 2017/10/16.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSBaseRequestModel.h"

@interface CSUploadFenRequestModel : CSBaseRequestModel
@property(nonatomic,copy)NSString * msg;
@property (nonatomic, assign)int type;
@property (nonatomic, assign)int score;
@property (nonatomic,copy) NSString *truename;
@property (nonatomic,copy) NSString *bank_card;
//汇款凭据图片（下分
@property (nonatomic,copy) NSString *pod;

@property(nonatomic,strong)CSUploadFenRequestModel * result;
@property (nonatomic,copy) NSString *surplus_score;
@end
