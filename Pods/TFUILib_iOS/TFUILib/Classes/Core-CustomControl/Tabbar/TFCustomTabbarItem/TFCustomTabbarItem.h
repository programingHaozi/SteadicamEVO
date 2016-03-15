//
//  TFCustomTabbarItem.h
//  TFUILib
//
//  Created by Chen Hao 陈浩 on 16/3/9.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFView.h"

/**
 *  TFCustomTabbarItem
 */
@interface TFCustomTabbarItem : TFView

/**
 *  点击回调
 */
typedef void(^TouchActionBlock)(TFCustomTabbarItem *);

/**
 *  是否被选择(单独更改无法切换Controller)
 */
@property (nonatomic, assign) BOOL selected;

/**
 *  正常背景色
 */
@property (nonatomic, strong) UIColor *normalBackgroundColor;

/**
 *  选中背景色
 */
@property (nonatomic, strong) UIColor *selectBackgroundColor;

/**
 *  正常背景图片
 */
@property (nonatomic, strong) UIImage *normalBackgroundImage;

/**
 *  选中背景图片
 */
@property (nonatomic, strong) UIImage *selectBackgroundImage;

/**
 *  标记值
 */
@property (nonatomic, strong) NSString *badgeValue;

/**
 *  标记背景色
 */
@property (nonatomic, strong) UIColor * badgeBackgroundColor;

/**
 *  标记文本色
 */
@property (nonatomic, strong) UIColor * badgeStringColor;

/**
 *  标题
 */
@property (nonatomic, strong) NSString *title;

/**
 *  标题正常色
 */
@property (nonatomic, strong) UIColor * titleNormalColor;

/**
 *  标题选择色
 */
@property (nonatomic, strong) UIColor * titleSelectColor;

/**
 *  正常图片
 */
@property (nonatomic, strong) UIImage *normalImage;

/**
 *  选择图片
 */
@property (nonatomic, strong) UIImage *selectImage;

/**
 *  点击回调(请勿自行赋值)
 */
@property (nonatomic, strong) TouchActionBlock touchActionBlock;

/**
 *  初始化TFCustomTabbarItem
 *
 *  @param title         标题
 *  @param normalImage   正常图片
 *  @param selectedImage 选中图片
 *
 *  @return TFCustomTabbarItem
 */
- (instancetype)initWithTitle:(NSString *)title
                  normalImage:(UIImage *)normalImage
                selectedImage:(UIImage *)selectedImage;

@end
