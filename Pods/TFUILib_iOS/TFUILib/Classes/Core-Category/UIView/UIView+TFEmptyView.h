//
//  UIView+TFEmptyView.h
//  loading
//
//  Created by xiayiyong on 15/9/9.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TFEmptyView : UIView

@property(nonatomic, strong) UILabel *alertLabel;

- (id)initWithFrame:(CGRect)frame superView:(UIView *)superView alertText:(NSString *)alertMessage;
@end

@interface UIView (TFEmptyView)

@property(nonatomic, strong) TFEmptyView *emptyView;

-(void)showEmptyView;
-(void)hideEmptyView;

@end
