//
//  NSString+TTExtend.m
//  GoPlay
//
//  Created by 邴天宇 on 4/1/16.
//  Copyright © 2016年 邴天宇. All rights reserved.
//

#import "NSString+TTExtend.h"

@implementation NSString (TTExtend)
- (NSString*)addpreStr:(NSString*)preStr sufStr:(NSString*)sufStr
{
    if (!preStr) {
        preStr = @"";
    }
    if (!sufStr) {
        sufStr = @"";
    }
    return [NSString stringWithFormat:@"%@%@%@", preStr, self, sufStr];
}
- (NSString*)distanceFormatter
{
    CGFloat discount = 0;
    if ([self intValue] == 0) {
        return @"未知";
    }
    else if ([self floatValue] > 1000) {
        discount = [self floatValue] / 1000.0;
        return [NSString stringWithFormat:@"%.1fkm", discount];
    }
    else {
        return [NSString stringWithFormat:@"%ldm", (long)[self integerValue]];
    }
}

- (NSString*)priceFormatter
{
    if (!self.length) {
        return @"0";
    }
    CGFloat price = [self floatValue];
    return [NSString stringWithFormat:@"%g", price];
}

- (NSString*)tt_UrlValueEncode
{
    NSString* result = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
        (CFStringRef)self,
        NULL,
        CFSTR("!*'();:@&=+$,/?%#[]"),
        kCFStringEncodingUTF8));

    return result;
}

- (NSString *)opendegreeCheck
{
    NSString *str;
    switch ([self integerValue]) {
        case 1:
        {
            str = @"极度腼腆";
        }
            break;
        case 2:
        {
            str = @"腼腆";
        }
            break;
        case 3:
        {
            str = @"轻微开放";
        }
            break;
        case 4:
        {
            str = @"开放";
        }
            break;
        case 5:
        {
            str = @"极度开放";
        }
            break;
        default:
            break;
    }
    return str;
}

- (NSString *)drinkerCheck
{
    NSString *str;
    switch ([self integerValue]) {
        case 1:
        {
            str = @"滴酒不沾";
        }
            break;
        case 2:
        {
            str = @"闻香型";
        }
            break;
        case 3:
        {
            str = @"浅尝型";
        }
            break;
        case 4:
        {
            str = @"善饮型";
        }
            break;
        case 5:
        {
            str = @"畅饮型";
        }
            break;
        case 6:
        {
            str = @"豪饮型";
        }
            break;
        default:
            break;
    }
    return str;
}

- (NSString *)skillCheck
{
    NSString *str;
    switch ([self integerValue]) {
        case 1:
        {
            str = @"约唱歌";
        }
            break;
        case 2:
        {
            str = @"约泡吧";
        }
            break;
        case 3:
        {
            str = @"约伴游";
        }
            break;
        case 4:
        {
            str = @"约吃饭";
        }
            break;
        case 5:
        {
            str = @"约跳舞";
        }
            break;
        case 6:
        {
            str = @"看电影";
        }
            break;
        case 7:
        {
            str = @"约健身";
        }
            break;
        case 8:
        {
            str = @"约摄影";
        }
            break;
        case 9:
        {
            str = @"约打球";
        }
            break;
        case 10:
        {
            str = @"打游戏";
        }
            break;
        case 11:
        {
            str = @"约游泳";
        }
            break;
        case 12:
        {
            str = @"约喝茶";
        }
            break;
        case 13:
        {
            str = @"约购物";
        }
            break;
        default:
            break;
    }
    return str;
}
- (int)compareOneDay:(NSDate*)oneDay withAnotherDay:(NSDate*)anotherDay
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString* oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString* anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate* dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate* dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    //    NSLog(@"date1 : %@, date2 : %@", oneDay, anotherDay);
    if (result == NSOrderedDescending) {
        //NSLog(@"Date1  is in the future");
        return 1;
    }
    else if (result == NSOrderedAscending) {
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //NSLog(@"Both dates are the same");
    return 0;
}

+ (int)compareOneDay:(NSDate*)oneDay withAnotherDay:(NSDate*)anotherDay
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString* oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString* anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate* dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate* dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    //    NSLog(@"date1 : %@, date2 : %@", oneDay, anotherDay);
    if (result == NSOrderedDescending) {
        //NSLog(@"Date1  is in the future");
        return 1;
    }
    else if (result == NSOrderedAscending) {
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //NSLog(@"Both dates are the same");
    return 0;
}

