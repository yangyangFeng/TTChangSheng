//
//  CSMessageRecordTool.m
//  ChangSheng
//
//  Created by cnepayzx on 2017/11/10.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSMessageRecordTool.h"


#import <Realm/Realm.h>



static CSMessageRecordTool * tool = nil;

@implementation CSMessageRecordTool
- (CSMessageRecordTool *)cs_cacheMessage:(CSMessageModel *)model userInfo:(CSCacheUserInfo *)userInfo addLast:(BOOL)addLast chatType:(CS_Message_Record_Type)chatType
{
    RLMRealm * realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    
    NSString * new_userId = [self userId:userInfo.userId chatType:chatType];
//    [NSString stringWithFormat:@"%@-%@",ChatTypeChange(chatType),userInfo.userId];
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"ID = %@ AND userType = %@",new_userId,ChatTypeChange(chatType)];//CONTAINS
    RLMResults * result = [CSMsg_User objectsInRealm:realm withPredicate:pred];
    
    CSMsg_User * user = [CSMsg_User new];
//    user.userType = ChatTypeChange(chatType);
    if (result.count) {
        user = [result firstObject];
    }
    else
    {
        user.ID = new_userId;
        user.userId = userInfo.userId;
        user.avatar = userInfo.avatar;
        user.nickname = userInfo.nickname;
    }
    

    
    CSMsg_User_Msg * msg = [self cs_dataModelTransformationMessage:model userInfo:userInfo chatType:chatType];
    msg.owner = user;
    
    if (addLast) {
        [user.msgRecords addObject:msg];
    }
    else
    {
        [user.msgRecords insertObject:msg atIndex:0];
    }

    //聊天类型
    user.userType = ChatTypeChange(chatType);
    
    
    if (result.count) {
        [realm addOrUpdateObject:user];
    }
    else
    {
        [realm addObject:user];
    }
    [realm commitWriteTransaction];
//    [realm transactionWithBlock:^{
//        [realm addOrUpdateObject:user];
//    }];
    
    return self;
}

- (CSMsg_User_Msg *)cs_dataModelTransformationMessage:(CSMessageModel *)model
                                             userInfo:(CSCacheUserInfo *)userInfo
                                             chatType:(CS_Message_Record_Type)chatType
{
    NSString * new_userId = [self userId:userInfo.userId chatType:chatType];
    
    CSMsg_User_Msg * msg = [CSMsg_User_Msg new];
    msg.img_width = model.body.img_width;
    msg.img_height = model.body.img_height;
    
    msg.is_self = model.isSelf;
    if (model.isSelf) {
        msg.avatar = [CSUserInfo shareInstance].info.avatar;
        msg.nickname = [CSUserInfo shareInstance].info.nickname;
    }
    else
    {
        msg.avatar = userInfo.avatar;
        msg.nickname = userInfo.nickname;
    }
    if (new_userId == self.currentChatId || model.isSelf) {
        msg.isRead = YES;
    }
    msg.content = model.body.content;
    msg.voice_length = model.body.voice_length;
    msg.type = [NSString stringWithFormat:@"%ld",model.body.msgType];
    msg.link_url = model.body.linkUrl;
    msg.timestamp = model.body.timestamp;
    msg.img_url_b = model.body.img_url_b;
    msg.chatType = ChatTypeChange(chatType);
    msg.msg_id = [NSString stringWithFormat:@"%@-%@",new_userId,model.body.msgId];
    return msg;
}

- (NSString *)userId:(NSString *)userId chatType:(CS_Message_Record_Type)chatType
{
    NSString * new_userId = [NSString stringWithFormat:@"%@-%@",ChatTypeChange(chatType),userId];
    return new_userId;
}


- (CSMessageRecordTool *)cs_cacheMessages:(NSArray<CSMessageModel*> *)models userInfo:(CSCacheUserInfo *)userInfo addLast:(BOOL)addLast chatType:(CS_Message_Record_Type)chatType
{
    RLMRealm * realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    
    NSString * new_userId = [self userId:userInfo.userId chatType:chatType];
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"ID = %@ AND userType = %@",new_userId,ChatTypeChange(chatType)];//CONTAINS
    RLMResults * result = [CSMsg_User objectsInRealm:realm withPredicate:pred];
    
    CSMsg_User * user = [CSMsg_User new];
