//
//  LLChatViewController.m
//  LLWeChat
//
//  Created by GYJZH on 7/21/16.
//  Copyright © 2016 GYJZH. All rights reserved.
//

#import "LLChatViewController.h"
#import "LLConfig.h"
#import "LLMessageTextCell.h"
#import "LLMessageDateCell.h"
#import "LLMessageRecordingCell.h"
#import "LLChatInputView.h"
#import "LLChatManager.h"
#import "LLUtils.h"
#import "LLActionSheet.h"
#import "UIKit+LLExt.h"
#import "LLWebViewController.h"
#import "LLMessageImageCell.h"
#import "LLChatAssetDisplayController.h"
#import "LLImagePickerControllerDelegate.h"
#import "LLAssetManager.h"
#import "LLImagePickerController.h"
#import "LLMessageGifCell.h"
#import "LLGaoDeLocationViewController.h"
#import "LLMessageLocationCell.h"
#import "LLLocationShowController.h"
#import "LLAudioManager.h"
#import "LLMessageVoiceCell.h"
#import "LLMessageVideoCell.h"
#import "UIImagePickerController_L1.h"
#import "LLDeviceManager.h"
#import "LLChatVoiceTipView.h"
#import "LLMessageCellManager.h"
#import "LLChatMoreBottomBar.h"
#import "LLChatSharePanel.h"
#import "LLSightCapatureController.h"
#import "LLMessageCacheManager.h"
#import "LLConversationModelManager.h"
#import "LLGIFDisplayController.h"
#import "LLTextDisplayController.h"
#import "LLTextActionDelegate.h"
#import "LLUserProfile.h"
#import "LLNavigationController.h"
#import "MFMailComposeViewController_LL.h"
@import MediaPlayer;

#define BLACK_BAR_VIEW_TAG 1000
#define DIM_VIEW_TAG 1001

#define VIEW_BACKGROUND_COLOR kLLBackgroundColor_lightGray

#define TABLEVIEW_BACKGROUND_COLOR kLLBackgroundColor_lightGray
#import "LBPhotoBrowserManager.h"
#import "LB3DTouchVC.h"
#import "CSUploadFileModel.h"
#import "IQKeyboardManager.h"
#import "CSIMReceiveManager.h"
#import "CSIMSendMessageRequest.h"
#import "CSIMSendMessageManager.h"
#import "CSIMSendMessageRequestModel.h"
#import "TTNavigationController.h"
#import "CSMsgHistoryRequestModel.h"
@interface LLChatViewController ()
<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate,
LLMessageCellActionDelegate, LLChatImagePreviewDelegate,
LLImagePickerControllerDelegate, LLChatShareDelegate, LLLocationViewDelegate,
LLAudioRecordDelegate, LLAudioPlayDelegate, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, LLChatManagerMessageListDelegate,
LLDeviceManagerDelegate, LLSightCapatureControllerDelegate, LLTextActionDelegate,
MFMailComposeViewControllerDelegate,
CSIMReceiveManagerDelegate
>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet LLChatInputView *chatInputView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chatInputViewBottomConstraint;

@property (nonatomic) NSMutableArray<CSMessageModel *> *dataSource;

@property (strong, nonatomic) IBOutlet UIView *refreshView;

@property (strong, nonatomic) IBOutlet LLChatVoiceTipView *voiceTipView;

@property (nonatomic) UIImagePickerController_L1 *imagePicker;

@property (nonatomic) LLVoiceIndicatorView *voiceIndicatorView;

@property (nonatomic) LLChatMoreBottomBar *chatMoreBottomBar;
@property (nonatomic) LLChatSharePanel *chatSharePanel;

@property (nonatomic) NSMutableArray<CSMessageModel *> *selectedMessageModels;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomConstraint;


@end

@implementation LLChatViewController {
    BOOL isChatControllerDidAppear;
    BOOL navigationBarTranslucent;
    UITapGestureRecognizer *tapGesture;
    NSArray *rightBarButtonItems;
    BOOL isPulling;
    BOOL isLoading;
    
    NSInteger countDown;
    LLSightCapatureController *_sightController;
    UITextField *textField;
    CSMessageModel *lastedMessageModel;
    
    BOOL firstViewWillAppear;
    BOOL firstViewDidAppear;
}


#pragma mark - UI/LifeCycle 相关 -

- (void)viewDidLoad {
    [super viewDidLoad];

    [CSIMReceiveManager shareInstance].delegate = self;
    //记录进入该聊天室
    [[CSIMReceiveManager shareInstance] inChatWithChatType:(CSChatTypeChat) chatId:self.conversationModel.chatId];
    
    [self tt_SetNaviBarHide:NO withAnimation:NO];
    
    self.tt_navigationBar.contentView.backgroundColor = [UIColor whiteColor];
    self.tt_navigationBar.titleLabel.textColor = [UIColor colorWithHexColorString:@"333333"];
    [self tt_Title:self.conversationModel.nickName];
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.backgroundColor = TABLEVIEW_BACKGROUND_COLOR;
    self.tableView.contentInset = UIEdgeInsetsZero;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    
    self.refreshView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
    self.voiceTipView.frame = CGRectMake(0, 64, SCREEN_WIDTH, 45);
    
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    [self.tableView addGestureRecognizer:tapGesture];
    
    self.chatInputView.delegate = self;
    self.dataSource = [NSMutableArray array];
    
    self.refreshView.backgroundColor = TABLEVIEW_BACKGROUND_COLOR;
    isPulling = NO;
    isLoading = NO;
    
    
    
    [self loadMessageData];
    
    [self addRefreshTool];
    
//    [self.view layoutIfNeeded];
}

- (void)reConnectionSocket
{
    
        CSMessageModel * msgData = [self.dataSource firstObject];
        CSMsgHistoryRequestModel * param = [CSMsgHistoryRequestModel new];
        param.chat_type = CSChatTypeChat;//1为群聊
        param.ID = self.conversationModel.chatId.intValue;
        [CSHttpRequestManager request_chatRecord_paramters:param.mj_keyValues success:^(id responseObject) {
            CSMsgRecordModel * obj = [CSMsgRecordModel mj_objectWithKeyValues:responseObject];
            
            NSMutableArray * messagesArray = [NSMutableArray array];

            for (CSMsgRecordModel * msgData in obj.result.data) {
                CSMessageModel * msgModel = [CSMessageModel conversionWithRecordModel:msgData chatType:param.chat_type chatId:[NSString stringWithFormat:@"%d",self.conversationModel.chatId]];
       
                [messagesArray addObject:msgModel];
            }
            
            self.conversationModel.allMessageModels = messagesArray;
             
            self.dataSource = [self processData:self.conversationModel];
            [self.tableView reloadData];
            
        } failure:^(NSError *error) {
            
        } showHUD:NO];
    
}

- (void)addRefreshTool
{
    self.tableView.mj_header = [TTRefresh tt_headeRefresh:^{
        CSMessageModel * msgData = [self.dataSource firstObject];
        CSMsgHistoryRequestModel * param = [CSMsgHistoryRequestModel new];
        param.chat_type = CSChatTypeChat;//1为群聊
        param.ID = self.conversationModel.chatId.intValue;
        param.last_id = msgData.msgId;
        [CSHttpRequestManager request_chatRecord_paramters:param.mj_keyValues success:^(id responseObject) {
            CSMsgRecordModel * obj = [CSMsgRecordModel mj_objectWithKeyValues:responseObject];
            
            NSMutableArray * messagesArray = [NSMutableArray array];
            NSMutableArray * messagesRequestArray = [NSMutableArray array];
            for (CSMsgRecordModel * msgData in obj.result.data) {
                CSMessageModel * msgModel = [CSMessageModel conversionWithRecordModel:msgData chatType:param.chat_type chatId:[NSString stringWithFormat:@"%d",self.conversationModel.chatId]];
                
//                CSIMSendMessageRequestModel * sendMsgModel = [CSIMSendMessageRequestModel new];
//                sendMsgModel.body = msgModel;
                [messagesArray addObject:msgModel];
                [messagesRequestArray addObject:msgModel];
            }
//            [self.dataSource insertObjects:messagesArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, messagesArray.count)]];
            [self.conversationModel.allMessageModels insertObjects:messagesRequestArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, messagesRequestArray.count)]];
            self.dataSource = [self processData:self.conversationModel];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        } failure:^(NSError *error) {
            [self.tableView.mj_header endRefreshing];
        } showHUD:NO];
    }];
}

- (void)loadMessageData
{
//    for (CSIMSendMessageRequestModel * sendMsgModel in self.conversationModel.allMessageModels) {
//        [self.dataSource addObject:sendMsgModel.body];
//    }
    self.dataSource = [self processData:self.conversationModel];
    [self.tableView reloadData];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self scrollToBottom:NO];
//    });
    
    [self.tableView scrollToBottomAnimated:YES];
}

- (void)updateViewConstraints {
    self.tableViewHeightConstraint.constant = SCREEN_HEIGHT - 64 - MAIN_BOTTOM_TABBAR_HEIGHT;
    
    [super updateViewConstraints];
    
}

- (void)dealloc
{
//    [[CSIMReceiveManager shareInstance] removeDelegate:self];
//    //退出该聊天室
//    [[CSIMReceiveManager shareInstance] outChatWithChatType:(CSChatTypeGroupChat) chatId:self.conversationModel.chatId];
//
//    [_sightController.contentView.layer removeObserver:self forKeyPath:@"position"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [[IQKeyboardManager sharedManager] setEnable:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self blackStatusBar];
    
    TTNavigationController * nav = (TTNavigationController *)self.navigationController;
    [nav navigationCanDragBack:NO];

    [self.chatInputView registerKeyboardNotification];
    self.chatInputView.delegate = self;
//

    _voiceTipView.hidden = NO;
//    
    self.navigationController.interactivePopGestureRecognizer.delaysTouchesBegan= NO;
//
    self.navigationController.navigationBar.subviews[0].alpha = 1;
    UIView *blackView = [self.view viewWithTag:BLACK_BAR_VIEW_TAG];
    [blackView removeFromSuperview];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reConnectionSocket) name:NOTIFICE_KEY_SOCKET_OPEN object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    
    
    //当会话隐藏时，取消键盘事件和代理
    [self.chatInputView unregisterKeyboardNotification];
    self.chatInputView.delegate = nil;
    
    self.navigationController.navigationBar.translucent = navigationBarTranslucent;
    _voiceTipView.hidden = YES;
    //后退
    if (![self.navigationController.childViewControllers containsObject:self]) {
        //如果更了新消息，或者保留草稿，则把当前会话在会话列表置顶
//        if (self.conversationModel.draft.length > 0 || lastedMessageModel.timestamp < [self.conversationModel.allMessageModels lastObject].timestamp) {
//            [[LLConversationModelManager sharedManager] reloadConversationModelToTop:self.conversationModel];
//        }
        
        //后退时停止tableview滚动
        [self.tableView setContentOffset:self.tableView.contentOffset animated:NO];
        
        //FIXME:会话退出时，强制输入框取消FirstResponder,这样下次打开会话时，就不会
        //自动成为FirstResponder了，目前没有发现更好的解决方法
        //仅仅设置TextViewEditable = NO;下次会话不会自动弹键盘，但进入会话会卡顿一下
        if (self.chatInputView.keyboardType == kLLKeyboardTypeDefault) {
            if (!textField) {
                textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
            }
            [self.view addSubview:textField];
            textField.hidden = YES;
            [textField becomeFirstResponder];
            [self.chatInputView setTextViewEditable:NO];
        }
    }
    
}