- (BOOL)iscontaninStartTime:(NSString*)start endTime:(NSString*)end
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"DD-HH:mm:ss"];

    NSDateFormatter* tt_formatter = [[NSDateFormatter alloc] init];
    [tt_formatter setDateFormat:@"HH:mm:ss"];
    NSDate* startDate = [tt_formatter dateFromString:start];
    NSDate* endDate = [tt_formatter dateFromString:end];

    //    int start_time = [start intValue];
    //    int end_time = [end intValue];
    if ([start compareOneDay:startDate withAnotherDay:endDate] < 0) {

        NSDate* date = [NSDate date];
        NSCalendar* calendar = [NSCalendar currentCalendar];
        //        NSDateComponents* comps = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:date];
        NSInteger day = 1;
        //        NSInteger second = [comps second];
        NSString* str = [NSString stringWithFormat:@"%ld-%@", day, self];
        NSDate* selectDate = [formatter dateFromString:str];
        NSDate* endDate = [formatter dateFromString:[end addpreStr:@"1-" sufStr:nil]];
        NSDate* startDate = [formatter dateFromString:[start addpreStr:@"1-" sufStr:nil]];
        int result1 = [self compareOneDay:selectDate withAnotherDay:startDate];
        int result2 = [self compareOneDay:selectDate withAnotherDay:endDate];
        if (result1 >= 0 && result2 <= 0) {
            return YES;
        }
        else {
            return NO;
        }
    }
    else {

        NSDate* date = [NSDate date];
        NSCalendar* calendar = [NSCalendar currentCalendar];
        //        NSDateComponents* comps = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:date];
        NSInteger day = 1;
        //        NSInteger second = [comps second];
        NSString* str = [NSString stringWithFormat:@"%ld-%@", day, self];
        NSDate* selectDate = [formatter dateFromString:str];
        NSDate* startDate = [formatter dateFromString:start];
        NSDate* endDate = [formatter dateFromString:end];
        NSDate* Date_24 = [formatter dateFromString:@"24:00:00"];
        NSDate* Date_00 = [formatter dateFromString:@"00:00:00"];
        int result1 = [self compareOneDay:selectDate withAnotherDay:startDate];
        int result2 = [self compareOneDay:selectDate withAnotherDay:Date_24];
        int result3 = [self compareOneDay:selectDate withAnotherDay:Date_00];
        int result4 = [self compareOneDay:selectDate withAnotherDay:endDate];
        if (result1 >= 0 && result2 <= 0 && result3 >= 0 && result4 <= 0) {
            return YES;
        }
        else {
            return NO;
        }
        return NO;
    }
}

+ (BOOL)isCurrentcontaninStartTime:(NSString*)start endTime:(NSString*)end
{
    
    NSInteger startInt = [start integerValue];
    NSInteger endInt = [end integerValue];
    
    if (startInt < endInt) { //如果是 正常区间
        
        NSDate* date = [NSDate date];
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDateComponents* comps = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:date];
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm:ss"];
        formatter.timeZone =  [NSTimeZone timeZoneForSecondsFromGMT:8 * 3600];//直接指定时区
        
        NSInteger hour = [comps hour];
        NSInteger minute = [comps minute];
        NSString* str = [NSString stringWithFormat:@"%ld:%ld:00", hour, minute];
         return [str iscontaninStartTime:start endTime:end];
    }
    else{
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"DD-HH:mm:ss"];
        formatter.timeZone =  [NSTimeZone timeZoneForSecondsFromGMT:8 * 3600];//直接指定时区
        
        NSDate* date = [NSDate date];
        NSCalendar* calendar = [NSCalendar currentCalendar];
                NSDateComponents* comps = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:date];
        NSInteger day = 1;
        //        NSInteger second = [comps second];
//        [formatter setDateFormat:@"HH:mm:ss"];
        NSInteger hour = [comps hour];
        NSInteger minute = [comps minute];
        NSString* currentTime = [NSString stringWithFormat:@"%ld:%ld:00", hour, minute];
        
        NSString* str = [NSString stringWithFormat:@"%ld-%@", day, currentTime];
        NSDate* selectDate = [formatter dateFromString:str];
        NSDate* startDate = [formatter dateFromString:[start addpreStr:@"01-" sufStr:nil]];
        NSDate* endDate = [formatter dateFromString:[end addpreStr:@"01-" sufStr:nil]];
        NSDate* Date_24 = [formatter dateFromString:@"01-23:59:59"];
        NSDate* Date_00 = [formatter dateFromString:@"01-00:00:00"];
        int result1 = [self compareOneDay:selectDate withAnotherDay:startDate];
        int result2 = [self compareOneDay:selectDate withAnotherDay:Date_24];
        int result3 = [self compareOneDay:selectDate withAnotherDay:Date_00];
        int result4 = [self compareOneDay:selectDate withAnotherDay:endDate];
        if ((result1 >= 0 && result2 <= 0) | (result3 >= 0 && result4 <= 0)) {
            return YES;
        }
        else {
            return NO;
        }
    }
}

- (NSString *)retainTheDecimal:(int)num
{
    CGFloat digits = [self floatValue] * pow(10.0f, (num - 1));
    CGFloat new_digits = ceilf(digits);
    return [NSString stringWithFormat:@"%g",new_digits / pow(10.0f, (num - 1))];
}

- (NSString *)formattrHourTime
{
    return [NSString stringWithFormat:@"%d",[self intValue]];
}
@end
