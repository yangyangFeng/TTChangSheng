//
//  UIImage+TTSize.h
//  GoPlay
//
//  Created by 邴天宇 on 21/1/16.
//  Copyright © 2016年 邴天宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (TTSize)
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;
+ (UIImage*)tt_scaleImage:(UIImage*)image toScale:(float)scaleSize;
+ (UIImage *)tt_compressImageQuality:(UIImage *)image toByte:(NSInteger)maxLength;
- (NSData *)tt_compressToDataLength:(NSInteger)length;
@end
