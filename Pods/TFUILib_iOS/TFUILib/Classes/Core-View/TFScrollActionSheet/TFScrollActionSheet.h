//
//  TFScrollActionSheet.h
//  TFScrollActionSheet
//
//  Created by weizhou on 12/27/14.
//  Copyright (c) 2014 xiayiyong. All rights reserved.
//  https://github.com/dopcn/DOPScrollableActionSheet
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class DOPAction;

@interface TFScrollActionSheet : UIView

/**
 *  初始化一个可现实多行的滚动的actionsheet
 *
 *  @param cancelButtonTitle 取消按钮文字
 *  @param actions
 *
 *  @return
 */
- (instancetype)initWithCancelButtonTitle:(NSString*)cancelButtonTitle actionArray:(NSArray *)actions;

/**
 *  显示试图
 */
- (void)show;

/**
 *  隐藏试图
 */
- (void)dismiss;

@end

#pragma mark - DOPAction interface
@interface DOPAction : NSObject

@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, copy) NSString *actionName;
@property (nonatomic, copy) void(^handler)(void);

- (instancetype)initWithName:(NSString *)name
                    iconName:(NSString *)iconName
                     handler:(void(^)(void))handler;

@end