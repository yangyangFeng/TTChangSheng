//
//  CSMessageDBModel.h
//  ChangSheng
//
//  Created by cnepayzx on 2017/11/13.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
@class CSMsg_User_Msg,CSMsg_User;
@interface CSMessageDBModel : RLMObject

@end

RLM_ARRAY_TYPE(CSMsg_User_Msg)
@interface CSMsg_User : RLMObject
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *userId;

@property (nonatomic,copy) NSString *userType;
@property RLMArray <CSMsg_User_Msg> * msgRecords;
@end

@interface CSMsg_User_Msg : RLMObject


@property CSMsg_User *owner;
@property (nonatomic,copy) NSString *msg_id;


/********************个客户端自定义字段***********************
 *default is No
 */
@property (nonatomic,assign) BOOL isRead;

@property (nonatomic,copy) NSString *link_url;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *timestamp;
@property (nonatomic,copy) NSString *nickname;
@property (nonatomic,copy) NSString *avatar;
@property (nonatomic,copy) NSString *is_self;
@property (nonatomic,assign) NSInteger voice_length;
@property(nonatomic,assign) NSInteger img_width;
@property(nonatomic,assign) NSInteger img_height;
@end
