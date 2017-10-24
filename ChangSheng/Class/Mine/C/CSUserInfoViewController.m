//
//  CSUserInfoViewController.m
//  ChangSheng
//
//  Created by 邴天宇 on 2017/10/18.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSUserInfoViewController.h"
#import "CSUserNameInputViewController.h"
#import "StoryBoardController.h"
#import "FSMediaPicker.h"
#import "CSChangeAvatarModel.h"
@interface CSUserInfoViewController ()<FSMediaPickerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *changshengCode;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;

@property (weak, nonatomic) IBOutlet UILabel *nickName;
@end

@implementation CSUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.tableView.separatorStyle =0;

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.nickName.text = [CSUserInfo shareInstance].info.nickname;
    self.changshengCode.text = [CSUserInfo shareInstance].info.code;
    
    [self.userImageView yy_setImageWithURL:[NSURL URLWithString:[CSUserInfo shareInstance].info.avatar] placeholder:[UIImage imageNamed:@"个人资料头像.png"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        FSMediaPicker* mediaPicker = [[FSMediaPicker alloc] init];
        mediaPicker.mediaType = FSMediaTypePhoto;
        mediaPicker.editMode = FSEditModeNone;
        mediaPicker.delegate = self;
        
        [mediaPicker showFromView:self.userImageView];
    }
    else if (indexPath.row == 1)
    {
        CSUserNameInputSuperViewController * inputTextC = [CSUserNameInputSuperViewController new];
        [inputTextC setCallBlock:^(NSString *nickName) {
            self.nickName.text = [CSUserInfo shareInstance].info.nickname = nickName;
        }];
        [self.navigationController pushViewController:inputTextC animated:YES];
    }
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
        
        
        self.userImageView.image = newimage;
    }
    
    [MBProgressHUD tt_ShowInView:self.view WithTitle:@"正在处理..."];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSData * imageData = [self.userImageView.image tt_compressToDataLength:CS_IMAGE_DATA_SIZE];

        [MBProgressHUD tt_HideFromeView:self.view];
        [CSHttpRequestManager request_changeHeaderImage_paramters:@{@"file":@"avatar"} fileData:imageData fileType:CS_UPLOAD_FILE_IMAGE | CS_UPLOAD_FILE_CUSTOME success:^(id responseObject) {
            CSChangeAvatarModel * obj = [CSChangeAvatarModel mj_objectWithKeyValues:responseObject];
            [CSUserInfo shareInstance].info.avatar = obj.result.avatar;
        } failure:^(NSError *error) {
            
        } uploadprogress:^(CGFloat uploadProgress) {
            
        } showHUD:YES];
    });
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end


@implementation CSUserInfoSuperViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    UITableViewController * userInfoC = (UITableViewController*)[StoryBoardController storyBoardName:@"Mine" ViewControllerIdentifiter:@"CSUserInfoViewController"];
    [self addChildTableViewController:userInfoC];
    [self tt_Title:@"个人资料"];
    [self.view addSubview:userInfoC.tableView];
    
    [userInfoC.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(44);
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self blackStatusBar];
}

@end