- (void)tt_DefaultLeftBtnClickAction
{
    [super tt_DefaultLeftBtnClickAction];
    [[CSIMReceiveManager shareInstance] removeDelegate:self];
    //退出该聊天室
    [[CSIMReceiveManager shareInstance] outChatWithChatType:(CSChatTypeChat) chatId:self.conversationModel.chatId];

}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [_sightController.contentView.layer removeObserver:self forKeyPath:@"position"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICE_KEY_SOCKET_OPEN object:nil];
    [self whiteStatusBar];
    
    TTNavigationController * nav = (TTNavigationController *)self.navigationController;
    [nav navigationCanDragBack:YES];
    
    self.navigationController.interactivePopGestureRecognizer.delaysTouchesBegan = YES;
    if (![self.navigationController.childViewControllers containsObject:self]) {
        //清理下拉刷新
        UIActivityIndicatorView *indicator = self.refreshView.subviews[0];
        [indicator stopAnimating];
        self.tableView.tableHeaderView = nil;
        isLoading = NO;
        isPulling = NO;
        
        //停止播放录音
        [[LLAudioManager sharedManager] stopPlaying];
        [[LLDeviceManager sharedManager] disableProximitySensor];
        [LLDeviceManager sharedManager].delegate = nil;
        
        //清理Model和缓存
//        [self cleanMessageModelWhenExit];
//        [[LLMessageCacheManager sharedManager] cleanCacheWhenConversationExit:self.conversationModel];
        
        [self.conversationModel.allMessageModels removeAllObjects];
        [self.dataSource removeAllObjects];
        [self.tableView reloadData];
    
        //取消消息代理
//        [LLChatManager sharedManager].messageListDelegate = nil;
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        
        //清理输入键盘
//        self.conversationModel.draft = self.chatInputView.currentInputText;
//        [self.conversationModel saveDraftToDB];
        [self.chatInputView dismissKeyboardWhenConversationEnd];
        
        //清除小视频
        [self removeSightController];
        
        //其他
        [_voiceTipView removeFromSuperview];
        [textField removeFromSuperview];
        isChatControllerDidAppear = NO;
        firstViewDidAppear = NO;
        firstViewWillAppear = NO;
        lastedMessageModel = nil;
    }
    
}
//
//- (void)cleanMessageModelWhenExit {
//    NSArray<CSMessageModel *> *models = self.conversationModel.allMessageModels;
//    for (CSMessageModel *model in models) {
//        [model cleanWhenConversationSessionEnded];
//    }
//    /*
//    NSArray<LLMessageModel *> *models = self.conversationModel.allMessageModels;
//    for (LLMessageModel *model in models) {
//        [model cleanWhenConversationSessionEnded];
//    }
//     */
//}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}


#pragma mark - Download/Upload -

- (void)registerChatManagerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageUploadHandler:) name:LLMessageUploadStatusChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageDownloadHandler:) name:LLMessageDownloadStatusChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(thumbnailDownloadCompleteHandler:) name:LLMessageThumbnailDownloadCompleteNotification object:nil];

}

- (void)registerApplicationNotification {
    
}

- (void)thumbnailDownloadCompleteHandler:(NSNotification *)notification {
    LLMessageModel *messageModel = notification.userInfo[LLChatManagerMessageModelKey];
    if (!messageModel)
        return;
    
    WEAK_SELF;
    dispatch_async(dispatch_get_main_queue(), ^{
        LLMessageBaseCell *baseCell = [weakSelf visibleCellForMessageModel:messageModel];
        if (!baseCell) {
            [messageModel setNeedsUpdateThumbnail];
            return;
        }
        
        switch (messageModel.messageBodyType) {
            case kLLMessageBodyTypeVideo:
            case kLLMessageBodyTypeImage:
                [baseCell updateMessageThumbnail];
                break;
            default:
                break;
        }
    });

}

//- (void)messageUploadHandler:(NSNotification *)notification {
//    CSMessageModel *messageModel = notification.userInfo[LLChatManagerMessageModelKey];
//    if (!messageModel)
//        return;
//
//    WEAK_SELF;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        LLMessageBaseCell *baseCell = [weakSelf visibleCellForMessageModel:messageModel];
//        if (!baseCell) {
//            [messageModel setNeedsUpdateUploadStatus];
//            return;
//        }
//
//        [baseCell updateMessageUploadStatus];
//
//    });
//
//}

//- (void)messageDownloadHandler:(NSNotification *)notification {
//    LLMessageModel *messageModel = notification.userInfo[LLChatManagerMessageModelKey];
//    if (!messageModel)
//        return;
//
//    //派发下载错误提示
//    if (messageModel.messageDownloadStatus == kLLMessageDownloadStatusFailed && messageModel.messageBodyType == kLLMessageBodyTypeVideo && self.navigationController.visibleViewController == self) {
//        [LLUtils showMessageAlertWithTitle:nil message:@"下载失败" actionTitle:@"我知道了"];
//    }
//
//    WEAK_SELF;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        LLMessageBaseCell *baseCell = [weakSelf visibleCellForMessageModel:messageModel];
//        if (!baseCell) {
//            [messageModel setNeedsUpdateDownloadStatus];
//            return;
//        }
//
//        [baseCell updateMessageDownloadStatus];
//    });
//
//}


#pragma mark - 获取聊天数据
     
- (void)fetchMessageList {
    [LLChatManager sharedManager].messageListDelegate = self;
//    self.conversationModel.referenceMessageModel = nil;
//    [[LLChatManager sharedManager] loadMoreMessagesForConversationModel:self.conversationModel maxCount:MESSAGE_LIMIT_FOR_ONE_FETCH isDirectionUp:YES];
}

//- (void)refreshChatControllerForReuse {
//    self.navigationItem.title = self.conversationModel.nickName;
//
//    [self registerApplicationNotification];
//    [self registerChatManagerNotification];
//
////    if (self.conversationModel.updateType == kLLMessageListUpdateTypeLoadMore) {
////        if (!self.tableView.tableHeaderView) {
////            self.tableView.tableHeaderView = self.refreshView;
////        }
////    }else if (self.conversationModel.updateType == kLLMessageListUpdateTypeLoadMoreComplete) {
////        self.tableView.tableHeaderView = nil;
////    }
////
////    self.chatInputView.draft = self.conversationModel.draft;
////    self.chatInputView.delegate = self;
////    [self.chatInputView prepareKeyboardWhenConversationWillBegin];
////
////    if (self.conversationModel.draft.length == 0 ) {
////        self.chatInputViewBottomConstraint.constant = 0;
////    }
////
//    [self.view layoutIfNeeded];
//
//    self.tableView.contentInset = UIEdgeInsetsMake(CGRectGetHeight(self.chatInputView.frame) - MAIN_BOTTOM_TABBAR_HEIGHT + self.chatInputViewBottomConstraint.constant, 0, 0, 0);
//    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
//
//    self.dataSource = [self processData:self.conversationModel];
//    [self.tableView reloadData];
//
//    [self scrollToBottom:NO];
//
//}


//- (void)loadMoreMessagesDidFinishedWithConversationModel:(LLConversationModel *)aConversationModel {
////    if ((aConversationModel != self.conversationModel) && ![aConversationModel.conversationId isEqualToString:self.conversationModel.conversationId]) {
////        return;
////    }
//    
//    LLMessageBaseCell *cell;
//    LLMessageModel *pullCellModel;
//    CGFloat pullCellPointY = 0;
//    for (UITableViewCell *item in self.tableView.visibleCells) {
//        if ([item isKindOfClass:[LLMessageBaseCell class]]) {
//            cell = (LLMessageBaseCell *)item;
//            pullCellModel = cell.messageModel;
//            pullCellPointY = [cell convertPoint:CGPointZero toView:self.view].y;
//            break;
//        }
//    }
//    
//    if (aConversationModel.updateType == kLLMessageListUpdateTypeLoadMore) {
//        if (!self.tableView.tableHeaderView) {
//            self.tableView.tableHeaderView = self.refreshView;
//        }
//    }else if (aConversationModel.updateType == kLLMessageListUpdateTypeLoadMoreComplete) {
//        self.tableView.tableHeaderView = nil;
//    }
//
//    self.conversationModel = aConversationModel;
//    self.dataSource = [self processData:self.conversationModel];
//    
//    if (self.tableView.visibleCells.count == 0) {
//        [self.tableView reloadData];
//        [self.tableView layoutIfNeeded];
//        
//        [self scrollToBottom:NO];
//    }else if (aConversationModel.updateType == kLLMessageListUpdateTypeNewMessage) {
//        BOOL shouldScroolToBottom = [self shouldScrollToBottomForNewMessage];
//        
//        [self.tableView reloadData];
//        [self.tableView layoutIfNeeded];
//        
//        if (shouldScroolToBottom) {
//            [self scrollToBottom:YES];
//        }
//    }else {
//        [self.tableView reloadData];
//        
//        NSInteger index = [self.dataSource indexOfObject:pullCellModel];
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
//        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
//        
//        LLMessageBaseCell *newCell = [self.tableView cellForRowAtIndexPath:indexPath];
//        
//        CGFloat _offsetY = self.tableView.contentOffset.y;
//        CGFloat _cellYInView = [newCell convertPoint:CGPointZero toView:self.view].y;
//        CGFloat newoffsetY = _offsetY + (_cellYInView - pullCellPointY);
//        if (newoffsetY < 0)
//            newoffsetY = 0;
//        
//        [self.tableView setContentOffset:CGPointMake(0, newoffsetY) animated:NO];
//        
//        UIActivityIndicatorView *indicator = self.refreshView.subviews[0];
//        [indicator stopAnimating];
//        
//        [self performSelectorOnMainThread:@selector(pullToRefreshFinished) withObject:nil waitUntilDone:NO];
//    }
//
//}


- (BOOL)shouldScrollToBottomForNewMessage {
    CGFloat _h = self.tableView.contentSize.height - self.tableView.contentOffset.y - (CGRectGetHeight(self.tableView.frame) - self.tableView.contentInset.bottom);
    
    return _h <= 66 * 4;
}

#pragma mark - 下拉刷新
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (self.tableView.tableHeaderView && !isLoading &&!isPulling && (scrollView.isDragging || scrollView.isDecelerating) && scrollView.contentOffset.y <= 20 - scrollView.contentInset.top && self.conversationModel.allMessageModels.count > 0) {
//        isPulling = YES;
//        UIActivityIndicatorView *indicator = self.refreshView.subviews[0];
//        if (![indicator isAnimating]) {
//            [indicator startAnimating];
//        }
//    }
//    
//    if (_sightController) {
//        [_sightController scrollViewPanGestureRecognizerStateChanged:scrollView.panGestureRecognizer];
//    }
//    
}

- (void)loadMoreMessagesAfterDeletionIfNeeded {
    if (self.tableView.tableHeaderView && !isLoading &&!isPulling && self.tableView.contentOffset.y <= 20 - self.tableView.contentInset.top) {
        UIActivityIndicatorView *indicator = self.refreshView.subviews[0];
        if (![indicator isAnimating]) {
            [indicator startAnimating];
        }
        [self pullToRefresh];
    }
}

- (void)pullToRefresh {
    isPulling = NO;
    isLoading = YES;
    
    NSLog(@"开始下拉刷新");
//    self.conversationModel.referenceMessageModel = self.conversationModel.allMessageModels.count > 0 ? self.conversationModel.allMessageModels[0] : nil;
//    [[LLChatManager sharedManager] loadMoreMessagesForConversationModel:self.conversationModel maxCount:MESSAGE_LIMIT_FOR_ONE_FETCH isDirectionUp:YES];

}
/*
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (!isLoading && isPulling) {
        [self pullToRefresh];
    }
    
    if (scrollView == self.tableView) {
        for (UITableViewCell *cell in self.tableView.visibleCells) {
            if ([cell isKindOfClass:[LLMessageBaseCell class]]) {
                LLMessageBaseCell *chatCell = (LLMessageBaseCell *)cell;
                [chatCell didEndScrolling];
            }
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (isPulling) {
        [self pullToRefresh];
    }
    
    if (_sightController) {
        [_sightController scrollViewPanGestureRecognizerStateChanged:scrollView.panGestureRecognizer];
    }
}
- (void)pullToRefreshFinished {
    isLoading = NO;
}
 */

