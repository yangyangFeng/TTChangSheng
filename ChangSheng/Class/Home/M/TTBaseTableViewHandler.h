//
//  TTBaseTableViewHandler.h
//  ChangSheng
//
//  Created by 邴天宇 on 17/9/26.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol TTBaseTableViewHandlerDelegate <NSObject>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
@interface TTBaseTableViewHandler : NSObject<UITableViewDelegate,UITableViewDataSource>

- (id)initWithTableView:(UITableView *)tableView;
@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,weak) id<TTBaseTableViewHandlerDelegate> delegate;
@end
