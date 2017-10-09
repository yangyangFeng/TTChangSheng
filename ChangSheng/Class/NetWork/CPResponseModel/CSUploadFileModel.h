//
//  CSUploadFileModel.h
//  ChangSheng
//
//  Created by 邴天宇 on 17/10/9.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSHttpsResModel.h"

@interface CSUploadFileModel : CSHttpsResModel
/**
 语音文件地址
 */
@property (nonatomic,copy) NSString *file_url;
@end