- (NSMutableArray<CSMessageModel *> *)processData:(CSIMConversationModel *)conversationModel {
    NSMutableArray<CSMessageModel *> *messageList = [NSMutableArray array];
    NSArray<CSMessageModel *> *models = conversationModel.allMessageModels;
    for (NSInteger i = 0; i < models.count; i++) {
        
        if (i == 0 || (models[i].body.timestamp.integerValue - models[i-1].body.timestamp.integerValue > CHAT_CELL_TIME_INTERVEL)) {
            CSMessageModel *model = [[CSMessageModel alloc] initWithType:kCSMessageBodyTypeDateTime];
            model.body.timestamp = models[i].timestamp;
            model.msgId = models[i].msgId;
            [messageList addObject:model];
        }
        [messageList addObject:models[i]];
    }

    return messageList;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  //  NSLog(@"numberOfSections");
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    NSLog(@"numberOfRows %ld", self.dataSource.count);
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [UIView setAnimationsEnabled:NO];
    CSMessageModel *messageModel = self.dataSource[indexPath.row];
    NSString *reuseId =
//    @"123";
    [[LLMessageCellManager sharedManager] reuseIdentifierForMessegeModel:messageModel];
    UITableViewCell *_cell;

//    switch (messageModel.messageBodyType) {
    switch (messageModel.body.msgType) {
        case kCSMessageBodyTypeText:
        case kCSMessageBodyTypeVideo:
        case kCSMessageBodyTypeVoice:
        case kCSMessageBodyTypeImage:
        {
            LLMessageBaseCell *cell = [[LLMessageCellManager sharedManager] messageCellForMessageModel:messageModel tableView:tableView];
            [messageModel setNeedsUpdateForReuse];
            cell.delegate = self;
            _cell = cell;
            break;
        }
        case kCSMessageBodyTypeDateTime: {
            LLMessageDateCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
            if (!cell) {
                cell = [[LLMessageDateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
            }
            
            [messageModel setNeedsUpdateForReuse];
            cell.messageModel = messageModel;
            _cell = cell;
            break;
        }
        case kCSMessageBodyTypeGif: {
            LLMessageGifCell *cell = [tableView dequeueReusableCellWithIdentifier: reuseId];
            if (!cell) {
                cell = [[LLMessageGifCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
                [cell prepareForUse:messageModel.isSelf];
            }
            
            [messageModel setNeedsUpdateForReuse];
            cell.messageModel = messageModel;
            cell.delegate = self;
            _cell = cell;
            break;
        }
        case kCSMessageBodyTypeRecording: {
            LLMessageRecordingCell *cell = [LLMessageRecordingCell sharedRecordingCell];
            [messageModel setNeedsUpdateForReuse];
            cell.messageModel = messageModel;
            
            _cell = cell;
            break;
        }
        default:
            break;
    }
    
//    if ([messageModel checkNeedsUpdate]) {
//        ((LLMessageBaseCell *)_cell).messageModel = messageModel;
//    }
    
    if ([_cell isKindOfClass:[LLMessageBaseCell class]]) {
        LLMessageBaseCell *baseCell = (LLMessageBaseCell *)_cell;
        [baseCell setCellEditingAnimated:NO];
        if (baseCell.isCellSelected != messageModel.isSelected) {
            baseCell.isCellSelected = messageModel.isSelected;
        }
        
        switch(messageModel.messageBodyType) {
            case kCSMessageBodyTypeLocation: {
                if ([messageModel.address isEqualToString:LOCATION_UNKNOWE_ADDRESS] && !messageModel.isFetchingAddress) {
                    [self asyncReGeocodeForMessageModel:messageModel];
                }
                break;
            }
            case kCSMessageBodyTypeVoice: {
                LLMessageVoiceCell *voiceCell = (LLMessageVoiceCell *)_cell;
                if (messageModel.isMediaPlaying != voiceCell.isVoicePlaying) {
                    if (messageModel.isMediaPlaying) {
                        [voiceCell startVoicePlaying];
                    }else {
                        [voiceCell stopVoicePlaying];
                    }
                }
                    
                break;
            }
                default:
                break;
        }
    }
    
    [UIView setAnimationsEnabled:YES];
    return _cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CSMessageModel *messageModel = self.dataSource[indexPath.row];
//    NSLog(@"height->%g,str->%@",messageModel.cellHeight,messageModel.body.content);
    return messageModel.cellHeight + 5;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[LLMessageBaseCell class]]) {
        LLMessageBaseCell *baseCell = (LLMessageBaseCell *)cell;
        [baseCell didEndDisplayingCell];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[LLMessageBaseCell class]]) {
        LLMessageBaseCell *baseCell = (LLMessageBaseCell *)cell;
        [baseCell willDisplayCell];
    }
}

#pragma mark - TableView 相关方法 -

- (LLMessageBaseCell *)visibleCellForMessageModel:(CSMessageModel *)model {
//    if (!model || !(self.conversationModel.chatId.intValue == model.chatId)) {
//        return nil;
//    }
    
    for (UITableViewCell *cell in self.tableView.visibleCells) {
        if ([cell isKindOfClass:[LLMessageDateCell class]]){
            continue;
        }
        LLMessageBaseCell *chatCell = (LLMessageBaseCell *)cell;
        if (chatCell.messageModel == model) {
            return chatCell;
        }
//        if ((chatCell.messageModel.messageBodyType == model.msgType) &&
//            [chatCell.messageModel isEqual:model]) {
//            return chatCell;
//        }
    }
    
    return nil;
}

#pragma -发送单条消息,刷新tableview,
- (void)addModelToDataSourceAndScrollToBottom:(CSIMSendMessageRequestModel *)messageModel animated:(BOOL)animated {
    [self.conversationModel.allMessageModels addObject:messageModel.body];
//    if (messageModel.timestamp - [self.dataSource lastObject].timestamp > CHAT_CELL_TIME_INTERVEL) {
//        LLMessageModel *dateModel = [[LLMessageModel alloc] initWithType:kLLMessageBodyTypeDateTime];
//        dateModel.timestamp = messageModel.timestamp;
//        [self.dataSource addObject:dateModel];
//    }
    [self.dataSource addObject:messageModel.body];
    
    [self.tableView reloadData];
    [self scrollToBottom:animated];
}
//发送多条
- (void)addModelsInArrayToDataSourceAndScrollToBottom:(NSArray<CSMessageModel *> *)messageModels animated:(BOOL)animated {
    [self.conversationModel.allMessageModels addObjectsFromArray:messageModels];
    for (NSInteger i = 0, count = messageModels.count; i < count; i++) {
        CSMessageModel *messageModel = messageModels[i];
        
        if (([messageModel.timestamp longLongValue] - [self.dataSource lastObject].timestamp.longLongValue) > CHAT_CELL_TIME_INTERVEL) {
            CSMessageModel *dateModel = [[CSMessageModel alloc] initWithType:kCSMessageBodyTypeDateTime];
            dateModel.timestamp = messageModel.timestamp;
            [self.dataSource addObject:dateModel];
        }
        
        [self.dataSource addObject:messageModel];
    }
    
    [self.tableView reloadData];
    [self scrollToBottom:animated];
}

- (void)deleteTableRowWithModel:(CSMessageModel *)model withRowAnimation:(UITableViewRowAnimation)animation {
    NSInteger index = [self.dataSource indexOfObject:model];
    NSMutableArray<NSIndexPath *> *deleteIndexPaths = [NSMutableArray array];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.conversationModel.allMessageModels removeObject:model];
    [self.dataSource removeObjectAtIndex:index];
    [deleteIndexPaths addObject:indexPath];
    
    if (self.dataSource[index-1].messageBodyType == kLLMessageBodyTypeDateTime &&
        ((index == self.dataSource.count) || (self.dataSource[index].messageBodyType == kLLMessageBodyTypeDateTime))) {
        [self.dataSource removeObjectAtIndex:index - 1];
        [deleteIndexPaths addObject:[NSIndexPath indexPathForRow:index-1 inSection:0]];
    }
    
    [self.tableView deleteRowsAtIndexPaths:deleteIndexPaths withRowAnimation:animation];
    WEAK_SELF;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf loadMoreMessagesAfterDeletionIfNeeded];
    });
}

- (void)deleteTableRowsWithMessageModelInArray:(NSArray<LLMessageModel *> *)messageModels {
    //获取后台实际删除的MessageModel
    NSMutableArray *deleteMessageModels = [[LLChatManager sharedManager] deleteMessages:messageModels fromConversation:self.conversationModel];
    
    NSMutableArray<NSIndexPath *> *deleteIndexPaths = [NSMutableArray array];
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    for (LLMessageModel *messageModel in deleteMessageModels) {
        messageModel.isDeleting = YES;
        NSInteger index = [self.dataSource indexOfObject:messageModel];
        [indexSet addIndex:index];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [deleteIndexPaths addObject:indexPath];
    }
    
    //删除不必要的日期Cell
    NSInteger deleteDateIndex = -1;
    for (NSInteger index = 0, count = self.dataSource.count; index < count; index++) {
        LLMessageModel *messageModel = self.dataSource[index];
        if (messageModel.messageBodyType == kLLMessageBodyTypeDateTime) {
            if (deleteDateIndex >= 0) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:deleteDateIndex inSection:0];
                [deleteIndexPaths addObject:indexPath];
                [indexSet addIndex:deleteDateIndex];
            }
            
            deleteDateIndex = index;
        }else if (!messageModel.isDeleting){
            deleteDateIndex = -1;
        }
    }
    
    if (deleteDateIndex >= 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:deleteDateIndex inSection:0];
        [deleteIndexPaths addObject:indexPath];
        [indexSet addIndex:deleteDateIndex];
    }
    
    [self.conversationModel.allMessageModels removeObjectsInArray:deleteMessageModels];
    [self.dataSource removeObjectsAtIndexes:indexSet];
    
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:deleteIndexPaths withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    
    WEAK_SELF;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [weakSelf loadMoreMessagesAfterDeletionIfNeeded];
//    });
}

//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    if (scrollView == self.tableView) {
//        for (UITableViewCell *cell in self.tableView.visibleCells) {
//            if ([cell isKindOfClass:[LLMessageBaseCell class]]) {
//                LLMessageBaseCell *chatCell = (LLMessageBaseCell *)cell;
//                [chatCell willBeginScrolling];
//            }
//        }
//    }
//}

- (void)scrollToBottom:(BOOL)animated {
    
    if (self.dataSource.count == 0)
        return;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataSource.count - 1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        CGFloat offsetY = self.tableView.contentSize.height + self.tableView.contentInset.bottom - CGRectGetHeight(self.tableView.frame);
        if (offsetY < -self.tableView.contentInset.top)
            offsetY = -self.tableView.contentInset.top;
        [self.tableView setContentOffset:CGPointMake(0, offsetY) animated:animated];
    }else {
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    }
}


#pragma mark - 处理键盘事件

- (void)updateKeyboard:(LLKeyboardShowHideInfo)keyboardInfo {
    CGFloat constant = keyboardInfo.toKeyboardType == kLLKeyboardTypeNone ? 0 :
    keyboardInfo.keyboardHeight;
    
    if (keyboardInfo.duration == 0) {
        [UIView setAnimationsEnabled:NO];
    }
    
    BOOL needScrollToBottom = ((self.chatInputViewBottomConstraint.constant == 0) && (constant > 0));
    [UIView animateWithDuration:keyboardInfo.duration
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState |
                                keyboardInfo.curve
                     animations:^() {
                         self.chatInputViewBottomConstraint.constant = constant;
                         [self.view layoutIfNeeded];
                         
                         self.tableView.contentInset = UIEdgeInsetsMake(constant + CGRectGetHeight(self.chatInputView.frame) - MAIN_BOTTOM_TABBAR_HEIGHT, 0, 0, 0);
                         self.tableView.scrollIndicatorInsets = self.tableView.contentInset;

                     }
                     completion: nil];
    
    if (needScrollToBottom) {
        [self scrollToBottom:keyboardInfo.duration > 0];
    }

    if (keyboardInfo.duration == 0) {
        [UIView setAnimationsEnabled:YES];
    }
}

- (void)tapHandler:(UITapGestureRecognizer *)tap {
    [self.chatInputView dismissKeyboard];
    
    if (_sightController) {
        [self sightCapatureControllerDidCancel:_sightController];
    }
}

- (void)textViewDidChange:(UITextView *)textView {
//    self.conversationModel.draft = textView.text;
    
}

