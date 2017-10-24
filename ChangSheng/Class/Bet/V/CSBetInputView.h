//
//  CSBetInputView.h
//  ChangSheng
//
//  Created by cnepayzx on 2017/10/9.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CSBetInputViewDelegate <NSObject>
- (void)cs_keyboardBetTypeName:(NSString *)typeName
                          type:(NSString *)type;

- (void)cs_keyboardBtnActionType:(int)type;

- (void)cs_keyboardHide;

- (void)cs_keyboardShow;

- (void)cs_keyboardSendMessageText:(NSString *)text;
@end

@interface CSBetInputView : UIView
@property (nonatomic,weak) id<CSBetInputViewDelegate> delegate;
@end