//    user.userType = ChatTypeChange(chatType);
    if (result.count) {
        user = [result firstObject];
    }
    else
    {
        user.ID = new_userId;
        user.userId = userInfo.userId;
        user.avatar = userInfo.avatar;
        user.nickname = userInfo.nickname;
        [realm addObject:user];
    }
    
   
    NSMutableArray * messageArray = [NSMutableArray array];
    if (addLast) {
        for (CSMessageModel * model in models){
            
            CSMsg_User_Msg * msg = [self cs_dataModelTransformationMessage:model userInfo:userInfo chatType:chatType];

            msg.owner = user;

            [messageArray addObject:msg];

        }
    }
    else
    {
        for (int i = models.count - 1; i >=0; i--) {
            CSMessageModel * model = models[i];
            CSMsg_User_Msg * msg = [self cs_dataModelTransformationMessage:model userInfo:userInfo chatType:chatType];
            
            //如果已存在数据 就不再添加了
//            NSPredicate * pred = [NSPredicate predicateWithFormat:@"msgId = %@",msg.msg_id];//CONTAINS
//            RLMResults * result = [CSMsg_User_Msg objectsInRealm:realm where:@"msg_id = %@",msg.msg_id];

            
            msg.owner = user;
            
            [messageArray addObject:msg];
//            [user.msgRecords insertObject:msg atIndex:0];

        }
    }
    
    //聊天类型
    user.userType = ChatTypeChange(chatType);
    
//    [realm addOrUpdateObject:user];
    [realm addOrUpdateObjects:messageArray];
    user.msgRecords = [CSMsg_User_Msg objectsWhere:@"owner = %@",user];
//    RLMResults * result = [CSMsg_User_Msg objectsInRealm:realm where:@"msg_id = %@",msg.msg_id];
    [realm commitWriteTransaction];
    return self;
}

- (CSMessageRecordTool *)loadCacheMessageWithUserId:(NSString *)userId loadDatas:(loadDatas)loadDatas chatType:(CS_Message_Record_Type)chatType
{
    RLMRealm * realm = [RLMRealm defaultRealm];
//    NSPredicate * pred = [NSPredicate predicateWithFormat:@"userId = %@",userId];
//    NSString * new_userId = [NSString stringWithFormat:@"%@-%@",ChatTypeChange(chatType),userId];
    NSString * new_userId = [self userId:userId chatType:chatType];
    
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"ID = %@ AND userType = %@",new_userId,ChatTypeChange(chatType)];//CONTAINS
    RLMResults * result = [CSMsg_User objectsInRealm:realm withPredicate:pred];
    CSMsg_User * user = [result firstObject];
    NSMutableArray * datas = [NSMutableArray array];
    for (CSMsg_User_Msg * msgModel in user.msgRecords) {
        CSMessageModel * model = [CSMessageModel conversionWithLocalRecordModel:msgModel chatType:(CSChatTypeChat) chatId:userId];
        [datas addObject:model];
    }
    if (loadDatas) {
        loadDatas(datas);
    }
    return self;
}

- (CSMessageRecordTool *)loadCacheMessageWithUserId:(NSString *)userId loadDatas:(loadDatas)loadDatas LastId:(NSString *)lastId count:(NSInteger)count chatType:(CS_Message_Record_Type)chatType
{
    RLMRealm * realm = [RLMRealm defaultRealm];
    
//    NSString * new_userId = [NSString stringWithFormat:@"%@-%@",ChatTypeChange(chatType),userId];
    NSString * new_userId = [self userId:userId chatType:chatType];
    
//    NSPredicate * pred = [NSPredicate predicateWithFormat:@"userId = %@",userId];
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"ID = %@ AND userType = %@",new_userId,ChatTypeChange(chatType)];//CONTAINS
    RLMResults * result = [CSMsg_User objectsInRealm:realm withPredicate:pred];
    CSMsg_User * user = [result firstObject];
    RLMSortDescriptor * rlmSort = [RLMSortDescriptor sortDescriptorWithKeyPath:@"timestamp" ascending:YES];
    [user.msgRecords sortedResultsUsingDescriptors:@[rlmSort]];
    
    NSInteger currentIndex= -1;
    if (lastId) {
//        currentIndex = [user.msgRecords indexOfObjectWhere:@"msg_id = %@",[NSString stringWithFormat:@"%@-%@",userId,lastId]];
        currentIndex += [user.msgRecords indexOfObjectWhere:@"msg_id = %@",[NSString stringWithFormat:@"%@",lastId]];
    }
    else
    {
        currentIndex += user.msgRecords.count;
    }
    
    NSMutableArray * datas = [NSMutableArray array];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    if (currentIndex>=0) {//(currentIndex - count) ?: 0
        for (int i = currentIndex ; i >=MAX((currentIndex - count), -1); i--) {
            if (i >= user.msgRecords.count) {
                break;
            }
            
            CSMsg_User_Msg * msgModel = [user.msgRecords objectAtIndex:i];
            CSMessageModel * model = [CSMessageModel conversionWithLocalRecordModel:msgModel chatType:(CSChatTypeChat) chatId:userId];
            [datas addObject:model];
//            NSLog(@"i===%d   ,   msgId-->%@    ,    content-->%@,    isread = %d",i,model.msgId,model.body.content, msgModel.isRead);
        }
    }
    
    NSArray *tempArray = [datas sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    

    if (loadDatas) {
        loadDatas(tempArray);
    }
//    [self getUnReadMessageNumWithUserId:userId chatType:(CSChatTypeChat)];
    //清除 未读消息
    [self cleanUnReadMessageNumWithUserId:userId chatType:(chatType)];
    return self;
}

