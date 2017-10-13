//
//  CSMessageModel.h
//  TestChat
//
//  Created by cnepayzx on 2017/9/27.
//  Copyright © 2017年 bingtianyu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EMTextMessageBody.h"
#import "EMMessage.h"
#import "EMImageMessageBody.h"
#import "EMSDK.h"

#import "LLSDKError.h"
#import "LLSDKType.h"
#import <MapKit/MapKit.h>
#import "CSMsgRecordModel.h"

@class CSMessageBodyModel;
@class CSUnreadListModel;

/*!
 *  \~chinese
 *  聊天类型
 *
 *  \~english
 *  Chat type
 */
typedef enum{
    CSChatTypeGroupChat = 1,    /*! \~chinese 群聊消息 \~english Group chat */
    CSChatTypeChat   ,   /*! \~chinese 单聊消息 \~english Chat */
//    CSChatTypeChatRoom,     /*! \~chinese 聊天室消息 \~english Chatroom chat */
}CSChatType;
/*!
 *  \~chinese
 *  消息体类型
 *
 *  \~english
 *  Message body type
 */
typedef enum{
    CSMessageBodyTypeText   = 1,    /*! \~chinese 文本类型 \~english Text */
    CSMessageBodyTypeImage,         /*! \~chinese 图片类型 \~english Image */
    CSMessageBodyTypeVoice,         /*! \~chinese 语音类型 \~english Voice */
    CSMessageBodyTypeLink,          /*! \~chinese 外部链接类型 \~english Video */
    CSMessageBodyTypeVideo,         /*! \~chinese 视频类型 \~english Video */
    CSMessageBodyTypeLocation,      /*! \~chinese 位置类型 \~english Location */
    CSMessageBodyTypeFile,          /*! \~chinese 文件类型 \~english File */
    CSMessageBodyTypeCmd,           /*! \~chinese 命令类型 \~english Cmd */
}CSMessageBodyType;
////:1|2|3|4, 1,文字 2,图片 3,语音, 4点击跳转外部连接 // action=4 需要

/*!
 *  \~chinese
 *  附件下载状态
 *
 *  \~english
 *  Download status of attachment
 */
typedef enum{
    CSDownloadStatusDownloading   = 0,  /*! \~chinese 正在下载 \~english Downloading */
    CSDownloadStatusSuccessed,          /*! \~chinese 下载成功 \~english Successed */
    CSDownloadStatusFailed,             /*! \~chinese 下载失败 \~english Failed */
    CSDownloadStatusPending,            /*! \~chinese 准备下载 \~english Pending */
}CSDownloadStatus;


typedef NS_ENUM(NSInteger, kCSMessageBodyType) {
    kCSMessageBodyTypeText = CSMessageBodyTypeText,
    kCSMessageBodyTypeImage = CSMessageBodyTypeImage,
    kCSMessageBodyTypeVideo = CSMessageBodyTypeVideo,
    kCSMessageBodyTypeLink = CSMessageBodyTypeLink,
    kCSMessageBodyTypeVoice = CSMessageBodyTypeVoice,
    kCSMessageBodyTypeEMLocation = CSMessageBodyTypeLocation,
    kCSMessageBodyTypeFile = CSMessageBodyTypeFile,
    kCSMessageBodyTypeDateTime,
    kCSMessageBodyTypeGif,
    kCSMessageBodyTypeLocation,
    kCSMessageBodyTypeRecording, //表示正在录音的Cell
    
    
};

static inline kCSMessageBodyType CS_changeMessageType (CSMessageBodyType type){
    kCSMessageBodyType newType;
    switch (type) {
        case CSMessageBodyTypeText:
            newType = kCSMessageBodyTypeText;
            break;
        case CSMessageBodyTypeImage:
            newType = kCSMessageBodyTypeImage;
            break;
        case CSMessageBodyTypeVoice:
            newType = kCSMessageBodyTypeVoice;
            break;
        case CSMessageBodyTypeLink:
            newType = kCSMessageBodyTypeLink;
            break;
        default:
            break;
    }
    return newType;
}

