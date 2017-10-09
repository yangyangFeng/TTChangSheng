//
//  VoiceRecordHelper.h
//  KeyBoardView
//
//  Created by 余强 on 16/3/20.
//  Copyright © 2016年 你好，我是余强，一位来自上海的ios开发者，现就职于bdcluster(上海大数聚科技有限公司)。这个工程致力于完成一个优雅的IM实现方案. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef enum  {
    MoreViewTypePhotoAblums,
    MoreViewTypePhotoLocation,
    MoreViewTypeTakePicture,
    MoreViewTypePhoneCall,
    MoreViewTypeVideoCall,
} MoreViewType;


typedef enum  {
    KeyBoardTypeVoiceRecoder,   //录音
    KeyBoardTypeEmoij,          //emoij
    KeyBoardTypeMore,           //更多
    KeyBoardTypeSystem          //系统键盘
}  KeyBoardType;



/**
 Emotion面板表情类型
 */
typedef enum  {
    EmotionTypeEmoij,           //emoij
    EmotionTypeGif,             //gif
    EmotionTypePhoto,           //静态
}  EmotionType;




#define      SCREEN_WIDTH                     [UIScreen mainScreen].bounds.size.width
#define      SCREEN_HEIGHT                    [UIScreen mainScreen].bounds.size.height




#define KeyToolBarHeight 44

#define KTextViewHeightChangeNotification  @"textViewHeightChangeNotification"




#define kHorizontalPadding 8
#define kVerticalPadding 5



#define KTextHeight 33
#define  KMaxInputViewHeight 140


#define kVoiceRecorderTotalTime 120.0

typedef BOOL(^PrepareRecorderCompletion)();
typedef void(^StartRecorderCompletion)();
typedef void(^StopRecorderCompletion)(NSString *);
typedef void(^PauseRecorderCompletion)();
typedef void(^ResumeRecorderCompletion)();
typedef void(^CancellRecorderDeleteFileCompletion)();
typedef void(^RecordProgress)(float progress);
typedef void(^PeakPowerForChannel)(float peakPowerForChannel);


@interface VoiceRecordHelper : NSObject

@property (nonatomic, copy) StopRecorderCompletion maxTimeStopRecorderCompletion;
@property (nonatomic, copy) StopRecorderCompletion minTimeStopRecorderCompletion;
@property (nonatomic, copy) RecordProgress recordProgress;
@property (nonatomic, copy) PeakPowerForChannel peakPowerForChannel;
@property (nonatomic, copy, readonly) NSString *recordPath;
@property (nonatomic, copy) NSString *recordDuration;
@property (nonatomic) float maxRecordTime; // 默认 120秒为最大
@property (nonatomic) float minRecordTime; // 默认 3秒为最小
@property (nonatomic, readonly) NSTimeInterval currentTimeInterval;

- (void)prepareRecordingWithPath:(NSString *)path prepareRecorderCompletion:(PrepareRecorderCompletion)prepareRecorderCompletion;
- (void)startRecordingWithStartRecorderCompletion:(StartRecorderCompletion)startRecorderCompletion;
- (void)pauseRecordingWithPauseRecorderCompletion:(PauseRecorderCompletion)pauseRecorderCompletion;
- (void)resumeRecordingWithResumeRecorderCompletion:(ResumeRecorderCompletion)resumeRecorderCompletion;
- (void)stopRecordingWithStopRecorderCompletion:(StopRecorderCompletion)stopRecorderCompletion;
- (void)cancelledDeleteWithCompletion:(CancellRecorderDeleteFileCompletion)cancelledDeleteCompletion;

@end
