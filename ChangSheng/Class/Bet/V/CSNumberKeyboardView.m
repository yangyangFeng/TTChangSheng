//
//  CSNumberKeyboardView.m
//  ChangSheng
//
//  Created by cnepayzx on 2017/10/9.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSNumberKeyboardView.h"
#import "CSCustomNumberButton.h"
#define BTN_TAG_FLAG 999

@interface CSNumberKeyboardView ()
@property (nonatomic,copy) NSMutableString *number_string;
@end

@implementation CSNumberKeyboardView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _number_string = [NSMutableString string];
        UIColor * lineColor = rgb(170, 170, 170);
        
        CSCustomNumberButton * delBtn = [CSCustomNumberButton buttonWithType:(UIButtonTypeCustom)];
        [delBtn setImage:[UIImage imageNamed:@"Remove.png"] forState:(UIControlStateNormal)];
        [delBtn addTarget:self action:@selector(deleteDidAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:delBtn];
        [delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.mas_equalTo(0);
            make.height.mas_equalTo(45);
            make.width.mas_equalTo(WIDTH/4.0);
        }];
        
        CSCustomNumberButton * betBtn = [CSCustomNumberButton buttonWithType:(UIButtonTypeCustom)];
        [betBtn setTitle:@"下注" forState:(UIControlStateNormal)];
        [betBtn.titleLabel setFont:[UIFont systemFontOfSize:20]];
        [betBtn addTarget:self action:@selector(betDidAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:betBtn];
        [betBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(delBtn.mas_bottom).offset(0);
            make.height.mas_equalTo(45*2);
            make.width.mas_equalTo(WIDTH/4.0);
        }];
        
        CSCustomNumberButton * cancleBtn = [CSCustomNumberButton buttonWithType:(UIButtonTypeCustom)];
        [cancleBtn setTitle:@"撤销" forState:(UIControlStateNormal)];
        [cancleBtn.titleLabel setFont:[UIFont systemFontOfSize:20]];
        [cancleBtn addTarget:self action:@selector(cancleDidAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:cancleBtn];
        [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(45*2);
            make.width.mas_equalTo(WIDTH/4.0);
        }];
        
        for (int i = 0; i < 15; i++) {
//            i-=3;
            int j = i-3;
            CSCustomNumberButton * btn = [CSCustomNumberButton buttonWithType:(UIButtonTypeCustom)];
            if (i == 1) {
                [btn setTitle:@"梭" forState:(UIControlStateNormal)];
                btn.tag = BTN_TAG_FLAG + 10 * i;
                [btn addTarget:self action:@selector(btnDidAction:) forControlEvents:(UIControlEventTouchUpInside)];
            }
            else if(i == 2){
                [btn setTitle:@"改" forState:(UIControlStateNormal)];
                btn.tag = BTN_TAG_FLAG + 10 * i;
                [btn addTarget:self action:@selector(btnDidAction:) forControlEvents:(UIControlEventTouchUpInside)];
            }
            else if (j == 9 || i == 0) {
                btn.enabled = NO;
            }
            else if (j == 10)
            {
                [btn setTitle:[NSString stringWithFormat:@"%d",0] forState:(UIControlStateNormal)];
                btn.tag = BTN_TAG_FLAG ;
                [btn addTarget:self action:@selector(btnDidAction:) forControlEvents:(UIControlEventTouchUpInside)];
            }
            else if (j == 11)
            {
                [btn setTitle:@"00" forState:(UIControlStateNormal)];
                btn.titleLabel.font = [UIFont systemFontOfSize:20];
                btn.tag = BTN_TAG_FLAG + 100 ;
                [btn addTarget:self action:@selector(btnDidAction:) forControlEvents:(UIControlEventTouchUpInside)];
            }
            else
            {
                [btn setTitle:[NSString stringWithFormat:@"%d",(j+1)] forState:(UIControlStateNormal)];
                btn.tag = BTN_TAG_FLAG + j + 1;
                [btn addTarget:self action:@selector(btnDidAction:) forControlEvents:(UIControlEventTouchUpInside)];
            }
            [self addSubview:btn];
            
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(45 * (i/3));
                make.width.mas_equalTo(WIDTH/4.0);
                make.height.mas_equalTo(45 );
                make.left.mas_equalTo((WIDTH/4.0) * (i %3));
            }];         
        }
        
//        for (int i = 0; i < 12 ; i++) {
//            if (i%3 == 0) {
//                UIView * line = [UIView new];
//                line.backgroundColor = lineColor;
//                [self addSubview:line];
//                [line mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.top.mas_equalTo(45 * (i/3));
//                    make.left.mas_equalTo(0);
//                    if (i/3 == 2)
//                    {
//                        make.right.mas_equalTo(-WIDTH/4.0);
//                    }
//                    else if (i == 2){
//                        make.right.mas_equalTo(-WIDTH/4.0);
//                    }
//                    else
//                    {
//                        make.right.mas_equalTo(0);
//                    }
//                    make.height.mas_equalTo(SINGLE_LINE_WIDTH);
//                }];
//            }
//        }

        
        for (int i = 0; i < 5 ; i++) {
            
                UIView * line = [UIView new];
                line.backgroundColor = lineColor;
                [self addSubview:line];
                [line mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(45 *i);
                    make.left.mas_equalTo(0);
            
                    if (i%2 == 0 && i!=0){
                        make.right.mas_equalTo(-WIDTH/4.0);
                    }
                    else
                    {
                        make.right.mas_equalTo(0);
                    }
                    make.height.mas_equalTo(SINGLE_LINE_WIDTH);
                }];
            
        }
        
        for (int i = 1; i <= 3; i++) {
            UIView * line = [UIView new];
            line.backgroundColor = lineColor;
            [self addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.mas_equalTo(0);
                make.width.mas_equalTo(SINGLE_LINE_WIDTH);
                make.left.mas_equalTo(i*(WIDTH/4.0));
            }];
        }
        
    }
    return self;
}

- (void)btnDidAction:(id)sender
{
    UIButton * btn = sender;
    NSLog(@"tag->%ld",btn.tag-BTN_TAG_FLAG);
    NSString * number = [NSString stringWithFormat:@"%ld",btn.tag - BTN_TAG_FLAG];
    if (btn.tag == (10+BTN_TAG_FLAG)) {
        number = @"梭";
    }
    else if (btn.tag == (20+BTN_TAG_FLAG))
    {
        number = @"改";
    }
    if ([number isEqualToString:@"100"]) {
        number = @"00";
    }
//    [self.number_string appendString:[NSString stringWithFormat:@"%ld",btn.tag - BTN_TAG_FLAG]];
    if ([_delegate respondsToSelector:@selector(cs_keyboardWithNumber:)]) {
        [_delegate cs_keyboardWithNumber:number];
    }
}

- (void)betDidAction:(id)sender
{
    if ([_delegate respondsToSelector:@selector(cs_keyboardWithBetAction)]) {
        [_delegate cs_keyboardWithBetAction];
    }
}

- (void)deleteDidAction:(id)sender
{
    if ([_delegate respondsToSelector:@selector(cs_keyboardWithDelete)]) {
        [_delegate cs_keyboardWithDelete];
    }
}

- (void)cancleDidAction:(id)sender
{
    if ([_delegate respondsToSelector:@selector(cs_keyboardWithCancle)]) {
        [_delegate cs_keyboardWithCancle];
    }
}
@end
