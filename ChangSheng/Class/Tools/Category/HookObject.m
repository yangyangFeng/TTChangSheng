//
//  HookObject.m
//  GoPlay
//
//  Created by 邴天宇 on 11/4/16.
//  Copyright © 2016年 邴天宇. All rights reserved.
//

#import "HookObject.h"
#import <objc/objc.h>
#import <objc/runtime.h>
@implementation HookObject
// this method will just excute once
+ (void)initialize
{
    // 获取到UIWindow中sendEvent对应的method
    Method sendEvent = class_getInstanceMethod([UIView class], @selector(sendEvent:));
    Method sendEventMySelf = class_getInstanceMethod([self class], @selector(sendEventHooked:));

    // 将目标函数的原实现绑定到sendEventOriginalImplemention方法上
    IMP sendEventImp = method_getImplementation(sendEvent);
    class_addMethod([UIView class], @selector(sendEventOriginal:), sendEventImp, method_getTypeEncoding(sendEvent));

    // 然后用我们自己的函数的实现，替换目标函数对应的实现
    IMP sendEventMySelfImp = method_getImplementation(sendEventMySelf);
    class_replaceMethod([UIView class], @selector(sendEvent:), sendEventMySelfImp, method_getTypeEncoding(sendEvent));
}

/*
    32  * 截获到window的sendEvent
    33  * 我们可以先处理完以后，再继续调用正常处理流程
    34  */
- (void)sendEventHooked:(UIEvent*)event
{
    // do something what ever you want
    NSLog(@"haha, this is my self sendEventMethod!!!!!!!");

    if ([self isKindOfClass:[UIView class]]) {
        UIView * view = (UIView *)self;
        [view setExclusiveTouch:YES];
    }
    // invoke original implemention
    [self performSelector:@selector(sendEventOriginal:) withObject:event];
}

//+ (void)initialize
//{
//    // 获取到UIWindow中layoutSubviews对应的method
//    Method layoutSubviews = class_getInstanceMethod([UIView class], @selector(layoutSubviews));
//    Method layoutSubviewsMySelf = class_getInstanceMethod([self class], @selector(layoutSubviewsHooked));
//    
//    // 将目标函数的原实现绑定到layoutSubviewsOriginalImplemention方法上
//    IMP layoutSubviewsImp = method_getImplementation(layoutSubviews);
//    class_addMethod([UIView class], @selector(layoutSubviewsOriginal), layoutSubviewsImp, method_getTypeEncoding(layoutSubviews));
//    
//    // 然后用我们自己的函数的实现，替换目标函数对应的实现
//    IMP layoutSubviewsMySelfImp = method_getImplementation(layoutSubviewsMySelf);
//    class_replaceMethod([UIView class], @selector(layoutSubviews), layoutSubviewsMySelfImp, method_getTypeEncoding(layoutSubviews));
//}
//
///*
// 32  * 截获到window的layoutSubviews
// 33  * 我们可以先处理完以后，再继续调用正常处理流程
// 34  */
//- (void)layoutSubviewsHooked
//{
//    // do something what ever you want
//    NSLog(@"haha, this is my self layoutSubviewsMethod!!!!!!!");
//    
//    if (<#condition#>) {
//        <#statements#>
//    }
//    // invoke original implemention
//    [self performSelector:@selector(layoutSubviewsOriginal)];
//}
@end
