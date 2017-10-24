//
//  CSPublicBetViewController.m
//  ChangSheng
//
//  Created by 邴天宇 on 2017/10/14.
//  Copyright © 2017年 邴天宇. All rights reserved.
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
#import "LLMessageBaseCell.h"
@import MediaPlayer;

#define BLACK_BAR_VIEW_TAG 1000
#define DIM_VIEW_TAG 1001

#define VIEW_BACKGROUND_COLOR kLLBackgroundColor_lightGray

#define TABLEVIEW_BACKGROUND_COLOR kLLBackgroundColor_lightGray
#import "CSGongGaoView.h"
#import "LBPhotoBrowserManager.h"
#import "LB3DTouchVC.h"
#import "CSUploadFileModel.h"
#import "IQKeyboardManager.h"
#import "CSIMReceiveManager.h"
#import "CSIMSendMessageRequest.h"
#import "CSIMSendMessageManager.h"
#import "CSIMSendMessageRequestModel.h"
#import "TTNavigationController.h"
#import "CSUserServiceListViewController.h"
//#import "KVOController.h"
#import "LLWebViewController.h"
#import "NSString+TTLengthExtend.h"

#import "CSPublicBetViewController.h"
#import "CSPublicBetInputToolBarView.h"
#import "StoryBoardController.h"
#import "CSMsgHistoryRequestModel.h"
@interface CSPublicBetViewController ()
<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate,
LLMessageCellActionDelegate, LLChatImagePreviewDelegate,
LLImagePickerControllerDelegate, LLChatShareDelegate, LLLocationViewDelegate,
LLAudioRecordDelegate, LLAudioPlayDelegate, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, LLChatManagerMessageListDelegate,
LLDeviceManagerDelegate, LLSightCapatureControllerDelegate, LLTextActionDelegate,
MFMailComposeViewControllerDelegate,
CSIMReceiveManagerDelegate,
CSPublicBetInputToolBarViewDelegate
>

@property (strong, nonatomic) UITableView *tableView;

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

@property (nonatomic,strong) CSPublicBetInputToolBarView *inputToolBarView;

@property(nonatomic,assign)CGFloat keyboardHeight;

@property(nonatomic,assign)CGFloat textViewChangeHeight;

@property (nonatomic,strong) CSGongGaoView * gongGaoView;
@end

@implementation CSPublicBetViewController{
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

-(CSGongGaoView *)gongGaoView
{
    if (!_gongGaoView) {
        _gongGaoView = [CSGongGaoView viewFromXIB];
        
    }
    return _gongGaoView;
}

#pragma mark - UI/LifeCycle 相关 -
//#FIXME:    ***************************************inputView
- (void)keyboardFrameWillChange:(NSNotification *)notify {
    CGRect kbFrame = [[notify userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat constant = kbFrame.size.height;
    
    [UIView animateWithDuration:0.2 animations:^{
        CGFloat textHeight;
        if (self.inputToolBarView.currentInputType == CS_CurrentInputType_Bet) {
            textHeight = 0;
        }
        else
        {
            textHeight = self.textViewChangeHeight;
        }
        self.inputToolBarView.y = HEIGHT - 50 - kbFrame.size.height - textHeight;
        self.keyboardHeight = kbFrame.size.height;
        self.inputToolBarView.maskView.alpha = 0;
        
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, constant + textHeight, 0);
        self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
        [self.tableView scrollsToBottomAnimated:YES];
        
    }completion:^(BOOL finished) {
        
    }];
}
//#FIXME:    ***************************************inputView
- (void)updateFrame:(NSNotification *)notice
{
    NSNumber * height = notice.object;
    
    CGFloat textHeight = height.floatValue -33 ;
    [UIView animateWithDuration:0.2 animations:^{
//        if (self.inputToolBarView.currentInputType == CS_CurrentInputType_Bet) {
//            textHeight = 0;
//        }
//        else
//        {
//            textHeight = self.textViewChangeHeight;
//        }
        self.textViewChangeHeight = textHeight;
        self.inputToolBarView.y = HEIGHT - 50 - _keyboardHeight - textHeight;
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, _keyboardHeight + textHeight , 0);
        //UIEdgeInsetsMake(0, 0, HEIGHT - self.inputToolBarView.height - 64 + textHeight , 0);
        self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
        [self.tableView scrollToBottomAnimated:YES];
    }];
}
- (void)cs_keyboardHide
{
    [UIView animateWithDuration:0.15 animations:^{
        self.inputToolBarView.maskView.alpha = 1;
    }];
    [UIView animateWithDuration:0.3 delay:0 options:(UIViewAnimationOptionCurveEaseIn) animations:^{
        CGFloat textHeight;
        if (self.inputToolBarView.currentInputType == CS_CurrentInputType_Bet) {
            textHeight = 0;
        }
        else
        {
            textHeight = self.textViewChangeHeight;
        }
        self.inputToolBarView.y = HEIGHT - 50 - textHeight;
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, textHeight, 0);
        self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
        [self.tableView layoutIfNeeded];
    } completion:nil];
}

