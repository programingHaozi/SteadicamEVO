//
//  TFFileManager.h
//  TFBaseLib
//
//  Created by xiayiyong on 15/10/21.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ImageIO/ImageIO.h>
#import <UIKit/UIKit.h>

@interface TFFileManager : NSObject

/**
 *  根据地址和键获取归档对象
 *
 *  @param path 归档的地址
 *  @param key  归档的key
 *
 *  @return 返回的对象
 */
+(id)attributeOfItemAtPath:(NSString *)path forKey:(NSString *)key;

/**
 *  根据地址和键获取归档对象
 *
 *  @param path  归档的地址
 *  @param key   归档的key
 *  @param error 错误信息
 *
 *  @return 返回的对象
 */
+(id)attributeOfItemAtPath:(NSString *)path forKey:(NSString *)key error:(NSError **)error;

/**
 *  根据地址返回归档的字典对象
 *
 *  @param path 地址
 *
 *  @return 返回的对象
 */
+(NSDictionary *)attributesOfItemAtPath:(NSString *)path;

/**
 *  根据地址返回归档的字典对象
 *
 *  @param path  地址
 *  @param error 错误信息
 *
 *  @return 返回的对象
 */
+(NSDictionary *)attributesOfItemAtPath:(NSString *)path error:(NSError **)error;

/**
 *  将一个文件拷贝到另一个路径
 *
 *  @param path   当前文件路径
 *  @param toPath 拷贝的路径
 *
 *  @return 成功返回YES 否则返回NO
 */
+(BOOL)copyItemAtPath:(NSString *)path toPath:(NSString *)toPath;

/**
 *  将一个文件拷贝到另一个路径
 *
 *  @param path   当前文件路径
 *  @param toPath 拷贝的路径
 *  @param error  错误信息
 *
 *  @return 成功返回YES 否则返回NO
 */
+(BOOL)copyItemAtPath:(NSString *)path toPath:(NSString *)toPath error:(NSError **)error;

/**
 *  将一个文件拷贝到另一个路径是否重写
 *
 *  @param path      当前文件路径
 *  @param toPath    拷贝的路径
 *  @param overwrite 是否重写
 *
 *  @return 成功返回YES 否则返回NO
 */
+(BOOL)copyItemAtPath:(NSString *)path toPath:(NSString *)toPath overwrite:(BOOL)overwrite;

/**
 *  将一个文件拷贝到另一个路径是否重写
 *
 *  @param path      当前文件路径
 *  @param toPath    拷贝的路径
 *  @param overwrite 是否重写
 *  @param error     错误信息
 *
 *  @return 成功返回YES 否则返回NO
 */
+(BOOL)copyItemAtPath:(NSString *)path toPath:(NSString *)toPath overwrite:(BOOL)overwrite error:(NSError **)error;

/**
 *  根据路径创建一个文件
 *
 *  @param path 路径地址
 *
 *  @return 成功返回YES 否则返回NO
 */
+(BOOL)createDirectoriesForFileAtPath:(NSString *)path;

/**
 *   根据路径创建一个文件
 *
 *  @param path  路径地址
 *  @param error 错误信息
 *
 *  @return 成功返回YES 否则返回NO
 */
+(BOOL)createDirectoriesForFileAtPath:(NSString *)path error:(NSError **)error;

/**
 *  根据路径创建一个文件夹
 *
 *  @param path 路径地址
 *
 *  @return 成功返回YES 否则返回NO
 */
+(BOOL)createDirectoriesForPath:(NSString *)path;

/**
 *  根据路径创建一个文件夹
 *
 *  @param path  路径地址
 *  @param error 错误信息
 *
 *  @return 成功返回YES 否则返回NO
 */
+(BOOL)createDirectoriesForPath:(NSString *)path error:(NSError **)error;

/**
 *  根据路径创建一个文件
 *
 *  @param path 路径地址
 *
 *  @return 成功返回YES 否则返回NO
 */
+(BOOL)createFileAtPath:(NSString *)path;

/**
 *   根据路径创建一个文件
 *
 *  @param path  路径地址
 *  @param error 错误信息
 *
 *  @return 成功返回YES 否则返回NO
 */
