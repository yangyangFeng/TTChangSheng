//
//  TTBaseTableViewHandler.m
//  ChangSheng
//
//  Created by 邴天宇 on 17/9/26.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "TTBaseTableViewHandler.h"

@implementation TTBaseTableViewHandler
- (id)initWithTableView:(UITableView *)tableView
{
    if (self = [super init]) {
        tableView.delegate = self;
        tableView.dataSource = self;
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}
@end