- (void)cs_keyboardShow
{
    [UIView animateWithDuration:0.15 animations:^{
        self.inputToolBarView.maskView.alpha = 0;
    }];
    [UIView animateWithDuration:0.25 animations:^{
        CGFloat textHeight;
        if (self.inputToolBarView.currentInputType == CS_CurrentInputType_Bet) {
            textHeight = 0;
        }
        else
        {
            textHeight = self.textViewChangeHeight;
        }
        self.inputToolBarView.y = HEIGHT - self.inputToolBarView.height - textHeight;
        
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, HEIGHT - self.inputToolBarView.height - 64 + textHeight, 0);
        self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
        [self.tableView scrollsToBottomAnimated:YES];
        [self.tableView layoutIfNeeded];
    } completion:^(BOOL finished) {
        //        [self.tableView scrollsToBottomAnimated:YES];
    }];
    
}

- (void)cellImageDidTapped:(LLMessageImageCell *)cell {
    
    [[LBPhotoBrowserManager defaultManager] showImageWithURLArray:@[cell.messageModel.body.content] fromImageViews:@[cell.chatImageView] selectedIndex:0 imageViewSuperView:cell.chatImageView.superview];
    
//    if (cell.chatImageView.image) {
//        [self showAssetFromCell:cell];
//    }else if (!cell.messageModel.isFetchingThumbnail){
////        [cell willDisplayCell];
//    }
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

- (void)loadWebLinkWithUrl:(NSString *)url title:(NSString *)title
{
    LLWebViewController *web = [[LLWebViewController alloc] initWithNibName:nil bundle:nil];
    web.fromViewController = self;
    web.url = [NSURL URLWithString:url];
    web.title = title;
    [self.navigationController pushViewController:web animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFrame:) name:@"updateInputTextViewFrame" object:nil];
    
    [CSIMReceiveManager shareInstance].delegate = self;
    [[CSIMReceiveManager shareInstance] inChatWithChatType:(CSChatTypeGroupChat) chatId:self.conversationModel.chatId];
    
    [self createSubviews];
    
    [self createNavigationBarButtons];
    //记录进入该聊天室
    
    [self addRefreshTool];
}

