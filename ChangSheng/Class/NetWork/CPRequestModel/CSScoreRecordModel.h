//
//  CSScoreRecordModel.h
//  ChangSheng
//
//  Created by 邴天宇 on 2017/10/18.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSHttpsResModel.h"

@interface CSScoreRecordModel : CSHttpsResModel

@property (nonatomic, strong)NSArray <CSScoreRecordModel *>* result;

@property (nonatomic,copy) NSString *create_time;
@property (nonatomic,copy) NSString *type_name;
@property (nonatomic,copy) NSString *score;
//@property (nonatomic,copy) NSString *code;
@property (nonatomic,copy) NSString *status_name;

@end
