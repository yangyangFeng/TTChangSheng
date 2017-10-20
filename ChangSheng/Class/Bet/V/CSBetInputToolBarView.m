//
//  CSBetInputToolBarView.m
//  ChangSheng
//
//  Created by 邴天宇 on 2017/10/14.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSBetInputToolBarView.h"

typedef enum : NSUInteger {
    CS_CurrentInputType_Bet,
    CS_CurrentInputType_Text,
} CS_CurrentInputType;

@interface CSBetInputToolBarView ()<UITextViewDelegate>
@property (nonatomic,assign) CS_CurrentInputType currentInputType;
@end
@implementation CSBetInputToolBarView

-(void)awakeFromNib
{
    [super awakeFromNib];
    _currentInputType = CS_CurrentInputType_Bet;
    self.textInputToolBar_Y.constant = 0;
    
//    self.my_fenLabel.hidden = NO;
//    self.inputField.hidden = NO;
//    self.rightButton.hidden = NO;
    
//    self.textInputField.hidden = YES;
//    self.biaoqingBtn.hidden = YES;
//    self.otherBtn.hidden = YES;
    
    self.textViewInputToolBar.alpha = 0;
    self.biaoqingBtn.alpha = 0;
    self.otherBtn.alpha = 0;
    _my_fenLabel.text = [NSString stringWithFormat:@"身上分:%d",[CSUserInfo shareInstance].info.surplus_score];
}

- (void)upDateUserScore
{
    _my_fenLabel.text = [NSString stringWithFormat:@"身上分:%d",[CSUserInfo shareInstance].info.surplus_score];
}

- (IBAction)inputChangeDidAction:(id)sender {
    switch (_currentInputType) {
        case CS_CurrentInputType_Bet:
        {
            [self.textViewInputToolBar becomeFirstResponder];
            self.currentInputType = CS_CurrentInputType_Text;
           
            [UIView animateWithDuration:0.2 animations:^{
                self.my_fenLabel.alpha = 0;
                self.inputField.alpha = 0;
                self.rightButton.alpha = 0;
                
                
                
                self.textViewInputToolBar.alpha = 1;
                self.biaoqingBtn.alpha = 1;
                self.otherBtn.alpha = 1;
            }];
            
            [self.intputChangeButton setImage:[UIImage imageNamed:@"投"] forState:(UIControlStateNormal)];
            
            
            if ([_delegate respondsToSelector:@selector(cs_keyboardHide)]) {
                [_delegate cs_keyboardHide];
            }
            
        }
            break;
        case CS_CurrentInputType_Text:
        {
//            [UIView animateWithDuration:0.2 animations:^{
//                self.textInputToolBar_Y.constant = 50;
//                [self layoutIfNeeded];
//            }completion:^(BOOL finished) {
//                self.currentInputType = CS_CurrentInputType_Bet;
//            }];
            [self.textViewInputToolBar resignFirstResponder];
            
            self.currentInputType = CS_CurrentInputType_Bet;
//            self.my_fenLabel.hidden = NO;
//            self.inputField.hidden = NO;
//            self.rightButton.hidden = NO;
//
//            self.textInputField.hidden = YES;
//            self.biaoqingBtn.hidden = YES;
//            self.otherBtn.hidden = YES;
            [UIView animateWithDuration:0.2 animations:^{
                self.my_fenLabel.alpha = 1;
                self.inputField.alpha = 1;
                self.rightButton.alpha = 1;
                
                
                
                self.textViewInputToolBar.alpha = 0;
                self.biaoqingBtn.alpha = 0;
                self.otherBtn.alpha = 0;
            }];
            
            
            
            [self.intputChangeButton setImage:[UIImage imageNamed:@"聊"] forState:(UIControlStateNormal)];
            
            if ([_delegate respondsToSelector:@selector(cs_keyboardShow)]) {
                [_delegate cs_keyboardShow];
            }
        }
            break;
        default:
            break;
    }
}
- (IBAction)rightButtonDidAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(cs_keyboardBtnActionType:)]) {
        [_delegate cs_keyboardBtnActionType:0];
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    CGSize size=[textView sizeThatFits:CGSizeMake(CGRectGetWidth(textView.frame), MAXFLOAT)];
    
    CGRect frame=textView.frame;
    
    frame.size.height=size.height;
    
    textView.frame=frame;

    

    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        if ([_delegate respondsToSelector:@selector(cs_keyboardSendMessageText:)]) {
            [_delegate cs_keyboardSendMessageText:textView.text];
        }
        return NO;
    }
    return YES;
}
 - (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    
    
    
    return YES;
    
    
    
}
@end
