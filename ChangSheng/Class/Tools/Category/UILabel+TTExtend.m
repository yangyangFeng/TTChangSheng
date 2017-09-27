//
//  UILabel+TTExtend.m
//  emjo表情测试
//
//  Created by 邴天宇 on 12/1/16.
//  Copyright © 2016年 邴天宇. All rights reserved.
//

#import "UILabel+TTExtend.h"

@implementation UILabel (TTExtend)
- (CGSize)boundingRectWithSize:(CGSize)size
{
    NSDictionary *attribute = @{NSFontAttributeName: self.font};
    
    CGSize retSize = [self.text boundingRectWithSize:size
                                             options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                          attributes:attribute
                                             context:nil].size;
    
    return retSize;
}
@end
