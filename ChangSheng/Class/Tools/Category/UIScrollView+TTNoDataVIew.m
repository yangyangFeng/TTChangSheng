//
//  UIScrollView+TTNoDataVIew.m
//  GoPlay
//
//  Created by 邴天宇 on 13/4/16.
//  Copyright © 2016年 邴天宇. All rights reserved.
//

#import "UIScrollView+TTNoDataView.h"

@interface UIScrollView ()
@property (nonatomic, strong) UIView* tt_contentView;
@property (nonatomic, strong) UIImageView* tt_noDataView;
@property (nonatomic, strong) UILabel* tt_titleLabel;
@end


//定义常量 必须是C语言字符串
static char *TT_tt_contentView_Key = "TTttcontentViewKey";
static char *TT_tt_noDataView = "TTttnoDataViewKey";
static char *TT_tt_titleLabel = "TTtttitleLabelKey";

@implementation UIScrollView (TTNoDataVIew)

- (void)tt_checkNoDataViewTitle:(NSString *)title withDataCount:(NSInteger )count
{
    if (!count) {
        if (self.tt_contentView) {
            return;
        }
        self.tt_contentView = [[UIView alloc]initWithFrame:self.bounds];
        self.tt_contentView.backgroundColor = self.backgroundColor;

        
        self.tt_noDataView = [[UIImageView alloc]initWithImage:IMAGE(@"nodataicon")];
        self.tt_noDataView.frame = CGRectMake(self.frame.size.width /2.0 - 100/2.0, self.frame.size.height/7.0 , 100, 100);

        
        self.tt_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.tt_noDataView.frame.origin.y + self.tt_noDataView.frame.size.height - 15, self.frame.size.width, 20)];
        self.tt_titleLabel.text = title;
        self.tt_titleLabel.textAlignment = NSTextAlignmentCenter;
        self.tt_titleLabel.textColor = rgb(73, 73, 73);
        self.tt_titleLabel.font = [UIFont fontWithName:@"Helvetica-Oblique" size:16];;
       
        
        [self.tt_contentView addSubview:self.tt_noDataView];
        [self.tt_contentView addSubview:self.tt_titleLabel];
        [self addSubview:self.tt_contentView];
        self.tt_contentView.userInteractionEnabled = NO;
    }
    else{
//        for (UIView * subView in self.subviews) {
//            if (subView.tag == 1024) {
//                [subView removeFromSuperview];
//                return;
//            }
//        }
        [self.tt_contentView removeFromSuperview];
        self.tt_contentView = nil;
    }
}


-(void)setTt_contentView:(UIView *)tt_contentView
{
    /*
     OBJC_ASSOCIATION_ASSIGN;            //assign策略
     OBJC_ASSOCIATION_COPY_NONATOMIC;    //copy策略
     OBJC_ASSOCIATION_RETAIN_NONATOMIC;  // retain策略
     
     OBJC_ASSOCIATION_RETAIN;
     OBJC_ASSOCIATION_COPY;
     */
    /*
     * id object 给哪个对象的属性赋值
     const void *key 属性对应的key
     id value  设置属性值为value
     objc_AssociationPolicy policy  使用的策略，是一个枚举值，和copy，retain，assign是一样的，手机开发一般都选择NONATOMIC
     objc_setAssociatedObject(id object, const void *key, id value, objc_AssociationPolicy policy);
     */
    
    objc_setAssociatedObject(self, TT_tt_contentView_Key, tt_contentView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(UIView *)tt_contentView
{
    return objc_getAssociatedObject(self, TT_tt_contentView_Key);
}

-(void)setTt_noDataView:(UIImageView *)tt_noDataView
{
    objc_setAssociatedObject(self, TT_tt_noDataView, tt_noDataView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(UIImageView *)tt_noDataView
{
    return objc_getAssociatedObject(self, TT_tt_noDataView);
}

-(void)setTt_titleLabel:(UILabel *)tt_titleLabel
{
    objc_setAssociatedObject(self, TT_tt_titleLabel, tt_titleLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(UILabel *)tt_titleLabel
{
    return objc_getAssociatedObject(self, TT_tt_titleLabel);
}
@end
