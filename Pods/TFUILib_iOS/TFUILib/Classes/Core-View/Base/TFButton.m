//
//  TFButton.m
//  TFUILib
//
//  Created by xiayiyong on 16/1/12.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFButton.h"
#import "UIView+Category.h"

#define BORDERWIDTH (1.0) // 边框宽度

#define HEXCOLORINBUTTON(c,a)  [UIColor colorWithRed:((c>>16)&0xFF)/255.0 \
green:((c>>8)&0xFF)/255.0 \
blue:(c&0xFF)/255.0 \
alpha:a]

#define kImageWithName(Name) ([UIImage imageNamed:Name])

#define kBigImageWithName(Name) ([UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:Name ofType:nil]])

//    获得按钮的大小
#define fl_btnWidth self.bounds.size.width
#define fl_btnHeight self.bounds.size.height

//    获得按钮中UILabel文本的大小
#define fl_labelWidth self.titleLabel.bounds.size.width
#define fl_labelHeight self.titleLabel.bounds.size.height

//    获得按钮中image图标的大小
#define fl_imageWidth self.imageView.bounds.size.width
#define fl_imageHeight self.imageView.bounds.size.height

@interface TFButton()

/**
 *  点击事件
 */
@property (nonatomic, copy)void(^actionBlock)();

@end

@implementation TFButton

#pragma mark - functions

