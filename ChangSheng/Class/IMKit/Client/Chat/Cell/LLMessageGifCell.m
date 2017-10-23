//
//  LLMessageGifCell.m
//  LLWeChat
//
//  Created by GYJZH on 8/18/16.
//  Copyright © 2016 GYJZH. All rights reserved.
//

#import "LLMessageGifCell.h"
#import "UIKit+LLExt.h"
#import "LLEmotionModelManager.h"
#import "LLUtils.h"
#import "LLChatManager+MessageExt.h"
#import "LLGIFImageView.h"



#define GIF_IMAGE_SIZE 100
#define GIF_IMAGE_MIN_SIZE 50

@interface LLMessageGifCell ()
//@property (nonatomic) LLGIFImageView *gifImageView;
@property(nonatomic,strong)YYAnimatedImageView *gifImageView;
@end

@implementation LLMessageGifCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.gifImageView = [[YYAnimatedImageView alloc] initWithFrame:CGRectMake(0, CONTENT_SUPER_TOP, GIF_IMAGE_SIZE, GIF_IMAGE_SIZE)];
//        self.gifImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.gifImageView];
//        [self.KVOController observe:self.gifImageView keyPath:@"currentAnimatedImageIndex" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
//            NSLog(@"%@",change);
//        }];
    }
    
    return self;
}
-(YYAnimatedImageView *)gifImageView{
    if (!_gifImageView) {
        _gifImageView =[[YYAnimatedImageView alloc]initWithFrame:CGRectMake(0, CONTENT_SUPER_TOP, GIF_IMAGE_SIZE, GIF_IMAGE_SIZE)];
        _gifImageView.contentMode = UIViewContentModeScaleAspectFit;
        _gifImageView.clipsToBounds = YES;
        _gifImageView.backgroundColor = [UIColor clearColor];
        
    }
    return _gifImageView;
}
- (void)layoutMessageContentViews:(BOOL)isFromMe {
    CGRect frame = self.gifImageView.frame;
    if (isFromMe) {
        frame.origin.x = CGRectGetMinX(self.avatarImage.frame) - CONTENT_AVATAR_MARGIN - frame.size.width;
    }else {
        frame.origin.x = CGRectGetMaxX(self.avatarImage.frame) + CONTENT_AVATAR_MARGIN;
    }
    
    self.gifImageView.frame = frame;

}

- (void)layoutMessageStatusViews:(BOOL)isFromMe {
//    if (isFromMe) {
//        _indicatorView.center = CGPointMake(CGRectGetMinX(self.gifImageView.frame) - CGRectGetWidth(_indicatorView.frame)/2 - 16, CGRectGetMidY(self.gifImageView.frame));
//
//        _statusButton.center = CGPointMake(CGRectGetMinX(self.gifImageView.frame) - CGRectGetWidth(_statusButton.frame)/2 - 16, CGRectGetMidY(self.gifImageView.frame));
//    }
    
    CGRect frame = CGRectZero;
    frame.size = self.messageModel.thumbnailImageSize;
    //frame.size = [LLMessageImageCell thumbnailSize:self.messageModel.thumbnailImageSize];
    //    frame.size.width = GIF_IMAGE_SIZE ? GIF_IMAGE_SIZE : 0;
    //    frame.size.height = GIF_IMAGE_SIZE ? GIF_IMAGE_SIZE : 0;
    if (frame.size.width > GIF_IMAGE_SIZE){
        frame.size.width = GIF_IMAGE_SIZE ? GIF_IMAGE_SIZE : 0;
    }
    if (frame.size.height > GIF_IMAGE_SIZE){
        frame.size.height = GIF_IMAGE_SIZE ? GIF_IMAGE_SIZE : 0;
    }
    
    if (isFromMe) {
        frame.origin.x = CGRectGetMinX(self.avatarImage.frame) - CONTENT_AVATAR_MARGIN - frame.size.width;
        frame.origin.y = CONTENT_SUPER_TOP;
        self.gifImageView.frame = frame;
        
//        _thumbnailImageView.center = self.chatImageView.center;
//        frame = _thumbnailImageView.frame;
//        frame.origin.x -= BUBBLE_MASK_ARROW / 2;
//        _thumbnailImageView.frame = frame;
        
    }else {
        frame.origin.x = CGRectGetMaxX(self.avatarImage.frame) + CONTENT_AVATAR_MARGIN;
        frame.origin.y = CONTENT_SUPER_TOP;
        self.gifImageView.frame = frame;
        
//        _thumbnailImageView.center = self.chatImageView.center;
//        frame = _thumbnailImageView.frame;
//        frame.origin.x += BUBBLE_MASK_ARROW / 2;
//        _thumbnailImageView.frame = frame;
    }
    
//    frame = self.chatImageView.frame;
//    frame.origin.x = CGRectGetMinX(frame) - 1;
//    frame.size.height += 2;
//    frame.size.width += 1;
//    self.borderView.frame = frame;
//
//    self.bubbleImage.frame = self.chatImageView.bounds;
//
//    if (isFromMe)
//        _maskView.frame = self.chatImageView.bounds;
}


