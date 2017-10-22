//
//  CSCaiwuViewController.m
//  ChangSheng
//
//  Created by 邴天宇 on 2017/10/16.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSCaiwuViewController.h"
#import "CSOperationListViewController.h"
#import "CSCaiwuTableViewInfoCell.h"
#import "CSCaiwuTableViewImageCell.h"
#import "FSMediaPicker.h"
#import "CSUploadFenRequestModel.h"
#import "CSIMReceiveManager.h"
@interface CSCaiwuViewController ()<UITableViewDelegate,UITableViewDataSource,FSMediaPickerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic)  UIButton *upBtn;
@property (weak, nonatomic)  UIButton *downBtn;
@property (weak, nonatomic)  UILabel *my_fenLabel;
@property (weak, nonatomic)  UITextField *inputField_fen;
@property (weak, nonatomic)  UITextField *inputField_name;
@property (weak, nonatomic) UILabel *uploadLabel;
@property (weak, nonatomic) UIButton * uploadButton;
@property (nonatomic,assign) BOOL isUpScore;
@property (weak, nonatomic)  UIImageView *uploadImageView;
@end

@implementation CSCaiwuViewController
- (void)addKeyboardObserver
{
    
    //NOTIFICE_KEY_SOCKET_CURRENT_SCORE
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upDateUserScoreText:) name:NOTIFICE_KEY_SOCKET_CURRENT_SCORE object:nil];
}

- (void)removeKeyboardObserver
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICE_KEY_SOCKET_CURRENT_SCORE object:nil];
}

- (void)upDateUserScoreText:(NSNotification *)notice
{
    self.my_fenLabel.text = [NSString stringWithFormat:@"%d",[CSUserInfo shareInstance].info.surplus_score];
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.my_fenLabel.text = [NSString stringWithFormat:@"%d",[CSUserInfo shareInstance].info.surplus_score];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self blackStatusBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self tt_SetNaviBarHide:NO withAnimation:NO];
    [self tt_Title:@"财务"];
    self.tt_navigationBar.contentView.backgroundColor = [UIColor whiteColor];
    self.tt_navigationBar.titleLabel.textColor = [UIColor colorWithHexColorString:@"333333"];
    self.isUpScore = YES;
    
    self.my_fenLabel.text = [NSString stringWithFormat:@"%d",[CSUserInfo shareInstance].info.surplus_score];
    self.commitBtn.layer.masksToBounds = YES;
    self.commitBtn.layer.cornerRadius = 44 /2.0;
    [self.commitBtn setBackgroundImage:[UIImage yy_imageWithColor:[UIColor colorWithHexColorString:@"1aab1b"] size:CGSizeMake(4, 4)] forState:(UIControlStateNormal)];
    
    self.tableView.delaysContentTouches = NO;
}

- (IBAction)upBtnDidAction:(id)sender {
    self.upBtn.selected = YES;
    self.downBtn.selected = NO;
    self.isUpScore = YES;
}

- (IBAction)downBtnDidAction:(id)sender {
    self.downBtn.selected = YES;
    self.upBtn.selected = NO;
    self.isUpScore = NO;
}
- (IBAction)uploadImageDidAction:(id)sender {
    [self.view endEditing:YES];
    FSMediaPicker* mediaPicker = [[FSMediaPicker alloc] init];
    mediaPicker.mediaType = FSMediaTypePhoto;
    mediaPicker.editMode = FSEditModeNone;
    mediaPicker.delegate = self;
    
    [mediaPicker showFromView:self.uploadImageView];
}

- (void)mediaPicker:(FSMediaPicker*)mediaPicker didFinishWithMediaInfo:(NSDictionary*)mediaInfo
{
    if (mediaInfo.mediaType == FSMediaTypeVideo) {
        //        self.player.contentURL = mediaInfo.mediaURL;
        //        [self.player play];
    }
    else
    {
        UIImage * newimage = [mediaInfo.originalImage fixOrientation];
        
        
                self.uploadImageView.image = newimage;
    }
}