- (instancetype)initWithAlignmentStatus:(TFAlignmentStatus)status
{
    self.gapBetween=10;
    TFButton *fl_button = [[TFButton alloc] init];
    
    fl_button.status = status;
    return fl_button;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self addTarget:self action:@selector(touch:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}
-(void)setGapBetween:(CGFloat)gapBetween
{
    _gapBetween=gapBetween;
}

- (void)setStatus:(TFAlignmentStatus)status
{
    _status = status;
}

#pragma mark - 左对齐
- (void)alignmentLeft
{
    //    获得按钮的文本的frame
    CGRect titleFrame = self.titleLabel.frame;
    //    设置按钮的文本的x坐标为0-－－左对齐
    titleFrame.origin.x = 0;
    //    获得按钮的图片的frame
    CGRect imageFrame = self.imageView.frame;
    //    设置按钮的图片的x坐标紧跟文本的后面
    imageFrame.origin.x = CGRectGetWidth(titleFrame)+self.gapBetween;
    //    重写赋值frame
    self.titleLabel.frame = titleFrame;
    self.imageView.frame = imageFrame;
}

#pragma mark - 右对齐
- (void)alignmentRight
{
    // 计算文本的的宽度
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    dictM[NSFontAttributeName] = self.titleLabel.font;
    CGRect frame = [self.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dictM context:nil];
    
    CGRect imageFrame = self.imageView.frame;
    imageFrame.origin.x = self.bounds.size.width - fl_imageWidth;
    CGRect titleFrame = self.titleLabel.frame;
    titleFrame.origin.x = imageFrame.origin.x - frame.size.width-self.gapBetween;
    //    重写赋值frame
    self.titleLabel.frame = titleFrame;
    self.imageView.frame = imageFrame;
}

#pragma mark - 居中对齐
- (void)alignmentCenter
{
    //    设置文本的坐标
    CGFloat labelX = (fl_btnWidth - fl_labelWidth -fl_imageWidth - self.gapBetween) * 0.5;
    CGFloat labelY = (fl_btnHeight - fl_labelHeight) * 0.5;
    
    //    设置label的frame
    self.titleLabel.frame = CGRectMake(labelX, labelY, fl_labelWidth, fl_labelHeight);
    
    //    设置图片的坐标
    CGFloat imageX = CGRectGetMaxX(self.titleLabel.frame) + self.gapBetween;
    CGFloat imageY = (fl_btnHeight - fl_imageHeight) * 0.5;
    //    设置图片的frame
    self.imageView.frame = CGRectMake(imageX, imageY, fl_imageWidth, fl_imageHeight);
}

#pragma mark - 图标在上，文本在下(居中)
- (void)alignmentTop
{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    // 计算文本的的宽度
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    dictM[NSFontAttributeName] = self.titleLabel.font;
    //CGRect frame = [self.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dictM context:nil];
    
    self.imageView.frame = CGRectMake((fl_btnWidth - fl_imageWidth) * 0.5, (fl_btnHeight-fl_labelHeight-fl_imageHeight-self.gapBetween)*0.5, fl_imageWidth, fl_imageHeight);
    self.titleLabel.frame = CGRectMake(0, (fl_btnHeight-fl_labelHeight-fl_imageHeight-self.gapBetween)*0.5+fl_imageHeight+self.gapBetween, fl_btnWidth, fl_labelHeight);
}

#pragma mark - 图标在下，文本在上(居中)
- (void)alignmentBottom
{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    // 计算文本的的宽度
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    dictM[NSFontAttributeName] = self.titleLabel.font;
    // CGRect frame = [self.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dictM context:nil];
    
    self.titleLabel.frame = CGRectMake(0, (fl_btnHeight-fl_labelHeight-fl_imageHeight-self.gapBetween)*0.5, fl_btnWidth, fl_labelHeight);
    self.imageView.frame = CGRectMake((fl_btnWidth - fl_imageWidth) * 0.5, (fl_btnHeight-fl_labelHeight-fl_imageHeight-self.gapBetween)*0.5+fl_labelHeight+self.gapBetween, fl_imageWidth, fl_imageHeight);
}

/**
 *  布局子控件
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    // 判断
    if (_status == TFAlignmentStatusNormal)
    {
        
    }
    else if (_status == TFAlignmentStatusLeft)
    {
        [self alignmentLeft];
    }
    else if (_status == TFAlignmentStatusCenter)
    {
        [self alignmentCenter];
    }
    else if (_status == TFAlignmentStatusRight)
    {
        [self alignmentRight];
    }
    else if (_status == TFAlignmentStatusTop)
    {
        [self alignmentTop];
    }
    else if (_status == TFAlignmentStatusBottom)
    {
        [self alignmentBottom];
    }
}

#pragma mark - 多边形按钮支持

// 绘制按钮时添加path遮罩
- (void)drawRect:(CGRect)rect
{
    //    [super drawRect:rect];
    
    if (self.path)
    {
        CAShapeLayer *shapLayer = [CAShapeLayer layer];
        shapLayer.path = self.path.CGPath;
        self.layer.mask = shapLayer;
    }
}

//覆盖方法，点击时判断点是否在path内，YES则响应，NO则不响应
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (self.path)
    {
        BOOL res = [super pointInside:point withEvent:event];
        if (res)
        {
            if ([self.path containsPoint:point])
            {
                return YES;
            }
            return NO;
        }
        return NO;
    }
    else
    {
        return YES;
    }
    
}

#pragma mark - touch

- (void)touchAction:(void (^)())actionBlock
{
    _actionBlock = actionBlock;
}

- (void)touch:(id)sender
{
    if (_actionBlock)
    {
        _actionBlock();
    }
}

#pragma mark - 设置按钮按钮全部状态背景

- (void)setNormalImage:(id)normalImage
     hightlightedImage:(id)hightlightedImage
         disabledImage:(id)disabledImage
{
    [self setNormalImage:normalImage];
    [self setHightlightedImage:hightlightedImage];
    [self setDisabledImage:disabledImage];
}

#pragma mark - 设置按钮按钮全部状态背景
- (void)setNormalBackgroundImage:(id)normalImage
     hightlightedBackgroundImage:(id)hightlightedImage
         disabledBackgroundImage:(id)disabledImage
{
    [self setNormalBackgroundImage:normalImage];
    [self setHightlightedBackgroundImage:hightlightedImage];
    [self setDisabledBackgroundImage:disabledImage];
}

#pragma mark - 设置按钮正常状态下的图片

- (void)setNormalImage:(id)image
{
    if ([image isKindOfClass:[UIImage class]])
    {
        [self setImage:image forState:UIControlStateNormal];
    }
    else if ([image isKindOfClass:[UIColor class]])
    {
        [self setImage:[self imageWithColor:image] forState:UIControlStateNormal];
    }
    else if ([image isKindOfClass:[NSString class]])
    {
        if ([image length] > 0)
        {
            [self setImage:kImageWithName(image) forState:UIControlStateNormal];
        }
    }
}

- (void)setNormalBackgroundImage:(id)image
{
    if ([image isKindOfClass:[UIImage class]])
    {
        [self setBackgroundImage:image forState:UIControlStateNormal];
    }
    else if ([image isKindOfClass:[UIColor class]])
    {
        [self setBackgroundImage:[self imageWithColor:image] forState:UIControlStateNormal];
    }
    else if ([image isKindOfClass:[NSString class]])
    {
        if ([image length] > 0)
        {
            [self setBackgroundImage:kImageWithName(image) forState:UIControlStateNormal];
        }
    }
}

#pragma mark - 设置按钮Hightlighted状态下的图片

- (void)setHightlightedImage:(id)image
{
    if ([image isKindOfClass:[UIImage class]])
    {
        [self setImage:image forState:UIControlStateHighlighted];
    }
    else if ([image isKindOfClass:[UIColor class]])
    {
        [self setImage:[self imageWithColor:image] forState:UIControlStateHighlighted];
    }
    else if ([image isKindOfClass:[NSString class]])
    {
        if ([image length] > 0)
        {
            [self setImage:kImageWithName(image) forState:UIControlStateHighlighted];
        }
    }
}

- (void)setHightlightedBackgroundImage:(id)image
{
    if ([image isKindOfClass:[UIImage class]])
    {
        [self setBackgroundImage:image forState:UIControlStateHighlighted];
    }
    else if ([image isKindOfClass:[UIColor class]])
    {
        [self setBackgroundImage:[self imageWithColor:image] forState:UIControlStateHighlighted];
    }
    else if ([image isKindOfClass:[NSString class]])
    {
        if ([image length] > 0)
        {
            [self setBackgroundImage:kImageWithName(image) forState:UIControlStateHighlighted];
        }
    }
}

#pragma mark - 设置按钮Selected状态下的图片

- (void)setSelectedImage:(id)image
{
    if ([image isKindOfClass:[UIImage class]])
    {
        [self setImage:image forState:UIControlStateSelected];
    }
    else if ([image isKindOfClass:[UIColor class]])
    {
        [self setImage:[self imageWithColor:image] forState:UIControlStateSelected];
    }
    else if ([image isKindOfClass:[NSString class]])
    {
        if ([image length] > 0)
        {
            [self setImage:kImageWithName(image) forState:UIControlStateSelected];
        }
    }
}

- (void)setSelectedBackgroundImage:(id)image
{
    if ([image isKindOfClass:[UIImage class]])
    {
        [self setBackgroundImage:image forState:UIControlStateSelected];
    }
    else if ([image isKindOfClass:[UIColor class]])
    {
        [self setBackgroundImage:[self imageWithColor:image] forState:UIControlStateSelected];
    }
    else if ([image isKindOfClass:[NSString class]])
    {
        if ([image length] > 0)
        {
            [self setBackgroundImage:kImageWithName(image) forState:UIControlStateSelected];
        }
    }
}

#pragma mark - 设置按钮禁用状态下的图片

- (void)setDisabledImage:(id)image
{
    if ([image isKindOfClass:[UIImage class]])
    {
        [self setImage:image forState:UIControlStateDisabled];
    }
    else if ([image isKindOfClass:[UIColor class]])
    {
        [self setImage:[self imageWithColor:image] forState:UIControlStateDisabled];
    }
    else if ([image isKindOfClass:[NSString class]])
    {
        [self setImage:kImageWithName(image) forState:UIControlStateDisabled];
    }
}

- (void)setDisabledBackgroundImage:(id)image
{
    if ([image isKindOfClass:[UIImage class]])
    {
        [self setBackgroundImage:image forState:UIControlStateDisabled];
    }
    else if ([image isKindOfClass:[UIColor class]])
    {
        [self setBackgroundImage:[self imageWithColor:image] forState:UIControlStateDisabled];
    }
    else if ([image isKindOfClass:[NSString class]])
    {
        [self setBackgroundImage:kImageWithName(image) forState:UIControlStateDisabled];
    }
}

-(UIImage *)imageWithColor:(UIColor *)color
{
    return [self imageWithColor:color size:CGSizeMake(1, 1)];
}

- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - 设置按钮

-(void)setNormalTitle:(NSString *)title
             textFont:(UIFont *)font
            textColor:(UIColor *)color
{
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitleColor:color forState:UIControlStateNormal];
    self.titleLabel.font = font;
}

-(void)setHighlightedTitle:(NSString *)title
                  textFont:(UIFont *)font
                 textColor:(UIColor *)color
{
    [self setTitle:title forState:UIControlStateHighlighted];
    [self setTitleColor:color forState:UIControlStateHighlighted];
    self.titleLabel.font = font;
}

-(void)setSelectedTitle:(NSString *)title
               textFont:(UIFont *)font
              textColor:(UIColor *)color
{
    [self setTitle:title forState:UIControlStateSelected];
    [self setTitleColor:color forState:UIControlStateSelected];
    self.titleLabel.font = font;
}

@end