//+ (CGFloat)heightForModel:(CSMessageModel *)model {
//    return GIF_IMAGE_SIZE + CONTENT_SUPER_BOTTOM;
//}

+ (CGSize)thumbnailSize:(CGSize)size {
    CGSize _size = size;
    CGFloat scale = GIF_IMAGE_SIZE / size.height;
    CGFloat _width = ceil(size.width * scale);
    if (_width < GIF_IMAGE_MIN_SIZE) {
        scale = GIF_IMAGE_MIN_SIZE / size.width;
        _size.width = GIF_IMAGE_MIN_SIZE;
        _size.height = ceil(size.height * scale);
    }else if (_width > GIF_IMAGE_SIZE) {
        scale = GIF_IMAGE_MIN_SIZE / size.height;
        if (scale * size.width <= GIF_IMAGE_SIZE) {
            _size.width = GIF_IMAGE_SIZE;
            _size.height = ceil(size.height * (GIF_IMAGE_SIZE / size.width));
        }else {
            _size.height = GIF_IMAGE_MIN_SIZE;
            _size.width = ceil(scale * size.width);
        }
    }else {
        _size.width = _width;
        _size.height = GIF_IMAGE_SIZE;
    }
    
    return _size;
}

+ (CGFloat)heightForModel:(CSMessageModel *)model {
    if (model.thumbnailImageSize.height > GIF_IMAGE_SIZE)
        return GIF_IMAGE_SIZE + CONTENT_SUPER_BOTTOM;
    else
        return model.thumbnailImageSize.height + CONTENT_SUPER_BOTTOM;
}
- (void)willDisplayCell {
    if (!self.messageModel.thumbnailImage) {
        WEAKSELF;

        [self.gifImageView yy_setImageWithURL:[NSURL URLWithString:self.messageModel.body.content] placeholder:nil options:YYWebImageOptionProgressiveBlur |YYWebImageOptionShowNetworkActivity completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
            self.messageModel.gifShowIndex = self.gifImageView.currentAnimatedImageIndex;

            weakSelf.messageModel.thumbnailImage = image;
            [weakSelf.messageModel internal_setMessageDownloadStatus:kCSMessageDownloadStatusSuccessed];
            [weakSelf.messageModel internal_setThumbnailDownloadStatus:kCSMessageDownloadStatusSuccessed];
        }];

    }
    else
    {
        self.gifImageView.image = self.messageModel.thumbnailImage;
//        self.gifImageView.currentAnimatedImageIndex = self.messageModel.gifShowIndex;
    }
  
}

- (void)didEndDisplayingCell {
//    self.gifImageView.image = nil;
}

- (void)willBeginScrolling {
    [super willBeginScrolling];
//    self.messageModel.gifShowIndex = self.gifImageView.currentAnimatedImageIndex;
}

- (void)didEndScrolling {
    
}


#pragma mark - 手势

- (UIView *)hitTestForTapGestureRecognizer:(CGPoint)point {
    CGPoint pointInView = [self.contentView convertPoint:point toView:self.gifImageView];
    
    if ([self.gifImageView pointInside:pointInView withEvent:nil]) {
        return self.gifImageView;
    }
    
    return nil;
}

- (UIView *)hitTestForlongPressedGestureRecognizer:(CGPoint)point {
    return [self hitTestForTapGestureRecognizer:point];
}

- (void)contentLongPressedBeganInView:(UIView *)view {
    [self showMenuControllerInRect:self.gifImageView.bounds inView:self.gifImageView];
}


#pragma mark - 菜单

- (NSArray<NSString *> *)menuItemNames {
    return @[@"添加到表情", @"转发", @"查看专集", @"删除", @"更多..."];
}

- (NSArray<NSString *> *)menuItemActionNames {
    return @[@"addToEmojiAction:", @"forwardAction:", @"showAlbumAction:",@"deleteAction:", @"moreAction:"];
}

- (void)addToEmojiAction:(id)sender {
    
}


- (void)showAlbumAction:(id)sender {
    
}


@end
