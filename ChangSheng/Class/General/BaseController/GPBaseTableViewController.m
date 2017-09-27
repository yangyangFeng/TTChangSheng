//
//  GPBaseTableViewController.m
//  GoPlay
//
//  Created by 邴天宇 on 26/12/15.
//  Copyright © 2015年 邴天宇. All rights reserved.
//

#import "GPBaseTableViewController.h"
#import "ILBarButtonItem.h"

@interface GPBaseTableViewController ()

@end

@implementation GPBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self setNavigationItem];
    
//    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableviewDidTapAction)];
//    [self.tableView addGestureRecognizer:tap];
}

- (void)setNavigationItem
{
    if (self.navigationController.viewControllers.count > 1) {
        ILBarButtonItem * goBack = [ILBarButtonItem barItemWithImage:IMAGE(@"back") selectedImage:IMAGE(@"back_gray") target:self action:@selector(goBackDidClickAction:)];

        self.navigationItem.leftBarButtonItem = goBack;
    }
    else{
        UIBarButtonItem * nilItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:(UIBarButtonItemStyleDone) target:nil action:nil];
        self.navigationItem.leftBarButtonItem = nilItem;
    }
}

- (void)goBackDidClickAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)tableviewDidTapAction
{
    
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
