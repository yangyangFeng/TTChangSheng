//
//  CSHttpGroupResModel.h
//  ChangSheng
//
//  Created by 邴天宇 on 17/9/27.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSHttpsResModel.h"

@interface CSHttpGroupResModel : CSHttpsResModel
@property (nonatomic, strong)NSArray * result;

@property (nonatomic,assign) int id;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,assign) int type;
@property (nonatomic,copy) NSString *img_url;
@property (nonatomic,assign) int people_num;
@property (nonatomic,assign) int is_join;

@end
