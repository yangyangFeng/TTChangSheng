
#import "NSString+TTLengthExtend.h"

@implementation NSString (TTLengthExtend)

- (CGSize)sizeWithFontSize:(CGFloat)fontSize
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSFontAttributeName] = [UIFont systemFontOfSize:fontSize];
    CGSize size = [self sizeWithAttributes:attributes];
    return size;
}

- (CGRect)boundsWithFontSize:(CGFloat)fontSize textWidth:(CGFloat)width
{
    CGSize textSize = CGSizeMake(width, MAXFLOAT);
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSFontAttributeName] = [UIFont fontWithName:@"Helvetica" size:fontSize];
    CGRect frame = [self boundingRectWithSize:textSize
                                      options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:attributes
                                      context:nil];
    return frame;
}

+(NSString *)TT_ret10bitString

{
    
    NSString *string = [[NSString alloc]init];
    for (int i = 0; i < 6; i++) {
        int number = arc4random() % 36;
        if (number < 6) {
            int figure = arc4random() % 10;
            NSString *tempString = [NSString stringWithFormat:@"%d", figure];
            string = [string stringByAppendingString:tempString];
        }else {
            int figure = (arc4random() % 26) + 97;
            char character = figure;
            NSString *tempString = [NSString stringWithFormat:@"%c", character];
            string = [string stringByAppendingString:tempString];
        }
    }
    return [NSString stringWithFormat:@"%@%@",[self getDate], string];
}

+ (NSString *)getDate
{
    NSDate *localDate = [NSDate date]; //获取当前时间
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[localDate timeIntervalSince1970]]; //转化为UNIX时间戳
    
    return timeSp;
}
- (NSString *)changeUNIT
{
    switch ([self integerValue]) {
        case 1:
            return @"套";
            break;
        case 2:
            return @"件";
            break;
        case 3:
            return @"块";
            break;
        case 4:
            return @"个";
            break;
        case 5:
            return @"包";
            break;
        case 6:
            return @"盘";
            break;
        case 7:
            return @"瓶";
            break;
        case 8:
            return @"杯";
            break;
        case 9:
            return @"份";
            break;
        case 10:
            return @"张";
            break;
        case 11:
            return @"对";
            break;
        case 12:
            return @"双";
            break;
        case 13:
            return @"间";
            break;
        case 14:
            return @"听";
            break;
        case 15:
            return @"桶";
            break;
        case 16:
            return @"半打";
            break;
        case 17:
            return @"打";
            break;
        case 18:
            return @"壶";
            break;
        case 19:
            return @"副";
            break;
        case 20:
            return @"支";
            break;
        case 21:
            return @"扎";
            break;
        case 22:
            return @"盒";
            break;
        case 23:
            return @"条";
            break;
        default:
            return @"件";
            break;
    }
}
@end
