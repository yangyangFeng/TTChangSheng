//
//  TTBaseTableViewHandler.h
//  ChangSheng
//
//  Created by 邴天宇 on 17/9/26.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTBaseTableViewHandler : NSObject<UITableViewDelegate,UITableViewDataSource>
- (id)initWithTableView:(UITableView *)tableView;
@end