#pragma mark - 处理Cell动作

- (void)textPhoneNumberDidTapped:(NSString *)phoneNumber userinfo:(nullable id)userinfo {
    [self.chatInputView dismissKeyboard];
    NSString *title = [NSString stringWithFormat:@"%@可能是一个电话号码,你可以", phoneNumber];
    LLActionSheet *actionSheet = [[LLActionSheet alloc] initWithTitle:title];
    LLActionSheetAction *action1 = [LLActionSheetAction actionWithTitle:@"呼叫"
                handler:^(LLActionSheetAction *action) {
                    [LLUtils callPhoneNumber:phoneNumber];
                                                        }];
    WEAK_SELF;
    LLActionSheetAction *action2 = [LLActionSheetAction actionWithTitle:@"添加到手机通讯录"
                handler:^(LLActionSheetAction *action) {
                    [weakSelf addToContact:phoneNumber];
                                                        }] ;

    [actionSheet addActions:@[action1]];

    [actionSheet showInWindow:[LLUtils popOverWindow]];
}

- (void)addToContact:(NSString *)phone {
    NSString *title = [NSString stringWithFormat:@"%@可能是一个电话号码,你可以", phone];
    LLActionSheet *actionSheet = [[LLActionSheet alloc] initWithTitle:title];
    LLActionSheetAction *action1 = [LLActionSheetAction actionWithTitle:@"创建新联系人"
                        handler:^(LLActionSheetAction *action) {
                                                                   
                                                                }];
    
    LLActionSheetAction *action2 = [LLActionSheetAction actionWithTitle:@"添加到现有联系人"
                                                                handler:^(LLActionSheetAction *action) {
                                                                    
                                                                }] ;
    
    [actionSheet addActions:@[action1, action2]];
    
    [actionSheet showInWindow:[LLUtils popOverWindow]];
}


- (void)textLinkDidTapped:(NSURL *)url userinfo:(nullable id)userinfo {
    [self.chatInputView dismissKeyboard];
    
    if ([url.scheme isEqualToString:URL_MAIL_SCHEME]) {
        NSString *recipient = url.resourceSpecifier;
        NSString *title = [NSString stringWithFormat:@"向%@发送邮件", recipient];
        LLActionSheet *actionSheet = [[LLActionSheet alloc] initWithTitle:title];
        
        WEAK_SELF;
        LLActionSheetAction *action1 = [LLActionSheetAction actionWithTitle:@"使用QQ邮箱发送"
                                                                   handler:nil];
        LLActionSheetAction *action2 = [LLActionSheetAction actionWithTitle:@"使用默认邮件账户" handler:^(LLActionSheetAction *action) {
            [weakSelf sendEmailToRecipient:recipient];
        }];
        
        [actionSheet addActions:@[action1, action2]];
        
        [actionSheet showInWindow:[LLUtils popOverWindow]];
    }else {
        LLWebViewController *web = [[LLWebViewController alloc] initWithNibName:nil bundle:nil];
        web.fromViewController = self;
        web.url = url;
        
        [self.navigationController pushViewController:web animated:YES];
    }
    
}

- (void)sendEmailToRecipient:(NSString *)recipient {
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController_LL *mc = [[MFMailComposeViewController_LL alloc] init];
        mc.mailComposeDelegate = self;
        [mc setToRecipients:@[recipient]];
        
        [self.navigationController presentViewController:mc animated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


- (void)textLinkDidLongPressed:(NSURL *)url userinfo:(nullable id)userinfo {
    [self.chatInputView dismissKeyboard];
    
    NSString *title;
    if ([url.scheme isEqualToString:URL_MAIL_SCHEME]) {
        title = url.resourceSpecifier;
    }else {
        title = url.absoluteString;
    }
    
    LLActionSheet *actionSheet = [[LLActionSheet alloc] initWithTitle:title];
    LLActionSheetAction *action = [LLActionSheetAction actionWithTitle:@"复制链接"
                        handler:^(LLActionSheetAction *action) {
                        [LLUtils copyToPasteboard:title];
                                                               }];
    [actionSheet addAction:action];

    [actionSheet showInWindow:[LLUtils popOverWindow]];
}

- (void)cellWithTagDidTapped:(NSInteger)tag {
    switch (tag) {
        case TAG_Photo:
            [self presentImagePickerController];
            break;
        case TAG_Location:
            [self presendLocationViewController];
            break;
        case TAG_Camera:
            [self takePictureAndVideoAction];
            break;
        case TAG_Sight:
            [self presentSightController];
            break;
        default:
            break;
    }
}


//MARK:图片单击放大，视频单击播放，声音也是单击播放，gif也是单击
//也就是说单击是一种查看消息详情的触发方式,文本消息的详细模式就是全屏浏览
//文本采用单击触发，而不是双击的理由：
//1、单击触发文本全屏浏览，会和其他类型的消息触发方式一致
//2、单击比起双击更易操作，鼠标双击还可以接受，用手指双击体验不好
//3、用户意识到文本也和图片、视频、声音一样单击触发后，文本误操作概率不会高于其他类型Cell
//4、文本内电话、URL、邮件、控制字符串等可点击区域不会造成干扰
//所以文本也采用单击触发的方式
- (void)cellDidTapped:(LLMessageBaseCell *)cell {
    switch (cell.messageModel.body.msgType) {
        case kCSMessageBodyTypeImage:
            [self cellImageDidTapped:(LLMessageImageCell *)cell];
            break;
        case kCSMessageBodyTypeGif:
//            [self cellGifDidTapped:(LLMessageGifCell *)cell];
            break;
        case kCSMessageBodyTypeVideo:
//            [self cellVideoDidTapped:(LLMessageVideoCell *)cell];
            break;
        case kCSMessageBodyTypeVoice:
            [self cellVoiceDidTapped:(LLMessageVoiceCell *)cell];
            break;
        case kCSMessageBodyTypeLocation:
//            [self cellLocationDidTapped:(LLMessageLocationCell *)cell];
            break;
        case kCSMessageBodyTypeText:
//            if (![LLUserProfile myUserProfile].userOptions.doubleTapToShowTextMessage) {
//                [self displayTextMessage:cell.messageModel];
//            }
            break;
            
        default:
            break;
    }
}

- (void)textCellDidDoubleTapped:(LLMessageTextCell *)cell {
    if ([LLUserProfile myUserProfile].userOptions.doubleTapToShowTextMessage) {
        [self displayTextMessage:cell.messageModel];
    }
}

- (void)avatarImageDidTapped:(LLMessageBaseCell *)cell {
    
}

#pragma mark - 处理Cell菜单 -

- (void)willShowMenuForCell:(LLMessageBaseCell *)cell {

}

- (void)didShowMenuForCell:(LLMessageBaseCell *)cell {

}

- (void)willHideMenuForCell:(LLMessageBaseCell *)cell {

}

- (void)didHideMenuForCell:(LLMessageBaseCell *)cell {
    self.chatInputView.chatInputTextView.targetCell = nil;
}

- (UIResponder *)currentFirstResponderIfNeedRetain {
    UITextView *textView = self.chatInputView.chatInputTextView;
    
    return textView.isFirstResponder ? textView : nil;
}


- (void)deleteMenuItemDidTapped:(LLMessageBaseCell *)cell {
    LLActionSheet *actionSheet = [[LLActionSheet alloc] initWithTitle:@"是否删除该条消息？"];
    
    WEAK_SELF;
    LLActionSheetAction *action = [LLActionSheetAction actionWithTitle:@"确定"
               handler:^(LLActionSheetAction *action) {
                   LLMessageModel *model = cell.messageModel;
                   BOOL result = [[LLChatManager sharedManager] deleteMessage:model fromConversation:weakSelf.conversationModel];
                   if (result) {
                       [weakSelf deleteTableRowWithModel:model withRowAnimation:UITableViewRowAnimationFade];
                   }
                                   } style:kLLActionStyleDestructive];
    
    [actionSheet addAction:action];
    
    [actionSheet showInWindow:[LLUtils popOverWindow]];
}

- (LLChatMoreBottomBar *)chatMoreBottomBar {
    if (!_chatMoreBottomBar) {
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"LLChatMoreBottomBar" owner:self options:nil];
        _chatMoreBottomBar = views[0];
        _chatMoreBottomBar.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 50);
        
        _chatSharePanel = views[1];
        _chatSharePanel.frame = self.view.bounds;
    }
    
    return _chatMoreBottomBar;
}

- (void)moreMenuItemDidTapped:(LLMessageBaseCell *)aCell {
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelEditing:)];
    self.navigationItem.leftBarButtonItem = cancel;
    self.navigationItem.rightBarButtonItems = nil;
    [LLMessageBaseCell setCellEditing:YES];
    
    self.selectedMessageModels = [@[aCell.messageModel] mutableCopy];
    self.chatMoreBottomBar.isButtonsEnabled = YES;
    aCell.isCellSelected = YES;
    //aCell.superview.subviews
    for (UITableViewCell *cell in self.tableView.visibleCells) {
        if ([cell isKindOfClass:[LLMessageBaseCell class]]) {
            LLMessageBaseCell *baseCell = (LLMessageBaseCell *)cell;
            [baseCell setCellEditingAnimated:YES];
        }
    }
    
    self.chatInputView.delegate = nil;
    [self.chatInputView dismissKeyboard];
    [self.view addSubview:self.chatMoreBottomBar];
    self.view.backgroundColor = TABLEVIEW_BACKGROUND_COLOR;
    self.chatMoreBottomBar.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 50);
    [UIView animateWithDuration:0.3 animations:^{
        self.chatMoreBottomBar.frame = CGRectMake(0, SCREEN_HEIGHT - MAIN_BOTTOM_TABBAR_HEIGHT - NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, MAIN_BOTTOM_TABBAR_HEIGHT);
        self.chatInputViewBottomConstraint.constant = -CGRectGetHeight(self.chatInputView.frame);
        self.tableViewBottomConstraint.constant = MAIN_BOTTOM_TABBAR_HEIGHT;
        [self.view layoutIfNeeded];
        
        self.tableView.contentInset = UIEdgeInsetsZero;
        self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    }];

}

- (void)cancelEditing:(id)sender {
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItems = rightBarButtonItems;
    [LLMessageBaseCell setCellEditing:NO];
    
    for (LLMessageModel *model in self.selectedMessageModels) {
        model.isSelected = NO;
    }
    
    for (UITableViewCell *cell in self.tableView.visibleCells) {
        if ([cell isKindOfClass:[LLMessageBaseCell class]]) {
            LLMessageBaseCell *baseCell = (LLMessageBaseCell *)cell;
            baseCell.isCellSelected = NO;
            [baseCell setCellEditingAnimated:NO];
        }
    }
    
    self.chatInputView.delegate = self;
    [UIView animateWithDuration:0.3 animations:^{
        self.chatMoreBottomBar.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 50);
        self.chatInputViewBottomConstraint.constant = 0;
        self.tableViewBottomConstraint.constant = 0;
        [self.view layoutIfNeeded];
        self.tableView.contentInset = UIEdgeInsetsMake(CGRectGetHeight(self.chatInputView.frame) - MAIN_BOTTOM_TABBAR_HEIGHT, 0, 0, 0);
        self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    } completion:^(BOOL finished) {
        self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
        [self.chatMoreBottomBar removeFromSuperview];
    }];
}

- (IBAction)deleteAction:(id)sender {
    if (self.selectedMessageModels.count == 0)
        return;
    
    LLActionSheet *actionSheet = [[LLActionSheet alloc] initWithTitle:nil];
    LLActionSheetAction *action = [LLActionSheetAction actionWithTitle:@"删除"
       handler:^(LLActionSheetAction *action) {
           [self deleteSelectedModels];
       } style:kLLActionStyleDestructive];
    
    [actionSheet addAction:action];
    
    [actionSheet showInWindow:[LLUtils popOverWindow]];

}

- (void)selectControllDidTapped:(LLMessageModel *)model selected:(BOOL)selected {
    if (selected) {
        [self.selectedMessageModels addObject:model];
    }else {
        [self.selectedMessageModels removeObject:model];
    }
    
    self.chatMoreBottomBar.isButtonsEnabled = self.selectedMessageModels.count > 0;
}

