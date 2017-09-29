//
//  CSMessageModel.m
//  TestChat
//
//  Created by cnepayzx on 2017/9/27.
//  Copyright © 2017年 bingtianyu. All rights reserved.
//

#import "CSMessageModel.h"

#import "LLMessageModel.h"
#import "LLUserProfile.h"
#import "LLUtils.h"
#import "LLEmotionModelManager.h"
#import "LLConfig.h"
#import "UIKit+LLExt.h"
#import "LLChatManager+MessageExt.h"
#import "LLMessageModelManager.h"
#import "LLMessageCellManager.h"
#import "LLMessageThumbnailManager.h"
#import "LLSimpleTextLabel.h"

#import "LLMessageImageCell.h"
#import "LLMessageTextCell.h"
#import "LLMessageGifCell.h"
#import "LLMessageDateCell.h"
#import "LLMessageLocationCell.h"
#import "LLMessageVoiceCell.h"
#import "LLMessageVideoCell.h"
#import "LLMessageRecordingCell.h"

#import "CSMessageModel.h"
//缩略图正在下载时照片尺寸
#define DOWNLOAD_IMAGE_WIDTH 175
#define DOWNLOAD_IMAGE_HEIGHT 145


typedef NS_OPTIONS(NSInteger, CSMessageCellUpdateType) {
    kCSMessageCellUpdateTypeNone = 0,          //
    kCSMessageCellUpdateTypeThumbnailChanged = 1,      //缩略图改变
    kCSMessageCellUpdateTypeUploadStatusChanged = 1 << 1,   //上传状态改变
    kCSMessageCellUpdateTypeDownloadStatusChanged = 1 << 2, //下载状态改变
    kCSMessageCellUpdateTypeNewForReuse = 1 << 3,       //首次使用，或者重用
    
};

@interface CSMessageModel ()
@property (nonatomic, readwrite) CSMessageStatus messageStatus;

@property (nonatomic, readwrite) CSMessageDownloadStatus thumbnailDownloadStatus;

@property (nonatomic, readwrite) CSMessageDownloadStatus messageDownloadStatus;

@property (nonatomic) CSMessageCellUpdateType updateType;

@end

NSMutableDictionary * tmpImageDict;

@implementation CSMessageModel
- (NSDictionary *)changeParams
{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:self.chatId forKey:@"chatId"];
    [param setObject:@(self.chartType) forKey:@"chartType"];
    [param setObject:@(self.msgType) forKey:@"msgType"];
    [param setObject:self.content forKey:@"content"];
    [param setObject:self.msgId forKey:@"msgId"];
    [param setObject:@(self.action) forKey:@"action"];
    [param setObject:@(self.playType) forKey:@"playType"];
    [param setObject:@(self.score) forKey:@"score"];
    [param setObject:@(2) forKey:@"receiveUserType"];
    return param;
}
+ (void)initialize {
    if (self == [CSMessageModel class]) {
        tmpImageDict = [NSMutableDictionary dictionary];
    }
}

#pragma mark - 消息初始化 -

+ (CSMessageModel*)newMessageChatType:(CSChatType)chatType
                  chatId:(NSString *)chatId
                   msgId:(NSString *)msgId
                 msgType:(CSMessageBodyType)msgType
                  action:(int)action
                 content:(NSString *)content
{
    CSMessageModel * msssageModel = [[CSMessageModel alloc]initNewMessageChatType:chatType chatId:chatId msgId:msgId msgType:msgType action:action content:content];
    return msssageModel;
}

