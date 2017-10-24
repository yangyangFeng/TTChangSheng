//
//  Mp3Recorder.h
//  BloodSugar
//
//  Created by PeterPan on 14-3-24.
//  Copyright (c) 2014年 shake. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@protocol Mp3RecorderDelegate <NSObject>
- (void)failRecord;
- (void)beginConvert;
- (void)endConvertWithData:(NSData *)voiceData;
@end

@interface Mp3Recorder : NSObject
@property (nonatomic, weak) id<Mp3RecorderDelegate> delegate;
@property (nonatomic, strong, readonly) AVAudioSession *session;
@property (nonatomic, strong, readonly) AVAudioRecorder *recorder;
- (id)initWithDelegate:(id<Mp3RecorderDelegate>)delegate;
- (void)startRecord;
- (void)stopRecord;
- (void)cancelRecord;

@end