- (void)deleteSelectedModels {
    if (self.tableView.visibleCells.count == 0) {
        [self cancelEditing:nil];
        return;
    }
    [self cancelEditing:nil];
    
    if (self.selectedMessageModels.count > 0) {
        WEAK_SELF;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf deleteTableRowsWithMessageModelInArray:self.selectedMessageModels];
        });
    }
}

#pragma mark - 更多
- (IBAction)shareAction:(id)sender {
    [self.chatSharePanel show];
}

#pragma mark - 处理照片

- (CSMessageModel *)createImageMessageModel:(NSData *)imageData imageSize:(CGSize)imageSize
                              uploadSuccess:(void(^)())uploadSuccess
{
    if (!imageData || imageData.length == 0 || imageSize.height == 0 || imageSize.width == 0) {
        NSString *msg = @"照片可能已被删除或损坏，无法发送";
        if ([NSThread isMainThread]) {
            [LLUtils showTextHUD:msg];
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [LLUtils showTextHUD:msg];
            });
        }
        return nil;
    }
    NSString * msgId = [CSMessageModel create_kMessageId];
    CSMessageModel * messageModel = [CSMessageModel sendImageMessageWithImageData:imageData imageSize:imageSize chatId:self.conversationModel.chatId chatType:(CSChatTypeChat) msgId:msgId msgType:(CSMessageBodyTypeImage) action:4 content:@"" uploadProgress:^(CGFloat progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"🍎🍎🍎🍎🍎🍎🍎🍎---------------->%g",progress);
            messageModel.fileUploadProgress = progress * 100;
//            LLMessageBaseCell *cell = [self cellWithMessageId:msgId];
////            [self visibleCellForMessageModel:messageModel];
//            if (cell) {
//                [cell updateMessageUploadStatus];
//            }
        });
    } uploadStatus:^(CSMessageModel *model, NSError *error) {
        if (error) {
            [self failMessageRefreshSendStatusWithModel:messageModel];
        }
        else
        {
            if (uploadSuccess) {
                uploadSuccess();
            }
        }
    } isSelf:YES];
    __weak CSMessageModel *weakModel = messageModel;
    [messageModel setFile_upload_progress_BLOCK:^(CGFloat progress) {
        
        weakModel.fileUploadProgress = progress * 100;
        LLMessageBaseCell *cell = [self cellWithMessageId:msgId];
        //            [self visibleCellForMessageModel:messageModel];
        if (cell) {
            [cell updateMessageUploadStatus];
        }
    }];
    return messageModel;
}

- (LLMessageBaseCell *)cellIndexPathWithModel:(CSMessageModel *)model
{
    NSInteger index = [self.dataSource indexOfObject:model];
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    LLMessageBaseCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        return cell;
    }
    return nil;
}

- (LLMessageBaseCell *)cellWithMessageId:(NSString *)messageId
{
    for (UITableViewCell *cell in self.tableView.visibleCells) {
        if ([cell isKindOfClass:[LLMessageDateCell class]]){
            continue;
        }
        LLMessageBaseCell *chatCell = (LLMessageBaseCell *)cell;
        if ([chatCell.messageModel.msgId isEqualToString:messageId]) {
            return chatCell;
        }
    }
    return nil;
}

- (void)cellImageDidTapped:(LLMessageImageCell *)cell {
    NSMutableArray *arrayUrl = [NSMutableArray array];
    NSMutableArray *arrayImageView = [NSMutableArray array];
    int index = 0;
        for (int i = [self.dataSource indexOfObject:cell.messageModel]; i< self.dataSource.count; i++) {
            CSMessageModel *model = self.dataSource[i];
            if (model.messageBodyType == kCSMessageBodyTypeImage ||
                model.messageBodyType == kCSMessageBodyTypeVideo) {
                [arrayUrl addObject:model.body.content];
                [arrayImageView addObject:cell.chatImageView];
                if (model == cell.messageModel) {
                    index = arrayUrl.count - 1;
                }
            }
            if (arrayUrl.count > 8) {
                break;
            }
        }
    
     [[LBPhotoBrowserManager defaultManager] showImageWithURLArray:arrayUrl fromImageViews:arrayImageView selectedIndex:index imageViewSuperView:cell.chatImageView.superview];
    
    // 添加图片浏览器长按手势的效果
    [[[LBPhotoBrowserManager defaultManager] addLongPressShowTitles:@[@"保存照片",@"取消"]] addTitleClickCallbackBlock:^(UIImage *image, NSIndexPath *indexPath, NSString *title) {
        LBPhotoBrowserLog(@"%@ %@ %@",image,indexPath,title);
        if ([title isEqualToString:@"保存照片"]) {
            [image savedPhotosAlbum:^{
                CS_HUD(@"保存成功");
            } failBlock:^{
                
            }];
        }
    }].style = LBMaximalImageViewOnDragDismmissStyleOne; // 默认的就
//    if (cell.messageModel.thumbnailImage) {
//        [self showAssetFromCell:cell];
//    }else if (!cell.messageModel.isFetchingThumbnail){
////        [[LLChatManager sharedManager] asyncDownloadMessageThumbnail:cell.messageModel completion:nil];
//        [cell willDisplayCell];
//    }
    
}
#pragma mark - 打开自定义相册
- (void)presentImagePickerController {
    LLImagePickerController *vc = [[LLImagePickerController alloc] init];
    vc.pickerDelegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(id)picker {
    if ([picker isKindOfClass:[LLImagePickerController class]]) {
        [((LLImagePickerController *)picker).presentingViewController
         dismissViewControllerAnimated:YES completion:nil];
    }else if ([picker isKindOfClass:[UIImagePickerController_L1 class]]) {
        [((UIImagePickerController_L1 *)picker).presentingViewController
         dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)imagePickerController:(LLImagePickerController *)picker
       didFinishPickingImages:(NSArray<LLAssetModel *> *)assets
                    withError:(NSError *)error {
    if (error || assets.count == 0) return;
    
    MBProgressHUD *HUD = [LLUtils showActivityIndicatiorHUDWithTitle:@"正在处理..." inView:picker.view];
    
    WEAK_SELF;
    //dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    dispatch_async(dispatch_get_main_queue(), ^{
         NSMutableArray<LLMessageModel *> *messageModels = [NSMutableArray arrayWithCapacity:assets.count];
        
         for (LLAssetModel *asset in assets) {
             
             NSData * imageData = [[LLAssetManager sharedAssetManager] fetchImageDataFromAssetModel:asset];
             
             CSIMSendMessageRequestModel * messageRequest = [CSIMSendMessageRequestModel new];
             CSMessageModel *messageModel = [weakSelf createImageMessageModel:imageData imageSize:asset.imageSize uploadSuccess:^{
                 //上传成功 发送消息
                 DLog(@"图片上传成功");
                 [[CSIMSendMessageManager shareInstance] sendMessage:messageRequest];
             }];
//             messageModel.thumbnailImage = [[LLAssetManager sharedAssetManager] fetchImageFromAssetModel:asset];
             
             messageRequest.body = messageModel;
             [self addModelToDataSourceAndScrollToBottom:messageRequest animated:NO];
             
             [messageRequest.msgStatus when:^(id obj) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     DLog(@"图片发送成功");
                     [messageModel internal_setMessageStatus:(kCSMessageStatusSuccessed)];
                     LLMessageBaseCell *cell = [self visibleCellForMessageModel:messageModel];
                     if (cell) {
                         [cell updateMessageUploadStatus];
                     }
                 });
             } failed:^(NSError *error) {
                 DLog(@"🍌🍌🍌🍌🍌🍌图片发送失败error:%@",error);
                 [self failMessageRefreshSendStatusWithModel:messageModel];
             }];
             
             
 
         }
        [picker.presentingViewController dismissViewControllerAnimated:YES completion:^{
            [LLUtils hideHUD:HUD animated:YES];
        }];
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//        });
        
    });

}

#pragma mark - 拍摄照片、视频

- (UIImagePickerController *)imagePicker {
    if (_imagePicker == nil) {
        _imagePicker = [[UIImagePickerController_L1 alloc] init];
        _imagePicker.modalPresentationStyle= UIModalPresentationOverFullScreen;
        _imagePicker.modalPresentationCapturesStatusBarAppearance = YES;
        _imagePicker.delegate = self;
    }
    
    return _imagePicker;
}

- (void)takePictureAndVideoAction {
#if TARGET_IPHONE_SIMULATOR
    
#elif TARGET_OS_IPHONE
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    //    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage,(NSString *)kUTTypeMovie];
    //    self.imagePicker.videoMaximumDuration = MAX_VIDEO_DURATION_FOR_CHAT;
    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    [self presentViewController:self.imagePicker animated:YES completion:NULL];
#endif
    
}
//拍摄照片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    MBProgressHUD *HUD = [LLUtils showActivityIndicatiorHUDWithTitle:@"正在处理..." inView:picker.view];
    
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
        NSURL *videoURL = info[UIImagePickerControllerMediaURL];
        WEAK_SELF;
        [LLUtils compressVideoForSend:videoURL
                        removeMOVFile:YES
                           okCallback:^(NSString *mp4Path) {
                               [weakSelf sendVideoMessageWithURL:mp4Path];
                               [picker dismissViewControllerAnimated:YES completion:nil];
                           }
                       cancelCallback:^{
                           [picker dismissViewControllerAnimated:YES completion:nil];
                       }
                         failCallback:^{
                            [picker dismissViewControllerAnimated:YES completion:nil];
                         }];

    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
          
//            [MBProgressHUD tt_Show];
            UIImage *orgImage = info[UIImagePickerControllerOriginalImage];
            NSData * imageData = [orgImage tt_compressToDataLength:450*1000];
            
            
            
            CSIMSendMessageRequestModel * messageRequest = [CSIMSendMessageRequestModel new];
            CSMessageModel *messageModel = [self createImageMessageModel:imageData imageSize:orgImage.size uploadSuccess:^{
                //上传成功 发送消息
                DLog(@"图片上传成功");
//                [MBProgressHUD tt_Hide];
                [[CSIMSendMessageManager shareInstance] sendMessage:messageRequest];
            }];
            messageModel.thumbnailImage = orgImage;
            messageRequest.body = messageModel;
            [self addModelToDataSourceAndScrollToBottom:messageRequest animated:NO];
            
            [messageRequest.msgStatus when:^(id obj) {
                
                DLog(@"图片发送成功");
                [messageModel internal_setMessageStatus:(kCSMessageStatusSuccessed)];
                LLMessageBaseCell *cell = [self visibleCellForMessageModel:messageModel];
                if (cell) {
                    [cell updateMessageUploadStatus];
                }
                
            } failed:^(NSError *error) {
                [self failMessageRefreshSendStatusWithModel:messageModel];
            }];
            
            
        });
        [picker.presentingViewController dismissViewControllerAnimated:YES completion:^{
            [LLUtils hideHUD:HUD animated:YES];
        }];
    }
    
}