typedef NS_ENUM(NSInteger, CSMessageDownloadStatus) {
    kCSMessageDownloadStatusDownloading ,
    kCSMessageDownloadStatusSuccessed ,
    kCSMessageDownloadStatusFailed ,
    kCSMessageDownloadStatusPending ,
    kCSMessageDownloadStatusWaiting ,
    kCSMessageDownloadStatusNone
};

typedef NS_ENUM(NSInteger, CSMessageStatus) {
    kCSMessageStatusPending,
    kCSMessageStatusDelivering,
    kCSMessageStatusSuccessed,
    kCSMessageStatusFailed ,
    kCSMessageStatusWaiting ,
    kCSMessageStatusNone
};

//typedef NS_ENUM(NSInteger, CSChatType) {
//    kLLChatTypeChat   = EMChatTypeChat,   /*! \~chinese 单聊消息 \~english Chat */
//    kLLChatTypeGroupChat = EMChatTypeGroupChat,
//    kLLChatTypeChatRoom = EMChatTypeChatRoom
//};
//
//typedef NS_ENUM(NSInteger, LLConversationType) {
//    kLLConversationTypeChat = EMConversationTypeChat,
//    kLLConversationTypeGroupChat = EMConversationTypeGroupChat,
//    kLLConversationTypeChatRoom = EMConversationTypeChatRoom
//};
//
//typedef NS_ENUM(NSInteger, LLMessageDirection) {
//    kCSMessageDirectionSend = CSMessageDirectionSend,
//    kCSMessageDirectionReceive = CSMessageDirectionReceive
//};

//static inline CSChatType CS_chatTypeForConversationType(LLConversationType conversationType) {
//    switch (conversationType) {
//        case kCSConversationTypeChat:
//            return kCSChatTypeChat;
//        case kCSConversationTypeChatRoom:
//            return kCSChatTypeChatRoom;
//        case kCSConversationTypeGroupChat:
//            return kCSChatTypeGroupChat;
//    }
//}

@interface CSMessageModel : NSObject

/**
 *  将消息转换成约定格式发送给服务端
 */
- (NSDictionary *)changeParams;

/**
 *  计算数据高度
 */
- (void)processModelForCell;

/**
 同步 message body type

 @param type <#type description#>
 */
- (void)syncMessageBodyType:(kCSMessageBodyType)type;

- (void)syncMessageSendStatus:(CSMessageStatus)status;


- (void)internal_setMessageDownloadStatus:(CSMessageDownloadStatus)messageDownloadStatus;

- (void)internal_setThumbnailDownloadStatus:(CSMessageDownloadStatus)thumbnailDownloadStatus;

- (void)internal_setIsFetchingAttachment:(BOOL)isFetchingAttachment;

- (void)internal_setIsFetchingThumbnail:(BOOL)isFetchingThumbnail;

@property (nonatomic,assign) BOOL isSelf;
//展示消息的CellHeight，计算一次，然后缓存
@property (nonatomic) CGFloat cellHeight;

@property (nonatomic, copy, readonly) NSString *messageId;
//@property (nonatomic, copy, readonly) NSString *chatid;

//消息发送方
@property (nonatomic, copy) NSString *from;
//消息接收方
@property (nonatomic, copy) NSString *to;

@property (nonatomic, getter=isFromMe) BOOL fromMe;

@property (nonatomic, readonly) kCSMessageBodyType messageBodyType;

@property (nonatomic,copy) NSString *timestamp;

@property (nonatomic) NSString *text;

@property (nonatomic) NSMutableAttributedString *attributedText;

@property (nonatomic) NSDictionary *ext;

//@property (nonatomic) LLMessageCellUpdateType updateType;

//消息即将被删除
@property (nonatomic) BOOL isDeleting;

//GIF动画停止时，显示的照片索引。在恢复动画时，从此帧开始播放
@property (nonatomic) NSInteger gifShowIndex;

#pragma mark - 图片消息

@property (nonatomic, weak) UIImage *thumbnailImage;

@property (nonatomic) CGSize thumbnailImageSize;

- (UIImage *)fullImage;

#pragma mark - 地址消息

@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *locationName;

