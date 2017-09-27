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

+ (UIImage*)TTscaleImage:(UIImage*)image toScale:(float)scaleSize

{

     UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
                                [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
                                UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
                                UIGraphicsEndImageContext();
                                
                                return scaledImage;
                                
                               
}
@end
