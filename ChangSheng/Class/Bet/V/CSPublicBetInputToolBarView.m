//
//  CSPublicBetInputToolBarView.m
//  ChangSheng
//
//  Created by 邴天宇 on 2017/10/14.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSPublicBetInputToolBarView.h"

#import "CSBetInputToolBarView.h"
#import "CSNumberKeyboardView.h"

@interface CSPublicBetInputToolBarView ()<CSNumberKeyboardViewDelegate,CSBetInputToolBarViewDelegate>
@property (nonatomic,strong) CSPublicBetInputToolBarModel *betModel;
@property (nonatomic,strong) CSBetInputToolBarView *topView;
@property (nonatomic,strong) CSBetInputView *centerView;
@property (nonatomic,strong) CSNumberKeyboardView *keyboardView;

@property (nonatomic,assign) BOOL isShow;
@end

@implementation CSPublicBetInputToolBarView

-(instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        _isShow = NO;
        _betModel = [CSPublicBetInputToolBarModel new];
        
        _topView = [CSBetInputToolBarView viewFromXIB];
        _centerView = [CSBetInputView viewFromXIB];
        _keyboardView = [[CSNumberKeyboardView alloc]init];
        _maskView = [UIView new];
        _maskView.backgroundColor = [UIColor whiteColor];
        
        _topView.delegate = self;
        _centerView.delegate = self;
        _keyboardView.delegate = self;
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapDidAction)];
        [_topView addGestureRecognizer:tap];
        
        
        [self addSubview:_topView];
        [self addSubview:_centerView];
        [self addSubview:_keyboardView];
        [self addSubview:_maskView];
        
        [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
            make.height.mas_equalTo(50);
        }];
        [_centerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_topView.mas_bottom).offset(0);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(128);
        }];
        [_keyboardView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_centerView.mas_bottom).offset(0);
            make.left.right.bottom.mas_equalTo(0);
        }];
        [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_topView.mas_bottom).offset(0);
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
    }
    return self;
}
- (void)cs_keyboardWithNumber:(NSString *)number
{
    if (!self.betModel.betType.length) {
        [MBProgressHUD tt_ErrorTitle:@"请选择下注类型"];
        return;
    }
    [self.betModel.betNumber appendString:number];
    self.topView.inputField.text = self.betModel.betMessage;
}

- (void)cs_keyboardWithBetAction
{
    if (!self.betModel.betType.length) {
        return;
    }
    if (!self.betModel.betNumber.length) {
        return;
    }
    CSMessageModel * msgModel = [CSMessageModel new];
    
    msgModel.action = 3;//下注
 
    msgModel.content = self.betModel.betMessage;
    
    msgModel.playType = self.betModel.betType.intValue;
    
    msgModel.score = self.betModel.betNumber.intValue;
    
    
    if ([_delegate respondsToSelector:@selector(cs_betMessageModel:)]) {
        [_delegate cs_betMessageModel:msgModel];
    }
    
    [self.betModel cleanBetMessage];

    self.topView.inputField.text = self.betModel.betMessage;
}

- (void)cs_keyboardSendMessageText:(NSString *)text
{
    if ([_delegate respondsToSelector:@selector(cs_keyboardSendMessageText:)]) {
        [_delegate cs_keyboardSendMessageText:text];
    }
}

- (void)cs_keyboardWithDelete
{
    if (self.betModel.betNumber.length > 0) {
        [self.betModel.betNumber deleteCharactersInRange:NSMakeRange(self.betModel.betNumber.length - 1,1)];
    }
    else if (self.betModel.betNumber.length == 0)
    {
        [self.betModel cleanBetMessage];
    }
    self.topView.inputField.text = self.betModel.betMessage;
}

- (void)cs_keyboardWithCancle
{
    [self.betModel cleanBetMessage];
    self.topView.inputField.text = self.betModel.betMessage;
    
    if ([_delegate respondsToSelector:@selector(cs_betCancleMessageModel:)]) {
        [_delegate cs_betCancleMessageModel:nil];
    }
}

- (void)cs_keyboardBetTypeName:(NSString *)typeName type:(NSString *)type
{
    [self.betModel.betNumber deleteCharactersInRange:NSMakeRange(0,self.betModel.betNumber.length)];
    self.betModel.betName = typeName;
    self.betModel.betType = type;
    
    self.topView.inputField.text = self.betModel.betMessage;
}

- (void)cs_keyboardBtnActionType:(int)type
{
    if ([_delegate respondsToSelector:@selector(cs_keyboardBtnActionType:)]) {
        [_delegate cs_keyboardBtnActionType:type];
    }
}

- (void)cs_keyboardHide
{
//    if ([_delegate respondsToSelector:@selector(cs_keyboardHide)]) {
//        [_delegate cs_keyboardHide];
//    }
}

- (void)cs_keyboardShow
{
    _isShow = YES;
    if ([_delegate respondsToSelector:@selector(cs_keyboardShow)]) {
        [_delegate cs_keyboardShow];
    }
}

- (void)cs_resignFirstResponder
{
    _isShow = NO;
    [self.topView.textViewInputToolBar resignFirstResponder];
    if ([_delegate respondsToSelector:@selector(cs_keyboardHide)]) {
        [_delegate cs_keyboardHide];
    }
}

- (void)tapDidAction
{
    if (_isShow) {
        
    }
    else
    {
        [self cs_keyboardShow];
    }
}
@end



@implementation CSPublicBetInputToolBarModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        _betNumber = [NSMutableString string];
    }
    return self;
}

- (void)cleanBetMessage
{
    self.betName = @"";
    self.betType = @"";
    [self.betNumber deleteCharactersInRange:NSMakeRange(0, self.betNumber.length)];
}

- (NSString *)betMessage
{
    return [NSString stringWithFormat:@"%@%@",self.betName.length ? [NSString stringWithFormat:@"%@:",self.betName] : @"",self.betNumber.length ? self.betNumber : @""];
}

@end