+(BOOL)createFileAtPath:(NSString *)path error:(NSError **)error;

/**
 *  根据路径创建一个文件是否重写
 *
 *  @param path      路径地址
 *  @param overwrite 是否重写
 *
 *  @return 成功返回YES 否则返回NO
 */
+(BOOL)createFileAtPath:(NSString *)path overwrite:(BOOL)overwrite;

/**
 *  根据路径创建一个文件是否重写
 *
 *  @param path      路径地址
 *  @param overwrite 是否重写
 *  @param error     错误信息
 *
 *  @return 成功返回YES 否则返回NO
 */
+(BOOL)createFileAtPath:(NSString *)path overwrite:(BOOL)overwrite error:(NSError **)error;

/**
 *  根据路径和内容创建文件
 *
 *  @param path    路径地址
 *  @param content 内容
 *
 *  @return        成功返回YES 否则返回NO
 */
+(BOOL)createFileAtPath:(NSString *)path withContent:(NSObject *)content;

/**
 *  根据路径和内容创建文件
 *
 *  @param path    路径地址
 *  @param content 内容
 *  @param error   错误信息
 *
 *  @return        成功返回YES 否则返回NO
 */
+(BOOL)createFileAtPath:(NSString *)path withContent:(NSObject *)content error:(NSError **)error;

/**
 *  根据路径和内容创建文件是否重写
 *
 *  @param path      路径地址
 *  @param content   内容
 *  @param overwrite 是否重写
 *
 *  @return 成功返回YES 否则返回NO
 */
+(BOOL)createFileAtPath:(NSString *)path withContent:(NSObject *)content overwrite:(BOOL)overwrite;

/**
 *  根据路径和内容创建文件是否重写
 *
 *  @param path      路径地址
 *  @param content   内容
 *  @param overwrite 是否重写
 *  @param error     错误信息
 *
 *  @return 成功返回YES 否则返回NO
 */
+(BOOL)createFileAtPath:(NSString *)path withContent:(NSObject *)content overwrite:(BOOL)overwrite error:(NSError **)error;

/**
 *  根据路径创建date对象
 *
 *  @param path 路径地址
 *
 *  @return 创建的date
 */
+(NSDate *)creationDateOfItemAtPath:(NSString *)path;

/**
 *  根据路径创建date对象
 *
 *  @param path  路径地址
 *  @param error 错误信息
 *
 *  @return 创建的date
 */
+(NSDate *)creationDateOfItemAtPath:(NSString *)path error:(NSError **)error;

/**
 *  创建空的Cache文件夹
 *
 *  @return 成功返回YES 否则返回NO
 */
+(BOOL)emptyCachesDirectory;

/**
 *  创建空的Temporary文件夹
 *
 *  @return 成功返回YES 否则返回NO
 */
+(BOOL)emptyTemporaryDirectory;

/**
 *  检查是否存在该路径的地址
 *
 *  @param path 地址
 *
 *  @return 成功返回YES 否则返回NO
 */
+(BOOL)existsItemAtPath:(NSString *)path;

/**
 *  这个路径是不是个文件夹
 *
 *  @param path 路径
 *
 *  @return 成功返回YES 否则返回NO
 */
+(BOOL)isDirectoryItemAtPath:(NSString *)path;

/**
 *  这个路径是不是个文件夹
 *
 *  @param path  路径
 *  @param error 错误内容
 *
 *  @return 成功返回YES 否则返回NO
 */
+(BOOL)isDirectoryItemAtPath:(NSString *)path error:(NSError **)error;

/**
 *  该路径下的文件是不是空的
 *
 *  @param path 路径
 *
 *  @return 成功返回YES 否则返回NO
 */
+(BOOL)isEmptyItemAtPath:(NSString *)path;

/**
 *  该路径下的文件是不是空的
 *
 *  @param path  路径
 *  @param error 错误信息
 *
 *  @return 成功返回YES 否则返回NO
 */
+(BOOL)isEmptyItemAtPath:(NSString *)path error:(NSError **)error;