- (id)initNewMessageChatType:(CSChatType)chatType chatId:(NSString *)chatId msgId:(NSString *)msgId msgType:(CSMessageBodyType)msgType action:(int)action content:(NSString *)content
{
    if (self = [super init]) {
        self.chartType = chatType;
        self.chatId = chatId;
        self.msgId = msgId;
        self.msgType = msgType;
        self.action = action;//普通消息
        self.msgType = msgType;
        self.content = content;
        _fromMe = YES;
        _isSelf = YES;
        
//        _sdk_message = message;
//        _messageBodyType = (LLMessageBodyType)_sdk_message.body.type;
//        _messageId = [message.messageId copy];
//        _conversationId = [message.conversationId copy];
        _messageStatus = kLLMessageStatusNone;
        _messageDownloadStatus = kLLMessageDownloadStatusNone;
        _thumbnailDownloadStatus = kLLMessageDownloadStatusNone;
        
//        _from = [message.from copy];
//        _to = [message.to copy];
//        _fromMe = _sdk_message.direction == EMMessageDirectionSend;
        
//        _updateType = kLLMessageCellUpdateTypeNewForReuse;
//        
//            if (_fromMe) {
//        _timestamp = adjustTimestampFromServer(message.timestamp);
//            }else {
//                _timestamp = adjustTimestampFromServer(message.serverTime);
//            }
//    
//        _ext = message.ext;
        _error = nil;
        
        [self processModelForCell];
    }
    return self;
}

- (instancetype)initWithImageModel:(CSMessageModel *)messageModel {
    self = [super init];
    if (self) {
        _messageBodyType = kCSMessageBodyTypeImage;
        _thumbnailImageSize = messageModel.thumbnailImageSize;
        _messageDownloadStatus = kCSMessageDownloadStatusSuccessed;
        _thumbnailDownloadStatus = kCSMessageDownloadStatusSuccessed;
        _messageId = [NSString stringWithFormat:@"%f%d",[NSDate date].timeIntervalSince1970, arc4random()];
        
        
        _cellHeight = messageModel.cellHeight;
        _fromMe = YES;
    }
    
    return self;
}


- (instancetype)initWithType:(CSMessageBodyType)type {
    self = [super init];
    if (self) {
        _messageBodyType = type;
        
        switch (type) {
            case kCSMessageBodyTypeDateTime:
                self.cellHeight = [LLMessageDateCell heightForModel:self];
                break;
            case kCSMessageBodyTypeVoice:
                self.cellHeight = [LLMessageVoiceCell heightForModel:self];
                break;
            case kCSMessageBodyTypeRecording:
                self.fromMe = YES;
                self.timestamp = [[NSDate date] timeIntervalSince1970];
                self.cellHeight = [LLMessageRecordingCell heightForModel:self];
            default:
                break;
        }
    }
    
    return self;
}

- (void)commonInit:(EMMessage *)message {
    DLog(@"废弃方法未实现");
//    _sdk_message = message;
//    _messageBodyType = (LLMessageBodyType)_sdk_message.body.type;
//    _messageId = [message.messageId copy];
//    _conversationId = [message.conversationId copy];
//    _messageStatus = kLLMessageStatusNone;
//    _messageDownloadStatus = kLLMessageDownloadStatusNone;
//    _thumbnailDownloadStatus = kLLMessageDownloadStatusNone;
//    
//    _from = [message.from copy];
//    _to = [message.to copy];
//    _fromMe = _sdk_message.direction == EMMessageDirectionSend;
//    
//    _updateType = kLLMessageCellUpdateTypeNewForReuse;
//    
//    //    if (_fromMe) {
//    _timestamp = adjustTimestampFromServer(message.timestamp);
//    //    }else {
//    //        _timestamp = adjustTimestampFromServer(message.serverTime);
//    //    }
//    
//    _ext = message.ext;
//    _error = nil;
//    
//    [self processModelForCell];
}

- (instancetype)initWithMessage:(EMMessage *)message {
    self = [super init];
    if (self) {
        [self commonInit:message];
    }
    
    return self;
}

//+ (LLMessageModel *)messageModelFromPool:(EMMessage *)message {
//    LLMessageModel *messageModel = [[LLMessageModel alloc] initWithMessage:message];
//    [[LLMessageModelManager sharedManager] addMessageModelToConversaion:messageModel];
//    
//    return messageModel;
//}

