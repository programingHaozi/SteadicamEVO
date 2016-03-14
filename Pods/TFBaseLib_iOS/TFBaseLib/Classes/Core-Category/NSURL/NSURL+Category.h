#import <Foundation/Foundation.h>

@interface NSURL (Category)

/**
 *  根据键获取URL的参数
 *
 *  @param key 键值
 *
 *  @return 返回的参数值
 */
-(NSString *)parameterForKey:(NSString *)key;

/**
 *  获取URL里的参数
 *
 *  @return 以字典的形式返回
 */
-(NSDictionary *)parameters;

@end
