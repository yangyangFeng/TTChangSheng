//
//  UITableView+TTNoDataView.h
//  GoPlay
//
//  Created by 邴天宇 on 20/4/16.
//  Copyright © 2016年 邴天宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (TTNoDataView)
- (void)tt_checkNoDataViewTitleInFooter:(NSString *)title withDataCount:(NSInteger )count;
- (void)tt_checkNoDataViewTitleInFooter:(NSString *)title withDataCount:(NSInteger )count height:(CGFloat)height;
@end