- (void)updateMessage:(CSMessageModel *)aMessage updateReason:(LLMessageModelUpdateReason)updateReason {
    BOOL isMessageIdChanged = ![aMessage.messageId isEqualToString:_messageId];
    DLog(@"废弃方法 未实现");
//    if (aMessage == _sdk_message) {
//        if (isMessageIdChanged) {
//            NSLog(@"更新消息时，消息ID发生了改变");
////            [[LLMessageCellManager sharedManager] updateMessageModel:self toMessageId:aMessage.messageId];
////            _messageId = [aMessage.messageId copy];
////        }
//    }else {
//        NSAssert(!isMessageIdChanged, @"更新消息发生异常:EMMessage和消息Id都改变了");
//    }
//    
//    _sdk_message = aMessage;
//    _ext = aMessage.ext;
//    
//    switch (updateReason) {
//        case kLLMessageModelUpdateReasonUploadComplete:
//            self.updateType |= kLLMessageCellUpdateTypeUploadStatusChanged;
//            break;
//            
//        case kLLMessageModelUpdateReasonThumbnailDownloadComplete:
//            self.updateType |= kLLMessageCellUpdateTypeThumbnailChanged;
//            break;
//            
//        case kLLMessageModelUpdateReasonAttachmentDownloadComplete:
//            self.fileDownloadProgress = 100;
//            self.updateType |= kLLMessageCellUpdateTypeDownloadStatusChanged;
//            switch (self.messageBodyType) {
//                case kLLMessageBodyTypeImage:
//                case kLLMessageBodyTypeVideo: {
//                    EMFileMessageBody *messageBody = (EMFileMessageBody *)self.sdk_message.body;
//                    if (messageBody.downloadStatus == EMDownloadStatusSuccessed) {
//                        self.thumbnailImage = nil;
//                        self.updateType |= kLLMessageCellUpdateTypeThumbnailChanged;
//                    }
//                    break;
//                }
//                default:
//                    break;
//            }
//            
//            break;
//            
//        case kLLMessageModelUpdateReasonReGeocodeComplete:
//            if (self.messageBodyType == kLLMessageBodyTypeLocation) {
//                self.updateType = kLLMessageCellUpdateTypeNewForReuse;
//                [[LLChatManager sharedManager] decodeMessageExtForLocationType:self];
//                self.cellHeight = [LLMessageLocationCell heightForModel:self];
//            }
//            break;
//    }
    
}

//FIXME: 环信有时候会出现DownloadStatus==Success,但文件获取为空的情况
- (UIImage *)fullImage {
    DLog(@"待实现方法");
//    if (self.messageBodyType == kLLMessageBodyTypeImage) {
//        EMImageMessageBody *imgMessageBody = (EMImageMessageBody *)self.sdk_message.body;
//        if (_fromMe || imgMessageBody.downloadStatus == EMDownloadStatusSuccessed) {
//            UIImage *fullImage = [UIImage imageWithContentsOfFile:imgMessageBody.localPath];
//            return fullImage;
//        }
//    }
    
    return [UIImage new];
}