@property (nonatomic) CLLocationCoordinate2D coordinate2D;
@property (nonatomic) BOOL defaultSnapshot;
@property (nonatomic) CGFloat snapshotScale;
@property (nonatomic) CGFloat zoomLevel;

@property (nonatomic) BOOL isFetchingAddress;

#pragma mark - 音频、视频

@property (nonatomic) BOOL isMediaPlaying;

@property (nonatomic) BOOL isMediaPlayed;

@property (nonatomic) BOOL needAnimateVoiceCell;

- (BOOL)isVideoPlayable;

- (BOOL)isFullImageAvailable;

- (BOOL)isVoicePlayable;

//单位为妙
@property (nonatomic) CGFloat mediaDuration;

@property (nonatomic) BOOL isSelected;

#pragma mark - 附件、文件
//附件下载地址
@property (nonatomic, copy) NSString *fileRemotePath;
//附件本地地址
@property (nonatomic, copy) NSString *fileLocalPath;
//单位为字节
@property (nonatomic) long long fileSize;
//附件上传进度，范围为0--100
@property (nonatomic) NSInteger fileUploadProgress;
//附件下载进度，范围为0--100
@property (nonatomic) NSInteger fileDownloadProgress;
/*!
 *  \~chinese
 *  附件的下载状态
 *
 *  \~english
 *  Download status of attachment
 */
@property (nonatomic) CSDownloadStatus downloadStatus;

@property (nonatomic, readonly) BOOL isFetchingThumbnail;

@property (nonatomic, readonly) BOOL isFetchingAttachment;

@property (nonatomic) LLSDKError *error;

/**
 缓存消息Key
 */
@property(nonatomic,copy)NSString * msgCacheKey;
//该方法供外部代码调用
//+ (LLMessageModel *)messageModelFromPool:(EMMessage *)message;

- (instancetype)initWithType:(CSMessageBodyType)type;

- (CSMessageModel *)sendVoiceMessageWithLocalPath:(NSString *)localPath
                                         duration:(NSInteger)duration
                                               to:(NSString *)to
                                      messageType:(CSChatType)messageType
                                          msgType:(CSMessageBodyType)msgBodyType
                                       messageExt:(nullable NSDictionary *)messageExt
                                       completion:(void (^ __nullable)(CSMessageModel *model, NSError *error))completion;

+ (CSMessageModel*)newMessageChatType:(CSChatType)chatType
                  chatId:(NSString *)chatId
                   msgId:(NSString *)msgId
                 msgType:(CSMessageBodyType)msgType
                  action:(int)action
                 content:(NSString *)content;

- (id)initNewMessageChatType:(CSChatType)chatType
                  chatId:(NSString *)chatId
                   msgId:(NSString *)msgId
                 msgType:(CSMessageBodyType)msgType
                  action:(int)action
                 content:(NSString *)content;

+ (CSMessageModel *)newVoiceMessageChatType:(CSChatType)chatType
                                     chatId:(NSString *)chatId
                                      msgId:(NSString *)msgId
                                    msgType:(CSMessageBodyType)msgType
                                     action:(int)action
                                    content:(NSString *)content
                                  localPath:(NSString *)localPath
                                   duration:(NSInteger)duration
                                 messageExt:(nullable NSDictionary *)messageExt
                                 completion:(void (^ __nullable)(CSMessageModel *model, NSError *error))completion;

//+ (CSMessageModel *)conversionWithRecordModel1:(CSMsgRecordModel*)msgRecordModel
//                                         chatType:(CSChatType)chatType
//                                       chatId:(NSString*)chatId;



+ (CSMessageModel *)conversionWithRecordModel:(CSMsgRecordModel*)msgRecordModel chatType:(CSChatType)chatType chatId:(NSString *)chatId;

+ (NSString *)messageTypeTitle:(EMMessage *)message;

- (long long)fileAttachmentSize;

- (void)cleanWhenConversationSessionEnded;
/**
 格式化请求参数
 */
- (void)formaterMessage;
#pragma mark - 消息状态 -
@property (nonatomic, readonly) CSMessageStatus messageStatus;

