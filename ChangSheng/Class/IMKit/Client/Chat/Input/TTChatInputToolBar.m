//
//  TTChatInputToolBar.m
//  ChangSheng
//
//  Created by cnepayzx on 2017/9/29.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "TTChatInputToolBar.h"

#import "UIImage+Color.h"
#define HEIGHT_TABBAR       49      // 就是chatBox的高度

#define HEIGHT_SCREEN       [UIScreen mainScreen].bounds.size.height
#define WIDTH_SCREEN        [UIScreen mainScreen].bounds.size.width

#define     CHATBOX_BUTTON_WIDTH        37
#define     HEIGHT_TEXTVIEW             HEIGHT_TABBAR * 0.74
#define     MAX_TEXTVIEW_HEIGHT         104

#define videwViewH HEIGHT_SCREEN * 0.64 // 录制视频视图高度
#define videwViewX HEIGHT_SCREEN * 0.36 // 录制视频视图X


@interface TTChatInputToolBar ()<UITextViewDelegate>
/** chotBox的顶部边线 */
@property (nonatomic, strong) UIView *topLine;
/** 录音按钮 */
@property (nonatomic, strong) UIButton *voiceButton;
/** 表情按钮 */
@property (nonatomic, strong) UIButton *faceButton;
/** (+)按钮 */
@property (nonatomic, strong) UIButton *moreButton;
/** 按住说话 */
@property (nonatomic, strong) UIButton *talkButton;

@property(nonatomic,strong)UITextView * textView;
@end
@implementation TTChatInputToolBar

- (id) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:rgb(241, 241, 248)];
        [self addSubview:self.topLine];
        [self addSubview:self.voiceButton];
        [self addSubview:self.textView];
        [self addSubview:self.faceButton];
        [self addSubview:self.moreButton];
        [self addSubview:self.talkButton];
        self.status = TTChatInputToolBarStatusNothing; // 起始状态
        [self addNotification];
    }
    return self;
}


#pragma mark - Getter and Setter

- (UIView *) topLine
{
    if (_topLine == nil) {
        _topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0.5)];
        [_topLine setBackgroundColor:rgb(165, 165, 165)];
    }
    return _topLine;
}

