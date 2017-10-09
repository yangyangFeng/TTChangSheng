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

@implementation CSNumberKeyboardView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
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
        [betBtn addTarget:self action:@selector(deleteDidAction:) forControlEvents:(UIControlEventTouchUpInside)];
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
        [cancleBtn addTarget:self action:@selector(deleteDidAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:cancleBtn];
        [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(45);
            make.width.mas_equalTo(WIDTH/4.0);
        }];
        
        for (int i = 0; i < 12; i++) {
            CSCustomNumberButton * btn = [CSCustomNumberButton buttonWithType:(UIButtonTypeCustom)];
            if (i == 9) {
                btn.enabled = NO;
            }
            else if (i == 10)
            {
                [btn setTitle:[NSString stringWithFormat:@"%d",0] forState:(UIControlStateNormal)];
                btn.tag = BTN_TAG_FLAG + i + 1;
                [btn addTarget:self action:@selector(btnDidAction:) forControlEvents:(UIControlEventTouchUpInside)];
            }
            else if (i == 11)
            {
                btn.enabled = NO;
            }
            else
            {
                [btn setTitle:[NSString stringWithFormat:@"%d",(i+1)] forState:(UIControlStateNormal)];
                btn.tag = BTN_TAG_FLAG + i + 1;
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
        
        for (int i = 0; i < 12 ; i++) {
            if (i%3 == 0) {
                UIView * line = [UIView new];
                line.backgroundColor = lineColor;
                [self addSubview:line];
                [line mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(45 * (i/3));
                    make.left.mas_equalTo(0);
                    if (i/3 == 2)
                    {
                        make.right.mas_equalTo(-WIDTH/4.0);
                    }
                    else
                    {
                        make.right.mas_equalTo(0);
                    }
                    make.height.mas_equalTo(SINGLE_LINE_WIDTH);
                }];
            }
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
}

- (void)deleteDidAction:(id)sender
{
    
}
@end