- (UIImage *)thumbnailImage {
    DLog(@"待实现方法");
    /*
    if (!_thumbnailImage) {
        _thumbnailImage = [[LLMessageThumbnailManager sharedManager] thumbnailForMessageModel:self];
        if (_thumbnailImage)
            return _thumbnailImage;
        
        UIImage *thumbnailImage;
        BOOL needSaveToCache = NO;
        BOOL needSaveToDisk = NO;
        BOOL needSaveToTemp = NO;
        switch (self.messageBodyType) {
            case kLLMessageBodyTypeImage:{
                EMImageMessageBody *imgMessageBody = (EMImageMessageBody *)self.sdk_message.body;
                
                self.thumbnailImageSize = [LLMessageImageCell thumbnailSize:imgMessageBody.size];
                if (_fromMe || imgMessageBody.downloadStatus == EMDownloadStatusSuccessed) {
                    UIImage *fullImage = [UIImage imageWithContentsOfFile:imgMessageBody.localPath];
                    _thumbnailImageSize = [LLMessageImageCell thumbnailSize:fullImage.size];
                    thumbnailImage = [fullImage resizeImageToSize:self.thumbnailImageSize opaque:YES scale:0];
                    
                    needSaveToCache = YES;
                    needSaveToDisk = YES;
                }else if (imgMessageBody.thumbnailDownloadStatus == EMDownloadStatusSuccessed) {
                    UIImage *image = [UIImage imageWithContentsOfFile:imgMessageBody.thumbnailLocalPath];
                    _thumbnailImageSize = [LLMessageImageCell thumbnailSize:image.size];
                    thumbnailImage = [image resizeImageToSize:self.thumbnailImageSize opaque:YES scale:0];
                    
                    needSaveToTemp = YES;
                }
                //FIXME:对于特殊图，比如超长、超宽、超小图，应该做特殊处理
                //调用该方法createWithImageInRect后，VM：raster data内存没有变化
                //以后再解决这个问题
                //                if (_thumbnailImageSize.height > 2 * IMAGE_MAX_SIZE) {
                //                    _thumbnailImage = [_thumbnailImage createWithImageInRect:CGRectMake(0, (_thumbnailImageSize.height - IMAGE_MAX_SIZE) / 2 * _thumbnailImage.scale, _thumbnailImageSize.width * _thumbnailImage.scale, IMAGE_MAX_SIZE * _thumbnailImage.scale)];
                //                }else if (_thumbnailImageSize.width > 2 * IMAGE_MAX_SIZE) {
                //                    _thumbnailImage = [_thumbnailImage createWithImageInRect:CGRectMake((_thumbnailImageSize.width - IMAGE_MAX_SIZE)/2 * _thumbnailImage.scale, 0, IMAGE_MAX_SIZE * _thumbnailImage.scale, _thumbnailImageSize.height * _thumbnailImage.scale)];
                //                }
                
                break;
            }
            case kLLMessageBodyTypeVideo:{
                EMVideoMessageBody *videoMessageBody = (EMVideoMessageBody *)self.sdk_message.body;
                
                if (_fromMe || videoMessageBody.downloadStatus == EMDownloadStatusSuccessed ) {
                    UIImage *image = [LLUtils getVideoThumbnailImage:videoMessageBody.localPath];
                    thumbnailImage = [image resizeImageToSize:self.thumbnailImageSize];
                    
                    needSaveToCache = YES;
                    needSaveToDisk = YES;
                }else if (videoMessageBody.thumbnailDownloadStatus == EMDownloadStatusSuccessed) {
                    UIImage *image = [[UIImage alloc] initWithContentsOfFile:videoMessageBody.thumbnailLocalPath];
                    thumbnailImage = [image resizeImageToSize:self.thumbnailImageSize];
                    
                    needSaveToTemp = YES;
                }
                
                break;
            }
            case kLLMessageBodyTypeLocation: {
                if (self.defaultSnapshot)
                    return nil;
                
                EMFileMessageBody *body = (EMFileMessageBody *)self.sdk_message.body;
                if (_fromMe || body.downloadStatus == EMDownloadStatusSuccessed) {
                    NSData *data = [NSData dataWithContentsOfFile:body.localPath];
                    thumbnailImage = [UIImage imageWithData:data scale:_snapshotScale];
                    
                    needSaveToCache = YES;
                    needSaveToDisk = NO;
                }
                
                break;
            }
                
            default:
                break;
        }
        
        if (thumbnailImage) {
            if (needSaveToTemp) {
                tmpImageDict[_messageId] = thumbnailImage;
            }else if (needSaveToCache) {
                tmpImageDict[_messageId] = nil;
                [[LLMessageThumbnailManager sharedManager] addThumbnailForMessageModel:self thumbnail:thumbnailImage toDisk:needSaveToDisk];
            }
        }
        
        _thumbnailImage = thumbnailImage;
    }
    */
    _thumbnailImage = [UIImage new];
    return _thumbnailImage;
}

