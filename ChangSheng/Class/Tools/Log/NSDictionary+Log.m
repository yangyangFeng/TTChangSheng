//
//  NSDictionary+Log.m
//  16-天气预报
//
//  Created by apple on 14/11/19.
//  Copyright (c) 2014年 HM. All rights reserved.
//

#import "NSDictionary+Log.h"

@implementation NSDictionary (Log)

// 在iOS中，如果数据包含在数组或者字典中，直接打印是看不到结果的
// 重写descriptionWithLocale方法，可以修正这个bug
// 此处不需要掌握，开发时，把这个文件拖到项目里就行！
- (NSString *)descriptionWithLocale:(id)locale {
    NSMutableString *strM = [NSMutableString stringWithString:@"{\n"];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [strM appendFormat:@"\t%@ = %@;\n", key, obj];
    }];
    
    [strM appendString:@"}"];
    
    return strM;
}

@end