@property (nonatomic, readonly) CSMessageDownloadStatus messageDownloadStatus;

@property (nonatomic, readonly) CSMessageDownloadStatus thumbnailDownloadStatus;

#pragma mark - MessageCell 更新
#pragma mark 因为APP有消息缓存(默认1300条)，所以减少重复计算是有必要的 -

- (void)setNeedsUpdateThumbnail;

- (void)setNeedsUpdateUploadStatus;

- (void)setNeedsUpdateDownloadStatus;

- (void)setNeedsUpdateForReuse;

- (BOOL)checkNeedsUpdateThumbnail;

- (BOOL)checkNeedsUpdateUploadStatus;

- (BOOL)checkNeedsUpdateDownloadStatus;

- (BOOL)checkNeedsUpdateForReuse;

- (BOOL)checkNeedsUpdate;

- (void)clearNeedsUpdateThumbnail;

- (void)clearNeedsUpdateUploadStatus;

- (void)clearNeedsUpdateDownloadStatus;

- (void)clearNeedsUpdateForReuse;


/*-----------------------------------------以下为消息体-------------------------------------*/
//:1|2, //1,群聊 2,单聊
@property(nonatomic,assign)CSChatType chartType;
//: 1|2 //消息接收方用户类型 1 代表 普通用户 2 代表 系统客户（主持人） //chartType == 2 && action ==4 需要
@property(nonatomic,assign)int receiveUserType;
//如果chartType=1 代表群组id 如果chartType=2 代表用户id
@property(nonatomic,copy)NSString* chatId;
//消息id （如果action=1 不需要， =2 || ==5 代表服务器返回的消息自增id, ==3 || ==4 代表客户端生成的唯一id  *
@property(nonatomic,copy)NSString * msgId;
// 1、普通消息 2、消息回执 3、路单图片 4、连接成功回执 5、用户上线 6 、用户下线
@property(nonatomic,assign)int action;
//:1|2|3|4, 1,文字 2,图片 3,语音, 4点击跳转外部连接 // action=4 需要
@property(nonatomic,assign)CSMessageBodyType msgType;
//"消息内容" // action=3 || ==4 需要
@property(nonatomic,copy)NSString * content;
//后台客服或者主持人发消息的时候需要，前台用不到 可以忽略;
@property(nonatomic,copy)NSString * linkUrl;

//1|2|3|4|5|6|7 //玩法 1、庄 2、闲 3、和 4、庄对 5、闲对 6、双对（庄对、闲对） 7、三宝（闲对、庄对、和）
@property(nonatomic,assign)int playType;
//:100 //下注分数 action=2 需要
@property(nonatomic,assign)int score;


/*---------------------------服务端发给客户端-----------------------------------*/
//@property(nonatomic,copy)NSString * msg;
//@property(nonatomic,assign)int code;
//回执ID
@property(nonatomic,copy)NSString * receiptId;
@property(nonatomic,strong)NSArray<CSUnreadListModel*> * unreadList;
@property(nonatomic,strong)CSMessageBodyModel * body;
@end

@interface CSMessageBodyModel : NSObject
//:1|2|3|4, //1,文字 2,图片 3,语音, 4点击跳转外部连接
@property(nonatomic,assign)CSMessageBodyType msgType;
//"消息内容", //action==3 只需要content 和 linkUrl 其他不需要
@property(nonatomic,copy)NSString * content;

@property(nonatomic,copy)NSString * linkUrl;
// : 0 //未读消息条数
@property(nonatomic,assign)int unreadCount;
//:"", //头像地址
@property(nonatomic,copy)NSString * avatar;

@property(nonatomic,copy)NSString * nickname;
//发送时间
@property(nonatomic,copy)NSString * date;
//时间戳
@property (nonatomic,copy) NSString *timestamp;
@end

@interface CSUnreadListModel : NSObject
// chartType:1|2 //1,群聊 2,单聊
@property(nonatomic,assign)int chartType;
//:10 //未读数量
@property(nonatomic,assign)int count;
//如果chartType=1 代表群组id 如果chartType=2 代表用户id
@property(nonatomic,assign)int chatId;

@end