//注释掉的代码是通常方法，但由于所有MessageModel都缓存起来了，一个MessageId唯一对应一个MessageModel
//所以MessageModel的比较只需要进行对象指针比较即可
- (BOOL)isEqual:(id)object {
    //    if (self == object)
    //        return YES;
    //
    //    if (!object || ![object isKindOfClass:[LLMessageModel class]]) {
    //        return NO;
    //    }
    //
    //    LLMessageModel *model = (LLMessageModel *)object;
    //    return [self.messageId isEqualToString:model.messageId];
    
    return self == object;
}

#pragma mark - 消息状态

- (void)internal_setMessageStatus:(LLMessageStatus)messageStatus {
    _messageStatus = messageStatus;
}

- (void)internal_setMessageDownloadStatus:(LLMessageDownloadStatus)messageDownloadStatus {
    _messageDownloadStatus = messageDownloadStatus;
}

- (void)internal_setThumbnailDownloadStatus:(LLMessageDownloadStatus)thumbnailDownloadStatus {
    _thumbnailDownloadStatus = thumbnailDownloadStatus;
}

- (void)internal_setIsFetchingAttachment:(BOOL)isFetchingAttachment {
    _isFetchingAttachment = isFetchingAttachment;
}

- (void)internal_setIsFetchingThumbnail:(BOOL)isFetchingThumbnail {
    _isFetchingThumbnail = isFetchingThumbnail;
}

- (CSMessageStatus)messageStatus {
    if (_messageStatus != kCSMessageStatusNone)
        return _messageStatus;
    
    return nil;
    
}

//- (LLMessageDirection)messageDirection {
//    return (LLMessageDirection)_sdk_message.direction;
//    return kLLMessageDirectionSend;
//}

- (CSMessageDownloadStatus)messageDownloadStatus {
    if (_messageDownloadStatus != kCSMessageDownloadStatusNone)
        return _messageDownloadStatus;
    if (_isSelf)
        return kCSMessageDownloadStatusSuccessed;
    
//    EMFileMessageBody *body = (EMFileMessageBody *)(_sdk_message.body);
//    if (body) {
//        return (CSMessageDownloadStatus)(self.downloadStatus);
//    }else {
//        return kCSMessageDownloadStatusNone;
//    }
    
    return (CSMessageDownloadStatus)(self.downloadStatus);
}

- (CSMessageDownloadStatus)thumbnailDownloadStatus {
    if (_thumbnailDownloadStatus != kCSMessageDownloadStatusNone)
        return _thumbnailDownloadStatus;
    if (_fromMe)
        return kCSMessageDownloadStatusSuccessed;
    
    switch (self.messageBodyType) {
        case kCSMessageBodyTypeImage: {
            
//            EMImageMessageBody *body = (EMImageMessageBody *)(_sdk_message.body);
            return (CSMessageDownloadStatus)self.thumbnailDownloadStatus;
        }
        case kCSMessageBodyTypeVideo: {
//            EMVideoMessageBody *body = (EMVideoMessageBody *)(_sdk_message.body);
            return (CSMessageDownloadStatus)self.thumbnailDownloadStatus;
        }
        default:
            return kCSMessageDownloadStatusNone;
    }
    
}

#pragma mark - MessageCell更新 -

- (void)setNeedsUpdateThumbnail {
    _updateType |= kCSMessageCellUpdateTypeThumbnailChanged;
}

- (void)setNeedsUpdateUploadStatus {
    _updateType |= kCSMessageCellUpdateTypeUploadStatusChanged;
}

- (void)setNeedsUpdateDownloadStatus {
    _updateType |= kCSMessageCellUpdateTypeDownloadStatusChanged;
}

- (void)setNeedsUpdateForReuse {
    _updateType |= kCSMessageCellUpdateTypeNewForReuse;
    _updateType |= (kCSMessageCellUpdateTypeNewForReuse - 1);
}

