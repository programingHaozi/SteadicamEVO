//
//  TFImageCropView.h
//  TFUILib
//
//  Created by xiayiyong on 16/4/21.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFView.h"

typedef void (^TFImageCropViewBlock)(UIImage*image,UIImage *croppedImage);

@interface TFImageCropView : TFView

/**
 *  要处理的image
 */
@property (nonatomic, retain) UIImage *image;

/**
 *  处理后的image
 */
@property (nonatomic, retain) UIImage *croppedImage;

/**
 *  初始化
 *
 *  @param frame frame
 *  @param image image
 *
 *  @return
 */
- (id)initWithFrame:(CGRect)frame andImage:(UIImage*)image;

/**
 *  裁剪
 */
- (void)crop;

/**
 *  裁剪
 */
- (void)cropWithBlock:(TFImageCropViewBlock)block;

/**
 *  还原
 */
- (void)reset;

@end
