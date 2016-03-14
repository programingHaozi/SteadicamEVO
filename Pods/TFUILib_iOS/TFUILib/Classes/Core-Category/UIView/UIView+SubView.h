//
//  UIView+SubView.h
//  TFBaseLib
//
//  Created by xiayiyong on 15/10/16.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SubView)

- (void)removeAllSubviews;

- (UIView *)subViewWithTag:(int)tag;

- (UILabel *)labelWithTag:(NSInteger)tag;
- (UIButton *)buttonWithTag:(NSInteger)tag;
- (UITextField *)textFieldWithTag:(NSInteger)tag;
- (UITextView *)textViewWithTag:(NSInteger)tag;
- (UIScrollView *)scrollViewWithTag:(NSInteger)tag;
- (UITableView *)tableViewWithTag:(NSInteger)tag;
- (UITableViewCell *)tableCellWithTag:(NSInteger)tag;
- (UIWindow *)windowWithTag:(NSInteger)tag;
- (UITabBar *)tabbarWithTag:(NSInteger)tag;
- (UITabBarItem *)tabbarItemWithTag:(NSInteger)tag;
- (UISwitch *)switchWithTag:(NSInteger)tag;
- (UIStepper *)stepperWithTag:(NSInteger)tag;
- (UISlider *)sliderWithTag:(NSInteger)tag;
- (UISegmentedControl *)segmentWithTag:(NSInteger)tag;
- (UITableViewHeaderFooterView *)tableHeaderFooterWithTag:(NSInteger)tag;
- (UIToolbar *)toolbarWithTag:(NSInteger)tag;
- (UIWebView *)webViewWithTag:(NSInteger)tag;
- (UICollectionViewCell *)collectionCellWithTag:(NSInteger)tag;
- (UICollectionView *)collectionViewWithTag:(NSInteger)tag;

@end
