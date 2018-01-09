//
//  CSBetInputToolBarView.h
//  ChangSheng
//
//  Created by 邴天宇 on 2017/10/14.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSBetInputView.h"
#import "CMInputView.h"

#define CS_TEXTVIEW_HEIGHT 33

typedef enum : NSUInteger {
    CS_CurrentInputType_Bet,
    CS_CurrentInputType_Text,
} CS_CurrentInputType;

@protocol CSBetInputToolBarViewDelegate <CSBetInputViewDelegate>

@end

@interface CSBetInputToolBarView : UIView

@property (nonatomic,assign) CS_CurrentInputType currentInputType;

@property (nonatomic,weak) id<CSBetInputToolBarViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *intputChangeButton;
@property (weak, nonatomic) IBOutlet UITextField *inputField;

@property (weak, nonatomic) IBOutlet UILabel *my_fenLabel;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet CMInputView *textViewInputToolBar;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textInputToolBar_Y;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeight;

/**
 更新用户身上分
 */
- (void)upDateUserScore;
@end