- (void)cleanUnReadMessageNumWithUserId:(NSString *)userId chatType:(CS_Message_Record_Type)chatType
{
    RLMRealm * realm = [RLMRealm defaultRealm];
    NSString * new_userId = [self userId:userId chatType:chatType];
//    NSString * new_userId = [NSString stringWithFormat:@"%@-%@",ChatTypeChange(chatType),userId];

    NSPredicate * pred = [NSPredicate predicateWithFormat:@"ID = %@ AND userType = %@",new_userId,ChatTypeChange(chatType)];//CONTAINS
    RLMResults * result = [CSMsg_User objectsInRealm:realm withPredicate:pred];
    NSPredicate * pred1 = [NSPredicate predicateWithFormat:@"isRead = NO"];
    CSMsg_User * user = [result firstObject];
    RLMResults * unRead = [user.msgRecords objectsWithPredicate:pred1];
    
    if (!unRead.count) {
        return;
    }
    
    [realm beginWriteTransaction];
    for (CSMsg_User_Msg * msg in unRead) {
        msg.isRead = YES;
    }
    [realm commitWriteTransaction];
//    RLMResults * msgResult = []
//    RLMSortDescriptor * rlmSort = [RLMSortDescriptor sortDescriptorWithKeyPath:@"timestamp" ascending:YES];
//    [user.msgRecords sortedResultsUsingDescriptors:@[rlmSort]];
}

- (NSInteger)getUnReadMessageNumWithUserId:(NSString *)userId chatType:(CS_Message_Record_Type)chatType
{
    RLMRealm * realm = [RLMRealm defaultRealm];
//    NSPredicate * pred = [NSPredicate predicateWithFormat:@"userId = %@",userId];
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"ID = %@ AND userType = %@",userId,ChatTypeChange(chatType)];//CONTAINS
    RLMResults * result = [CSMsg_User objectsInRealm:realm withPredicate:pred];
    NSPredicate * pred1 = [NSPredicate predicateWithFormat:@"isRead = NO"];
    CSMsg_User * user = [result firstObject];
    
    RLMResults * unRead = [user.msgRecords objectsWithPredicate:pred1];
    NSLog(@"未读--->%ld,修改后---->%ld",user.msgRecords.count,unRead.count);
    return unRead.count;
}

// 查询数据
- (id)realmSelectData:(NSString *)object theCondition:(NSString *)condition{
    
    Class cls = NSClassFromString(object);
    RLMResults *result = [cls objectsInRealm:[RLMRealm defaultRealm] where:condition];
    return result;
}

- (NSArray <CSFriendchartlistModel*> *)AccessToChatFriendWith:(CS_Message_Record_Type)chatType
{
    RLMRealm * realm = [RLMRealm defaultRealm];
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"userType = %@",ChatTypeChange(chatType)];
    RLMResults * result = [CSMsg_User objectsInRealm:realm withPredicate:pred];
    
    RLMSortDescriptor * rlmSort = [RLMSortDescriptor sortDescriptorWithKeyPath:@"timestamp" ascending:YES];
    
    NSMutableArray * datas = [NSMutableArray array];
    NSMutableArray * haveUnReadArray = [NSMutableArray array];
    NSMutableArray * noHaveUnReadArray = [NSMutableArray array];
    for (CSMsg_User * user in result) {
        RLMResults * msgRecords = [CSMsg_User_Msg objectsInRealm:realm where:@"owner = %@",user];
        [msgRecords sortedResultsUsingDescriptors:@[rlmSort]];
        
        CSFriendchartlistModel * model = [CSFriendchartlistModel new];
        CSMsg_User_Msg * msgModel = [msgRecords lastObject];
        model.lastmsg = msgModel.content;
        model.lastdata = msgModel.timestamp;
        
        model.lastmsgid = msgModel.msg_id;
        model.type = msgModel.type;
        model.nickname = user.nickname;
        model.headurl = user.avatar;
        model.userid = user.userId;
        NSPredicate * pred1 = [NSPredicate predicateWithFormat:@"isRead = NO"];
        
        RLMResults * unRead = [msgRecords objectsWithPredicate:pred1];
        model.unreadmsgnum = [NSString stringWithFormat:@"%ld",unRead.count];
        
        if (unRead.count) {
            [haveUnReadArray addObject:model];
        }
        else
        {
            [noHaveUnReadArray addObject:model];
        }
    }
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"lastdata" ascending:NO]];
    
    [haveUnReadArray sortUsingDescriptors:sortDescriptors];
    [noHaveUnReadArray sortUsingDescriptors:sortDescriptors];
    
    [datas addObjectsFromArray:haveUnReadArray];
    [datas addObjectsFromArray:noHaveUnReadArray];
    return datas;
}
    
