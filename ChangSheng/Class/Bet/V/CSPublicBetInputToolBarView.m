//
//  CSPublicBetInputToolBarView.m
//  ChangSheng
//
//  Created by 邴天宇 on 2017/10/14.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSPublicBetInputToolBarView.h"

#import "LLUtils+Popover.h"

@interface CSPublicBetInputToolBarView ()<CSNumberKeyboardViewDelegate,CSBetInputToolBarViewDelegate>
@property (nonatomic,strong) CSPublicBetInputToolBarModel *betModel;
@property (nonatomic,strong) CSBetInputToolBarView *topView;
@property (nonatomic,strong) CSBetInputView *centerView;
@property (nonatomic,strong) CSNumberKeyboardView *keyboardView;
@property(nonatomic,strong)UITapGestureRecognizer * tap;
@property (nonatomic,copy) NSString * text;
@property (nonatomic,assign) BOOL isShow;
@end

@implementation CSPublicBetInputToolBarView

-(instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        //默认高度 33
        self.textViewHeight = CS_TEXTVIEW_HEIGHT;
        
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
        
        _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapDidAction)];
        [_topView addGestureRecognizer:_tap];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textViewBecomeResponder)];
        [self.topView.textViewInputToolBar addGestureRecognizer:tap];
        
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
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFrame:) name:@"updateInputTextViewFrame" object:nil];
    }
    return self;
}

- (void)textViewBecomeResponder
{
    [self.topView.textViewInputToolBar becomeFirstResponder];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateInputTextViewFrame" object:nil];
}

- (void)updateFrame:(NSNotification *)notice
{
    NSNumber * height = notice.object;
    CGFloat textHeight = height.floatValue;
    self.textViewHeight = textHeight;
    //- 33;
    [UIView animateWithDuration:0.2 animations:^{
        [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(textHeight + 50 - 33);
        }];
        self.topView.textViewHeight.constant =  height.floatValue;
        [self.topView layoutIfNeeded];
        [self.centerView layoutIfNeeded];
        [self layoutIfNeeded];
    }];
}

- (void)cs_keyboardWithNumber:(NSString *)number
{
    if (!self.betModel.betType.length) {
        CS_HUD(@"请选择下注类型");
        return;
    }
    if (self.betModel.betNumber.intValue + number.intValue) {
        [self.betModel.betNumber appendString:number];
        self.topView.inputField.text = self.betModel.betMessage;
    }
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
//    self.text = self.topView.textViewInputToolBar.text;
//    self.topView.textViewInputToolBar.text = @"";
//    if ([_delegate respondsToSelector:@selector(cs_keyboardHide)]) {
//        [_delegate cs_keyboardHide];
//    }
    //- 33;
    [UIView animateWithDuration:0.2 animations:^{
        CGFloat textHeight = self.textViewHeight;;
        if (self.currentInputType == CS_CurrentInputType_Bet) {
            textHeight = 0;
        }
        else
        {
            textHeight = self.textViewHeight - CS_TEXTVIEW_HEIGHT;
        }
        
        [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(50 + textHeight);
        }];
        self.topView.textViewHeight.constant =  CS_TEXTVIEW_HEIGHT + textHeight;
        [self.topView layoutIfNeeded];
        [self.centerView layoutIfNeeded];
        [self layoutIfNeeded];
    }];
    
}

- (void)cs_keyboardShow
{
//    self.topView.textViewInputToolBar.text = self.text;
//    self.text = nil;
    _isShow = YES;
    if ([_delegate respondsToSelector:@selector(cs_keyboardShow)]) {
        [_delegate cs_keyboardShow];
    }
    //- 33;
    [UIView animateWithDuration:0.2 animations:^{
        CGFloat textHeight = self.textViewHeight;
        if (self.currentInputType == CS_CurrentInputType_Bet) {
            textHeight = 0;
        }
        else
        {
            textHeight = self.textViewHeight - CS_TEXTVIEW_HEIGHT;
        }
        [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(textHeight + 50);
        }];
        self.topView.textViewHeight.constant =  textHeight + CS_TEXTVIEW_HEIGHT;//textHeight;
        [self.topView layoutIfNeeded];
        [self.centerView layoutIfNeeded];
        [self layoutIfNeeded];
    }];
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
        if (self.currentInputType == CS_CurrentInputType_Bet) {
            [self cs_keyboardShow];
        }
    }
}

- (void)updateUserScore:(NSString*)score
{
    [self.topView upDateUserScore];
}

-(CS_CurrentInputType)currentInputType
{
    return self.topView.currentInputType;
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
