//
//  UIView+SubView.m
//  TFBaseLib
//
//  Created by xiayiyong on 15/10/16.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import "UIView+SubView.h"

@implementation UIView (SubView)

- (void)removeAllSubviews {
    for (UIView *view in self.subviews)
    {
        [view removeFromSuperview];
    }
}

- (UIView *)subViewWithTag:(int)tag
{
    for (UIView *v in self.subviews)
    {
        if (v.tag == tag)
        {
            return v;
        }
    }
    return nil;
}

- (UILabel *)labelWithTag:(NSInteger)tag
{
    UIView *view = [self viewWithTag:tag];
    if ([view isKindOfClass:[UILabel class]])
    {
        return (UILabel *)view;
    }
    
    return nil;
}

- (UIButton *)buttonWithTag:(NSInteger)tag
{
    UIView *view = [self viewWithTag:tag];
    if ([view isKindOfClass:[UIButton class]])
    {
        return (UIButton *)view;
    }
    
    return nil;
}

- (UITextField *)textFieldWithTag:(NSInteger)tag
{
    UIView *view = [self viewWithTag:tag];
    if ([view isKindOfClass:[UITextField class]])
    {
        return (UITextField *)view;
    }
    
    return nil;
}

- (UITextView *)textViewWithTag:(NSInteger)tag
{
    UIView *view = [self viewWithTag:tag];
    if ([view isKindOfClass:[UITextView class]])
    {
        return (UITextView *)view;
    }
    
    return nil;
}

- (UIScrollView *)scrollViewWithTag:(NSInteger)tag
{
    UIView *view = [self viewWithTag:tag];
    if ([view isKindOfClass:[UIScrollView class]])
    {
        return (UIScrollView *)view;
    }
    
    return nil;
}

- (UITableView *)tableViewWithTag:(NSInteger)tag
{
    UIView *view = [self viewWithTag:tag];
    if ([view isKindOfClass:[UITableView class]])
    {
        return (UITableView *)view;
    }
    
    return nil;
}

- (UITableViewCell *)tableCellWithTag:(NSInteger)tag
{
    UIView *view = [self viewWithTag:tag];
    if ([view isKindOfClass:[UITableViewCell class]])
    {
        return (UITableViewCell *)view;
    }
    
    return nil;
}

- (UIWindow *)windowWithTag:(NSInteger)tag
{
    UIView *view = [self viewWithTag:tag];
    if ([view isKindOfClass:[UIWindow class]])
    {
        return (UIWindow *)view;
    }
    
    return nil;
}

- (UITabBar *)tabbarWithTag:(NSInteger)tag
{
    UIView *view = [self viewWithTag:tag];
    if ([view isKindOfClass:[UITabBar class]])
    {
        return (UITabBar *)view;
    }
    
    return nil;
}

- (UITabBarItem *)tabbarItemWithTag:(NSInteger)tag
{
    UIView *view = [self viewWithTag:tag];
    if ([view isKindOfClass:[UITabBarItem class]])
    {
        return (UITabBarItem *)view;
    }
    
    return nil;
}

- (UISwitch *)switchWithTag:(NSInteger)tag
{
    UIView *view = [self viewWithTag:tag];
    if ([view isKindOfClass:[UISwitch class]])
    {
        return (UISwitch *)view;
    }
    
    return nil;
}

- (UIStepper *)stepperWithTag:(NSInteger)tag
{
    UIView *view = [self viewWithTag:tag];
    if ([view isKindOfClass:[UIStepper class]])
    {
        return (UIStepper *)view;
    }
    
    return nil;
}

- (UISlider *)sliderWithTag:(NSInteger)tag
{
    UIView *view = [self viewWithTag:tag];
    if ([view isKindOfClass:[UISlider class]])
    {
        return (UISlider *)view;
    }
    
    return nil;
}

- (UISegmentedControl *)segmentWithTag:(NSInteger)tag
{
    UIView *view = [self viewWithTag:tag];
    if ([view isKindOfClass:[UISegmentedControl class]])
    {
        return (UISegmentedControl *)view;
    }
    
    return nil;
}

- (UITableViewHeaderFooterView *)tableHeaderFooterWithTag:(NSInteger)tag
{
    UIView *view = [self viewWithTag:tag];
    if ([view isKindOfClass:[UITableViewHeaderFooterView class]])
    {
        return (UITableViewHeaderFooterView *)view;
    }
    
    return nil;
}

- (UIToolbar *)toolbarWithTag:(NSInteger)tag
{
    UIView *view = [self viewWithTag:tag];
    if ([view isKindOfClass:[UIToolbar class]])
    {
        return (UIToolbar *)view;
    }
    
    return nil;
}

- (UIWebView *)webViewWithTag:(NSInteger)tag
{
    UIView *view = [self viewWithTag:tag];
    if ([view isKindOfClass:[UIWebView class]])
    {
        return (UIWebView *)view;
    }
    
    return nil;
}

- (UICollectionView *)collectionViewWithTag:(NSInteger)tag
{
    UIView *view = [self viewWithTag:tag];
    if ([view isKindOfClass:[UICollectionView class]])
    {
        return (UICollectionView *)view;
    }
    
    return nil;
}

- (UICollectionViewCell *)collectionCellWithTag:(NSInteger)tag
{
    UIView *view = [self viewWithTag:tag];
    if ([view isKindOfClass:[UICollectionViewCell class]])
    {
        return (UICollectionViewCell *)view;
    }
    
    return nil;
}


@end