- (void)deleteFriendRecord:(NSString *)userId chatType:(CS_Message_Record_Type)chatType
{
    RLMRealm * realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    
//    NSString * new_userId = [NSString stringWithFormat:@"%@-%@",ChatTypeChange(chatType),userId];
    NSString * new_userId = [self userId:userId chatType:chatType];
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"ID = %@ AND userType = %@",new_userId,ChatTypeChange(chatType)];//CONTAINS
    RLMResults * result = [CSMsg_User objectsInRealm:realm withPredicate:pred];
    CSMsg_User * user = [result firstObject];
    [realm deleteObjects:user.msgRecords];
    [realm deleteObject:user];
    [realm commitWriteTransaction];
}
#pragma makr - 把语音消息未读转换为已读
- (void)readVoiceMessageWith:(CSMessageModel *)model
{
    CSMsg_User_Msg * result = [[CSMsg_User_Msg objectsWhere:@"msg_id = %@",model.body.msgId] firstObject];
    if (result) {
        [[RLMRealm defaultRealm] transactionWithBlock:^{
            result.isMediaPlayed = YES;
        }];
    }
}

// 检查该类中是否有该属性
- (BOOL)CheckPropertys:(NSString *)object propertyDict:(NSDictionary *)dict{
    
    Class cls = NSClassFromString(object);
    // 属性字符串数组
    NSMutableArray *clspropertys = [NSMutableArray array];
    
    unsigned pCount;
    objc_property_t *properties = class_copyPropertyList(cls, &pCount);//属性数组
    
    for(int i = 0; i < pCount; i++){
        objc_property_t property = properties[i];
        NSString *str =[NSString stringWithFormat:@"%s", property_getName(property)];
        [clspropertys addObject:str];
        //NSLog(@"propertyName:%s",property_getName(property));
        //NSLog(@"propertyAttributes:%s",property_getAttributes(property));
    }
    
    NSArray *keys = dict.allKeys;
    for (NSString *dictkey in keys) {
        if ([clspropertys containsObject:dictkey]) {
            NSLog(@"This class does contain attributes.:%@",dictkey);
        }else {
            NSLog(@"This class does not contain attributes.:%@",dictkey);
            return NO;
        }
    }
    return YES;
}

+ (CSMessageRecordTool *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [CSMessageRecordTool new];
    });
    return tool;
}


+ (void)setDefaultRealmForUser:(NSString *)username {
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    
    NSString * pathName = [path stringByAppendingString:[NSString stringWithFormat:@"/realmDB_%@.realm",username]];
    
    DLog(@"数据库地址---->%@",pathName);
    
    config.fileURL = [NSURL URLWithString:pathName];
    
    config.migrationBlock = ^(RLMMigration * _Nonnull migration, uint64_t oldSchemaVersion) {
        
        if (oldSchemaVersion < 3) {
            
            NSLog(@"进行数据迁移");
            
        }else{
            
            NSLog(@"不进行数据迁移");
            
        }
        
    };
    
    // 使用默认的目录，但是使用用户名来替换默认的文件名
//    NSString * path = [[[config.fileURL.path stringByDeletingLastPathComponent]
//                        stringByAppendingPathComponent:username]
//                       stringByAppendingPathExtension:@"realm"];
//    config.fileURL = [NSURL URLWithString:path];
    
    // 将这个配置应用到默认的 Realm 数据库当中
    [RLMRealmConfiguration setDefaultConfiguration:config];
}
@end