-(void)setIsUpScore:(BOOL)isUpScore
{
    _isUpScore = isUpScore;
    if (isUpScore) {
        _uploadLabel.text = @"上传汇款凭证";
    }
    else
    {
        _uploadLabel.text = @"上传银行卡照片";
    }
}
- (IBAction)commitBtnDidAction:(id)sender {
    
    CSUploadFenRequestModel * params = [CSUploadFenRequestModel new];
    if (!self.inputField_fen.text.length) {
        CS_HUD(@"请填写分数");
        return;
    }
    else if (!self.inputField_name.text.length)
    {
        CS_HUD(@"请填写真实姓名");
        return;
    }
    else if(!self.uploadImageView.image)
    {
        CS_HUD(@"请填上传照片");
        return;
    }
    else if (self.inputField_fen.text.length && (self.inputField_fen.text.intValue > [CSUserInfo shareInstance].info.surplus_score) && !_isUpScore)
    {
        CS_HUD(@"下分数不能高于身上分");
        return;
    }
    [MBProgressHUD tt_Show];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSData * imageData = [self.uploadImageView.image tt_compressToDataLength:CS_IMAGE_DATA_SIZE];
        params.score = self.inputField_fen.text.intValue;
        params.truename = self.inputField_name.text;
        NSMutableDictionary * paramsDic = [NSMutableDictionary dictionaryWithDictionary:params.mj_keyValues];
        if (_isUpScore) {
            [paramsDic setObject:@"pod" forKey:@"file"];
            [paramsDic setObject:@"1" forKey:@"type"];
        }
        else
        {
            [paramsDic setObject:@"bank_card" forKey:@"file"];
            [paramsDic setObject:@"2" forKey:@"type"];
        }
        
        [CSHttpRequestManager request_updownFen_paramters:paramsDic fileData:imageData fileType:CS_UPLOAD_FILE_IMAGE | CS_UPLOAD_FILE_CUSTOME success:^(id responseObject) {
            CSUploadFenRequestModel * obj = [CSUploadFenRequestModel mj_objectWithKeyValues:responseObject];
            [MBProgressHUD tt_SuccessTitle:obj.msg];
            [CSUserInfo shareInstance].info.surplus_score = obj.result.surplus_score.intValue;
            self.my_fenLabel.text = obj.result.surplus_score;
            NSArray * array = [self.navigationController viewControllers];
            NSMutableArray * popViewControllers = [NSMutableArray arrayWithArray:array];
            CSOperationListViewController * operationC = [CSOperationListViewController new];
            [popViewControllers replaceObjectAtIndex:popViewControllers.count - 1 withObject:operationC];
            [self.navigationController setViewControllers:popViewControllers animated:YES];
        } failure:^(NSError *error) {
            
        } uploadprogress:^(CGFloat uploadProgress) {
//            MBProgressHUD*hud = [MBProgressHUD tt_progressShowInView:self.view];
//            hud.progress = uploadProgress;
        } showHUD:YES];
    });
    
   

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 | indexPath.row == 2) {
        return 10;
    }
    else if (indexPath.row == 1)
    {
        return 195;
    }
    else{
        return 175;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString * identifiter = @"caiwuCell0";
    UITableViewCell *cell;
    if (indexPath.row == 0 | indexPath.row == 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:identifiter];
    }
    else if (indexPath.row == 1)
    {
        identifiter = @"CSCaiwuTableViewInfoCell";
        cell = [tableView dequeueReusableCellWithIdentifier:identifiter];
        CSCaiwuTableViewInfoCell * caiwuCell = (CSCaiwuTableViewInfoCell*)cell;
//        caiwuCell.upBtn addTarget:<#(nullable id)#> action:<#(nonnull SEL)#> forControlEvents:<#(UIControlEvents)#>
        self.upBtn = caiwuCell.upBtn;
        self.downBtn = caiwuCell.downBtn;
        self.my_fenLabel = caiwuCell.my_fenLabel;
        self.inputField_fen = caiwuCell.inputField_fen;
        self.inputField_name = caiwuCell.inputField_name;
        caiwuCell.my_fenLabel.text =  [NSString stringWithFormat:@"%d",[CSUserInfo shareInstance].info.surplus_score];
    }
    else{
        identifiter = @"CSCaiwuTableViewImageCell";
        cell = [tableView dequeueReusableCellWithIdentifier:identifiter];
        CSCaiwuTableViewImageCell *imageCell =(CSCaiwuTableViewImageCell*)cell;
        self.uploadLabel = imageCell.uploadLabel;
        self.uploadButton = imageCell.uploadButton;
        self.uploadImageView = imageCell.uploadImageView;
    }
    
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifiter];
    }
    return cell;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
