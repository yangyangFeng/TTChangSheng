

#import <Foundation/Foundation.h>

@interface NSString (TTLengthExtend)

/**
 *  返回单行字符串对应的文本控件size(默认字体为'HelveticaNeue', 可进入'NSString+LCExtend.m'中修改)
 *
 *  @param fontSize 字体大小
 */
- (CGSize)sizeWithFontSize:(CGFloat)fontSize;

/**
 *  返回多行字符串对应的文本控件frame(默认字体为'HelveticaNeue', 可进入'NSString+LCExtend.m'中修改)
 *
 *  @param fontSize 字体大小
 *  @param width    文本控件的最大宽度
 */
- (CGRect)boundsWithFontSize:(CGFloat)fontSize textWidth:(CGFloat)width;

/**
 *  随机生成10位随机字符串
 *
 *  @return
 */
+ (NSString *)TT_ret10bitString;
/**
 *  单位转换
 *
 *  @return
 */
- (NSString *)changeUNIT;
@end
