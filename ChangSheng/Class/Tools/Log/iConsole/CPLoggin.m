//
//  Loggin.m
//  cnepay_sdk
//
//  Created by BlackAnt on 17/3/27.
//  Copyright © 2017年 cne. All rights reserved.
//

#import "CPLoggin.h"

@implementation CPLoggin

+ (void)cp_infoLog:(NSString *)format, ...
{
    va_list argList;
    va_start(argList, format);
    NSString *content = [NSString stringWithFormat:@"\n\n\n-----BEGAN------\n[Info]-(%@)\n>%@\n-----END------\n\n\n",
                         [self stringDate],
                         format];
    [iConsole log:content args:argList];
    va_end(argList);
}

+ (void)cp_errorLog:(NSString *)format, ...
{
    va_list argList;
    va_start(argList, format);
    NSString *content = [NSString stringWithFormat:@"\n\n\n-----BEGAN------\n[Error]-(%@)\n>%@\n-----END------\n\n\n",
                         [self stringDate],
                         format];
    [iConsole log:content args:argList];
    va_end(argList);
}

+ (void)cp_warnLog:(NSString *)format, ...
{
    va_list argList;
    va_start(argList, format);
    NSString *content = [NSString stringWithFormat:@"\n\n\n-----BEGAN------\n[Warn]-(%@)\n>%@\n-----END------\n\n\n",
                         [self stringDate],
                         format];
    [iConsole log:content args:argList];
    va_end(argList);
}


+ (void)cp_bluetoothLog:(NSString *)format, ...
{
    va_list argList;
    va_start(argList, format);
    NSString *content = [NSString stringWithFormat:@"\n\n\n-----BEGAN------\n[Bluetooth]-(%@)\n>%@\n-----END------\n\n\n",
                         [self stringDate],
                         format];
    [iConsole log:content args:argList];
    va_end(argList);
}

+ (void)cp_inputLog:(NSString *)format, ...
{
    va_list argList;
    va_start(argList, format);
    NSString *content = [NSString stringWithFormat:@"\n\n\n-----BEGAN------\n[Input]-(%@)\n>%@\n-----END------\n\n\n",
                         [self stringDate],
                         format];
    [iConsole log:content args:argList];
    va_end(argList);
}

+ (NSString *)stringDate{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"dd hh:mm:ss"];
    return [formatter stringFromDate:date];
}


@end
