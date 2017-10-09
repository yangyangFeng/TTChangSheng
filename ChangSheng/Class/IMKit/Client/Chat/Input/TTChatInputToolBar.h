//
//  TTChatInputToolBar.h
//  ChangSheng
//
//  Created by cnepayzx on 2017/9/29.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TTChatInputToolBarStatus) {
    TTChatInputToolBarStatusNothing,     // 默认状态
    TTChatInputToolBarStatusShowVoice,   // 录音状态
    TTChatInputToolBarStatusShowFace,    // 输入表情状态
    TTChatInputToolBarStatusShowMore,    // 显示“更多”页面状态
    TTChatInputToolBarStatusShowKeyboard,// 正常键盘
    TTChatInputToolBarStatusShowVideo    // 录制视频
};

@class TTChatInputToolBar;
@protocol TTChatInputToolBarDelegate <NSObject>
/**
 *  输入框状态(位置)改变
 *
 *  @param chatBox    chatBox
 *  @param fromStatus 起始状态
 *  @param toStatus   目的状态
 */
- (void)chatBox:(TTChatInputToolBar *)chatBox changeStatusForm:(TTChatInputToolBarStatus)fromStatus to:(TTChatInputToolBarStatus)toStatus;

/**
 *  发送消息
 *
 *  @param chatBox     chatBox
 *  @param textMessage 消息
 */
- (void)chatBox:(TTChatInputToolBar *)chatBox sendTextMessage:(NSString *)textMessage;

/**
 *  输入框高度改变
 *
 *  @param chatBox chatBox
 *  @param height  height
 */
- (void)chatBox:(TTChatInputToolBar *)chatBox changeChatBoxHeight:(CGFloat)height;

/**
 *  开始录音
 *
 *  @param chatBox chatBox
 */
- (void)chatBoxDidStartRecordingVoice:(TTChatInputToolBar *)chatBox;
- (void)chatBoxDidStopRecordingVoice:(TTChatInputToolBar *)chatBox;
- (void)chatBoxDidCancelRecordingVoice:(TTChatInputToolBar *)chatBox;
- (void)chatBoxDidDrag:(BOOL)inside;

@end

@interface TTChatInputToolBar : UIView
/** 保存状态 */
@property (nonatomic, assign) TTChatInputToolBarStatus status;

@property (nonatomic, weak) id<TTChatInputToolBarDelegate>delegate;
@end