/**
 *  该路径下是不是文件
 *
 *  @param path 路径
 *
 *  @return 是返回YES 否则返回NO
 */
+(BOOL)isFileItemAtPath:(NSString *)path;

/**
 *  该路径下是不是文件
 *
 *  @param path  路径
 *  @param error 错误信息
 *
 *  @return 是返回YES 否则返回NO
 */
+(BOOL)isFileItemAtPath:(NSString *)path error:(NSError **)error;

/**
 *  是否是可执行文件
 *
 *  @param path 路径
 *
 *  @return 是返回YES 否则返回NO
 */
+(BOOL)isExecutableItemAtPath:(NSString *)path;

/**
 *  是否是可读取文件
 *
 *  @param path 路径
 *
 *  @return 是返回YES 否则返回NO
 */
+(BOOL)isReadableItemAtPath:(NSString *)path;

/**
 *  是否是可写文件
 *
 *  @param path 路径
 *
 *  @return 是返回YES 否则返回NO
 */
+(BOOL)isWritableItemAtPath:(NSString *)path;

/**
 *  文件夹列表
 *
 *  @param path 路径
 *
 *  @return 列表
 */
+(NSArray *)listDirectoriesInDirectoryAtPath:(NSString *)path;

/**
 *  文件夹列表
 *
 *  @param path 路径
 *  @param deep 是否深层拷贝
 *
 *  @return 列表
 */
+(NSArray *)listDirectoriesInDirectoryAtPath:(NSString *)path deep:(BOOL)deep;

/**
 *  文件列表
 *
 *  @param path 路径
 *
 *  @return 列表
 */
+(NSArray *)listFilesInDirectoryAtPath:(NSString *)path;

/**
 *  文件列表
 *
 *  @param path 路径
 *  @param deep 是否深层拷贝
 *
 *  @return 列表
 */
+(NSArray *)listFilesInDirectoryAtPath:(NSString *)path deep:(BOOL)deep;

/**
 *  文件夹里存在相同文件的列表
 *
 *  @param path      路径
 *  @param extension 要查找的文件
 *
 *  @return 列表
 */
+(NSArray *)listFilesInDirectoryAtPath:(NSString *)path withExtension:(NSString *)extension;

/**
 *  文件夹里存在相同文件的列表
 *
 *  @param path      路径
 *  @param extension 要查找的文件
 *  @param deep      deep
 *
 *  @return 列表
 */
+(NSArray *)listFilesInDirectoryAtPath:(NSString *)path withExtension:(NSString *)extension deep:(BOOL)deep;

/**
 *  文件夹里以此名字开头的文件
 *
 *  @param path   地址
 *  @param prefix 检验的名字
 *
 *  @return 列表
 */
+(NSArray *)listFilesInDirectoryAtPath:(NSString *)path withPrefix:(NSString *)prefix;

/**
 *  文件夹里以此名字开头的文件
 *
 *  @param path   地址
 *  @param prefix 检验的名字
 *  @param deep   deep
 *
 *  @return 列表
 */
+(NSArray *)listFilesInDirectoryAtPath:(NSString *)path withPrefix:(NSString *)prefix deep:(BOOL)deep;

/**
 *  文件夹里以此名字结尾的文件
 *
 *  @param path   地址
 *  @param prefix 检验的名字
 *
 *  @return 列表
 */
+(NSArray *)listFilesInDirectoryAtPath:(NSString *)path withSuffix:(NSString *)suffix;

/**
 *  文件夹里以此名字开头的文件
 *
 *  @param path   地址
 *  @param prefix 检验的名字
 *  @param deep   deep
 *
 *  @return 列表
 */
+(NSArray *)listFilesInDirectoryAtPath:(NSString *)path withSuffix:(NSString *)suffix deep:(BOOL)deep;

/**
 *  文件夹里所有元素的列表
 *
 *  @param path 路径
 *  @param deep deep
 *
 *  @return 列表
 */
+(NSArray *)listItemsInDirectoryAtPath:(NSString *)path deep:(BOOL)deep;

/**
 *  移动文件
 *
 *  @param path   路径
 *  @param toPath 移动到的路径
 *
 *  @return 成功返回YES错误NO
 */