- (void)reConnectionSocket
{
        CSMessageModel * msgData = [self.dataSource firstObject];
        CSMsgHistoryRequestModel * param = [CSMsgHistoryRequestModel new];
        param.chat_type = CSChatTypeGroupChat;//1为群聊
        param.ID = self.conversationModel.chatId.intValue;
        [CSHttpRequestManager request_chatRecord_paramters:param.mj_keyValues success:^(id responseObject) {
            CSMsgRecordModel * obj = [CSMsgRecordModel mj_objectWithKeyValues:responseObject];
            
            NSMutableArray * messagesArray = [NSMutableArray array];
//            NSMutableArray * messagesRequestArray = [NSMutableArray array];
            for (CSMsgRecordModel * msgData in obj.result.data) {
                CSMessageModel * msgModel = [CSMessageModel conversionWithRecordModel:msgData chatType:param.chat_type chatId:[NSString stringWithFormat:@"%d",self.conversationModel.chatId]];
                
                CSIMSendMessageRequestModel * sendMsgModel = [CSIMSendMessageRequestModel new];
                sendMsgModel.body = msgModel;
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
        param.chat_type = CSChatTypeGroupChat;//1为群聊
        param.ID = self.conversationModel.chatId.intValue;
        param.last_id = msgData.msgId;
        [CSHttpRequestManager request_chatRecord_paramters:param.mj_keyValues success:^(id responseObject) {
            CSMsgRecordModel * obj = [CSMsgRecordModel mj_objectWithKeyValues:responseObject];

            NSMutableArray * messagesArray = [NSMutableArray array];
            NSMutableArray * messagesRequestArray = [NSMutableArray array];
            for (CSMsgRecordModel * msgData in obj.result.data) {
                CSMessageModel * msgModel = [CSMessageModel conversionWithRecordModel:msgData chatType:param.chat_type chatId:[NSString stringWithFormat:@"%d",self.conversationModel.chatId]];

                CSIMSendMessageRequestModel * sendMsgModel = [CSIMSendMessageRequestModel new];
                sendMsgModel.body = msgModel;
                [messagesArray addObject:msgModel];
//                [messagesRequestArray addObject:sendMsgModel];
                [messagesRequestArray addObject:msgModel];
            }
//            [self.dataSource insertObjects:messagesArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, messagesArray.count)]];
//            [self.conversationModel.allMessageModels insertObjects:messagesRequestArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, messagesRequestArray.count)]];
            [self.conversationModel.allMessageModels insertObjects:messagesRequestArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, messagesRequestArray.count)]];
            self.dataSource = [self processData:self.conversationModel];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        } failure:^(NSError *error) {
            [self.tableView.mj_header endRefreshing];
        } showHUD:NO];
    }];
}

- (void)createNavigationBarButtons
{
    UIButton * caiwuBtn =self.tt_navigationBar.rightBtn;
    caiwuBtn.hidden = NO;
    [caiwuBtn setImage:[UIImage imageNamed:@"财务BTN"] forState:(UIControlStateNormal)];
    
    UIButton * kefuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [kefuBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    [kefuBtn setImage:[UIImage imageNamed:@"客服BTN"] forState:(UIControlStateNormal)];
    [kefuBtn addTarget:self action:@selector(kefuBtnDidAction) forControlEvents:(UIControlEventTouchUpInside)];
    [kefuBtn sizeToFit];
    [self.tt_navigationBar.centerView addSubview:kefuBtn];
    [kefuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(44);
    }];
}


- (void)kefuBtnDidAction
{
    CSUserServiceListViewController * C = [CSUserServiceListViewController new];
    [self.navigationController pushViewController:C animated:YES];
}

- (void)tt_DefaultRightBtnClickAction
{
    UIViewController * caiwuController = [StoryBoardController viewControllerID:@"CSCaiwuViewController" SBName:@"Mine"];
    [self.navigationController pushViewController:caiwuController animated:YES];
}

- (void)tt_DefaultLeftBtnClickAction
{
    [super tt_DefaultLeftBtnClickAction];
    [[CSIMReceiveManager shareInstance] removeDelegate:self];
    //退出该聊天室
    [[CSIMReceiveManager shareInstance] outChatWithChatType:(CSChatTypeGroupChat) chatId:self.conversationModel.chatId];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    

    [self.gongGaoView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.top).offset(64);
    }];
    [UIView animateWithDuration:0.25 animations:^{
        [self.gongGaoView layoutIfNeeded];
    }];
    
    [self blackStatusBar];
    [self addKeyboardObserver];
    
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
    [CSIMReceiveManager shareInstance].delegate = self;
    
    TTNavigationController * nav = (TTNavigationController *)self.navigationController;
    [nav navigationCanDragBack:NO];
    
    [self scrollToBottom:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    [[IQKeyboardManager sharedManager] setEnable:YES];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [self removeKeyboardObserver];
    
    TTNavigationController * nav = (TTNavigationController *)self.navigationController;
    [nav navigationCanDragBack:YES];
    
    self.navigationController.interactivePopGestureRecognizer.delaysTouchesBegan = YES;
}

