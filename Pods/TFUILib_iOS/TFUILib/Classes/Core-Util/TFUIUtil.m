//
//  MasonyUtil.m
//  Treasure
//
//  Created by xiayiyong on 15/8/5.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//
//

#define MODLUE_VIEW_CONTROLLER_TAG  888

#import "TFUIUtil.h"
#import "TFNavigationController.h"
#import "TFViewController.h"

#pragma mark - push

void tf_handleData(id data)
{
    [TFUIUtil handleData:data];
}

#pragma mark - push

void tf_pushViewController(UIViewController *vc)
{
    [TFUIUtil pushViewController:vc];
}

void tf_pushViewControllerFromViewController(UIViewController *vc,UIViewController *fromVC)
{
    [TFUIUtil pushViewController:vc from:fromVC];
}

void tf_pushActionViewController(TFActionModel *vc)
{
    [TFUIUtil pushActionViewController:vc];
}

void tf_pushActionViewControllerFromViewController(TFActionModel *vc,UIViewController *fromVC)
{
    [TFUIUtil pushActionViewController:vc from:fromVC];
}

#pragma mark - pop
void tf_popToViewController(UIViewController *vc)
{
    [TFUIUtil popToViewController:vc];
}

void tf_popToViewControllerWithClassName(NSString *className)
{
    [TFUIUtil popToViewControllerWithClassName:className];
}

void tf_popViewController()
{
    [TFUIUtil popViewController];
}

void tf_popToRootViewController()
{
    [TFUIUtil popToRootViewController];
}

#pragma mark - present dismiss

void tf_presentViewController(UIViewController *vc)
{
    [TFUIUtil presentViewController:vc];
}

void tf_dismissViewController(UIViewController *vc)
{
    [TFUIUtil dismissViewController:vc];
}

void tf_popModuleViewController()
{
    [TFUIUtil popModuleViewController];
}

void tf_back()
{
    [TFUIUtil back];
}

UIViewController *tf_getRootViewController()
{
    return [TFUIUtil getRootViewController];
}

@implementation TFUIUtil

+(void) handleData:(id)data
{
    if ([data isKindOfClass:[TFActionModel class]])
    {
        
    }
    else if ([data isKindOfClass:[TFModel class]])
    {
        
    }
}

/*
 push pop
 */
+(void) pushViewController:(UIViewController *)vc
{
    UIViewController *rootVC=[TFUIUtil getRootViewController];
    
    if (![rootVC isKindOfClass:[UINavigationController class]])
    {
        return;
    }
    
    UINavigationController *rootNav= (UINavigationController *)rootVC;
    
    NSString *fielPath = [[NSBundle mainBundle] pathForResource:@"ModuleConfig" ofType:@"plist"];
    NSArray *arr = [NSArray arrayWithContentsOfFile:fielPath];
    
    //1 模块跳转方式
    if (arr!=nil && [arr containsObject:NSStringFromClass([vc class])])
    {
        vc.view.tag=MODLUE_VIEW_CONTROLLER_TAG;
        [rootNav pushViewController:vc animated:YES];
    }
    //2 普通跳转方式
    else
    {
        vc.view.tag=0;
        [rootNav pushViewController:vc animated:YES];
    }
}

