//
//  NSString+Extend.h
//  CoreCategory
//
//  Created by 成林 on 15/4/6.
//  Copyright (c) 2015年 沐汐. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GTMBase64.h"
@interface NSString (Extend)

/** 删除所有的空格 */
@property (nonatomic, copy, readonly) NSString* deleteSpace;

/*
 *  时间戳对应的NSDate
 */
@property (nonatomic, strong, readonly) NSDate* date;

+ (NSString*)dictionaryToJsonString:(NSDictionary*)dict;
+ (BOOL)isValide:(NSString*)value;

//UTF-8转码
+ (NSString*)UTF8StringWithString:(NSString*)string;

+ (NSString*)imageWithBase64:(UIImage*)image;
//生成SN
//+(NSString *)snWithString:(NSString *)userid;

//验证身份证
+ (BOOL)verifyIDCardNumber:(NSString*)value; //验证身份证

//银行卡
+ (BOOL)validateBankCardNumber:(NSString*)bankCardNumber;

//用户名
+ (BOOL)validateUserName:(NSString*)name;

//密码
+ (BOOL)validatePassword:(NSString*)passWord;

//昵称
+ (BOOL)validateNickname:(NSString*)nickname;

+ (NSString*)getCurrentDate;

//获取本机时间
+ (NSString*)stringWithCurrenDate;

//手机号码验证
+ (BOOL)validateMobile:(NSString*)mobile;

//车牌号验证
+ (BOOL)validateCarNo:(NSString*)carNo;

//车牌号验证
+ (BOOL)validateEnginno:(NSString*)enginno;

/**
 *  验证中文汉字字母
 */
+ (BOOL)validateString:(NSString*)regStr;
/**
 *  以当前时间为图片名称
 *
 *  @return 图片名称.jpeg
 */
+ (NSString*)imageNameWithCurrentDate;
/**
 *  验证手机号码是否符合规则
 *
 *  @param mobileNum 电话号码
 *
 *  @return YES符合、NO不符合
 */
+ (BOOL)isMobileNumber:(NSString*)mobileNum;
/**
 *  检查密码是否是6-20位 允许特殊字符
 *
 *  @param _text 密码字符串
 *
 *  @return 是否符合符合YES、不符合NO
 */
+ (BOOL)CheckInput:(NSString*)_text;

/**
 *  判断字符串中是否只有中文、英文和数字
 */
+ (BOOL)judgeOnlyIncludeCEN:(NSString*)str;
/**
 *  判断是否只有英文字母和数字
 *
 *  @param str
 *
 *  @return yes or no
 */
+ (BOOL)isEnglishWordOrNumber:(NSString*)str;
/**
 *  只有数字
 *
 *  @param str
 *
 *  @return yes or no
 */
+ (BOOL)isOnlyNumber:(NSString*)str;
/*!
 *  判断输入字符串时候有系统自带表情
 */
+ (BOOL)stringContainsEmoji:(NSString*)string;
/**
 *  时间戳转格式化的时间字符串
 */
- (NSString*)timestampToTimeStringWithFormatString:(NSString*)formatString;
/**
 *  格式化时间
 *
 *  @param original_formatter 当前时间格式
 *  @param new_formatter      将要转换的时间格式
 *
 *  @return 格式时间
 */
- (NSString *)tt_formatter:(NSString *)original_formatter changeFormatter:(NSString *)new_formatter;
@end
