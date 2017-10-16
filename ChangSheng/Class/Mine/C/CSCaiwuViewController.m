//
//  CSCaiwuViewController.m
//  ChangSheng
//
//  Created by 邴天宇 on 2017/10/16.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSCaiwuViewController.h"

#import "CSCaiwuTableViewInfoCell.h"
#import "CSCaiwuTableViewImageCell.h"
#import "FSMediaPicker.h"
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

-(void)awakeFromNib
{
    [super awakeFromNib];
    
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
    self.downBtn.selected = self.upBtn.selected;
    self.upBtn.selected = !self.upBtn.selected;
    self.isUpScore = YES;
}

- (IBAction)downBtnDidAction:(id)sender {
    self.upBtn.selected = self.downBtn.selected;
    self.downBtn.selected = !self.downBtn.selected;
    self.isUpScore = NO;
}
- (IBAction)uploadImageDidAction:(id)sender {
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
        _uploadLabel.text = @"上传银行卡照片";
    }
    else
    {
        _uploadLabel.text = @"上传汇款凭证";
    }
}
- (IBAction)commitBtnDidAction:(id)sender {
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
