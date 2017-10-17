//
//  UIImage+TTSize.m
//  GoPlay
//
//  Created by 邴天宇 on 21/1/16.
//  Copyright © 2016年 邴天宇. All rights reserved.
//

#import "UIImage+TTSize.h"
#import <AssetsLibrary/ALAssetRepresentation.h>
#import <CoreImage/CoreImage.h>
#import <Foundation/Foundation.h>
#include <ImageIO/ImageIO.h>
static size_t getAssetBytesCallback(void* info, void* buffer, off_t position, size_t count)
{
    ALAssetRepresentation* rep = (__bridge id)info;

    NSError* error = nil;
    size_t countRead = [rep getBytes:(uint8_t*)buffer fromOffset:position length:count error:&error];

    if (countRead == 0 && error) {
        // We have no way of passing this info back to the caller, so we log it, at least.
        DLog(@"thumbnailForAsset:maxPixelSize: got an error reading an asset: %@", error);
    }

    return countRead;
}

static void releaseAssetCallback(void* info)
{
    // The info here is an ALAssetRepresentation which we CFRetain in thumbnailForAsset:maxPixelSize:.
    // This release balances that retain.
    CFRelease(info);
}
@implementation UIImage (TTSize)

// Returns a UIImage for the given asset, with size length at most the passed size.
// The resulting UIImage will be already rotated to UIImageOrientationUp, so its CGImageRef
// can be used directly without additional rotation handling.
// This is done synchronously, so you should call this method on a background queue/thread.
- (UIImage*)thumbnailForAsset:(ALAsset*)asset maxPixelSize:(NSUInteger)size
{
    NSParameterAssert(asset != nil);
    NSParameterAssert(size > 0);

    ALAssetRepresentation* rep = [asset defaultRepresentation];

    CGDataProviderDirectCallbacks callbacks = {
        .version = 0,
        .getBytePointer = NULL,
        .releaseBytePointer = NULL,
        .getBytesAtPosition = getAssetBytesCallback,
        .releaseInfo = releaseAssetCallback,
    };

    CGDataProviderRef provider = CGDataProviderCreateDirect((void*)CFBridgingRetain(rep), [rep size], &callbacks);
    CGImageSourceRef source = CGImageSourceCreateWithDataProvider(provider, NULL);

    CGImageRef imageRef = CGImageSourceCreateThumbnailAtIndex(source, 0, (__bridge CFDictionaryRef) @{
        (NSString*)kCGImageSourceCreateThumbnailFromImageAlways : @YES,
        (NSString*)kCGImageSourceThumbnailMaxPixelSize : [NSNumber numberWithInt:size],
        (NSString*)kCGImageSourceCreateThumbnailWithTransform : @YES,
    });
    CFRelease(source);
    CFRelease(provider);

    if (!imageRef) {
        return nil;
    }

    UIImage* toReturn = [UIImage imageWithCGImage:imageRef];

    CFRelease(imageRef);

    return toReturn;
}

+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // new size
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();

    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}

+ (UIImage*)tt_scaleImage:(UIImage*)image toScale:(float)scaleSize

{

     UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
                                [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
                                UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
                                UIGraphicsEndImageContext();
                                
                                return scaledImage;
                                
                               
}

+ (UIImage *)tt_compressImageQuality:(UIImage *)image toByte:(NSInteger)maxLength {
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return image;
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    return resultImage;
}

- (NSData *)tt_compressToDataLength:(NSInteger)length {
//    if (length <= 0 || [self isKindOfClass:[NSNull class]] || self == nil) block(nil);
    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *newImage = [self copy];
        {
            CGFloat scale = 0.9;
            NSData *pngData = UIImagePNGRepresentation(self);
            NSLog(@"Original pnglength %zd", pngData.length);
            NSData *jpgData = UIImageJPEGRepresentation(self, scale);
            NSLog(@"Original jpglength %zd", pngData.length);
            
            while (jpgData.length > length) {
                newImage = [newImage tt_compressWithWidth:newImage.size.width * scale];
                NSData *newImageData = UIImageJPEGRepresentation(newImage, 0.0);
                if (newImageData.length < length) {
                    CGFloat scale = 1.0;
                    newImageData = UIImageJPEGRepresentation(newImage, scale);
                    while (newImageData.length > length) {
                        scale -= 0.1;
                        newImageData = UIImageJPEGRepresentation(newImage, scale);
                    }
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        NSLog(@"Result jpglength %zd", newImageData.length);
//                        block(newImageData);
//                    });
                    return newImageData;
                }
            }
            
//            block(jpgData);
            return jpgData;
        }
//    });
}
- (UIImage *)tt_compressWithWidth:(CGFloat)width {
    if (width <= 0 || [self isKindOfClass:[NSNull class]] || self == nil) return nil;
    CGSize newSize = CGSizeMake(width, width * (self.size.height / self.size.width));
    UIGraphicsBeginImageContext(newSize);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