+(BOOL)moveItemAtPath:(NSString *)path toPath:(NSString *)toPath;

/**
 *  移动文件
 *
 *  @param path   路径
 *  @param toPath 移动到的路径
 *  @param error  错误信息
 *
 *  @return 成功返回YES错误NO
 */
+(BOOL)moveItemAtPath:(NSString *)path toPath:(NSString *)toPath error:(NSError **)error;

/**
 *  移动文件是否覆盖
 *
 *  @param path      路径

 *  @param toPath    移动到的路径
 *  @param overwrite 是否重新写
 *
 *  @return 成功返回YES错误NO
 */
+(BOOL)moveItemAtPath:(NSString *)path toPath:(NSString *)toPath overwrite:(BOOL)overwrite;

/**
 *  移动文件是否覆盖
 *
 *  @param path      路径
 *  @param toPath    移动到的路径
 *  @param overwrite 是否重新写
 *  @param error     错误信息
 *
 *  @return 成功返回YES错误NO
 */
+(BOOL)moveItemAtPath:(NSString *)path toPath:(NSString *)toPath overwrite:(BOOL)overwrite error:(NSError **)error;

/**
 *  ApplicationSupport文件夹
 *
 *  @return 文件夹
 */
+(NSString *)pathForApplicationSupportDirectory;

/**
 *  ApplicationSupport文件夹
 *
 *  @param path 路径
 *
 *  @return 文件夹
 */
+(NSString *)pathForApplicationSupportDirectoryWithPath:(NSString *)path;

/**
 *  Caches文件夹
 *
 *  @return 文件夹
 */
+(NSString *)pathForCachesDirectory;

/**
 *  Caches文件夹
 *
 *  @param path 路径
 *
 *  @return 文件夹
 */
+(NSString *)pathForCachesDirectoryWithPath:(NSString *)path;

/**
 *  Documents文件夹
 *
 *  @return 文件夹
 */
+(NSString *)pathForDocumentsDirectory;

/**
 *  Documents文件夹
 *
 *  @param path 路径
 *
 *  @return 文件夹
 */
+(NSString *)pathForDocumentsDirectoryWithPath:(NSString *)path;

/**
 *  Library文件夹
 *
 *  @return 文件夹
 */
+(NSString *)pathForLibraryDirectory;

/**
 *  Library文件夹
 *
 *  @param path 路径
 *
 *  @return 文件夹
 */
+(NSString *)pathForLibraryDirectoryWithPath:(NSString *)path;

/**
 *  MainBundle文件夹
 *
 *  @return 文件夹
 */
+(NSString *)pathForMainBundleDirectory;

/**
 *  MainBundle文件夹
 *
 *  @param path 路径
 *
 *  @return 文件夹
 */
+(NSString *)pathForMainBundleDirectoryWithPath:(NSString *)path;

/**
 *  plist的路径
 *
 *  @param name plist name
 *
 *  @return 路径
 */
+(NSString *)pathForPlistNamed:(NSString *)name;

/**
 *  Temporary文件夹
 *
 *  @return 文件夹
 */

+(NSString *)pathForTemporaryDirectory;

/**
 *  Temporary文件夹
 *
 *  @param path 路径
 *
 *  @return 文件夹
 */
+(NSString *)pathForTemporaryDirectoryWithPath:(NSString *)path;

/**
 *  读取字符文件
 *
 *  @param path 路径
 *
 *  @return 文件
 */
+(NSString *)readFileAtPath:(NSString *)path;

/**
 *  读取字符文件
 *
 *  @param path  路径
 *  @param error 错误信息
 *
 *  @return 文件
 */
+(NSString *)readFileAtPath:(NSString *)path error:(NSError **)error;

/**
 *  读取数组文件
 *
 *  @param path 路径
 *
 *  @return 文件
 */
+(NSArray *)readFileAtPathAsArray:(NSString *)path;

/**
 *  读取model文件
 *
 *  @param path  路径
 *
 *  @return 文件
 */
+(NSObject *)readFileAtPathAsCustomModel:(NSString *)path;