- (BOOL)checkNeedsUpdateThumbnail {
    return (_updateType & kCSMessageCellUpdateTypeThumbnailChanged) > 0;
}

- (BOOL)checkNeedsUpdateUploadStatus {
    return (_updateType & kCSMessageCellUpdateTypeUploadStatusChanged) > 0;
}

- (BOOL)checkNeedsUpdateDownloadStatus {
    return (_updateType & kCSMessageCellUpdateTypeDownloadStatusChanged) > 0;
}

- (BOOL)checkNeedsUpdateForReuse {
    return (_updateType & kCSMessageCellUpdateTypeNewForReuse) > 0;
}

- (BOOL)checkNeedsUpdate {
    return _updateType != kCSMessageCellUpdateTypeNone;
}

- (void)clearNeedsUpdateThumbnail {
    _updateType &= ~kCSMessageCellUpdateTypeThumbnailChanged;
}

- (void)clearNeedsUpdateUploadStatus {
    _updateType &= ~kCSMessageCellUpdateTypeUploadStatusChanged;
}

- (void)clearNeedsUpdateDownloadStatus {
    _updateType &= ~kCSMessageCellUpdateTypeDownloadStatusChanged;
}

- (void)clearNeedsUpdateForReuse {
    _updateType = kCSMessageCellUpdateTypeNone;
}

#pragma mark - 辅助 -

- (long long)fileAttachmentSize {
//    switch (_messageBodyType) {
//        case kLLMessageBodyTypeImage:
//        case kLLMessageBodyTypeVideo:
//        case kLLMessageBodyTypeFile:
//            return ((EMFileMessageBody *)(_sdk_message.body)).fileLength;
//            
//        default:
//            return 0;
//    }
    DLog(@"计算文集大小,未实现");
    return 100;
}

- (BOOL)isVideoPlayable {
    DLog(@"监测是否可以播放,未实现");
    return YES;
//    return (_sdk_message.body.type == EMMessageBodyTypeVideo) && (self.fromMe || self.messageDownloadStatus == kLLMessageDownloadStatusSuccessed);
}

- (BOOL)isFullImageAvailable {
    DLog(@"监测是否可以播放,未实现");
    return  YES;
//    return (_sdk_message.body.type == EMMessageBodyTypeImage) && (self.fromMe || self.messageDownloadStatus == kLLMessageDownloadStatusSuccessed);
}

- (BOOL)isVoicePlayable {
    DLog(@"监测是否可以播放,未实现");
    return YES;
//    return (_sdk_message.body.type == EMMessageBodyTypeVoice) && (self.fromMe || self.messageDownloadStatus == kLLMessageDownloadStatusSuccessed);
}

#pragma mark - 数据预处理

+ (NSString *)messageTypeTitle:(EMMessage *)message {
    NSString *typeTitle;
    
    switch (message.body.type) {
        case EMMessageBodyTypeText:{
            if ([message.ext[MESSAGE_EXT_TYPE_KEY] isEqualToString:MESSAGE_EXT_GIF_KEY]) {
                typeTitle = @"动画表情";
            }else {
                EMTextMessageBody *body = (EMTextMessageBody *)message.body;
                typeTitle = body.text;
            }
            break;
        }
        case EMMessageBodyTypeImage:
            typeTitle = @"[图片]";
            break;
        case EMMessageBodyTypeVideo:
            typeTitle = @"[视频]";
            break;
        case EMMessageBodyTypeLocation:
            typeTitle = @"[位置]";
            break;
        case EMMessageBodyTypeVoice:
            typeTitle = @"[语音]";
            break;
        case EMMessageBodyTypeFile:
            if ([message.ext[MESSAGE_EXT_TYPE_KEY] isEqualToString:MESSAGE_EXT_LOCATION_KEY]) {
                typeTitle = @"位置";
            }else {
                typeTitle = @"文件";
            }
            break;
        case EMMessageBodyTypeCmd:
            typeTitle = @"[CMD]";
            break;
            
    }
    
    return typeTitle;
}



