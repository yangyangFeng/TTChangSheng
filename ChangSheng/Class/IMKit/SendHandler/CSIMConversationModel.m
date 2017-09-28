//
//  CSIMConversationModel.m
//  ChangSheng
//
//  Created by 邴天宇 on 17/9/28.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSIMConversationModel.h"

@implementation CSIMConversationModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        _allMessageModels = [NSMutableArray array];
    }
    return self;
}
@end