- (void)imagePickerController:(LLImagePickerController *)picker didFinishPickingVideo:(NSString *)videoPath {
    [self sendVideoMessageWithURL:videoPath];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  发送视频文件
 *
 *  @param fileURL
 */
- (void)sendVideoMessageWithURL:(NSString *)filePath {
    CSChatType chatType = self.conversationModel.conversationType;
    //chatTypeForConversationType(self.conversationModel.conversationType);
    
    LLMessageModel *model = [[LLChatManager sharedManager]
            sendVideoMessageWithLocalPath:filePath
                          to:self.conversationModel.chatId
                 messageType:chatType
                  messageExt:nil
                    progress:nil
                    completion:nil];

    [self addModelToDataSourceAndScrollToBottom:model animated:NO];
    
}

/**
 *  播放本地视频
 *
 */
- (void)cellVideoDidTapped:(LLMessageVideoCell *)cell {
    if (cell.messageModel.isSelf || cell.messageModel.thumbnailImage) {
        [self showAssetFromCell:cell];
    }else if (!cell.messageModel.isFetchingThumbnail){
        [[LLChatManager sharedManager] asyncDownloadMessageThumbnail:cell.messageModel completion:nil];
    }
}

#pragma mark - 视频、图片弹出、弹入动画 -

- (void)showAssetFromCell:(LLMessageBaseCell *)cell {
    [[LLAudioManager sharedManager] stopPlaying];
    [self.chatInputView dismissKeyboard];
    
    NSMutableArray *array = [NSMutableArray array];
    for (CSMessageModel *model in self.dataSource) {
        if (model.messageBodyType == kCSMessageBodyTypeImage ||
            model.messageBodyType == kCSMessageBodyTypeVideo) {
            [array addObject:model];
        }
    }
    
    LLChatAssetDisplayController *vc = [[LLChatAssetDisplayController alloc] initWithNibName:nil bundle:nil];
    vc.allAssets = //array;
  @[cell.messageModel];
    vc.curShowMessageModel = cell.messageModel;
    vc.originalWindowFrame = [cell contentFrameInWindow];
    vc.delegate = self;
//    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
//        [self presentViewController:nav animated:YES completion:nil];
    [self.navigationController pushViewController:vc animated:NO];

}


- (void)didFinishWithMessageModel:(CSMessageModel *)model targetView:(UIView<LLAssetDisplayView> *)assetView scrollToTop:(BOOL)scrollToTop {
    NSInteger index = [self.dataSource indexOfObject:model];
    NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
    if (scrollToTop) {
        [self.tableView scrollToRowAtIndexPath:cellIndexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
    }
    LLMessageBaseCell *cell = [self visibleCellForMessageModel:model];
//    [cell layoutIfNeeded];
    self.tableView.scrollEnabled = NO;
    
    //cell不可见
    if (!cell) {
        CGRect frame = assetView.frame;
        frame.origin = CGPointZero;
        assetView.frame = frame;
        
        [self.view addSubview:assetView];
        [UIView animateWithDuration:DEFAULT_DURATION delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            assetView.alpha = 0;
            
        } completion:^(BOOL finished) {
            [assetView removeFromSuperview];
            self.tableView.scrollEnabled = YES;
        }];
    }else {
        CGRect targetFrame;
        UIImageView *targetView = assetView.imageView;
        UIImage *maskImage;
        UIView *blackView;
        LLMessageImageCell *imageCell;
        LLMessageVideoCell *videoCell;
        
        
        if (model.messageBodyType == kCSMessageBodyTypeImage) {
            imageCell = (LLMessageImageCell *)cell;
            [imageCell willExitFullScreenShow];
        
            blackView = assetView;
            CGRect frame = assetView.frame;
            frame.origin = CGPointZero;
            assetView.frame = frame;
            [self.view addSubview:assetView];
            
            targetFrame = [imageCell.chatImageView convertRect:imageCell.chatImageView.bounds toView:self.view];
            
            targetView.contentMode = UIViewContentModeScaleAspectFill;
            frame = targetView.frame;
            frame.origin.y -= ((UIScrollView *)assetView).contentOffset.y;
            targetView.frame = frame;
            [self.view addSubview:targetView];
            
            maskImage = [LLMessageImageCell bubbleImageForModel:model];
            
        }else if (model.messageBodyType == kCSMessageBodyTypeVideo) {
            videoCell = (LLMessageVideoCell *)cell;
            [videoCell willExitFullScreenShow];

            blackView = [[UIView alloc] initWithFrame:SCREEN_FRAME];
            blackView.backgroundColor = [UIColor blackColor];
            [self.view addSubview:blackView];
            
            targetView = [[UIImageView alloc] initWithImage:model.thumbnailImage];
            CGRect targetViewBeginFrame = CGRectZero;
            targetViewBeginFrame.size.width = SCREEN_WIDTH;
            targetViewBeginFrame.size.height = model.thumbnailImage.size.height / model.thumbnailImage.size.width * SCREEN_WIDTH;
            targetViewBeginFrame.origin.y = SCREEN_HEIGHT > CGRectGetHeight(targetViewBeginFrame) ? (SCREEN_HEIGHT - CGRectGetHeight(targetViewBeginFrame))/2 : 0;
            targetView.contentMode = UIViewContentModeScaleAspectFill;
            targetView.frame = targetViewBeginFrame;
            [self.view addSubview:targetView];

            targetFrame = [videoCell.videoImageView convertRect:videoCell.videoImageView.bounds toView:self.view];

            maskImage = [LLMessageVideoCell bubbleImageForModel:model];
        }
        
        UIImageView *maskImageView = [[UIImageView alloc] initWithImage:maskImage];
        maskImageView.contentMode = UIViewContentModeScaleToFill;
        
        CGRect frame = targetView.frame;
        CGRect maskBeginFrame = CGRectZero;
        maskBeginFrame.origin.y = CGRectGetMinY(frame) < 0 ? -CGRectGetMinY(frame) : 0;
        maskBeginFrame.size.width = CGRectGetWidth(frame);
        maskBeginFrame.size.height = CGRectGetHeight(targetFrame) * (CGRectGetWidth(frame) / CGRectGetWidth(targetFrame));
        if (maskBeginFrame.size.height > CGRectGetHeight(frame)) {
            maskBeginFrame.size.height = CGRectGetHeight(frame);
        }
        
        maskImageView.frame = maskBeginFrame;
        targetView.layer.mask = maskImageView.layer;
        targetView.layer.masksToBounds = YES;
        
        NSInteger index = [self.view.subviews indexOfObject:self.chatInputView];
        [self.view addSubview:self.chatInputView];
        
        [UIView animateWithDuration:DEFAULT_DURATION delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGSize targetViewEndSize = CGSizeMake(CGRectGetWidth(targetFrame), CGRectGetHeight(frame) * (CGRectGetWidth(targetFrame) / CGRectGetWidth(frame)));
            if (targetViewEndSize.height < CGRectGetHeight(targetFrame)) {
                targetViewEndSize = CGSizeMake(CGRectGetWidth(frame) * (CGRectGetHeight(targetFrame) / CGRectGetHeight(frame)), CGRectGetHeight(targetFrame));
            }
            
            CGRect targetViewEndFrame = CGRectZero;
            targetViewEndFrame.size = targetViewEndSize;
            targetViewEndFrame.origin.x = CGRectGetMinX(targetFrame) - (targetViewEndSize.width - CGRectGetWidth(targetFrame))/2;
            targetViewEndFrame.origin.y = CGRectGetMinY(targetFrame) - (targetViewEndSize.height - CGRectGetHeight(targetFrame)) / 2;
            targetView.frame = targetViewEndFrame;
            
            CGRect maskEndFrame = CGRectZero;
            maskEndFrame.origin.x = (targetViewEndSize.width - CGRectGetWidth(targetFrame)) / 2;
            maskEndFrame.origin.y = (targetViewEndSize.height - CGRectGetHeight(targetFrame)) / 2;
            maskEndFrame.size = targetFrame.size;
            maskImageView.frame = maskEndFrame;
            
        } completion:^(BOOL finished) {
            [targetView removeFromSuperview];
            [imageCell didExitFullScreenShow];
            [videoCell didExitFullScreenShow];
            [self.view insertSubview:self.chatInputView atIndex:index];
            self.tableView.scrollEnabled = YES;
        }];
        
        [UIView animateWithDuration:0.15 delay:0.1 options:UIViewAnimationOptionCurveLinear animations:^{
            blackView.alpha = 0;
        } completion:^(BOOL finished) {
            [blackView removeFromSuperview];
        }];

    }
    
}

#pragma mark - 重新发送/下载消息

- (void)resendMessage:(CSMessageModel *)model {
    [self waitingMessageRefreshSendStatusWithModel:model];
    CSIMSendMessageRequestModel * modelRequest = [CSIMSendMessageRequestModel new];
    modelRequest.body = model;
    [modelRequest.msgStatus when:^(id obj) {
        [self successMessageRefreshSendStatusWithModel:model];
    } failed:^(NSError *error) {
        [self failMessageRefreshSendStatusWithModel:model];
        
    }];
    [[CSIMSendMessageManager shareInstance] sendMessage:modelRequest];
}

- (void)redownloadMessage:(CSMessageModel *)model {
    DLog(@"消息重发");
    switch (model.messageBodyType) {
        case kLLMessageBodyTypeImage:
            break;
        case kLLMessageBodyTypeVoice:
        case kLLMessageBodyTypeVideo:
            [[LLChatManager sharedManager] asynDownloadMessageAttachments:model progress:nil completion:nil];
            break;
        default:
            break;
    }
    
}

#pragma mark - GIF 消息 -

- (void)sendGifMessage:(LLEmotionModel *)emotionModel {
    if ([emotionModel.group.groupName isEqualToString:@"custom"]) {
        NSLog(@"暂不支持");
        return;
    }
    
//    LLChatType chatType = chatTypeForConversationType(self.conversationModel.conversationType);
    CSChatType chatType = self.conversationModel.conversationType;
    LLMessageModel *model = [[LLChatManager sharedManager]
                             sendGIFTextMessage:emotionModel.text
                             to:self.conversationModel.chatId
                             messageType:chatType
                             emotionModel:emotionModel
                             completion:nil];
    
    [self addModelToDataSourceAndScrollToBottom:model animated:YES];
}

- (void)cellGifDidTapped:(LLMessageGifCell *)cell {
    LLGIFDisplayController *gifVC = [[LLGIFDisplayController alloc] init];
    gifVC.messageModel = cell.messageModel;
    
    [self.navigationController pushViewController:gifVC animated:YES];
}

#pragma mark - 收到消息 delegate
- (void)cs_receiveMessage:(CSMessageModel *)message
{
    //没有值说明是未读消息回调,不用解析
    if (!message) {
        return;
    }
    if ([message queryMessageWithChatType:CSChatTypeChat chatId:self.conversationModel.chatId]) {
        CSIMSendMessageRequestModel * model = [CSIMSendMessageRequestModel new];
        model.body = message;
        [self addModelToDataSourceAndScrollToBottom:model animated:YES];
    }
}

- (void)cs_sendMessageCallBlock:(CSMessageModel *)message
{
    WEAK_SELF;
    dispatch_async(dispatch_get_main_queue(), ^{
        LLMessageBaseCell *baseCell = [weakSelf visibleCellForMessageModel:message];
        if (!baseCell) {
            [message setNeedsUpdateUploadStatus];
            return;
        }
        [baseCell updateMessageUploadStatus];
    });
}
#pragma mark - 文字消息 -

- (void)sendTextMessage:(NSString *)text {
    
    CSIMSendMessageRequestModel * model = [CSIMSendMessageRequestModel new];
    CSMessageModel * msgModel = [CSMessageModel newMessageChatType:CSChatTypeChat chatId:self.conversationModel.chatId msgId:nil msgType:CSMessageBodyTypeText action:4 content:text isSelf:YES];
    
    model.body = msgModel;
    
    [model.msgStatus when:^(id obj) {
        [self successMessageRefreshSendStatusWithModel:msgModel];
        DLog(@"UI---------->文本发送成功:%@",text);
    } failed:^(NSError *error) {
        [self failMessageRefreshSendStatusWithModel:msgModel];
        DLog(@"UI---------->文本发送失败:%@,error--->",text,error);
    }];
    [[CSIMSendMessageManager shareInstance] sendMessage:model];
    
    [self addModelToDataSourceAndScrollToBottom:model animated:YES];
}

//FIXME:做这块时，遇到两个问题：
//1、当statusBar隐藏时，如何保持UINavigationBar的位置不变？默认行为是上移20point
//2、如何做到presentViewController时保持原来的键盘不回收？
//这个到现在也没查找如何做

- (void)displayTextMessage:(CSMessageModel *)messageModel {
    NSArray *windows = [UIApplication sharedApplication].windows;
    NSInteger maxWindowLevel = 0;
    for (UIWindow *window in windows) {
        if (window.windowLevel > maxWindowLevel) {
            maxWindowLevel = window.windowLevel;
        }
    }
    
    UIWindow *targetWindow = [[UIWindow alloc] initWithFrame:SCREEN_FRAME];
    targetWindow.backgroundColor = [UIColor clearColor];
    targetWindow.windowLevel = maxWindowLevel + 1;
    
    LLTextDisplayController *vc = [[LLTextDisplayController alloc] init];
    vc.messageModel = messageModel;
    vc.textActionDelegate = self;
    targetWindow.rootViewController = vc;
    targetWindow.hidden = NO;
    [vc showInWindow:targetWindow];
}


