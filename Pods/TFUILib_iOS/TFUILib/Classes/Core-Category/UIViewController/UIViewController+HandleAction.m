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

@implementation UIViewController (HandleAction)

-(void) handleData:(id)data
{
    if ([data isKindOfClass:[TFTableRowModel class]])
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

        if (item.url)
        {
            if ([item.url hasPrefix:@"http"])
            {
                [self handleWebURL:item.url];
                return;
            }
        }

        if (item.webModel)
        {
            [self handleWebModel:item.webModel];
        }
    }
}

- (void)handleWebModel:(id)webModel
{
    NSString *fielPath = [[NSBundle mainBundle] pathForResource:@"ActionConfig" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:fielPath];

    if (dict == nil)
    {
        [self pusWebVCWithdata:webModel];

        return;
    }

    NSString *webVC = dict[@"defaultWebViewController"];

    if (webVC.length>0 || webVC != nil)
    {
        Class vcClass = NSClassFromString(webVC);

        id vc = [[vcClass alloc] init];

        if (!vc)
        {
            [self pusWebVCWithdata:webModel];

            return;
        }
        else
        {
            if ([vc isKindOfClass:[TFWebViewController class]])
            {
                ((TFWebViewController*)vc).model = webModel;
                [self pushViewController:vc];
            }
        }
    }
    else
    {
        
    }
}

-(void)handleWebURL:(NSString *)url
{
    NSString *fielPath = [[NSBundle mainBundle] pathForResource:@"ActionConfig" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:fielPath];
    
    if (dict == nil)
    {
        [self pusWebVCWithdata:url];

        return;
    }
    
    NSString *webVC = dict[@"defaultWebViewController"];
    
    if (webVC.length>0 || webVC != nil)
    {
        Class vcClass = NSClassFromString(webVC);

        id vc = [[vcClass alloc] init];
        
        if (!vc)
        {
            [self pusWebVCWithdata:url];

            return;
        }
        else
        {
            if ([vc isKindOfClass:[TFWebViewController class]])
            {
                ((TFWebViewController*)vc).urlRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
                [self pushViewController:vc];
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

- (void)pusWebVCWithdata:(id)data
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
