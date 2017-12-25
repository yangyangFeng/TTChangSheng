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
- (CSMessageRecordTool *)cs_cacheMessage:(CSMessageModel *)model userId:(NSString *)userId addLast:(BOOL)addLast chatType:(CS_Message_Record_Type)chatType
{
    RLMRealm * realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    
    NSString * new_userId = [NSString stringWithFormat:@"%@-%@",ChatTypeChange(chatType),userId];
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"ID = %@ AND userType = %@",new_userId,ChatTypeChange(chatType)];//CONTAINS
    RLMResults * result = [CSMsg_User objectsInRealm:realm withPredicate:pred];
    
    CSMsg_User * user = [CSMsg_User new];
    user.userType = ChatTypeChange(chatType);
    if (result.count) {
        user = [result firstObject];
    }
    else
    {
        user.ID = new_userId;
        user.userId = userId;
    }
    
    CSMsg_User_Msg * msg = [CSMsg_User_Msg new];
    msg.img_width = model.body.img_width;
    msg.img_height = model.body.img_height;
    
    msg.content = model.body.content;
    msg.avatar = model.body.avatar;
    msg.voice_length = model.body.voice_length;
    msg.type = [NSString stringWithFormat:@"%ld",model.body.msgType];
    msg.link_url = model.body.linkUrl;
    msg.timestamp = model.body.timestamp;
    msg.is_self = [NSString stringWithFormat:@"%ld",model.isSelf];
    msg.nickname = model.body.nickname;
    msg.msg_id = [NSString stringWithFormat:@"%@-%@",new_userId,model.msgId];
    
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

- (CSMessageRecordTool *)cs_cacheMessages:(NSArray<CSMessageModel*> *)models userId:(NSString *)userId addLast:(BOOL)addLast chatType:(CS_Message_Record_Type)chatType
{
    RLMRealm * realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    NSString * new_userId = [NSString stringWithFormat:@"%@-%@",ChatTypeChange(chatType),userId];
//    NSPredicate * pred = [NSPredicate predicateWithFormat:@"userId = %@",userId];//CONTAINS
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"ID = %@ AND userType = %@",new_userId,ChatTypeChange(chatType)];//CONTAINS
    RLMResults * result = [CSMsg_User objectsInRealm:realm withPredicate:pred];
    
    CSMsg_User * user = [CSMsg_User new];
    user.userType = ChatTypeChange(chatType);
    if (result.count) {
        user = [result firstObject];
    }
    else
    {
        user.ID = new_userId;
        user.userId = userId;
    }
    
   

    if (addLast) {
        for (CSMessageModel * model in models){
            
            CSMsg_User_Msg * msg = [CSMsg_User_Msg new];
            msg.img_width = model.body.img_width;
            msg.img_height = model.body.img_height;
            
            msg.content = model.body.content;
            msg.avatar = model.body.avatar;
            msg.voice_length = model.body.voice_length;
            msg.type = [NSString stringWithFormat:@"%ld",model.body.msgType];
            msg.link_url = model.body.linkUrl;
            msg.timestamp = model.body.timestamp;
            msg.is_self = [NSString stringWithFormat:@"%ld",model.isSelf];
            msg.nickname = model.body.nickname;
            msg.msg_id = [NSString stringWithFormat:@"%@-%@",new_userId,model.msgId];
            
            [user.msgRecords addObject:msg];
        }
    }
    else
    {
        for (int i = models.count - 1; i >=0; i--) {
            CSMessageModel * model = models[i];
            CSMsg_User_Msg * msg = [CSMsg_User_Msg new];
            msg.img_width = model.body.img_width;
            msg.img_height = model.body.img_height;
            
            msg.content = model.body.content;
            msg.avatar = model.body.avatar;
            msg.voice_length = model.body.voice_length;
            msg.type = [NSString stringWithFormat:@"%ld",model.body.msgType];
            msg.link_url = model.body.linkUrl;
            msg.timestamp = model.body.timestamp;
            msg.is_self = [NSString stringWithFormat:@"%ld",model.isSelf];
            msg.nickname = model.body.nickname;
            msg.msg_id = [NSString stringWithFormat:@"%@-%@",new_userId,model.msgId];
            
            [user.msgRecords insertObject:msg atIndex:0];

        }
    }
    
    //聊天类型
    user.userType = ChatTypeChange(chatType);
    
    [realm addOrUpdateObject:user];
    [realm commitWriteTransaction];
    return self;
}

