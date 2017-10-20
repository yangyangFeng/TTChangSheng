//
//  CSBetInputToolBarView.m
//  ChangSheng
//
//  Created by 邴天宇 on 2017/10/14.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSBetInputToolBarView.h"


@interface CSBetInputToolBarView ()<UITextViewDelegate>


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
    
    self.textViewInputToolBar.layer.masksToBounds = YES;
    self.textViewInputToolBar.layer.cornerRadius = 5;
    self.textViewInputToolBar.layer.borderColor = [UIColor colorWithHexColorString:@"333333"].CGColor;
    self.textViewInputToolBar.layer.borderWidth = 1;
    
    self.textViewInputToolBar.maxNumberOfLines = 4;
    [self.textViewInputToolBar textValueDidChanged:^(NSString *text, CGFloat textHeight) {
//        CGRect frame = self.textViewInputToolBar.frame;
//        frame.size.height = textHeight;
//        self.textViewInputToolBar.frame = frame;
        [self postUpdateUIAction:textHeight];
    }];
}

- (void)postUpdateUIAction:(CGFloat)height
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateInputTextViewFrame" object:@(height)];
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
    
//    textView.frame=frame;

    DLog(@"-------------------%g----------------/n%@",frame.size.height,textView.text);

//    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateInputTextViewFrame" object:@(frame.size.height)];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        if ([_delegate respondsToSelector:@selector(cs_keyboardSendMessageText:)]) {
            [_delegate cs_keyboardSendMessageText:textView.text];
        }
        textView.text = @"";
        [self postUpdateUIAction:CS_TEXTVIEW_HEIGHT];
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