+(void) pushViewController:(UIViewController *)vc from:(UIViewController *)fromVC
{
    if ([fromVC isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *fromVCNav= (UINavigationController *)fromVC;
        [fromVCNav pushViewController:vc animated:YES];
    }
    else if (fromVC.navigationController!=nil && [fromVC.navigationController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *fromVCNav= (UINavigationController *)fromVC.navigationController;
        [fromVCNav pushViewController:vc animated:YES];
    }
    else
    {
        [TFUIUtil pushViewController:vc];
    }
}

+(BOOL)pushActionViewController:(TFActionModel*)model
{
    return [TFUIUtil pushActionViewController:model from:nil];
}

+(BOOL) pushActionViewController:(TFActionModel*)model from:(UIViewController *)fromVC
{
    NSString *fielPath = [[NSBundle mainBundle] pathForResource:@"ActionConfig" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:fielPath];
    
    if (dict == nil)
    {
        return NO;
    }
    
    NSString *action = model.action;
    NSString *vcClassName=[dict objectForKey:action];
    
    if (vcClassName == nil)
    {
        return NO;
    }
    
    if (vcClassName.length==0)
    {
        NSCAssert(NO, @"action对应value为空");
        return NO;
    }
    
    Class vcClass = NSClassFromString(vcClassName);
    if (vcClass == nil)
    {
        NSCAssert(NO, ([NSString stringWithFormat:@"%@不存在",vcClassName]));
        return NO;
    }
    
    id vc = [[vcClass alloc] init];
    
    if (![vc isKindOfClass:[TFViewController class]])
    {
        NSCAssert(NO, ([NSString stringWithFormat:@"%@不是TFViewController",vcClassName]));
        
        return NO;
    }
    
    id parameter = model.parameter;
    
    // 有parameter参数需要把parameter赋值给ViewModel
    if (parameter != nil)
    {
        NSString *viewModelClassName= [vcClassName stringByReplacingOccurrencesOfString:@"ViewController" withString:@"ViewModel"];
        Class viewModelClass = NSClassFromString(viewModelClassName);
        
        if (viewModelClass == nil)
        {
            NSCAssert(NO, ([NSString stringWithFormat:@"%@不存在",viewModelClassName]));
            return NO;
        }
        
        TFViewController *tempViewController = (TFViewController *)vc;
        if ([parameter isKindOfClass:viewModelClass])
        {
            tempViewController.viewModel = [viewModelClass mj_objectWithKeyValues:dict];
        }
        else if ([parameter isKindOfClass:[NSString class]])
        {
            NSDictionary *dict=[[self class] parseString:parameter];
            if (dict == nil)
            {
                NSCAssert(NO, ([NSString stringWithFormat:@"%@不和规范",parameter]));
                
                return NO;
            }
            else
            {
                tempViewController.viewModel = [viewModelClass mj_objectWithKeyValues:dict];
            }
        }
        else
        {
            NSCAssert(NO, ([NSString stringWithFormat:@"parameter不符合参数类型"]));
            
            return NO;
        }
    }
    
    [TFUIUtil pushViewController:vc from:fromVC];
    
    return YES;
}

+(void) popToViewController:(UIViewController *)vc
{
    if (vc == nil)
    {
        return;
    }
    
    [[self class]popToViewControllerWithClassName:NSStringFromClass([vc class])];
}

+(void) popToViewControllerWithClassName:(NSString *)className
{
    if (className == nil || className.length == 0)
    {
        return;
    }
    
    UIViewController *rootVC = [TFUIUtil getRootViewController];
    
    if (![rootVC isKindOfClass:[UINavigationController class]])
    {
        return;
    }
    
    UINavigationController *rootNav= (UINavigationController *)rootVC;
    NSMutableArray *vcs = [NSMutableArray arrayWithArray:rootNav.viewControllers];
    
    for (NSInteger i=vcs.count-1; i<vcs.count; i--)
    {
        UIViewController *vc = vcs[i];
        if ([vc isKindOfClass:NSClassFromString(className)])
        {
            [rootNav popToViewController:vc animated:YES];
            
            return;
        }
    }
}

+ (void)popViewController
{
    UIViewController *rootVC=[TFUIUtil getRootViewController];
    if (![rootVC isKindOfClass:[UINavigationController class]])
    {
        return;
    }
    
    UINavigationController *rootNav= (UINavigationController *)rootVC;
    [rootNav popViewControllerAnimated:YES];
}

+ (void)popToRootViewController
{
    UIViewController *rootVC=[TFUIUtil getRootViewController];
    if (![rootVC isKindOfClass:[UINavigationController class]])
    {
        return;
    }
    
    UINavigationController *rootNav= (UINavigationController *)rootVC;
    [rootNav popToRootViewControllerAnimated:YES];
}

+ (void)popModuleViewController
{
    UIViewController *rootVC=[TFUIUtil getRootViewController];
    if (![rootVC isKindOfClass:[UINavigationController class]])
    {
        return;
    }
    
    UINavigationController *rootNav= (UINavigationController *)rootVC;
    NSMutableArray *vcs = [NSMutableArray arrayWithArray:rootNav.viewControllers];
    for (NSInteger i=vcs.count-1; i>=0; i--)
    {
        UIViewController *vc = (UIViewController *)vcs[i];
        if (vc.view.tag == MODLUE_VIEW_CONTROLLER_TAG)
        {
            if (i>0)
            {
                [rootNav popToViewController:vcs[i-1] animated:YES];
            }
            
            return;
        }
    }
}

/*
 present dismiss
 */
+ (void)presentViewController:(UIViewController *)vc
{
    UIViewController *rootVC=[TFUIUtil getRootViewController];
    TFNavigationController *nav=[[TFNavigationController alloc]initWithRootViewController:vc];
    [rootVC presentViewController:nav animated:YES completion:^{
        
    }];
}

+ (void)dismissViewController:(UIViewController *)vc
{
    [vc dismissViewControllerAnimated:YES completion:^{
        
    }];
}

+ (void)back
{
    UIViewController *rootVC=[TFUIUtil getRootViewController];
    if ([rootVC isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *rootNav= (UINavigationController *)rootVC;
        [rootNav popViewControllerAnimated:YES];
    }
}

+ (UIViewController *)getRootViewController
{
    UIViewController *rootVC=[[UIApplication sharedApplication].delegate window].rootViewController;
    
    return rootVC;
}

+ (NSDictionary *)parseString:(NSString *)str
{
    NSMutableDictionary *datas = [[NSMutableDictionary alloc]init];
    if (str && str.length > 0)
    {
        //获取所有的键值组合
        NSArray *allKeyAndValues = [str componentsSeparatedByString:@","];
        if (allKeyAndValues && [allKeyAndValues count] > 0)
        {
            for (NSString *keyAndValue in allKeyAndValues)
            {
                //分离键值，存入字典
                NSArray *keyValue = [keyAndValue componentsSeparatedByString:@":"];
                if ([keyValue count] == 2)
                {
                    [datas setObject:[keyValue objectAtIndex:1] forKey:[keyValue objectAtIndex:0]];
                }
                else
                {
                    
                }
            }
        }
        else
        {
            
        }
    }
    
    return datas;
}

@end
