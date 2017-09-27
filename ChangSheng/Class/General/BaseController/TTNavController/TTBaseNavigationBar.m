//
//  TTBaseNavigationBar.m
//  TTCustomNavicaitonController
//
//  Created by 邴天宇 on 16/12/15.
//  Copyright © 2015年 邴天宇. All rights reserved.
//

#import "TTBaseNavigationBar.h"

@implementation TTBaseNavigationBar

+ (instancetype)createNaviBarViewFromXIB
{
    id view;
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:self options:nil];
    NSAssert((nib && (nib.count > 0)), @" ! can not find nib file.\n\nxib file name is not the same as class name?\n");
    view = [nib objectAtIndex:0];
    
    return view;
}

@end
