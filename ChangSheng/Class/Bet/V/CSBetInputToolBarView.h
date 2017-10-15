//
//  CSBetInputToolBarView.h
//  ChangSheng
//
//  Created by 邴天宇 on 2017/10/14.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSBetInputView.h"
@protocol CSBetInputToolBarViewDelegate <CSBetInputViewDelegate>

@end

@interface CSBetInputToolBarView : UIView

@property (nonatomic,weak) id<CSBetInputToolBarViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *intputChangeButton;
@property (weak, nonatomic) IBOutlet UITextField *inputField;

@property (weak, nonatomic) IBOutlet UILabel *my_fenLabel;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UITextView *textViewInputToolBar;

@property (weak, nonatomic) IBOutlet UIStackView *textInputToolBar;
@property (weak, nonatomic) IBOutlet UIButton *biaoqingBtn;
@property (weak, nonatomic) IBOutlet UIButton *otherBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textInputToolBar_Y;
@end