#pragma mark - 位置消息 -

- (void)presendLocationViewController {
    LLGaoDeLocationViewController *locationVC = [[LLGaoDeLocationViewController alloc] init];
    locationVC.delegate = self;
    
    LLNavigationController *navigationVC = [[LLNavigationController alloc] initWithRootViewController:locationVC];
    
    [self.navigationController presentViewController:navigationVC animated:YES completion:nil];
}

- (LLMessageModel *)didFinishWithLocationLatitude:(double)latitude
                            longitude:(double)longitude
                                 name:(NSString *)name
                              address:(NSString *)address
                            zoomLevel:(double)zoomLevel
                             snapshot:(UIImage *)snapshot {
    
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
    LLChatType chatType = chatTypeForConversationType(self.conversationModel.conversationType);

    LLMessageModel *locationModel = [[LLChatManager sharedManager]
            createLocationMessageWithLatitude:latitude
                                    longitude:longitude
                                    zoomLevel:zoomLevel
                                         name:name
                                      address:address
                                     snapshot:snapshot
                                           to:self.conversationModel.chatId
                                  messageType:chatType];
    NSLog(@"生成位置Model %@", locationModel.messageId);
    
    [self addModelToDataSourceAndScrollToBottom:locationModel animated:NO];
    
    return locationModel;
}

- (void)didCancelLocationViewController:(LLGaoDeLocationViewController *)locationViewController {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)asyncTakeCenterSnapshotDidComplete:(UIImage *)resultImage forMessageModel:(LLMessageModel *)messageModel {

    [[LLChatManager sharedManager] updateAndSendLocationForMessageModel:messageModel
                                withSnapshot:resultImage];
    NSLog(@"更新位置缩略图 %@", messageModel.messageId);
    
    LLMessageLocationCell *cell = (LLMessageLocationCell *)[self visibleCellForMessageModel:messageModel];
    
    if (cell) {
        [cell updateMessageThumbnail];
    }else {
        [messageModel setNeedsUpdateThumbnail];
    }
    
}

- (void)cellLocationDidTapped:(LLMessageLocationCell *)cell {
    [self.chatInputView dismissKeyboard];
    
    LLLocationShowController *locationVC = [[LLLocationShowController alloc] init];
    locationVC.model = cell.messageModel;
    [self.navigationController pushViewController:locationVC animated:YES];
}

- (void)asyncReGeocodeForMessageModel:(LLMessageModel *)messageModel {
    if (messageModel.isFetchingAddress)
        return;
    
    WEAK_SELF;
    messageModel.isFetchingAddress = YES;
    [[LLChatManager sharedManager] asynReGeocodeMessageModel:messageModel completion:^(LLMessageModel *messageModel, LLSDKError *error) {
        messageModel.isFetchingAddress = NO;
        if (![messageModel.conversationId isEqualToString:weakSelf.conversationModel.chatId])
            return;
    
        STRONG_SELF;
        LLMessageBaseCell *cell = [weakSelf visibleCellForMessageModel:messageModel];
        if (cell) {
            NSIndexPath *indexPath = [weakSelf.tableView indexPathForCell:cell];
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            if ((weakSelf.dataSource.count - 1 == indexPath.row) || !strongSelf->isChatControllerDidAppear) {
                [weakSelf.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
        }
        
    }];
}

#pragma mark - 录音

- (LLVoiceIndicatorView *)voiceIndicatorView {
    if (!_voiceIndicatorView) {
        _voiceIndicatorView = [[NSBundle mainBundle] loadNibNamed:@"LLVoiceIndicatorView" owner:nil options:nil][0];
    }
    
    return _voiceIndicatorView;
}
#pragma mark - Input 录音操作 回调
- (void)voiceRecordingShouldStart {
    [[LLAudioManager sharedManager] stopPlaying];
    
    if (![LLAudioManager sharedManager].isRecording)
        [[LLAudioManager sharedManager] startRecordingWithDelegate:self];
}

- (void)voicRecordingShouldFinish {
    [[LLAudioManager sharedManager] stopRecording];
}

- (void)voiceRecordingShouldCancel {
    [[LLAudioManager sharedManager] cancelRecording];
}

- (void)voiceRecordingDidDragoutside {
    if (_voiceIndicatorView.superview && _voiceIndicatorView.style != kLLVoiceIndicatorStyleTooLong)
        [self.voiceIndicatorView setStyle:kLLVoiceIndicatorStyleCancel];
}

- (void)voiceRecordingDidDraginside {
    if (_voiceIndicatorView.superview && _voiceIndicatorView.style != kLLVoiceIndicatorStyleTooLong)
        [self.voiceIndicatorView setStyle:kLLVoiceIndicatorStyleRecord];
}

- (void)voiceRecordingTooShort {
    [[LLAudioManager sharedManager] cancelRecording];
    
    [LLTipView showTipView:self.voiceIndicatorView];
    [self.voiceIndicatorView setStyle:kLLVoiceIndicatorStyleTooShort];
    
    [self hideVoiceIndicatorViewAfterDelay:MIN_RECORD_TIME_REQUIRED];
}
//到此结束
- (void)audioRecordAuthorizationDidGranted {
    [LLTipView showTipView:self.voiceIndicatorView];
    [self.voiceIndicatorView setStyle:kLLVoiceIndicatorStyleRecord];
}

//录音开始，此时做一个录音动画
- (void)audioRecordDidStartRecordingWithError:(NSError *)error {
    if (error) {
        if (_voiceIndicatorView.superview)
            [LLTipView hideTipView:_voiceIndicatorView];
        return;
    }
    
    CSMessageModel *messageModel = [[CSMessageModel alloc] initWithType:kCSMessageBodyTypeRecording];
    CSIMSendMessageRequestModel * model = [CSIMSendMessageRequestModel new];
    model.body = messageModel;
    [self addModelToDataSourceAndScrollToBottom:model animated:YES];

}

- (void)audioRecordDidUpdateVoiceMeter:(double)averagePower {
    if (_voiceIndicatorView.superview) {
        [_voiceIndicatorView updateMetersValue:averagePower];
    }
}

- (void)audioRecordDurationDidChanged:(NSTimeInterval)duration {
    [[LLMessageRecordingCell sharedRecordingCell] updateDurationLabel:round(duration)];
}

- (CSMessageModel *)getRecordingModel {
    for (NSInteger i = self.dataSource.count - 1; i >= 0; i--) {
        if (self.dataSource[i].messageBodyType == kCSMessageBodyTypeRecording) {
            return self.dataSource[i];
        }
    }

    return nil;
}

//移除录音动画
- (void)audioRecordDidFailed {
    if (_voiceIndicatorView.superview) {
        [_voiceIndicatorView setCountDown:0];
        [LLTipView hideTipView:_voiceIndicatorView];
    }
    
    LLMessageModel *voiceModel = [self getRecordingModel];
    if (voiceModel) {
        WEAK_SELF;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf deleteTableRowWithModel:voiceModel withRowAnimation:UITableViewRowAnimationFade];
        });
    }
}

- (void)audioRecordDidCancelled {
    [self audioRecordDidFailed];
}

- (NSTimeInterval)audioRecordMaxRecordTime {
    return MAX_RECORD_TIME_ALLOWED - 10;
}

- (void)audioRecordDurationTooShort {
    LLMessageModel *voiceModel = [self getRecordingModel];
    if (voiceModel) {
        WEAK_SELF;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf deleteTableRowWithModel:voiceModel withRowAnimation:UITableViewRowAnimationFade];
        });
    }else {
        [LLTipView showTipView:self.voiceIndicatorView];
        [self.voiceIndicatorView setStyle:kLLVoiceIndicatorStyleTooShort];
        
        [self hideVoiceIndicatorViewAfterDelay:2];
    }
}

- (void)audioRecordDurationTooLong {
    if (_voiceIndicatorView.superview) {
        countDown = 9;
        NSTimer *countDownTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(showCountDownIndicator:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:countDownTimer forMode:NSRunLoopCommonModes];
    }
    
}

- (void)showCountDownIndicator:(NSTimer *)timer {
    if (_voiceIndicatorView.superview && countDown > 0) {
        [_voiceIndicatorView setCountDown:countDown];
        --countDown;
    }else {
        [_voiceIndicatorView setCountDown:0];
        [timer invalidate];
        
        [[LLAudioManager sharedManager] stopRecording];
        
    }
}
#pragma mark - 结束录音 发送录音
//#FIXME: 声音录制结束
- (void)audioRecordDidFinishSuccessed:(NSString *)voiceFilePath duration:(CFTimeInterval)duration {
    if (_voiceIndicatorView.superview)  {
        if (_voiceIndicatorView.style == kLLVoiceIndicatorStyleTooLong) {
            WEAK_SELF;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                STRONG_SELF;
                if (strongSelf->_voiceIndicatorView.superview)
                    [LLTipView hideTipView:strongSelf->_voiceIndicatorView];
                
                [weakSelf.chatInputView cancelRecordButtonTouchEvent];
            });
        }else {
            [LLTipView hideTipView:_voiceIndicatorView];
            if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
                [self.chatInputView cancelRecordButtonTouchEvent];
            }
        }
    }
    
//    LLChatType chatType = chatTypeForConversationType(self.conversationModel.conversationType);
//#FIXME: 待处理
    CSIMSendMessageRequestModel * model = [CSIMSendMessageRequestModel new];
    __block CSMessageModel * msgModel;
    [CSHttpRequestManager upLoadFileRequestParamters:nil filePath:voiceFilePath fileType:CS_UPLOAD_FILE_VOICE success:^(id responseObject) {
        CSUploadFileModel * rsp = [CSUploadFileModel mj_objectWithKeyValues:responseObject];
        
        msgModel = [CSMessageModel newVoiceMessageChatType:CSChatTypeChat chatId:self.conversationModel.chatId msgId:nil msgType:(CSMessageBodyTypeVoice) action:4 content:rsp.result.file_url localPath:voiceFilePath duration:duration uploadProgress:^(CGFloat progress) {
            DLog(@"语音上传进度--->%g",progress);
        } uploadStatus:^(CSMessageModel *model, NSError *error) {
            
        } isSelf:YES];

        CSMessageModel *recordingModel = [self getRecordingModel];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (recordingModel) {
                NSInteger index = [self.dataSource indexOfObject:recordingModel];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
                [self.dataSource replaceObjectAtIndex:index withObject:msgModel];
                
                //        index = [self.conversationModel.allMessageModels indexOfObject:recordingModel];
                //        [self.conversationModel.allMessageModels replaceObjectAtIndex:index withObject:voiceModel];
                
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            model.body = msgModel;// 发送语音 model
        
            [model.msgStatus when:^(id obj) {
                DLog(@"语音一FASONG");
                [self successMessageRefreshSendStatusWithModel:msgModel];
            } failed:^(NSError *error) {
                [self failMessageRefreshSendStatusWithModel:msgModel];
            }];
            
            [[CSIMSendMessageManager shareInstance] sendMessage:model];
            
        });
            
                    
    } failure:^(NSError *error) {
        
    } uploadprogress:^(CGFloat uploadProgress) {
        NSLog(@"上传进度->%@",uploadProgress);
    } showHUD:YES];
//    return;
    
  
//                                 sendVoiceMessageWithLocalPath:voiceFilePath duration:duration to:@"3" messageType:kLLChatTypeChat messageExt:nil completion:nil];
//                                 newMessageChatType:CSChatTypeChat chatId:@"3" msgId:nil msgType:CSMessageBodyTypeVoice action:4 content:text];
    
//    model.body = msgModel;
    
