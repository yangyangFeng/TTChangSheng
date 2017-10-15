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

#import "CSUploadFileModel.h"
#import "IQKeyboardManager.h"
#import "CSIMReceiveManager.h"
#import "CSIMSendMessageRequest.h"
#import "CSIMSendMessageManager.h"
#import "CSIMSendMessageRequestModel.h"
#import "TTNavigationController.h"

//#import "KVOController.h"

#import "CSPublicBetViewController.h"
#import "CSPublicBetInputToolBarView.h"

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


#pragma mark - UI/LifeCycle 相关 -

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createSubviews];
}
- (void)keyboardFrameWillChange:(NSNotification *)notify {
    CGRect kbFrame = [[notify userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat constant = kbFrame.size.height;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.inputToolBarView.y = HEIGHT - 50 - kbFrame.size.height;
        self.inputToolBarView.maskView.alpha = 0;
        
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, constant, 0);
        self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
        [self.tableView scrollsToBottomAnimated:YES];
//        [self.tableView layoutIfNeeded];
    
    }completion:^(BOOL finished) {
        
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self blackStatusBar];
    [self addKeyboardObserver];
    
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
    [CSIMReceiveManager shareInstance].delegate = self;
    
    TTNavigationController * nav = (TTNavigationController *)self.navigationController;
    [nav navigationCanDragBack:NO];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self whiteStatusBar];
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
}

- (void)loadMessageData
{
    for (CSIMSendMessageRequestModel * sendMsgModel in self.conversationModel.allMessageModels) {
        [self.dataSource addObject:sendMsgModel.body];
    }
    [self.tableView reloadData];
}

- (void)updateViewConstraints {
    self.tableViewHeightConstraint.constant = SCREEN_HEIGHT - 64 - MAIN_BOTTOM_TABBAR_HEIGHT;
    
    [super updateViewConstraints];
}

- (void)tapHandler:(UITapGestureRecognizer *)tap {
    [self.inputToolBarView cs_resignFirstResponder];
}

- (void)cs_keyboardHide
{
    [UIView animateWithDuration:0.15 animations:^{
        self.inputToolBarView.maskView.alpha = 1;
    }];
    [UIView animateWithDuration:0.3 delay:0 options:(UIViewAnimationOptionCurveEaseIn) animations:^{
        self.inputToolBarView.y = HEIGHT - 50;
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
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
        self.inputToolBarView.y = HEIGHT - self.inputToolBarView.height;
        
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, HEIGHT - self.inputToolBarView.height - 64, 0);
        self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
        [self.tableView scrollsToBottomAnimated:YES];
        [self.tableView layoutIfNeeded];
    } completion:^(BOOL finished) {
//        [self.tableView scrollsToBottomAnimated:YES];
    }];
    
}

#pragma mark - 文字消息 -

- (void)sendTextMessage:(NSString *)text {
    
    CSIMSendMessageRequestModel * model = [CSIMSendMessageRequestModel new];
    CSMessageModel * msgModel = [CSMessageModel newMessageChatType:CSChatTypeGroupChat chatId:self.conversationModel.chatId msgId:nil msgType:CSMessageBodyTypeText action:4 content:text];
    
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
        [model internal_setMessageStatus:kCSMessageStatusWaiting];
        [cell updateMessageUploadStatus];
    }
}

- (void)waitingMessageRefreshSendStatusWithModel:(CSMessageModel *)model
{
    LLMessageBaseCell * cell = [self visibleCellForMessageModel:model];
    if (cell) {
        [model internal_setMessageStatus:kCSMessageStatusSuccessed];
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

    }];
    [[CSIMSendMessageManager shareInstance] sendMessage:modelRequest];

//    [[LLChatManager sharedManager] resendMessage:model
//                                        progress:nil
//                                      completion:nil];
    
}

#pragma mark - 收到消息 delegate
- (void)cs_receiveMessage:(CSMessageModel *)message
{
    CSIMSendMessageRequestModel * model = [CSIMSendMessageRequestModel new];
    model.body = message;
    [self addModelToDataSourceAndScrollToBottom:model animated:YES];
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
#pragma mark - 下注
- (void)cs_betMessageModel:(CSMessageModel *)messageModel
{
    CSIMSendMessageRequestModel * model = [CSIMSendMessageRequestModel new];
    CSMessageModel * msgModel = [CSMessageModel sendBetMessageChatType:CSChatTypeGroupChat chatId:self.conversationModel.chatId msgId:nil msgType:(CSMessageBodyTypeText) betType:messageModel.playType betNumber:messageModel.score action:messageModel.action content:messageModel.content];
    
    model.body = msgModel;
    
    [model.msgStatus when:^(id obj) {
        DLog(@"UI层----文本:%@已发送",messageModel.content);
    } failed:^(NSError *error) {
        
    }];
    [[CSIMSendMessageManager shareInstance] sendMessage:model];
    
    [self addModelToDataSourceAndScrollToBottom:model animated:YES];
}

#pragma mark - 撤销下注
- (void)cs_betCancleMessageModel:(CSMessageModel *)messageModel
{
    
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
    NSString *reuseId = @"123";
    //    [[LLMessageCellManager sharedManager] reuseIdentifierForMessegeModel:messageModel];
    UITableViewCell *_cell;
    
    switch (messageModel.messageBodyType) {
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
                [cell prepareForUse:messageModel.isFromMe];
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
    
    [UIView setAnimationsEnabled:YES];
    return _cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CSMessageModel *messageModel = self.dataSource[indexPath.row];
    //    NSLog(@"height->%g,str->%@",messageModel.cellHeight,messageModel.body.content);
    return messageModel.cellHeight;
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
}

- (void)removeKeyboardObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
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
@end
