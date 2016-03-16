//
//  LBBasePlugin.m
//  LightBundle
//
//  Created by Hu Dan 胡丹 on 15/11/3.
//  Copyright © 2015年 Ren Wenchao 任文超. All rights reserved.
//

#import "LBBasePlugin.h"
#import <objc/runtime.h>

@interface LBBasePlugin()

// callbakid
@property (nonatomic,retain) NSString *callbackId;

@end

@implementation LBBasePlugin

/**
 *  初始化
 *
 *  @param callBackId
 *
 *  @return
 */
- (instancetype)initWithCallBackId:(NSString*)callBackId param:(NSDictionary *)paramers
{
    self = [super init];
    if (self)
    {
        self.callbackId = callBackId;
        self.paramers = paramers;
        self.statusBarStyle = [[UIApplication sharedApplication] statusBarStyle];
        self.navBgColor = [UINavigationBar appearance].barTintColor;
        self.windowTintColor = [[[UIApplication sharedApplication] delegate] window].tintColor;
        self.navigationBarBgImage = [[UINavigationBar appearance] backgroundImageForBarMetrics:UIBarMetricsDefault];
        self.navigationBarShadowImage = [[UINavigationBar appearance] shadowImage];
    }
    return self;
}

/**
 *  调用native功能
 */
- (void)jsCallFunction
{
 
}

/**
 *  返回js-sdk数据
 *
 *  @param text      返回内容 (类型为NSString、NSDictionary或对象)
 *  @param errorCode 错误码
 *  @param msg       消息
 *
 *  @return          调用js的返回值
 */
- (void)callbackJsSdk:(id)text errorCode:(LBErrorCode)errorCode msg:(NSString *)msg
{
    LBLog(@"ocCalljs:%@", LB_FUNC_CALLBACK([self getJsonText:text errorCode:errorCode msg:msg]));
    [self.lb evaluateJavaScript:LB_FUNC_CALLBACK([self getJsonText:text errorCode:errorCode msg:msg]) completionHandler:^(id ret, NSError *error) {
        
    }];
}

/**
 *  取消插件展示
 */
- (void)stopShowing
{
    
}

/**
 *  提示vc未设置
 */
- (void)alertNoVc
{
    [self showAlert:@"未实现代理方法：LBGetVc"];
}

/**
 *  show alert
 *
 *  @param text text
 */
- (void)showAlert:(NSString *)text
{
    [[[UIAlertView alloc] initWithTitle:nil
                                message:text
                               delegate:self
                      cancelButtonTitle:@"好的"
                      otherButtonTitles:nil, nil] show];
}

/**
 *  UIColor转UIImage
 *
 *  @param color color
 *
 *  @return image
 */
- (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

/**
 *  获得返回json字符串
 *
 *  @param text      (类型为NSString、NSDictionary或对象)
 *  @param errorCode error code
 *  @param msg       msg
 *
 *  @return json字符串
 */
- (NSString *)getJsonText:(id) text errorCode:(LBErrorCode)errorCode msg:(NSString *)msg
{
    NSMutableDictionary *dicResult = [NSMutableDictionary new];
    if ([text isKindOfClass:[NSString class]])
    {
        [dicResult setValue:text forKey:LB_RET_TEXT];
    }
    else if ([text isKindOfClass:[NSDictionary class]] ||
             [text isKindOfClass:[NSMutableDictionary class]])
    {
        [dicResult setValue:text forKey:LB_RET_TEXT];
    }
    else
    {
        [dicResult setValue:[self getObjectData:text] forKey:LB_RET_TEXT];
    }
    [dicResult setValue:[NSString stringWithFormat:@"%d", errorCode] forKey:LB_RET_ERROR_CODE];
    [dicResult setValue:msg forKey:LB_RET_MSG];
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:_callbackId forKey:LB_RET_callbackId];
    [dic setValue:dicResult forKey:LB_RET_RESULT];
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

/**
 *  对象转dic
 *
 *  @param obj
 *
 *  @return
 */
- (NSDictionary *)getObjectData:(id)obj
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int propsCount;
    objc_property_t *props = class_copyPropertyList([obj class], &propsCount);//获得属性列表
    for(int i = 0;i < propsCount; i++)
    {
        objc_property_t prop = props[i];
        
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];//获得属性的名称
        id value = [obj valueForKey:propName];//kvc读值
        if (value == nil)
        {
            value = [NSNull null];
        }
        else
        {
            value = [self getObjectInternal:value];//自定义处理数组，字典，其他类
        }
        [dic setObject:value forKey:propName];
    }
    return dic;
}

- (id)getObjectInternal:(id)obj
{
    if ([obj isKindOfClass:[NSString class]]
        || [obj isKindOfClass:[NSNumber class]]
        || [obj isKindOfClass:[NSNull class]])
    {
        return obj;
    }
    
    if ([obj isKindOfClass:[NSArray class]])
    {
        NSArray *objarr = obj;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        for(int i = 0;i < objarr.count; i++)
        {
            [arr setObject:[self getObjectInternal:[objarr objectAtIndex:i]] atIndexedSubscript:i];
        }
        return arr;
    }
    
    if ([obj isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *objdic = obj;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        for(NSString *key in objdic.allKeys)
        {
            [dic setObject:[self getObjectInternal:[objdic objectForKey:key]] forKey:key];
        }
        return dic;
    }
    return [self getObjectData:obj];
}

@end