//    CSChatType chatType = self.conversationModel.conversationType;
//    LLMessageModel *voiceModel = [[LLChatManager sharedManager]
//            sendVoiceMessageWithLocalPath:voiceFilePath
//                                 duration:duration
//                                       to:self.conversationModel.chatId
//                              messageType:chatType
//                               messageExt:nil
//                               completion:nil];
//    
//    CSMessageModel *recordingModel = [self getRecordingModel];
//    if (recordingModel) {
//        [[LLChatManager sharedManager] updateMessageModelWithTimestamp:voiceModel timestamp:recordingModel.timestamp];
//
//        NSInteger index = [self.dataSource indexOfObject:recordingModel];
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
//        [self.dataSource replaceObjectAtIndex:index withObject:voiceModel];
//        
//        index = [self.conversationModel.allMessageModels indexOfObject:recordingModel];
//        [self.conversationModel.allMessageModels replaceObjectAtIndex:index withObject:voiceModel];
//        
//        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//        [[LLChatManager sharedManager] updateMessageModelWithTimestamp:voiceModel timestamp:recordingModel.timestamp];
        
//        NSInteger index = [self.dataSource indexOfObject:recordingModel];
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
//        [self.dataSource replaceObjectAtIndex:index withObject:msgModel];
        
//        index = [self.conversationModel.allMessageModels indexOfObject:recordingModel];
//        [self.conversationModel.allMessageModels replaceObjectAtIndex:index withObject:voiceModel];
        
//        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//    }else {
//        [self addModelToDataSourceAndScrollToBottom:model animated:YES];
//    }

}

#pragma mark - 播放录音 -

- (void)cellVoiceDidTapped:(LLMessageVoiceCell *)cell {
    CSMessageModel *messageModel = cell.messageModel;
    
    if (!messageModel.isVoicePlayable) {
//        if (messageModel.messageDownloadStatus == kCSMessageDownloadStatusPending || messageModel.messageDownloadStatus == kCSMessageDownloadStatusFailed) {
            if (!messageModel.fileLocalPath.length) {
//            [[LLChatManager sharedManager] asynDownloadMessageAttachments:messageModel progress:nil completion:nil];
            [[CSIMMessageQueueManager shareInstance] asynsDownLoaderVoiceWithModel:messageModel success:^(id responseObject) {
                [messageModel internal_setMessageDownloadStatus:kCSMessageDownloadStatusSuccessed];
                [cell updateMessageDownloadStatus];//更新下载状态
                [self cellVoiceDidTapped:cell];
            } fail:^(NSError *error) {
                
            }];
        }
        
        return;
    }
    
    if (messageModel.isMediaPlaying) {
        messageModel.isMediaPlaying = NO;
        [cell stopVoicePlaying];
        [[LLAudioManager sharedManager] stopPlaying];
   
    }else {
        [[LLAudioManager sharedManager] startPlayingWithPath:messageModel.fileLocalPath delegate:self userinfo:cell.messageModel continuePlaying:NO];
    }
    
}

- (void)audioPlayDidStarted:(id)userinfo {
    CSMessageModel *messageModel = (CSMessageModel *)userinfo;
    LLMessageVoiceCell *cell = (LLMessageVoiceCell *)[self visibleCellForMessageModel:messageModel];
    
    [[LLChatManager sharedManager] changeVoiceMessageModelPlayStatus:messageModel];
    messageModel.isMediaPlaying = YES;
    [cell startVoicePlaying];
    
    [[LLDeviceManager sharedManager] enableProximitySensor];
    [LLDeviceManager sharedManager].delegate = self;
}

- (void)audioPlayVolumeTooLow {
    [LLUtils showTipView:self.voiceIndicatorView];
    [self.voiceIndicatorView setStyle:kLLVoiceIndicatorStyleVolumeTooLow];

}

- (void)voiceCellDidEndPlaying:(id)userinfo {
    [[LLDeviceManager sharedManager] disableProximitySensor];
    [LLDeviceManager sharedManager].delegate = nil;
    
    if (_voiceIndicatorView.superview)
        [LLTipView hideTipView:_voiceIndicatorView];
    
    CSMessageModel *messageModel = (LLMessageModel *)userinfo;
    messageModel.isMediaPlaying = NO;
    LLMessageVoiceCell *cell = (LLMessageVoiceCell *)[self visibleCellForMessageModel:messageModel];
    [cell stopVoicePlaying];

}

- (void)audioPlayDidFailed:(id)userinfo {
    [self voiceCellDidEndPlaying:userinfo];
}

- (void)audioPlayDidStopped:(id)userinfo {
    [self voiceCellDidEndPlaying:userinfo];
}

- (void)audioPlayDidFinished:(id)userinfo {
    [self hideVoiceIndicatorViewAfterDelay:3];
    
    CSMessageModel *messageModel = (CSMessageModel *)userinfo;
    messageModel.isMediaPlaying = NO;
    LLMessageVoiceCell *cell = (LLMessageVoiceCell *)[self visibleCellForMessageModel:messageModel];
    [cell stopVoicePlaying];
    
    NSMutableArray<CSMessageModel *> *allMessageModels = self.dataSource;
    for (NSInteger index = [allMessageModels indexOfObject:messageModel] + 1, r = allMessageModels.count; index < r; index ++ ) {
        CSMessageModel *model = allMessageModels[index];
    
        if (model.messageBodyType == kCSMessageBodyTypeVoice && !model.isMediaPlayed && !model.isMediaPlaying && !model.isSelf && model.isVoicePlayable) {
            
            [[LLChatManager sharedManager] changeVoiceMessageModelPlayStatus:model];
            LLMessageBaseCell *cell = [self visibleCellForMessageModel:model];
            if (cell) {
                cell.messageModel = cell.messageModel;
            }

            [[LLAudioManager sharedManager] startPlayingWithPath:model.fileLocalPath delegate:self userinfo:model continuePlaying:YES];
            
            return;
        }
    }
    
    [[LLAudioManager sharedManager] stopPlaying];

}


- (void)deviceIsCloseToUser:(BOOL)isCloseToUser {
    if (isCloseToUser) {
        //切换为听筒播放
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }else {
        //切换为扬声器播放
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
    
    if (!isCloseToUser && !self.voiceTipView.superview) {
        WEAK_SELF;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.view addSubview:self.voiceTipView];
            weakSelf.voiceTipView.alpha = 0;
            [UIView animateWithDuration:0.5 animations:^{
                weakSelf.voiceTipView.alpha = 1;
            }];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.voiceTipView removeWithAnimation];
            });
        });
        
        
    }
}

- (void)hideVoiceIndicatorViewAfterDelay:(CGFloat)delay {
    if (_voiceIndicatorView.superview) {
        WEAK_SELF;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            STRONG_SELF;
            if (strongSelf->_voiceIndicatorView.superview)
                [LLTipView hideTipView:strongSelf->_voiceIndicatorView];
        });
    }
}

#pragma mark - Sight 小视频 -

- (void)presentSightController {
    self.chatInputView.delegate = nil;
    [self.chatInputView dismissKeyboard];
    self.chatInputView.delegate = self;
    
    _sightController = [[LLSightCapatureController alloc] initWithNibName:nil bundle:nil];
    _sightController.delegate = self;
    
    UIView *dimView = [[UIView alloc] initWithFrame:self.view.bounds];
    dimView.backgroundColor = [UIColor blackColor];
    dimView.alpha = 0;
    dimView.userInteractionEnabled = NO;
    dimView.tag = DIM_VIEW_TAG;
    [self.view addSubview:dimView];
    
    [self addChildViewController:_sightController];
    CGFloat _height = round(THE_GOLDEN_RATIO * SCREEN_HEIGHT);
    _sightController.view.frame = CGRectMake(0, SCREEN_HEIGHT - 320, SCREEN_WIDTH, _height);

    self.view.backgroundColor = TABLEVIEW_BACKGROUND_COLOR;
    [UIView animateWithDuration:DEFAULT_DURATION animations:^{
        self.chatInputViewBottomConstraint.constant = -CGRectGetHeight(self.chatInputView.frame);
        self.tableViewBottomConstraint.constant = MAIN_BOTTOM_TABBAR_HEIGHT;
        
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, _height - MAIN_BOTTOM_TABBAR_HEIGHT - NAVIGATION_BAR_HEIGHT, 0);
        self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
        [self.view layoutIfNeeded];
        [self scrollToBottom:NO];
    } completion:^(BOOL finished) {
        [self.view addSubview:_sightController.view];
        [_sightController.contentView.layer addObserver:self forKeyPath:@"position" options:NSKeyValueObservingOptionNew context:nil];
        
        [UIView animateWithDuration:DEFAULT_DURATION animations:^{
            dimView.alpha = 0.4;
            _sightController.view.bottom_LL = SCREEN_HEIGHT;
        }];
    }];

}

- (void)sightCapatureControllerDidCancel:(LLSightCapatureController *)sightController {
    UIView *dimView = [self.view viewWithTag:DIM_VIEW_TAG];
    [_sightController.contentView.layer removeObserver:self forKeyPath:@"position"];
    _sightController = nil;
    
    [UIView animateWithDuration:DEFAULT_DURATION animations:^{
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, CGRectGetHeight(self.chatInputView.frame) - MAIN_BOTTOM_TABBAR_HEIGHT, 0);
        self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
        sightController.view.top_LL = SCREEN_HEIGHT;
        dimView.alpha = 0;
    
    } completion:^(BOOL finished) {
        [sightController.view removeFromSuperview];
        [sightController removeFromParentViewController];
        [dimView removeFromSuperview];
        
        [UIView animateWithDuration:DEFAULT_DURATION animations:^{
            self.tableViewBottomConstraint.constant = 0;
            self.chatInputViewBottomConstraint.constant = 0;
            [self.view layoutIfNeeded];
            self.tableView.contentInset = UIEdgeInsetsMake(CGRectGetHeight(self.chatInputView.frame) - MAIN_BOTTOM_TABBAR_HEIGHT, 0, 0, 0);
            self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
        } completion:^(BOOL finished) {
            self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
        }];
    }];
}

- (void)removeSightController {
    if (!_sightController)
        return;
    
    [_sightController.contentView.layer removeObserver:self forKeyPath:@"position"];
    [_sightController.view removeFromSuperview];
    [_sightController removeFromParentViewController];
    
    UIView *dimView = [self.view viewWithTag:DIM_VIEW_TAG];
    [dimView removeFromSuperview];
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    self.tableViewBottomConstraint.constant = 0;
    self.chatInputViewBottomConstraint.constant = 0;
    _sightController = nil;
}


#pragma - KVO -

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"position"]) {
        UIView *dimView = [self.view viewWithTag:DIM_VIEW_TAG];
        dimView.alpha = 0.4 * (1 - CGRectGetMinY(_sightController.contentView.frame) / CGRectGetHeight(_sightController.view.frame));
    }else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


#pragma mark - Debug

- (void)debug1:(id)sender {

}

- (void)debug2:(id)sender {

    
}

#pragma mark - 辅助方法

+ (NSString *)getFileSizeString:(CGFloat)fileSize {
    NSString *ret;
    fileSize /= 1024;
    if (fileSize < 1024) {
        ret = [NSString stringWithFormat:@"%.0fK", round(fileSize)];
    }else {
        ret = [NSString stringWithFormat:@"%.2fM", fileSize/1024];
    }
    
    return ret;
}

- (void)failMessageRefreshSendStatusWithModel:(CSMessageModel *)model
{
    LLMessageBaseCell * cell = [self visibleCellForMessageModel:model];
    if (cell) {
        [model internal_setMessageStatus:kCSMessageStatusFailed];
        [cell updateMessageUploadStatus];
    }
}

- (void)successMessageRefreshSendStatusWithModel:(CSMessageModel *)model
{
    LLMessageBaseCell * cell = [self visibleCellForMessageModel:model];
    if (cell) {
        [model internal_setMessageStatus:kCSMessageStatusSuccessed];
        [cell updateMessageUploadStatus];
    }
}

- (void)waitingMessageRefreshSendStatusWithModel:(CSMessageModel *)model
{
    LLMessageBaseCell * cell = [self visibleCellForMessageModel:model];
    if (cell) {
        [model internal_setMessageStatus:kCSMessageStatusWaiting];
        [cell updateMessageUploadStatus];
    }
}
#pragma mark - 其他 -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
