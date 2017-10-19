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
#import "CSUploadFileModel.h"

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

@property(nonatomic,copy)CS_MESSAGE_UPLOAD_STATUS cs_upload_status;
@property(nonatomic,copy)CS_MESSAGE_UPLOAD_PROGRESS cs_upload_progress;

@property(nonatomic,strong)NSData * tempImageData;
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
    if (self.msgType == CSMessageBodyTypeVoice) {
        [param setObject:@(self.mediaDuration) forKey:@"voice_length"];
    }
    if (self.msgType == CSMessageBodyTypeImage) {
        [param setObject:@(self.body.img_width) forKey:@"img_width"];
        [param setObject:@(self.body.img_height) forKey:@"img_height"];
    }
    return param;
}

- (void)formaterMessage
{
    self.body = [CSMessageBodyModel mj_objectWithKeyValues:self.mj_keyValues];
//    self.body.msgType = self.msgType;

}

+ (void)initialize {
    if (self == [CSMessageModel class]) {
        tmpImageDict = [NSMutableDictionary dictionary];
    }
}

#pragma mark - 消息初始化 -
+ (CSMessageModel *)sendImageMessageWithImageData:(NSData *)imageData
                                        imageSize:(CGSize)imageSize
                                           chatId:(NSString *)chatId
                                         chatType:(CSChatType)chatType
                                          msgType:(CSMessageBodyType)msgBodyType
                                           action:(int)action
                                          content:(NSString *)content
                                   uploadProgress:(CS_MESSAGE_UPLOAD_PROGRESS)cs_uploadProgress
                                     uploadStatus:(CS_MESSAGE_UPLOAD_STATUS)cs_uploadStatus
                                           isSelf:(BOOL)isSelf
{
    CSMessageModel * model = [[CSMessageModel alloc]initNewMessageChatType:chatType chatId:chatId msgId:nil msgType:msgBodyType action:action content:content isSelf:isSelf];
    model.tempImageData = imageData;
    model.thumbnailImage = [UIImage imageWithData:imageData];
    model.thumbnailImageSize = imageSize;
    
    [model formaterMessage];
    model.body.img_width = imageSize.width;
    model.body.img_height =  imageSize.height;
    
    [model cs_uploadImageUploadProgress:cs_uploadProgress uploadStatus:cs_uploadStatus];
    
    return model;
}

- (void)cs_uploadImageUploadProgress:(CS_MESSAGE_UPLOAD_PROGRESS)cs_uploadProgress
                        uploadStatus:(CS_MESSAGE_UPLOAD_STATUS)cs_uploadStatus
{
    //#FIXME:发送拍摄照片正在处理
    WEAKSELF;
    
    [CSHttpRequestManager upLoadFileRequestParamters:nil fileData:self.tempImageData fileType:(CS_UPLOAD_FILE_IMAGE) success:^(id responseObject) {
        CSUploadFileModel * obj = [CSUploadFileModel mj_objectWithKeyValues:responseObject];
        weakSelf.content = obj.result.file_url;
        weakSelf.body.content = obj.result.file_url;
        //                 messageRequest.body.body.content
        self.tempImageData = nil;
        if (cs_uploadStatus) {
            cs_uploadStatus(weakSelf,nil);
        }
    } failure:^(NSError *error) {
        if (cs_uploadStatus) {
            cs_uploadStatus(weakSelf,error);
        }
    } uploadprogress:^(CGFloat uploadProgress) {
        if (cs_uploadProgress) {
            cs_uploadProgress(uploadProgress);
        }
        
    } showHUD:NO];
}

