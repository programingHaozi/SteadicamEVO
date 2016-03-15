//
//  CoreDataHelper.m
//  OBDTest
//
//  Created by sunxiaofei on 14/12/26.
//  Copyright (c) 2014年 sunxiaofei. All rights reserved.
//

#import "CoreDataHelper.h"
#import "TorqueFeature.h"
#import "EncryptedStore.h"


#if USE_EncryptedCoreData
#define kEncryptedCoreDataPassword @"4ddd8473ed21046131e7b24555382705b0c53703"
#endif

@interface CoreDataHelper()

@property (nonatomic,copy) NSString *resourceName;
@property (nonatomic,copy) NSString *extensionName;
@property (nonatomic,copy) NSString *sqliteName;
@property (nonatomic,assign) BOOL useBundle;

@end

@implementation CoreDataHelper

@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

+ (instancetype)sharedInstance {
    NSAssert(1 > 2, @"Must override in subclass!!!");
    return nil;
}

- (instancetype)initWithResourceInfo:(NSString *)resourceName
                       extensionName:(NSString *)extensioName
                          sqliteName:(NSString *)sqliteName
                           useBundle:(BOOL)useBundle
{
    if (self = [super init]) {
        self.resourceName = resourceName;
        self.extensionName = extensioName;
        self.sqliteName = sqliteName;
        self.useBundle = useBundle;
    }
    
    return self;
}


- (NSArray *)fetchedObjectsByEntityName:(NSString *)name predicateWithFormat:(NSString *)predicateFormat error:(NSError **)error {
    NSFetchRequest *fetchreq = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:name inManagedObjectContext:self.managedObjectContext];
    
    [fetchreq setEntity:entity];
    if (predicateFormat) {
        NSPredicate * cdt = [NSPredicate predicateWithFormat:predicateFormat];
        [fetchreq setPredicate:cdt];
    }
    
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchreq error:error];
    
    return [fetchedObjects copy];
}

- (void)deleteObjectsByEntityName:(NSString *)name predicateWithFormat:(NSString *)predicateFormat error:(NSError **)error {
 
    NSArray *array = [self fetchedObjectsByEntityName:name predicateWithFormat:predicateFormat error:error];

    for (NSManagedObject *obj in array) {
        [self.managedObjectContext deleteObject:obj];
    }
}

- (id)newByEntityName:(NSString *)name {
    return [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:self.managedObjectContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    //得到数据库连接对象
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        //将操作句柄与数据连接对象关联。
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    return __managedObjectContext;
}
//创建model文件对应的表映射
/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }

    if (self.useBundle) {
        NSString *modelPath = [[NSBundle mainBundle] pathForResource:self.resourceName ofType:@"bundle"];
        __managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:@[[NSBundle bundleWithPath:modelPath]]];
    } else {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:self.resourceName withExtension:self.extensionName];
        //通过model文件进行创建
        __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    
    return __managedObjectModel;
}
/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
#if USE_EncryptedCoreData == 1
    __persistentStoreCoordinator = [EncryptedStore makeStore:[self managedObjectModel] passcode:kEncryptedCoreDataPassword];
#elif USE_EncryptedCoreData == 2
    NSURL *databaseURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:self.sqliteName];
    
    int cache = [kStoreCacheSize intValue];
    EncryptedStoreOptions options;
    options.passphrase = kEncryptedCoreDataPassword;
    options.database_location = (char*)[[databaseURL description] UTF8String];
    options.cache_size = &cache;
    
    __persistentStoreCoordinator = [EncryptedStore makeStoreWithStructOptions:&options managedObjectModel:[self managedObjectModel]];
    
#elif USE_EncryptedCoreData == 3
    NSURL *databaseURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:self.sqliteName];
    __persistentStoreCoordinator = [EncryptedStore makeStoreWithOptions:@{
                                                         EncryptedStorePassphraseKey : kEncryptedCoreDataPassword,
                                                         EncryptedStoreDatabaseLocation : [databaseURL description]}
                                    managedObjectModel:[self managedObjectModel]];
#else
    //数据库文件访问ＵＲＬ
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:self.sqliteName];
    NSError *error = nil;
    //通过model文件生成相应的ＳＱＬＩＴＥ表结构。
     __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
   
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
#endif
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