- (CSMessageRecordTool *)loadCacheMessageWithUserId:(NSString *)userId loadDatas:(loadDatas)loadDatas chatType:(CS_Message_Record_Type)chatType
{
    RLMRealm * realm = [RLMRealm defaultRealm];
//    NSPredicate * pred = [NSPredicate predicateWithFormat:@"userId = %@",userId];
    NSString * new_userId = [NSString stringWithFormat:@"%@-%@",ChatTypeChange(chatType),userId];
    
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
    
    NSString * new_userId = [NSString stringWithFormat:@"%@-%@",ChatTypeChange(chatType),userId];
    
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
    if (currentIndex) {//(currentIndex - count) ?: 0
        for (int i = currentIndex ; i >=MAX((currentIndex - count), 0); i--) {
            if (i >= user.msgRecords.count) {
                break;
            }
            
            CSMsg_User_Msg * msgModel = [user.msgRecords objectAtIndex:i];
            CSMessageModel * model = [CSMessageModel conversionWithLocalRecordModel:msgModel chatType:(CSChatTypeChat) chatId:userId];
            [datas addObject:model];
            NSLog(@"i===%d   ,   msgId-->%@    ,    content-->%@,    isread = %d",i,model.msgId,model.body.content, msgModel.isRead);
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
    NSString * new_userId = [NSString stringWithFormat:@"%@-%@",ChatTypeChange(chatType),userId];
//    NSPredicate * pred = [NSPredicate predicateWithFormat:@"userId = %@",userId];
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
    for (CSMsg_User * user in result) {
        [user.msgRecords sortedResultsUsingDescriptors:@[rlmSort]];
        
        CSFriendchartlistModel * model = [CSFriendchartlistModel new];
        CSMsg_User_Msg * msgModel = [user.msgRecords lastObject];
        model.lastmsg = msgModel.content;
        model.nickname = msgModel.nickname;
        model.lastdata = msgModel.timestamp;
        model.headurl = msgModel.avatar;
        model.lastmsgid = msgModel.msg_id;
        model.userid = user.userId;
        NSPredicate * pred1 = [NSPredicate predicateWithFormat:@"isRead = NO"];
        
        RLMResults * unRead = [user.msgRecords objectsWithPredicate:pred1];
        model.unreadmsgnum = [NSString stringWithFormat:@"%ld",unRead.count];
        
        [datas addObject:model];
    }

    return datas;
}
//
//// 更新数据
//- (BOOL)realmsUpdateData:(NSString *)object theCondition:(NSString *)condition property:(NSDictionary *)dict{
//    
//    Class cls = NSClassFromString(object);
//    if (cls == nil) {
//        return NO;
//    }
//    
//    RLMResults *results = [self realmsselectData:object theCondition:condition];
//    if (!results.count) {
//        return YES;
//    }
//    
//    if (dict == nil) {
//        return NO;
//    }
//    
//    // 检查属性
//    if (![self CheckPropertys:object propertyDict:dict]) {
//        return NO;
//    }
//    
//    NSError *error = nil;
//    [self.rlmRealm beginWriteTransaction];
//    
//    //将每条数据的每个 属性设置为对应的值
//    for (NSString *updateKey in dict.allKeys) {
//        [results setValue:dict[updateKey] forKeyPath:updateKey];
//    }
//    // 如果没有值，就新插入一条数据
//    //[cls createOrUpdateInRealm:self.rlmRealm withValue:dict];
//    
//    return [self.rlmRealm commitWriteTransaction:&error];
//}

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
