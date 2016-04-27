//
//  UIView+HandleAction.m
//  TFUILib
//
//  Created by xiayiyong on 16/4/22.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import "UIView+HandleAction.h"
#import "TFViewController.h"
#import "TFWebViewController.h"

@implementation UIView (HandleAction)

-(void) handleData:(TFTableRowModel*)data
{
    [self handleData:data completion:nil];
}

-(void) handleData:(TFTableRowModel*)data completion:(void (^)(TFTableRowModel*))completion
{
    if (data==nil)
    {
        return;
    }
    
    if (![data isKindOfClass:[TFTableRowModel class]])
    {
        return;
    }
    
    //按照vc处理
    if (data.vc!=nil)
    {
        Class vcClass = NSClassFromString(data.vc);
        if (vcClass!=nil)
        {
            [self pushViewController:[[vcClass alloc]init]];
        }
        else
        {
            NSCAssert(NO, ([NSString stringWithFormat:@"vc对应%@不存在",vcClass]));
        }
        return;
    }
    
    //按照method处理
    if (data.method!=nil)
    {
        SEL selector = NSSelectorFromString(data.method);
        if ([self respondsToSelector:selector])
        {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self performSelector:selector withObject:nil withObject:nil];
#pragma clang diagnostic pop
        }
        else
        {
            NSCAssert(NO, ([NSString stringWithFormat:@"method对应%@不存在",data.method]));
        }
        
        return;
    }
    
    //app处理
    //剩下的我处理不来了，交给方法的block处理吧
    if (completion)
    {
        completion(data);
        return;
    }
    
    //app都不愿意处理，还是我默认处理吧
    if (data.url)
    {
        [self pusWebVCWithData:data.url];
    }
    else if (data.webModel)
    {
        [self pusWebVCWithData:data.webModel];
    }
}

- (void)handleActionModel:(TFTableRowModel*)item
{
    NSString *action = item.action;
    if (action!=nil)
    {
        NSString *fielPath = [[NSBundle mainBundle] pathForResource:@"ActionConfig" ofType:@"plist"];
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:fielPath];
        
        if (dict==nil)
        {
            return;
        }
        
        NSString *vcClassName=[dict objectForKey:action];
        
        if (vcClassName==nil||vcClassName.length==0)
        {
            NSCAssert(NO, @"action对应value为空");
            return;
        }
        
        Class vcClass = NSClassFromString(vcClassName);
        if (vcClass==nil)
        {
            NSCAssert(NO, ([NSString stringWithFormat:@"%@不存在",vcClassName]));
            return;
        }
        
        id vc = [[vcClass alloc] init];
        
        if (![vc isKindOfClass:[TFViewController class]])
        {
            NSCAssert(NO, ([NSString stringWithFormat:@"%@不是TFViewController",vcClassName]));
            return;
        }
        
        id parameter= item.parameter;
        
        // 有parameter参数需要把parameter赋值给ViewModel
        if (parameter!=nil)
        {
            NSString *viewModelClassName= [vcClassName stringByReplacingOccurrencesOfString:@"ViewController" withString:@"ViewModel"];
            Class viewModelClass = NSClassFromString(viewModelClassName);
            if (viewModelClass==nil)
            {
                NSCAssert(NO, ([NSString stringWithFormat:@"%@不存在",viewModelClassName]));
                return;
            }
            
            TFViewController *tempViewController = (TFViewController *)vc;
            if ([parameter isKindOfClass:viewModelClass])
            {
                tempViewController.viewModel = [viewModelClass mj_objectWithKeyValues:dict];
            }
            else if ([parameter isKindOfClass:[NSString class]])
            {
                NSDictionary *dict=[[self class] parseString:parameter];
                if (dict==nil)
                {
                    NSCAssert(NO, ([NSString stringWithFormat:@"%@不和规范",parameter]));
                    return;
                }
                else
                {
                    tempViewController.viewModel = [viewModelClass mj_objectWithKeyValues:dict];
                }
            }
            else
            {
                NSCAssert(NO, ([NSString stringWithFormat:@"parameter不符合参数类型"]));
                return;
            }
        }
        
        [self pushViewController:vc];
        return;
    }
}

- (void)pusWebVCWithData:(id)data
{
    TFWebViewController *vc=[[TFWebViewController alloc]init];
    if ([data isKindOfClass:[NSString class]])
    {
        vc.urlRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:data]];
    }
    else
    {
        vc.model = data;
    }
    
    [self pushViewController:vc];
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