- (void)processModelForCell {
    DLog(@"cell 高度,未实现");
    switch (CS_changeMessageType(self.msgType)) {
        case kCSMessageBodyTypeText: {
            if ([self.ext[MESSAGE_EXT_TYPE_KEY] isEqualToString:MESSAGE_EXT_GIF_KEY]) {
                
                self.text = [NSString stringWithFormat:@"[%@]", self.content];
                _messageBodyType = kCSMessageBodyTypeGif;
                self.cellHeight = [LLMessageGifCell heightForModel:self];
                
            }else {
                
                self.text = self.content;
                self.attributedText = [LLSimpleTextLabel createAttributedStringWithEmotionString:self.content font:[LLMessageTextCell font] lineSpacing:0];
                
                self.cellHeight = [LLMessageTextCell heightForModel:self];
            }
            
        }
            break;
        case kCSMessageBodyTypeDateTime:
            self.cellHeight = [LLMessageDateCell heightForModel:self];
            break;
        case kCSMessageBodyTypeImage:{
//            EMImageMessageBody *imgMessageBody;
            DLog(@"图片尺寸");
            self.thumbnailImageSize = [LLMessageImageCell thumbnailSize:CGSizeMake(100, 100)];
//            self.fileLocalPath = imgMessageBody.localPath;
            self.cellHeight = [LLMessageImageCell heightForModel:self];
            break;
        }
        case kCSMessageBodyTypeFile:
        case kCSMessageBodyTypeLocation: {
//            NSDictionary *messageExt = self.sdk_message.ext;
//            
//            if ([messageExt[MESSAGE_EXT_TYPE_KEY] isEqualToString:MESSAGE_EXT_LOCATION_KEY]) {
//                _messageBodyType = kCSMessageBodyTypeLocation;
//                [[LLChatManager sharedManager] decodeMessageExtForLocationType:self];
////                EMFileMessageBody *body = (EMFileMessageBody *)self.sdk_message.body;
//                
//                self.fileLocalPath = body.localPath;
//                self.cellHeight = [LLMessageLocationCell heightForModel:self];
//            }
            
            break;
        }
        case kCSMessageBodyTypeVoice: {
//            EMVoiceMessageBody *voiceBody = (EMVoiceMessageBody *)self.sdk_message.body;
//            self.mediaDuration = voiceBody.duration;
//            self.isMediaPlayed = NO;
//            self.isMediaPlaying = NO;
//            if (_sdk_message.ext) {
//                self.isMediaPlayed = [_sdk_message.ext[@"isPlayed"] boolValue];
//            }
            // 音频路径
//            self.fileLocalPath = voiceBody.localPath;
            DLog(@"音频未实现");
            self.cellHeight = [LLMessageVoiceCell heightForModel:self];
            
            break;
        }
        case kCSMessageBodyTypeVideo: {
//            EMVideoMessageBody *videoBody = (EMVideoMessageBody *)self.sdk_message.body;
//            // 视频路径
//            self.fileLocalPath = videoBody.localPath;
//            self.thumbnailImageSize = [LLMessageVideoCell thumbnailSize:videoBody.thumbnailSize];
//            self.mediaDuration = videoBody.duration;
//            self.fileSize = videoBody.fileLength;
//            self.cellHeight = [LLMessageVideoCell heightForModel:self];
            
            break;
        }
            
        case kCSMessageBodyTypeGif:
            self.cellHeight = [LLMessageGifCell heightForModel:self];
            break;
        default:
            break;
            
    }
    
}

- (void)cleanWhenConversationSessionEnded {
    _gifShowIndex = 0;
    if (_isMediaPlaying) {
        _isMediaPlaying = NO;
        _isMediaPlayed = YES;
    }
    _isFetchingAddress = NO;
}
@end

@implementation CSMessageBodyModel



@end

@implementation CSUnreadListModel



@end
