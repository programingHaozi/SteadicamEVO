//
//  TFImageView.h
//  TFUILib
//
//  Created by xiayiyong on 16/1/12.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TFImageView : UIImageView

/**
 *  是否打开Tap手势
 */
@property (nonatomic, assign) BOOL enableTap;

/**
 *  是否打开Pinch手势
 */
@property (nonatomic, assign) BOOL enablePinch;

/**
 *  是否打开Pan手势
 */
@property (nonatomic, assign) BOOL enablePan;

/**
 *  是否打开双击手势
 */
@property (nonatomic, assign) BOOL enableDoubleTap;

/**
 *  默认图片
 */
@property (nonatomic, strong) UIImage *placeholderImage;

/**
 *  Tap事件
 *
 *  @param actionBlock Tap事件block
 */
- (void)tapAction:(void(^)())actionBlock;

/**
 *  Pinch事件
 *
 *  @param actionBlock Pinch事件block
 */
- (void)PinchAction:(void(^)())actionBlock;

/**
 *  Pan事件
 *
 *  @param actionBlock Pan事件block
 */
- (void)PanAction:(void(^)())actionBlock;

/**
 *  DoubleTap事件
 *
 *  @param actionBlock DoubleTap事件block
 */
- (void)DoubleTapAction:(void(^)())actionBlock;

@end
