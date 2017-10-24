//
//  CSBetInputView.m
//  ChangSheng
//
//  Created by cnepayzx on 2017/10/9.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSBetInputView.h"

@implementation CSBetInputView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)xianDidAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(cs_keyboardBetTypeName:type:)]) {
        [_delegate cs_keyboardBetTypeName:@"闲" type:@"2"];
    }
}
- (IBAction)heDidAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(cs_keyboardBetTypeName:type:)]) {
        [_delegate cs_keyboardBetTypeName:@"和" type:@"3"];
    }
}
- (IBAction)zhuangDidAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(cs_keyboardBetTypeName:type:)]) {
        [_delegate cs_keyboardBetTypeName:@"庄" type:@"1"];
    }
}
- (IBAction)zhuangDuiDidAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(cs_keyboardBetTypeName:type:)]) {
        [_delegate cs_keyboardBetTypeName:@"庄对" type:@"4"];
    }
}
- (IBAction)xianDuiDidAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(cs_keyboardBetTypeName:type:)]) {
        [_delegate cs_keyboardBetTypeName:@"闲对" type:@"5"];
    }
}
- (IBAction)shuangDuiDidAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(cs_keyboardBetTypeName:type:)]) {
        [_delegate cs_keyboardBetTypeName:@"双对" type:@"6"];
    }
}
- (IBAction)sanBaoDidAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(cs_keyboardBetTypeName:type:)]) {
        [_delegate cs_keyboardBetTypeName:@"三宝" type:@"7"];
    }
}
- (IBAction)topDidAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(cs_keyboardBtnActionType:)]) {
        [_delegate cs_keyboardBtnActionType:1];
    }
}
- (IBAction)bottomDidAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(cs_keyboardBtnActionType:)]) {
        [_delegate cs_keyboardBtnActionType:2];
    }
}

@end
