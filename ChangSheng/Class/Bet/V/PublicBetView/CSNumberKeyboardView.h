//
//  CSNumberKeyboardView.h
//  ChangSheng
//
//  Created by cnepayzx on 2017/10/9.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CSNumberKeyboardViewDelegate <NSObject>
- (void)cs_keyboardWithNumber:(NSString *)number;
- (void)cs_keyboardWithCancle;
- (void)cs_keyboardWithDelete;
- (void)cs_keyboardWithBetAction;
@end

@interface CSNumberKeyboardView : UIView
@property (nonatomic,weak) id<CSNumberKeyboardViewDelegate> delegate;
@end