- (void)createSubviews
{
    [self tt_SetNaviBarHide:NO withAnimation:NO];
    
    self.tt_navigationBar.contentView.backgroundColor = [UIColor whiteColor];
    self.tt_navigationBar.titleLabel.textColor = [UIColor colorWithHexColorString:@"333333"];
    [self tt_Title:self.conversationModel.nickName];
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.refreshView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
    self.voiceTipView.frame = CGRectMake(0, 64, SCREEN_WIDTH, 45);
    
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    [self.tableView addGestureRecognizer:tapGesture];
    
//    self.chatInputView.delegate = self;
    self.dataSource = [NSMutableArray array];
    
    self.refreshView.backgroundColor = TABLEVIEW_BACKGROUND_COLOR;
    isPulling = NO;
    isLoading = NO;
  
    [self loadMessageData];
    
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.inputToolBarView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(64);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-50);
    }];
    
    [self.tableView reloadData];

    [self.view addSubview:self.gongGaoView];
    self.gongGaoView.contentView.text = self.conversationModel.group_tips;
    CGRect frame = [self.conversationModel.group_tips boundsWithFontSize:13 textWidth:WIDTH - 40 -35];
    CGFloat height = frame.size.height + 30;
    [self.gongGaoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.top).offset(64 - height);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(height);
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.gongGaoView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.top).offset(64 - height);
        }];
        [UIView animateWithDuration:0.25 animations:^{
            [self.gongGaoView layoutIfNeeded];
        }];
    });
}

- (void)loadMessageData
{
//    for (CSIMSendMessageRequestModel * sendMsgModel in self.conversationModel.allMessageModels) {
//        [self.dataSource addObject:sendMsgModel.body];
//    }
    self.dataSource = [self processData:self.conversationModel];
    [self.tableView reloadData];
}

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


- (void)updateViewConstraints {
    self.tableViewHeightConstraint.constant = SCREEN_HEIGHT - 64 - MAIN_BOTTOM_TABBAR_HEIGHT;
    
    [super updateViewConstraints];
}

- (void)tapHandler:(UITapGestureRecognizer *)tap {
    [self.inputToolBarView cs_resignFirstResponder];
}

#pragma mark - 文字消息 -