+ (CSMessageModel *)newImageMessageWithImageSize:(CGSize)imageSize
                                          chatId:(NSString *)chatId
                                        chatType:(CSChatType)chatType
                                           msgId:(NSString *)msgId
                                         msgType:(CSMessageBodyType)msgBodyType
                                          action:(int)action
                                         content:(NSString *)content
                                          isSelf:(BOOL)isSelf
{
    CSMessageModel * model = [[CSMessageModel alloc]initNewMessageChatType:chatType chatId:chatId msgId:msgId msgType:msgBodyType action:action content:content isSelf:isSelf];
//    model.thumbnailImage = [UIImage imageWithData:imageData];
    if ([content hasSuffix:@".gif"]) {
        [model syncMessageBodyType:CSMessageBodyTypeGif];
        model.msgType = CSMessageBodyTypeGif;
        model.body.msgType = CSMessageBodyTypeGif;
    }
    model.thumbnailImageSize = [LLMessageImageCell thumbnailSize:imageSize];
    [model formaterMessage];
    model.body.img_width = imageSize.width;
    model.body.img_height =  imageSize.height;
    return model;
}
+ (CSMessageModel *)newLinkImageMessageWithImageSize:(CGSize)imageSize
                                              chatId:(NSString *)chatId
                                            chatType:(CSChatType)chatType
                                               msgId:(NSString *)msgId
                                             msgType:(CSMessageBodyType)msgBodyType
                                              action:(int)action
                                             content:(NSString *)content
                                             linkUrl:(NSString*)linkUrl
                                              isSelf:(BOOL)isSelf
{
    CSMessageModel * model = [[CSMessageModel alloc]initNewMessageChatType:chatType chatId:chatId msgId:msgId msgType:msgBodyType action:action content:content isSelf:isSelf];
    //    model.thumbnailImage = [UIImage imageWithData:imageData];
//    if ([content hasSuffix:@".gif"]) {
//        [model syncMessageBodyType:CSMessageBodyTypeGif];
//        model.msgType = CSMessageBodyTypeGif;
//        model.body.msgType = CSMessageBodyTypeGif;
//    }
    model.thumbnailImageSize = [LLMessageImageCell thumbnailSize:imageSize];
    model.linkUrl = linkUrl;
    [model formaterMessage];
    model.body.img_width = imageSize.width;
    model.body.img_height =  imageSize.height;
    return model;
}
+ (CSMessageModel *)newVoiceMessageChatType:(CSChatType)chatType
                                chatId:(NSString *)chatId
                                 msgId:(NSString *)msgId
                               msgType:(CSMessageBodyType)msgType
                                action:(int)action
                               content:(NSString *)content
                             localPath:(NSString *)localPath
                              duration:(NSInteger)duration
                         uploadProgress:(CS_MESSAGE_UPLOAD_PROGRESS)uploadProgress
                           uploadStatus:(CS_MESSAGE_UPLOAD_STATUS)uploadStatus
                                 isSelf:(BOOL)isSelf
{
    CSMessageModel * model = [[CSMessageModel alloc]initNewMessageChatType:chatType chatId:chatId msgId:msgId msgType:msgType action:action content:content isSelf:isSelf];
    
    
    model.mediaDuration = duration;
    model.fileLocalPath = localPath;

    [model formaterMessage];
    return model;

}

- (void)cs_checkParams
{
    self.isSelf = NO;
    _messageStatus = kCSMessageStatusSuccessed;
    _messageDownloadStatus = kCSMessageDownloadStatusSuccessed;
    _thumbnailDownloadStatus = kCSMessageDownloadStatusWaiting;
    
    if ([self.body.content hasSuffix:@".gif"]) {
//        [self syncMessageBodyType:CSMessageBodyTypeGif];
        self.msgType = CSMessageBodyTypeGif;
        self.body.msgType = CSMessageBodyTypeGif;
    }
    if (self.body.msgType == CSMessageBodyTypeImage |
        self.body.msgType == CSMessageBodyTypeGif |
        self.body.msgType == CSMessageBodyTypeLink) {
        self.thumbnailImageSize = [LLMessageImageCell thumbnailSize:CGSizeMake(self.body.img_width, self.body.img_height)];
    }
    [self syncMessageBodyType:CS_changeMessageType(self.body.msgType)];
    [self processModelForCell];
}

+ (CSMessageModel*)newMessageChatType:(CSChatType)chatType
                  chatId:(NSString *)chatId
                   msgId:(NSString *)msgId
                 msgType:(CSMessageBodyType)msgType
                  action:(int)action
                 content:(NSString *)content
                  isSelf:(BOOL)isSelf
{
    CSMessageModel * messageModel = [[CSMessageModel alloc]initNewMessageChatType:chatType chatId:chatId msgId:msgId msgType:msgType action:action content:content isSelf:isSelf];
    
    return messageModel;
}

