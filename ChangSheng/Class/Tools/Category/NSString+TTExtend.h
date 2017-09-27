//
//  NSString+TTExtend.h
//  GoPlay
//
//  Created by 邴天宇 on 4/1/16.
//  Copyright © 2016年 邴天宇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TTExtend)
/**
 *  为文本添加前缀和后缀
 *
 */
- (NSString *)addpreStr:(NSString*)preStr sufStr:(NSString *)sufStr;
/**
 *  格式化距离
 *
 */
- (NSString *)distanceFormatter;
/**
 *  格式化金额
 *
 */
- (NSString *)priceFormatter;
/**
 *  url 编码
 *
 */
- (NSString*)tt_UrlValueEncode;
/**
 *  开放程度 (业务需要)
 *
 *  @return 开放程度
 */
- (NSString *)opendegreeCheck;
/**
 *  酒量 (业务需要)
 *
 *  @return 酒量
 */
- (NSString *)drinkerCheck;
/**
 *  技能 (业务需求)
 *
 *  @return 
 */
- (NSString *)skillCheck;

/**
    保留小数

 @return 保留 num位, 进 1
 */
- (NSString *)retainTheDecimal:(int)num;
- (BOOL)iscontaninStartTime:(NSString *)start endTime:(NSString *)end;

+ (BOOL)isCurrentcontaninStartTime:(NSString *)start endTime:(NSString *)end;

/**
 0-9点时间取整

 @return <#return value description#>
 */
- (NSString *)formattrHourTime;
@end