- (void)sendTextMessage:(NSString *)text {
    
    CSIMSendMessageRequestModel * model = [CSIMSendMessageRequestModel new];
    CSMessageModel * msgModel = [CSMessageModel newMessageChatType:CSChatTypeGroupChat chatId:self.conversationModel.chatId msgId:nil msgType:CSMessageBodyTypeText action:4 content:text isSelf:YES];
    
    model.body = msgModel;
    
    [model.msgStatus when:^(id obj) {
        DLog(@"UI层-----文本:%@已发送",text);
//        [self failMessageRefreshSendStatusWithModel:msgModel];

        [self successMessageRefreshSendStatusWithModel:msgModel];
    } failed:^(NSError *error) {
        [self failMessageRefreshSendStatusWithModel:msgModel];
    }];
    [[CSIMSendMessageManager shareInstance] sendMessage:model];
    
    [self addModelToDataSourceAndScrollToBottom:model animated:YES];
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
- (void)resendMessage:(CSMessageModel *)model {
    [self waitingMessageRefreshSendStatusWithModel:model];
    CSIMSendMessageRequestModel * modelRequest = [CSIMSendMessageRequestModel new];
    modelRequest.body = model;
    [modelRequest.msgStatus when:^(id obj) {
        [self successMessageRefreshSendStatusWithModel:model];
    } failed:^(NSError *error) {
        [self failMessageRefreshSendStatusWithModel:model];
        [MBProgressHUD tt_ShowInView:self.view WithTitle:error.domain after:1];
    }];
    [[CSIMSendMessageManager shareInstance] sendMessage:modelRequest];

//    [[LLChatManager sharedManager] resendMessage:model
//                                        progress:nil
//                                      completion:nil];
    
}

#pragma mark - 收到消息 delegate
- (void)cs_receiveMessage:(CSMessageModel *)message
{
    //没有值说明是未读消息回调,不用解析
    if (!message) {
        return;
    }
    if ([message queryMessageWithChatType:CSChatTypeGroupChat chatId:self.conversationModel.chatId]) {
        CSIMSendMessageRequestModel * model = [CSIMSendMessageRequestModel new];
        model.body = message;
        [self addModelToDataSourceAndScrollToBottom:model animated:YES];
    }
}

- (void)cs_sendMessageCallBlock:(CSMessageModel *)message
{
    WEAK_SELF;
    dispatch_async(dispatch_get_main_queue(), ^{
//        LLMessageBaseCell *baseCell = [weakSelf visibleCellForMessageModel:message];
//        if (!baseCell) {
//            [message setNeedsUpdateUploadStatus];
//            return;
//        }
//
//        [baseCell updateMessageUploadStatus];
        
    });
}
- (void)cs_keyboardSendMessageText:(NSString *)text
{
    [self sendTextMessage:text];
}

- (void)cs_keyboardBtnActionType:(int)type
{
    switch (type) {
        case 0:
        {
            [self loadWebLinkWithUrl:[NSString stringWithFormat:@"%@/chat/bootsImg?group_id=%@&token=%@",baseUrl,self.conversationModel.chatId,[CSUserInfo shareInstance].info.token] title:@"路单图"];
        }
            break;
        case 1:
        {
            [self loadWebLinkWithUrl:[NSString stringWithFormat:@"%@/chat/bettingList?group_id=%@&token=%@",baseUrl,self.conversationModel.chatId,[CSUserInfo shareInstance].info.token] title:@"投注表"];
        }
            break;
        case 2:
        {
            [self loadWebLinkWithUrl:[NSString stringWithFormat:@"%@/chat/bettingResultList?group_id=%@&token=%@",baseUrl,self.conversationModel.chatId,[CSUserInfo shareInstance].info.token] title:@"分数表"];
        }
            break;
        default:
            break;
    }
}
#pragma mark - 下注
- (void)cs_betMessageModel:(CSMessageModel *)messageModel
{
    CSIMSendMessageRequestModel * model = [CSIMSendMessageRequestModel new];
    CSMessageModel * msgModel = [CSMessageModel sendBetMessageChatType:CSChatTypeGroupChat chatId:self.conversationModel.chatId msgId:nil msgType:(CSMessageBodyTypeText) betType:messageModel.playType betNumber:messageModel.score action:messageModel.action content:messageModel.content isSelf:YES];
//     CSMessageModel * msgModel = [CSMessageModel sendBetMessageChatType:CSChatTypeGroupChat chatId:@"10" msgId:nil msgType:(CSMessageBodyTypeText) betType:messageModel.playType betNumber:messageModel.score action:messageModel.action content:messageModel.content isSelf:YES];
    
    model.body = msgModel;
    
    [model.msgStatus when:^(id obj) {
        DLog(@"UI层----文本:%@已发送",messageModel.content);
        [self successMessageRefreshSendStatusWithModel:msgModel];
    } failed:^(NSError *error) {
        [MBProgressHUD tt_ShowInView:self.view WithTitle:error.domain after:1];
        [self failMessageRefreshSendStatusWithModel:msgModel];
        if (error.code == 100) { //交易超时
            
        }
        else
        {
            [self deleteCellWithModel:msgModel];
        }
    }];
    [[CSIMSendMessageManager shareInstance] sendMessage:model];
    
    [self addModelToDataSourceAndScrollToBottom:model animated:YES];
}

- (void)deleteCellWithModel:(CSMessageModel *)model
{
    NSInteger index = [self.dataSource indexOfObject:model];
    NSMutableArray<NSIndexPath *> *deleteIndexPaths = [NSMutableArray array];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.conversationModel.allMessageModels removeObject:model];
    [self.dataSource removeObjectAtIndex:index];
    [deleteIndexPaths addObject:indexPath];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationFade)];