- (id)initNewMessageChatType:(CSChatType)chatType chatId:(NSString *)chatId msgId:(NSString *)msgId msgType:(CSMessageBodyType)msgType action:(int)action content:(NSString *)content isSelf:(BOOL)isSelf
{
    if (self = [super init]) {
        _messageBodyType = msgType;
        
        _messageStatus = kCSMessageStatusWaiting;
        _messageDownloadStatus = kCSMessageDownloadStatusSuccessed;
        _thumbnailDownloadStatus = kCSMessageDownloadStatusWaiting;
        switch (msgType) {
            case kCSMessageBodyTypeDateTime:
                self.cellHeight = [LLMessageDateCell heightForModel:self];
                break;
            case kCSMessageBodyTypeVoice:
                self.cellHeight = [LLMessageVoiceCell heightForModel:self];
                break;
            case kCSMessageBodyTypeRecording:
                self.isSelf = YES;
                self.timestamp = [NSString stringWithFormat:@"%d",[[NSDate date] timeIntervalSince1970]];
                self.cellHeight = [LLMessageRecordingCell heightForModel:self];
            default:
                break;
        }
        
        self.chartType = chatType;
        self.chatId = chatId;
        if (msgId) {
            self.msgId = msgId;
        }
        else
        {
            self.msgId = [NSDate date].timestamp;
            self.timestamp = self.msgId;
            self.msgCacheKey = self.msgId;
        }
        self.msgType = msgType;
        self.action = action;//普通消息
        self.msgType = msgType;
        self.content = content;


        
        _isSelf = isSelf;
        
        if (isSelf) {
            self.body.nickname = [CSUserInfo shareInstance].info.nickname;
            self.body.avatar = [CSUserInfo shareInstance].info.avatar;
        }

        _error = nil;
        [self formaterMessage];
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
        _isSelf = YES;
    }
    
    return self;
}

#pragma makr - create Image Model
//+ (CSMessageModel *)sendImageMessageWithData:(NSData *)imageData
//                                   imageSize:(CGSize)imageSize
//                                          to:(NSString *)toUser
//                                 messageType:(LLChatType)messageType
//                                  messageExt:(NSDictionary *)messageExt
//                                    progress:(void (^)(CSMessageModel *model, int progress))progress
//                                  completion:(void (^)(CSMessageModel *model, LLSDKError *error))completion {
//    
//    EMImageMessageBody *body = [[EMImageMessageBody alloc] initWithData:imageData displayName:@"image.png"];
//    body.size = imageSize;
//    
//    NSString *from = [[EMClient sharedClient] currentUsername];
//    EMMessage *message = [[EMMessage alloc] initWithConversationID:toUser from:from to:toUser body:body ext:messageExt];
//    message.chatType = (EMChatType)messageType;
//    
//    CSMessageModel *model = [LLMessageModel messageModelFromPool:message];
//    
//    
//    return model;
//}

+ (CSMessageModel*)sendBetMessageChatType:(CSChatType)chatType
                                   chatId:(NSString *)chatId
                                    msgId:(NSString *)msgId
                                  msgType:(CSMessageBodyType)msgType
                                  betType:(int)betType
                                betNumber:(int)betNumber
                                   action:(int)action
                                  content:(NSString *)content
                                   isSelf:(BOOL)isSelf
{
    CSMessageModel * messageModel = [[CSMessageModel alloc]initNewMessageChatType:chatType chatId:chatId msgId:msgId msgType:msgType action:action content:content isSelf:isSelf];
    messageModel.playType = betType;
    messageModel.score = betNumber;
    
    return messageModel;
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
                self.isSelf = YES;
                self.timestamp = [NSString stringWithFormat:@"%d",[[NSDate date] timeIntervalSince1970]];
                self.cellHeight = [LLMessageRecordingCell heightForModel:self];
            default:
                break;
        }
    }
    
    return self;
}

