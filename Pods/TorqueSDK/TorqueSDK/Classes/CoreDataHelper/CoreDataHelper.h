//
//  CoreDataHelper.h
//  OBDTest
//
//  Created by sunxiaofei on 14/12/26.
//  Copyright (c) 2014年 sunxiaofei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#define kResource   @"TorqueModel"
#define kExtension  @"momd"
#define kSqliteName @"TorqueModel.sqlite"
#define kStoreCacheSize @(2000)

@interface CoreDataHelper : NSObject


@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (CoreDataHelper *)sharedInstance;


- (instancetype)initWithResourceInfo:(NSString *)resourceName
                       extensionName:(NSString *)extensioName
                          sqliteName:(NSString *)sqliteName
                           useBundle:(BOOL)useBundle;
/**
 *  通过类名获取所有对象
 *
 *  @param name  类名
 *  @param predicateFormat 查询条件
 *  @param error 错误
 *
 *  @return 所有对象数组
 */
- (NSArray *)fetchedObjectsByEntityName:(NSString *)name predicateWithFormat:(NSString *)predicateFormat error:(NSError **)error;


/**
 *  通过类名删除查找到的对象
 *
 *  @param name            类名
 *  @param predicateFormat 删除的查询条件
 *  @param error           错误信息
 */
- (void)deleteObjectsByEntityName:(NSString *)name predicateWithFormat:(NSString *)predicateFormat error:(NSError **)error;

    
/**
 *  新建一个实例对象
 *  @param name 类名
 *
 *  @return 实例对象
 */
- (id)newByEntityName:(NSString *)name;
/**
 *  保存上下文
 */
- (void)saveContext;
/**
 *  返回应用程序文档路径
 *
 *  @return 返回应用程序文档路径
 */
- (NSURL *)applicationDocumentsDirectory;



@end