/**
 *  读取data文件
 *
 *  @param path 路径
 *
 *  @return 文件
 */
+(NSData *)readFileAtPathAsData:(NSString *)path;

/**
 *  读取data文件
 *
 *  @param path 路径
 *
 *  @return 文件
 */
+(NSData *)readFileAtPathAsData:(NSString *)path error:(NSError **)error;

/**
 *  读取字典文件
 *
 *  @param path 路径
 *
 *  @return 文件
 */
+(NSDictionary *)readFileAtPathAsDictionary:(NSString *)path;

/**
 *  读取image文件
 *
 *  @param path 路径
 *
 *  @return 文件
 */
+(UIImage *)readFileAtPathAsImage:(NSString *)path;

/**
 *  读取image文件
 *
 *  @param path  路径
 *  @param error 错误信息
 *
 *  @return 文件
 */
+(UIImage *)readFileAtPathAsImage:(NSString *)path error:(NSError **)error;

/**
 *  读取imageView文件
 *
 *  @param path 路径
 *
 *  @return 文件
 */
+(UIImageView *)readFileAtPathAsImageView:(NSString *)path;

/**
 *  读取imageView文件
 *
 *  @param path  路径
 *  @param error 错误信息
 *
 *  @return 文件
 */
+(UIImageView *)readFileAtPathAsImageView:(NSString *)path error:(NSError **)error;

/**
 *  读取json文件
 *
 *  @param path 路径
 *
 *  @return 文件
 */

+(NSJSONSerialization *)readFileAtPathAsJSON:(NSString *)path;

/**
 *  读取json文件
 *
 *  @param path  路径
 *  @param error 错误信息
 *
 *  @return 文件
 */
+(NSJSONSerialization *)readFileAtPathAsJSON:(NSString *)path error:(NSError **)error;

/**
 *  读取动态数组文件
 *
 *  @param path 路径
 *
 *  @return 文件
 */
+(NSMutableArray *)readFileAtPathAsMutableArray:(NSString *)path;

/**
 *  读取动态data文件
 *
 *  @param path 路径
 *
 *  @return 文件
 */
+(NSMutableData *)readFileAtPathAsMutableData:(NSString *)path;

/**
 *  读取动态data文件
 *
 *  @param path  路径
 *  @param error 错误信息
 *
 *  @return 文件
 */
+(NSMutableData *)readFileAtPathAsMutableData:(NSString *)path error:(NSError **)error;

/**
 *  读取动态data文件
 *
 *  @param path 路径
 *
 *  @return 文件
 */
+(NSMutableDictionary *)readFileAtPathAsMutableDictionary:(NSString *)path;

/**
 *  读取文件
 *
 *  @param path 路径
 *
 *  @return 文件
 */
+(NSString *)readFileAtPathAsString:(NSString *)path;

/**
 *  读取文件
 *
 *  @param path  路径
 *  @param error 错误信息
 *
 *  @return 返回文件
 */
+(NSString *)readFileAtPathAsString:(NSString *)path error:(NSError **)error;

/**
 *  从文件夹删除文件
 *
 *  @param path 路径
 *
 *  @return 成功返回YES，否则返回NO
 */
+(BOOL)removeFilesInDirectoryAtPath:(NSString *)path;

/**
 *  从文件夹删除文件
 *
 *  @param path  路径
 *  @param error 错误信息
 *
 *  @return 成功返回YES，否则返回NO
 */
+(BOOL)removeFilesInDirectoryAtPath:(NSString *)path error:(NSError **)error;

/**
 *  删除文件夹里的指定文件
 *
 *  @param path      路径
 *  @param extension 指定的文件
 *
 *  @return 成功返回YES，否则返回NO
 */
+(BOOL)removeFilesInDirectoryAtPath:(NSString *)path withExtension:(NSString *)extension;

/**
 *  删除文件夹里的指定文件
 *
 *  @param path      路径
 *  @param extension 指定的文件
 *  @param error     错误信息
 *
 *  @return 成功返回YES，否则返回NO
 */
