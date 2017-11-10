//
//  CSMessageRecordTool.m
//  ChangSheng
//
//  Created by cnepayzx on 2017/11/10.
//  Copyright © 2017年 邴天宇. All rights reserved.
//

#import "CSMessageRecordTool.h"
#import <Realm/Realm.h>

@implementation CSMessageRecordTool

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
