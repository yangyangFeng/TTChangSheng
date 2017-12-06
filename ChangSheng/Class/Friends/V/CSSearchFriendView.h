//
//  CSSearchFriendView.h
//  ChangSheng
//
//  Created by cnepayzx on 2017/12/3.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol CSSearchFriendViewDelegate <NSObject>
- (void)searchBarDidSearch:(NSString *)text;
@end

@interface CSSearchFriendView : UIView
@property(nonatomic,weak) id <CSSearchFriendViewDelegate> delegate;

@end