+(BOOL)removeFilesInDirectoryAtPath:(NSString *)path withExtension:(NSString *)extension error:(NSError **)error;

/**
 *  删除指定开头的文件
 *
 *  @param path   路径
 *  @param prefix 指定的开头
 *
 *  @return 成功返回YES，否则返回NO
 */
+(BOOL)removeFilesInDirectoryAtPath:(NSString *)path withPrefix:(NSString *)prefix;

/**
 *  删除指定开头的文件
 *
 *  @param path   路径
 *  @param prefix 指定的开头
 *  @param error  错误信息
 *
 *  @return 成功返回YES，否则返回NO
 */
+(BOOL)removeFilesInDirectoryAtPath:(NSString *)path withPrefix:(NSString *)prefix error:(NSError **)error;

/**
 *  删除指定结尾的文件
 *
 *  @param path   路径
 *  @param prefix 指定的结尾
 *
 *  @return 成功返回YES，否则返回NO
 */
+(BOOL)removeFilesInDirectoryAtPath:(NSString *)path withSuffix:(NSString *)suffix;

/**
 *  删除指定结尾的文件
 *
 *  @param path   路径
 *  @param prefix 指定的结尾
 *  @param error  错误信息
 *
 *  @return 成功返回YES，否则返回NO
 */
+(BOOL)removeFilesInDirectoryAtPath:(NSString *)path withSuffix:(NSString *)suffix error:(NSError **)error;

/**
 *  删除文件夹里的元素
 *
 *  @param path 路径
 *
 *  @return 成功返回YES，否则返回NO
 */
+(BOOL)removeItemsInDirectoryAtPath:(NSString *)path;

/**
 *  删除文件夹里的元素
 *
 *  @param path  路径
 *  @param error 错误信息
 *
 *  @return 成功返回YES，否则返回NO
 */
+(BOOL)removeItemsInDirectoryAtPath:(NSString *)path error:(NSError **)error;

/**
 *  删除路径下的文件
 *
 *  @param path 路径
 *
 *  @return 成功返回YES，否则返回NO
 */
+(BOOL)removeItemAtPath:(NSString *)path;

/**
 *  删除路径下的文件
 *
 *  @param path  路径
 *  @param error 错误信息
 *
 *  @return 成功返回YES，否则返回NO
 */
+(BOOL)removeItemAtPath:(NSString *)path error:(NSError **)error;

/**
 *  改变文件名字
 *
 *  @param path 路径
 *  @param name 文件名
 *
 *  @return 成功返回YES，否则返回NO
 */
+(BOOL)renameItemAtPath:(NSString *)path withName:(NSString *)name;

/**
 *  改变文件名字
 *
 *  @param path  路径
 *  @param name  文件名
 *  @param error 错误信息
 *
 *  @return 成功返回YES，否则返回NO
 */
+(BOOL)renameItemAtPath:(NSString *)path withName:(NSString *)name error:(NSError **)error;

/**
 *  转换文件大小
 *
 *  @param size 输入的size
 *
 *  @return 返回的size
 */
+(NSString *)sizeFormatted:(NSNumber *)size;

/**
 *  文件夹大小
 *
 *  @param path 路径
 *
 *  @return 文件夹大小
 */
+(NSString *)sizeFormattedOfDirectoryAtPath:(NSString *)path;

/**
 *  文件夹大小
 *
 *  @param path  路径
 *  @param error 错误信息
 *
 *  @return 文件夹大小
 */
+(NSString *)sizeFormattedOfDirectoryAtPath:(NSString *)path error:(NSError **)error;

/**
 *  文件大小
 *
 *  @param path 路径
 *
 *  @return 文件夹大小
 */
+(NSString *)sizeFormattedOfFileAtPath:(NSString *)path;

/**
 *  文件大小
 *
 *  @param path  路径
 *  @param error 错误信息
 *
 *  @return 文件夹大小
 */
+(NSString *)sizeFormattedOfFileAtPath:(NSString *)path error:(NSError **)error;

/**
 *  文件大小
 *
 *  @param path 路径
 *
 *  @return 文件夹大小
 */
+(NSString *)sizeFormattedOfItemAtPath:(NSString *)path;

