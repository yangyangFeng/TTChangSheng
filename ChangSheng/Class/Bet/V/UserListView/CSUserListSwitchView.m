//
//  CSUserListSwitchView.m
//  ChangSheng
//
//  Created by 邴天宇 on 2018/1/10.
//  Copyright © 2018年 邴天宇. All rights reserved.
//

#import "CSUserListSwitchView.h"


@interface CSUserListSwitchView()

@end

@implementation CSUserListSwitchView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if(self){
        
        self.backgroundColor = [UIColor whiteColor];
        
        _switchBtn = [UISwitch new];
        
        UILabel * title = [UILabel new];
        title.font = [UIFont systemFontOfSize:14];
        title.textColor = [UIColor colorWithHexColorString:@"666666"];
        title.text = @"消息免打扰";
        
        [self addSubview:_switchBtn];
        [self addSubview:title];
        
        
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.left.mas_equalTo(15);
        }];
        
        [_switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-10);
            make.width.mas_equalTo(70);
        }];
    }
    
    return self;
}

@end
