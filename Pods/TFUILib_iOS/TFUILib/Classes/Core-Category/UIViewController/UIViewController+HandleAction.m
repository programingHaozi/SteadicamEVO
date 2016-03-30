//
//  UIViewController+HandleAction.m
//  TFUILib
//
//  Created by xiayiyong on 16/3/21.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import "UIViewController+HandleAction.h"
#import "UIViewController+Push.h"
#import "TFViewController.h"
#import "TFWebViewController.h"
#import "TFTableSectionModel.h"
#import "TFTableRowModel.h"
#import "TFActionModel.h"
#import "TFWebModel.h"

@implementation UIViewController (HandleAction)

-(void) handleData:(id)data
{
    if ([data isKindOfClass:[TFActionModel class]])
    {
        [self handleActionModel:data];
    }
    if ([data isKindOfClass:[TFWebModel class]])
    {
        [self handleWebModel:data];
    }
    else if ([data isKindOfClass:[TFTableRowModel class]])
    {
        TFTableRowModel *item=(TFTableRowModel *)data;
        
        Class viewModelClass = NSClassFromString(item.vc);
        if (viewModelClass!=nil)
        {
            [self pushViewController:[[viewModelClass alloc]init]];
            return;
        }
        
        SEL selector = NSSelectorFromString(item.method);
        if ([self respondsToSelector:selector])
        {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self performSelector:selector withObject:nil withObject:nil];
#pragma clang diagnostic pop
            return;
        }
        
    }
    else if ([data isKindOfClass:[TFModel class]])
    {

    }
}

-(BOOL) handleActionModel:(TFActionModel*)model
{
    if (model.h5.length > 0 || model.h5 != nil)
    {
        TFWebModel *webModel = [[TFWebModel alloc] init];
        webModel.url =[model.h5 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [self handleWebModel:webModel];
        
        return YES;
    }
    
    if (model.vc.length > 0 || model.vc != nil)
    {
        
        Class vcClass = NSClassFromString(model.vc);
        if (vcClass == nil)
        {
            NSCAssert(NO, ([NSString stringWithFormat:@"%@不存在",model.vc]));
            return NO;
        }
        
        id vc = [[vcClass alloc] init];
        
        [self pushViewController:vc];
        
        return YES;
    }
    
    if (model.method.length > 0 || model.method != nil)
    {
        SEL selector = NSSelectorFromString(model.method);
        if ([self respondsToSelector:selector])
        {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self performSelector:selector withObject:nil];
#pragma clang diagnostic pop
            return YES;
        }
        
        return NO;

    }
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
            NSDictionary *dict=[self parseString:parameter];
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
    
    [self pushViewController:vc];
    
    return YES;
}

-(void)handleWebModel:(TFWebModel*)model
{
    NSString *fielPath = [[NSBundle mainBundle] pathForResource:@"ActionConfig" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:fielPath];
    
    if (dict == nil)
    {
        
    }
    else
    {
        TFWebViewController *vc=[[TFWebViewController alloc]init];
        vc.model=model;
        [self pushViewController:vc];

    }
    
    NSString *webVC = dict[@"defaultWebViewController"];
    
    if (webVC.length>0 || webVC != nil)
    {
        Class vcClass = NSClassFromString(webVC);
        if (vcClass == nil)
        {
            NSCAssert(1, ([NSString stringWithFormat:@"%@不存在",webVC]));
        }
        else
        {
            TFWebViewController *vc=[[TFWebViewController alloc]init];
            vc.model=model;
            [self pushViewController:vc];

        }
        
        id vc = [[vcClass alloc] init];
        
        if (![vc isKindOfClass:[TFWebViewController class]])
        {
            TFWebViewController *vc=[[TFWebViewController alloc]init];
            vc.model=model;
            [self pushViewController:vc];
        }
        else
        {
            TFWebViewController *vc = [[vcClass alloc] init];
            vc.model = model;
            [self pushViewController:vc];
        }

    }
    else
    {
        TFWebViewController *vc=[[TFWebViewController alloc]init];
        vc.model=model;
        [self pushViewController:vc];
    }

}

- (NSDictionary *)parseString:(NSString *)str
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
