//
//  MJRefreshGifHeader+TTGifHeader.h
//  GoPlay
//
//  Created by 邴天宇 on 21/1/16.
//  Copyright © 2016年 邴天宇. All rights reserved.
//

#import "MJRefreshGifHeader.h"

@interface MJRefreshGifHeader (TTGifHeader)
/**
 *  添加headerview
 *
 *  @param block 刷新时要做的事
 *
 *  @return 
 */
+ (MJRefreshGifHeader *)tt_headerWithRefreshingBlock:(void(^)())block;
@end