- (UIButton *) voiceButton
{
    if (_voiceButton == nil) {
        _voiceButton = [[UIButton alloc] initWithFrame:CGRectMake(0, (HEIGHT_TABBAR - CHATBOX_BUTTON_WIDTH) / 2, CHATBOX_BUTTON_WIDTH, CHATBOX_BUTTON_WIDTH)];
        [_voiceButton setImage:[UIImage imageNamed:@"ToolViewInputVoice"] forState:UIControlStateNormal];
        [_voiceButton setImage:[UIImage imageNamed:@"ToolViewInputVoiceHL"] forState:UIControlStateHighlighted];
        [_voiceButton addTarget:self action:@selector(voiceButtonDown:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voiceButton;
}

- (UIButton *) moreButton
{
    if (_moreButton == nil) {
        _moreButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - CHATBOX_BUTTON_WIDTH, (HEIGHT_TABBAR - CHATBOX_BUTTON_WIDTH) / 2, CHATBOX_BUTTON_WIDTH, CHATBOX_BUTTON_WIDTH)];
        [_moreButton setImage:[UIImage imageNamed:@"TypeSelectorBtn_Black"] forState:UIControlStateNormal];
        [_moreButton setImage:[UIImage imageNamed:@"TypeSelectorBtnHL_Black"] forState:UIControlStateHighlighted];
        [_moreButton addTarget:self action:@selector(moreButtonDown:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreButton;
}

- (UIButton *) faceButton
{
    if (_faceButton == nil) {
        _faceButton = [[UIButton alloc] initWithFrame:CGRectMake(self.moreButton.x - CHATBOX_BUTTON_WIDTH, (HEIGHT_TABBAR - CHATBOX_BUTTON_WIDTH) / 2, CHATBOX_BUTTON_WIDTH, CHATBOX_BUTTON_WIDTH)];
        [_faceButton setImage:[UIImage imageNamed:@"ToolViewEmotion"] forState:UIControlStateNormal];
        [_faceButton setImage:[UIImage imageNamed:@"ToolViewEmotionHL"] forState:UIControlStateHighlighted];
        [_faceButton addTarget:self action:@selector(faceButtonDown:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _faceButton;
}

- (UITextView *) textView
{
    if (_textView == nil) {
        _textView = [[UITextView alloc] initWithFrame:self.talkButton.frame];
        [_textView setFont:[UIFont systemFontOfSize:16.0f]];
        [_textView.layer setMasksToBounds:YES];
        [_textView.layer setCornerRadius:4.0f];
        [_textView.layer setBorderWidth:0.5f];
        [_textView.layer setBorderColor:self.topLine.backgroundColor.CGColor];
        [_textView setScrollsToTop:NO];
        [_textView setReturnKeyType:UIReturnKeySend];
        [_textView setDelegate:self];
    }
    return _textView;
}

- (UIButton *) talkButton
{
    if (_talkButton == nil) {
        _talkButton = [[UIButton alloc] initWithFrame:CGRectMake(self.voiceButton.x + self.voiceButton.width + 4, self.height * 0.13, self.faceButton.x - self.voiceButton.x - self.voiceButton.width - 8, HEIGHT_TEXTVIEW)];
        [_talkButton setTitle:@"按住 说话" forState:UIControlStateNormal];
        [_talkButton setTitle:@"松开 结束" forState:UIControlStateHighlighted];
        [_talkButton setTitleColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0] forState:UIControlStateNormal];
        
        [_talkButton setBackgroundImage:[UIImage yy_imageWithColor:[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.5]] forState:UIControlStateHighlighted];
        [_talkButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
        [_talkButton.layer setMasksToBounds:YES];
        [_talkButton.layer setCornerRadius:4.0f];
        [_talkButton.layer setBorderWidth:0.5f];
        [_talkButton.layer setBorderColor:self.topLine.backgroundColor.CGColor];
        [_talkButton setHidden:YES];
        [_talkButton addTarget:self action:@selector(talkButtonDown:) forControlEvents:UIControlEventTouchDown];
        [_talkButton addTarget:self action:@selector(talkButtonUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [_talkButton addTarget:self action:@selector(talkButtonUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
        [_talkButton addTarget:self action:@selector(talkButtonTouchCancel:) forControlEvents:UIControlEventTouchCancel];
        [_talkButton addTarget:self action:@selector(talkButtonDragOutside:) forControlEvents:UIControlEventTouchDragOutside];
        [_talkButton addTarget:self action:@selector(talkButtonDragInside:) forControlEvents:UIControlEventTouchDragInside];
    }
    return _talkButton;
}

#pragma mark - UITextViewDelegate

- (void) textViewDidBeginEditing:(UITextView *)textView
{
    //    TTChatInputToolBarStatus lastStatus = self.status;
//    self.status = TTChatInputToolBarStatusShowKeyboard;
}

- (void) textViewDidChange:(UITextView *)textView
{
    //    CGFloat height = [textView sizeThatFits:CGSizeMake(self.textView.width, MAXFLOAT)].height;
    if (textView.text.length > 5000) { // 限制5000字内
        textView.text = [textView.text substringToIndex:5000];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        if (self.textView.text.length > 0) {     // send Text
            //            if ([self.textView.text isTrimmingSpace]) {
            ////                [MBProgressHUD showError:@"不能发送空白消息"];
            //            } else {
//            if (_delegate && [_delegate respondsToSelector:@selector(chatBox:sendTextMessage:)]) {
//                [_delegate chatBox:self sendTextMessage:self.textView.text];
//            }
            //            }
        }
        [self.textView setText:@""];
        return NO;
    }
    return YES;
}


#pragma mark - Public Methods

- (BOOL)resignFirstResponder
{
    [self.textView resignFirstResponder];
    [_moreButton setImage:[UIImage imageNamed:@"TypeSelectorBtn_Black"] forState:UIControlStateNormal];
    [_faceButton setImage:[UIImage imageNamed:@"ToolViewEmotion"] forState:UIControlStateNormal];
    return [super resignFirstResponder];
}




#pragma mark - Event Response

// 录音按钮点击事件
- (void) voiceButtonDown:(UIButton *)sender
{
//    TTChatInputToolBarStatus lastStatus = self.status;
//    if (lastStatus == TTChatInputToolBarStatusShowVoice) {//正在显示talkButton，改为键盘状态
//        self.status = TTChatInputToolBarStatusShowKeyboard;
//        [self.talkButton setHidden:YES];
//        [self.textView setHidden:NO];
//        [self.textView becomeFirstResponder];
//        [_voiceButton setImage:[UIImage imageNamed:@"ToolViewInputVoice"] forState:UIControlStateNormal];
//    } else {    // 变成talkButton的状态
//        self.status = TTChatInputToolBarStatusShowVoice;
//        [self.textView resignFirstResponder];
//        [self.textView setHidden:YES];
//        [self.talkButton setHidden:NO];
//        [_voiceButton setImage:[UIImage imageNamed:@"ToolViewKeyboard"] forState:UIControlStateNormal];
//    }
//    if (_delegate && [_delegate respondsToSelector:@selector(chatBox:changeStatusForm:to:)]) {
//        [_delegate chatBox:self changeStatusForm:lastStatus to:self.status];
//    }
}

// 更多（+）按钮
- (void) moreButtonDown:(UIButton *)sender
{
    TTChatInputToolBarStatus lastStatus = self.status;
    if (lastStatus == TTChatInputToolBarStatusShowMore) { // 当前显示的就是more页面
        self.status = TTChatInputToolBarStatusShowKeyboard;
        [self.textView becomeFirstResponder];
    } else {
        [self.talkButton setHidden:YES];
        [self.textView setHidden:NO];
        [_voiceButton setImage:[UIImage imageNamed:@"ToolViewInputVoice"] forState:UIControlStateNormal];
        
        self.status = TTChatInputToolBarStatusShowMore;
        if (lastStatus == TTChatInputToolBarStatusShowFace) {  // 改变按钮样式
            [_faceButton setImage:[UIImage imageNamed:@"ToolViewEmotion"] forState:UIControlStateNormal];
        } else if (lastStatus == TTChatInputToolBarStatusShowVoice) {
            [_talkButton setHidden:YES];
            [_textView setHidden:NO];
            [_voiceButton setImage:[UIImage imageNamed:@"ToolViewInputVoice"] forState:UIControlStateNormal];
        } else if (lastStatus == TTChatInputToolBarStatusShowKeyboard) {
            [self.textView resignFirstResponder];
            self.status = TTChatInputToolBarStatusShowMore;
        }
    }
    if (_delegate && [_delegate respondsToSelector:@selector(chatBox:changeStatusForm:to:)]) {
        [_delegate chatBox:self changeStatusForm:lastStatus to:self.status];
    }
}

// 表情按钮
- (void) faceButtonDown:(UIButton *)sender
{
    TTChatInputToolBarStatus lastStatus = self.status;
    if (lastStatus == TTChatInputToolBarStatusShowFace) {       // 正在显示表情,改为现实键盘状态
        self.status = TTChatInputToolBarStatusShowKeyboard;
        [_faceButton setImage:[UIImage imageNamed:@"ToolViewEmotion"] forState:UIControlStateNormal];
        [self.textView becomeFirstResponder];
    } else {
        [self.talkButton setHidden:YES];
        [self.textView setHidden:NO];
        [_voiceButton setImage:[UIImage imageNamed:@"ToolViewInputVoice"] forState:UIControlStateNormal];
        self.status = TTChatInputToolBarStatusShowFace;
        [_faceButton setImage:[UIImage imageNamed:@"ToolViewKeyboard"] forState:UIControlStateNormal];
        if (lastStatus == TTChatInputToolBarStatusShowMore) {
        } else if (lastStatus == TTChatInputToolBarStatusShowVoice) {
            [_voiceButton setImage:[UIImage imageNamed:@"ToolViewInputVoice"] forState:UIControlStateNormal];
            [_talkButton setHidden:YES];
            [_textView setHidden:NO];
        }  else if (lastStatus == TTChatInputToolBarStatusShowKeyboard) {
            [self.textView resignFirstResponder];
            self.status = TTChatInputToolBarStatusShowFace;
        } else if (lastStatus == TTChatInputToolBarStatusShowVoice) {
            [self.talkButton setHidden:YES];
            [self.textView setHidden:NO];
            [_voiceButton setImage:[UIImage imageNamed:@"ToolViewInputVoice"] forState:UIControlStateNormal];
            self.status         = TTChatInputToolBarStatusShowFace;
        }
        
    }
    if (_delegate && [_delegate respondsToSelector:@selector(chatBox:changeStatusForm:to:)]) {
        [_delegate chatBox:self changeStatusForm:lastStatus to:self.status];
    }
    
    
}

// 说话按钮
- (void)talkButtonDown:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(chatBoxDidStartRecordingVoice:)]) {
        [_delegate chatBoxDidStartRecordingVoice:self];
    }
}

- (void)talkButtonUpInside:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(chatBoxDidStopRecordingVoice:)]) {
        [_delegate chatBoxDidStopRecordingVoice:self];
    }
}

- (void)talkButtonUpOutside:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(chatBoxDidCancelRecordingVoice:)]) {
        [_delegate chatBoxDidCancelRecordingVoice:self];
    }
}

- (void)talkButtonDragOutside:(UIButton *)sender
{
    if ([_delegate respondsToSelector:@selector(chatBoxDidDrag:)]) {
        [_delegate chatBoxDidDrag:NO];
    }
}

- (void)talkButtonDragInside:(UIButton *)sender
{
    if ([_delegate respondsToSelector:@selector(chatBoxDidDrag:)]) {
        [_delegate chatBoxDidDrag:YES];
    }
}

- (void)talkButtonTouchCancel:(UIButton *)sender
{
}

#pragma mark - Private

- (void)emotionDidSelected:(NSNotification *)notifi
{
//    XZEmotion *emotion = notifi.userInfo[GXSelectEmotionKey];
//    if (emotion.code) {
//        [self.textView insertText:emotion.code.emoji];
//        [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length, 0)];
//    } else if (emotion.face_name) {
//        [self.textView insertText:emotion.face_name];
//    }
}

// 删除
- (void)deleteBtnClicked
{
    [self.textView deleteBackward];
}

- (void)sendMessage
{
    if (self.textView.text.length > 0) {     // send Text
        if (_delegate && [_delegate respondsToSelector:@selector(chatBox:sendTextMessage:)]) {
            [_delegate chatBox:self sendTextMessage:self.textView.text];
        }
    }
    [self.textView setText:@""];
}

// 监听通知
- (void)addNotification
{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidSelected:) name:GXEmotionDidSelectNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteBtnClicked) name:GXEmotionDidDeleteNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendMessage) name:GXEmotionDidSendNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
