//
//  LLWebViewController.h
//  LLWeChat
//
//  Created by GYJZH on 8/11/16.
//  Copyright © 2016 GYJZH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLViewController.h"
#import "CSBaseViewController.h"
@interface LLWebViewController : CSBaseViewController

@property (nonatomic) NSURL *url;

@property (nonatomic) UIViewController *fromViewController;

@end