+ (CSMessageModel *)conversionWithRecordModel:(CSMsgRecordModel*)msgRecordModel
                                     chatType:(CSChatType)chatType
                                       chatId:(NSString *)chatId
{
    CSMessageModel * msgBody;
    
    switch ((CSMessageBodyType)msgRecordModel.type.integerValue) {
        case CSMessageBodyTypeText:
            msgBody = [CSMessageModel newMessageChatType:chatType chatId:chatId msgId:msgRecordModel.msg_id msgType:CSMessageBodyTypeText action:1 content:msgRecordModel.content isSelf:msgRecordModel.is_self.intValue];
            break;
            case CSMessageBodyTypeImage:
            msgBody = [CSMessageModel newImageMessageWithImageSize:CGSizeMake(msgRecordModel.img_width, msgRecordModel.img_height) chatId:chatId chatType:chatType msgId:msgRecordModel.msg_id msgType:(CSMessageBodyTypeImage) action:1 content:msgRecordModel.content isSelf:msgRecordModel.is_self.intValue];
//                       newMessageChatType:chatType chatId:chatId msgId:msgRecordModel.msg_id msgType:CSMessageBodyTypeImage action:1 content:msgRecordModel.content];
            break;
            case CSMessageBodyTypeVoice:
            msgBody = [CSMessageModel newVoiceMessageChatType:chatType chatId:chatId msgId:msgRecordModel.msg_id msgType:CSMessageBodyTypeVoice action:1 content:msgRecordModel.content localPath:nil duration:msgRecordModel.voice_length uploadProgress:nil uploadStatus:nil isSelf:msgRecordModel.is_self.intValue];
            break;
            case CSMessageBodyTypeLink:
            msgBody = [CSMessageModel newLinkImageMessageWithImageSize:CGSizeMake(msgRecordModel.img_width, msgRecordModel.img_height) chatId:chatId chatType:chatType msgId:msgRecordModel.msg_id msgType:(CSMessageBodyTypeImage) action:1 content:msgRecordModel.content
                                                           linkUrl:msgRecordModel.linkUrl isSelf:msgRecordModel.is_self.intValue];
            break;
        default:
            break;
    }
    [msgBody internal_setMessageStatus:(kCSMessageStatusSuccessed)];
    
    msgBody.body.avatar = msgRecordModel.avatar;
    msgBody.body.nickname = msgRecordModel.nickname;
    
    return msgBody;
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
//    _isSelf = _sdk_message.direction == EMMessageDirectionSend;
//    
//    _updateType = kLLMessageCellUpdateTypeNewForReuse;
//    
//    //    if (_isSelf) {
//    _timestamp = adjustTimestampFromServer(message.timestamp);
//    //    }else {
//    //        _timestamp = adjustTimestampFromServer(message.serverTime);
//    //    }
//    
//    _ext = message.ext;
//    _error = nil;
    
    [self processModelForCell];
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
    
//    if (self.messageBodyType == kLLMessageBodyTypeImage) {
//        EMImageMessageBody *imgMessageBody = (EMImageMessageBody *)self.sdk_message.body;
//        if (_isSelf || imgMessageBody.downloadStatus == EMDownloadStatusSuccessed) {
//            UIImage *fullImage = [UIImage imageWithContentsOfFile:imgMessageBody.localPath];
//            return fullImage;
//        }
//    }
    
    return self.thumbnailImage;
}

//- (UIImage *)thumbnailImage {
//
//    return _thumbnailImage;
//}