/**
 *  文件大小
 *
 *  @param path  路径
 *  @param error 错误信息
 *
 *  @return 文件夹大小
 */
+(NSString *)sizeFormattedOfItemAtPath:(NSString *)path error:(NSError **)error;

/**
 *  文件夹大小
 *
 *  @param path 路径
 *
 *  @return 文件夹大小
 */
+(NSNumber *)sizeOfDirectoryAtPath:(NSString *)path;

/**
 *  文件夹大小
 *
 *  @param path  路径
 *  @param error 错误信息
 *
 *  @return 文件夹大小
 */
+(NSNumber *)sizeOfDirectoryAtPath:(NSString *)path error:(NSError **)error;

/**
 *  文件大小
 *
 *  @param path 路径
 *
 *  @return 文件夹大小
 */
+(NSNumber *)sizeOfFileAtPath:(NSString *)path;

/**
 *  文件大小
 *
 *  @param path  路径
 *  @param error 错误信息
 *
 *  @return 文件夹大小
 */
+(NSNumber *)sizeOfFileAtPath:(NSString *)path error:(NSError **)error;

/**
 *  文件大小
 *
 *  @param path 路径
 *
 *  @return 文件夹大小
 */
+(NSNumber *)sizeOfItemAtPath:(NSString *)path;

/**
 *  文件大小
 *
 *  @param path  路径
 *  @param error 错误信息
 *
 *  @return 文件夹大小
 */
+(NSNumber *)sizeOfItemAtPath:(NSString *)path error:(NSError **)error;

/**
 *  文件的URL
 *
 *  @param path 路径
 *
 *  @return URL
 */
+(NSURL *)urlForItemAtPath:(NSString *)path;

/**
 *  将内容写入到文件
 *
 *  @param path    路径
 *  @param content 内容
 *
 *  @return 成功返回YES，否则返回NO
 */
+(BOOL)writeFileAtPath:(NSString *)path content:(NSObject *)content;

/**
 *  将内容写入到文件
 *
 *  @param path    路径
 *  @param content 内容
 *  @param error   错误信息
 *
 *  @return 成功返回YES，否则返回NO
 */
+(BOOL)writeFileAtPath:(NSString *)path content:(NSObject *)content error:(NSError **)error;

/**
 *  获取原始数据的image
 *
 *  @param path 路径
 *
 *  @return 返回数据
 */
+(NSDictionary *)metadataOfImageAtPath:(NSString *)path;

/**
 *  可交换图像的image
 *
 *  @param path 路径
 *
 *  @return 返回数据
 */
+(NSDictionary *)exifDataOfImageAtPath:(NSString *)path;

/**
 *  tiff格式的image
 *
 *  @param path 路径
 *
 *  @return 返回数据
 */
+(NSDictionary *)tiffDataOfImageAtPath:(NSString *)path;

/**
 *  xattr文件
 *
 *  @param path 路径
 *
 *  @return 返回数据
 */
+(NSDictionary *)xattrOfItemAtPath:(NSString *)path;

/**
 *  xattr文件
 *
 *  @param path 路径
 *  @param key  键值
 *
 *  @return 返回数据
 */
+(NSString *)xattrOfItemAtPath:(NSString *)path getValueForKey:(NSString *)key;

/**
 *  修改存在文件的属性
 *
 *  @param path 路径
 *  @param key  键
 *
 *  @return 成功返回YES，否则返回NO
 */
+(BOOL)xattrOfItemAtPath:(NSString *)path hasValueForKey:(NSString *)key;

/**
 *  删除文件属性
 *
 *  @param path 路径
 *  @param key  key
 *
 *  @return 成功返回YES，否则返回NO
 */
+(BOOL)xattrOfItemAtPath:(NSString *)path removeValueForKey:(NSString *)key;

/**
 *  设置文件属性
 *
 *  @param path  路径
 *  @param value 属性
 *  @param key   key
 *
 *  @return 成功返回YES，否则返回NO
 */
+(BOOL)xattrOfItemAtPath:(NSString *)path setValue:(NSString *)value forKey:(NSString *)key;

@end