//        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
//        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        [self.tableView endUpdates];
//    });
    
    
//    WEAK_SELF;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [weakSelf loadMoreMessagesAfterDeletionIfNeeded];
//    });
}

#pragma mark - 撤销下注
- (void)cs_betCancleMessageModel:(CSMessageModel *)messageModel
{
//    [MBProgressHUD tt_Show];
    CSIMSendMessageRequestModel * model = [CSIMSendMessageRequestModel new];
    CSMessageModel * msgModel = [CSMessageModel newCancleBetMessageChatType:CSChatTypeGroupChat chatId:self.conversationModel.chatId msgId:nil msgType:nil action:5 content:nil isSelf:YES];
    
    model.body = msgModel;
    
    [model.msgStatus when:^(id obj) {
        DLog(@"UI层----文本:%@已发送",messageModel.content);
//        [self successMessageRefreshSendStatusWithModel:msgModel];
        [MBProgressHUD tt_SuccessTitle:@"本局下注已撤销"];
    } failed:^(NSError *error) {
        [MBProgressHUD tt_SuccessTitle:error.domain];
//        [self failMessageRefreshSendStatusWithModel:msgModel];
    }];
    
    [[CSIMSendMessageManager shareInstance] sendMessage:model];
    
//    [self addModelToDataSourceAndScrollToBottom:model animated:YES];
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
//    [UIView setAnimationsEnabled:NO];
    CSMessageModel *messageModel = self.dataSource[indexPath.row];
    UITableViewCell *_cell;
//    if (indexPath.row >= self.dataSource.count) {
//        _cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"123"];
//        return _cell;
//    }
//    else
//    {
//     messageModel  = self.dataSource[indexPath.row];
//    }
        
    NSString *reuseId = [[LLMessageCellManager sharedManager] reuseIdentifierForMessegeModel:messageModel];
    
//    switch (CS_changeMessageType(messageModel.body.msgType)) {
    switch ((messageModel.body.msgType)) {
        case kCSMessageBodyTypeText:
        case kCSMessageBodyTypeVideo:
        case kCSMessageBodyTypeVoice:
        case kCSMessageBodyTypeImage:
        case kCSMessageBodyTypeLink:
        {
            if (messageModel.msgType == CSMessageBodyTypeImage |
                messageModel.msgType == CSMessageBodyTypeGif |
                messageModel.msgType == CSMessageBodyTypeLink) {
                
            }
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
        [baseCell enableLongGesture:NO];//屏蔽长按手势
        [baseCell setCellEditingAnimated:NO];
        if (baseCell.isCellSelected != messageModel.isSelected) {
            baseCell.isCellSelected = messageModel.isSelected;
        }
        
        switch(messageModel.messageBodyType) {
            case kCSMessageBodyTypeLocation: {
                if ([messageModel.address isEqualToString:LOCATION_UNKNOWE_ADDRESS] && !messageModel.isFetchingAddress) {
//                    [self asyncReGeocodeForMessageModel:messageModel];
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
    
//    [UIView setAnimationsEnabled:YES];
    
    return _cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CSMessageModel *messageModel = self.dataSource[indexPath.row];
    //    NSLog(@"height->%g,str->%@",messageModel.cellHeight,messageModel.body.content);
    return messageModel.cellHeight + 10;
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
        [baseCell updateMessageUploadStatus];
    }
}

- (void)addModelToDataSourceAndScrollToBottom:(CSIMSendMessageRequestModel *)messageModel animated:(BOOL)animated {
    [self.conversationModel.allMessageModels addObject:messageModel.body];
    
    [self.dataSource addObject:messageModel.body];
    
    [self.tableView reloadData];
    [self scrollToBottom:animated];
}
- (void)scrollToBottom:(BOOL)animated {
    if (self.dataSource.count == 0)
        return;
    [self.tableView scrollsToBottomAnimated:YES];
}

#pragma mark - cell点击

- (void)cellDidTapped:(LLMessageBaseCell *)cell {
    switch (cell.messageModel.body.msgType) {
        case kCSMessageBodyTypeImage:
            [self cellImageDidTapped:(LLMessageImageCell *)cell];
            break;
        case kCSMessageBodyTypeGif:
            //            [self cellGifDidTapped:(LLMessageGifCell *)cell];
            break;
        case kCSMessageBodyTypeLink:
            //            [self cellVideoDidTapped:(LLMessageVideoCell *)cell];
            
            [self loadWebLinkWithUrl:[NSString stringWithFormat:@"%@?group_id=%@&token=%@",cell.messageModel.body.linkUrl,self.conversationModel.chatId,[CSUserInfo shareInstance].info.token] title:@""];
            break;
        case kCSMessageBodyTypeVoice:
            //            [self cellVoiceDidTapped:(LLMessageVoiceCell *)cell];
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
    //    DLog(@"%@",cell.messageModel.body.msgType);
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
        
        [actionSheet addActions:@[ action2]];
        
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
//    switch (tag) {
//        case TAG_Photo:
//            [self presentImagePickerController];
//            break;
//        case TAG_Location:
//            [self presendLocationViewController];
//            break;
//        case TAG_Camera:
//            [self takePictureAndVideoAction];
//            break;
//        case TAG_Sight:
//            [self presentSightController];
//            break;
//        default:
//            break;
//    }
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = TABLEVIEW_BACKGROUND_COLOR;
        _tableView.contentInset = UIEdgeInsetsZero;
        
        self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
        _tableView.separatorStyle = 0;
    }
    return  _tableView;
}


-(CSPublicBetInputToolBarView *)inputToolBarView
{
    if(!_inputToolBarView)
    {
        CGFloat height = 358;
        _inputToolBarView = [[CSPublicBetInputToolBarView alloc]initWithFrame:CGRectMake(0, HEIGHT - 50, WIDTH, height)];
        _inputToolBarView.delegate = self;
    }
    return _inputToolBarView;
}

- (void)addKeyboardObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardWillShowNotification object:nil];
    //NOTIFICE_KEY_SOCKET_CURRENT_SCORE
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upDateUserScoreText:) name:NOTIFICE_KEY_SOCKET_CURRENT_SCORE object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reConnectionSocket) name:NOTIFICE_KEY_SOCKET_OPEN object:nil];
}

- (void)removeKeyboardObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICE_KEY_SOCKET_CURRENT_SCORE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICE_KEY_SOCKET_OPEN object:nil];
}

- (LLMessageBaseCell *)visibleCellForMessageModel:(CSMessageModel *)model {

    for (UITableViewCell *cell in self.tableView.visibleCells) {
        if ([cell isKindOfClass:[LLMessageDateCell class]]){
            continue;
        }
        LLMessageBaseCell *chatCell = (LLMessageBaseCell *)cell;
        if ((chatCell.messageModel.messageBodyType == model.msgType) &&
            [chatCell.messageModel isEqual:model]) {
            return chatCell;
        }
    }
    
    return nil;
}

- (void)upDateUserScoreText:(NSNotification *)notice
{
    [self.inputToolBarView updateUserScore:@"0"];
}
@end