- (UIImage *)thumbnailImage {
    
    
    if (!_thumbnailImage) {
//        UIImageView * tempView = [UIImageView new];
//        [tempView yy_setImageWithURL:self.body.content options:YYWebImageOptionShowNetworkActivity];
//        _thumbnailImage = tempView.image;
//        if (_thumbnailImage)
//            return _thumbnailImage;
        
        UIImage *thumbnailImage = [UIImageView new];;
        BOOL needSaveToCache = NO;
        BOOL needSaveToDisk = NO;
        BOOL needSaveToTemp = NO;
        switch (self.messageBodyType) {
            case kCSMessageBodyTypeImage:{
//                EMImageMessageBody *imgMessageBody = (EMImageMessageBody *)self.sdk_message.body;
                
                self.thumbnailImageSize = [LLMessageImageCell thumbnailSize:self.thumbnailImageSize];
                
//                if (_isSelf || imgMessageBody.downloadStatus == EMDownloadStatusSuccessed) {
//                    UIImage *fullImage = [UIImage imageWithContentsOfFile:imgMessageBody.localPath];
//                    _thumbnailImageSize = [LLMessageImageCell thumbnailSize:fullImage.size];
//                    thumbnailImage = [fullImage resizeImageToSize:self.thumbnailImageSize opaque:YES scale:0];
//
//                    needSaveToCache = YES;
//                    needSaveToDisk = YES;
//                }else if (imgMessageBody.thumbnailDownloadStatus == EMDownloadStatusSuccessed) {
//                    UIImage *image = [UIImage imageWithContentsOfFile:imgMessageBody.thumbnailLocalPath];
//                    _thumbnailImageSize = [LLMessageImageCell thumbnailSize:image.size];
//                    thumbnailImage = [image resizeImageToSize:self.thumbnailImageSize opaque:YES scale:0];
//
//                    needSaveToTemp = YES;
//                }
//                FIXME:对于特殊图，比如超长、超宽、超小图，应该做特殊处理
//                调用该方法createWithImageInRect后，VM：raster data内存没有变化
//                以后再解决这个问题
                                if (_thumbnailImageSize.height > 2 * IMAGE_MAX_SIZE) {
                                    _thumbnailImage = [_thumbnailImage createWithImageInRect:CGRectMake(0, (_thumbnailImageSize.height - IMAGE_MAX_SIZE) / 2 * _thumbnailImage.scale, _thumbnailImageSize.width * _thumbnailImage.scale, IMAGE_MAX_SIZE * _thumbnailImage.scale)];
                                }else if (_thumbnailImageSize.width > 2 * IMAGE_MAX_SIZE) {
                                    _thumbnailImage = [_thumbnailImage createWithImageInRect:CGRectMake((_thumbnailImageSize.width - IMAGE_MAX_SIZE)/2 * _thumbnailImage.scale, 0, IMAGE_MAX_SIZE * _thumbnailImage.scale, _thumbnailImageSize.height * _thumbnailImage.scale)];
                                }
                
                break;
            }

                
            default:
                break;
        }
        
//        if (thumbnailImage) {
//            if (needSaveToTemp) {
//                tmpImageDict[_messageId] = thumbnailImage;
//            }else if (needSaveToCache) {
//                tmpImageDict[_messageId] = nil;
//                [[LLMessageThumbnailManager sharedManager] addThumbnailForMessageModel:self thumbnail:thumbnailImage toDisk:needSaveToDisk];
//            }
//        }
        
        _thumbnailImage = thumbnailImage;
    }
    
//    _thumbnailImage = [UIImage new];
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

- (void)internal_setMessageStatus:(CSMessageStatus)messageStatus {
    _messageStatus = messageStatus;
}

- (void)internal_setMessageDownloadStatus:(CSMessageDownloadStatus)messageDownloadStatus {
    _messageDownloadStatus = messageDownloadStatus;
}

- (void)internal_setThumbnailDownloadStatus:(CSMessageDownloadStatus)thumbnailDownloadStatus {
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
//同步 body  type
- (void)syncMessageBodyType:(kCSMessageBodyType)type
{
    _messageBodyType = type;
}
- (void)syncMessageSendStatus:(CSMessageStatus)status
{
    _messageStatus = status;
}

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
    if (_isSelf)
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
    switch (_messageBodyType) {
        case kCSMessageBodyTypeImage:
        case kCSMessageBodyTypeVideo:
        case kCSMessageBodyTypeFile:
            return [LLUtils getFileSize:self.fileLocalPath];
//            ((EMFileMessageBody *)(_sdk_message.body)).fileLength;
            
        default:
            return 0;
    }
    DLog(@"计算文集大小,未实现");
    return 100;
}

- (BOOL)isVideoPlayable {
    
    return (self.body.msgType == CSMessageBodyTypeVideo) && (self.isSelf || self.messageDownloadStatus == kCSMessageDownloadStatusSuccessed);
//    return YES;
//    return (_sdk_message.body.type == EMMessageBodyTypeVideo) && (self.isSelf || self.messageDownloadStatus == kLLMessageDownloadStatusSuccessed);
}

- (BOOL)isFullImageAvailable {
    
    return (self.body.msgType == CSMessageBodyTypeImage) && (self.isSelf || self.messageDownloadStatus == kCSMessageDownloadStatusSuccessed);
    //    return  YES;
//    return (_sdk_message.body.type == EMMessageBodyTypeImage) && (self.isSelf || self.messageDownloadStatus == kLLMessageDownloadStatusSuccessed);
}

- (BOOL)isVoicePlayable {
    
     return (self.body.msgType == CSMessageBodyTypeVoice) && (self.messageDownloadStatus == kCSMessageDownloadStatusSuccessed) && (self.fileLocalPath.length);
//    return (self.body.msgType == CSMessageBodyTypeVoice) && (self.isSelf || self.messageDownloadStatus == kCSMessageDownloadStatusSuccessed);
//    return YES;
//    return (_sdk_message.body.type == EMMessageBodyTypeVoice) && (self.isSelf || self.messageDownloadStatus == kLLMessageDownloadStatusSuccessed);
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
    
    switch (CS_changeMessageType(self.body.msgType)) {
        case kCSMessageBodyTypeText: {
            if ([self.ext[MESSAGE_EXT_TYPE_KEY] isEqualToString:MESSAGE_EXT_GIF_KEY]) {
                
                self.text = [NSString stringWithFormat:@"[%@]", self.body.content];
                _messageBodyType = kCSMessageBodyTypeGif;
                self.cellHeight = [LLMessageGifCell heightForModel:self];
                
            }else {
                
                self.text = self.body.content;
                self.attributedText = [LLSimpleTextLabel createAttributedStringWithEmotionString:self.body.content font:[LLMessageTextCell font] lineSpacing:0];
                
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
            //FIXME: 宽高写死要改
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
