//
//  TFImageCropView.m
//  TFUILib
//
//  Created by xiayiyong on 16/4/21.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFImageCropView.h"
#import <QuartzCore/QuartzCore.h>
#include <math.h>

@interface TFImageCropView()

@property (nonatomic) CGSize originalImageViewSize;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *tmpImage;

@end

@implementation TFImageCropView

- (void)setup
{
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)];
    self.imageView.userInteractionEnabled = YES;
    [self addSubview:self.imageView];
    
    UIPinchGestureRecognizer *scaleGes = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scaleImage:)];
    [self.imageView addGestureRecognizer:scaleGes];
    
    UIPanGestureRecognizer *moveGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveImage:)];
    [moveGes setMinimumNumberOfTouches:1];
    [moveGes setMaximumNumberOfTouches:1];
    [self.imageView addGestureRecognizer:moveGes];
}

- (id)initWithFrame:(CGRect)frame andImage:(UIImage*)image
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.image=image;
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        [self setup];
    }
    return self;
}

float _lastTransX = 0.0, _lastTransY = 0.0;
- (void)moveImage:(UIPanGestureRecognizer *)sender
{
    CGPoint translatedPoint = [sender translationInView:self];
    if([sender state] == UIGestureRecognizerStateBegan)
    {
        _lastTransX = 0.0;
        _lastTransY = 0.0;
    }
    
    CGAffineTransform trans = CGAffineTransformMakeTranslation(translatedPoint.x - _lastTransX, translatedPoint.y - _lastTransY);
    CGAffineTransform newTransform = CGAffineTransformConcat(self.imageView.transform, trans);
    _lastTransX = translatedPoint.x;
    _lastTransY = translatedPoint.y;
    
    self.imageView.transform = newTransform;
}

float _lastScale = 1.0;
- (void)scaleImage:(UIPinchGestureRecognizer *)sender
{
    if([sender state] == UIGestureRecognizerStateBegan)
    {
        _lastScale = 1.0;
        return;
    }
    
    CGFloat scale = [sender scale]/_lastScale;
    CGAffineTransform currentTransform = self.imageView.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    [self.imageView setTransform:newTransform];
    
    _lastScale = [sender scale];
}

float _lastRotation = 0.0;
- (void)rotateImage:(UIRotationGestureRecognizer *)sender
{
    if([sender state] == UIGestureRecognizerStateEnded)
    {
        _lastRotation = 0.0;
        return;
    }
    CGFloat rotation = -_lastRotation + [sender rotation];
    CGAffineTransform currentTransform = self.imageView.transform;
    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform,rotation);
    [self.imageView setTransform:newTransform];
    
    _lastRotation = [sender rotation];
}

- (void)setImage:(UIImage *)image
{
    if (_image != image)
    {
        _image = [image copy];
    }
    
    float _imageScale = self.frame.size.width / image.size.width;
    self.imageView.frame = CGRectMake(0, 0, image.size.width * _imageScale, image.size.height*_imageScale);
    _originalImageViewSize = CGSizeMake(image.size.width * _imageScale, image.size.height * _imageScale);
    self.imageView.image = image;
    self.imageView.center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
}

- (void)crop
{
    [self cropWithBlock:nil];
}

- (void)cropWithBlock:(TFImageCropViewBlock)block
{
    float zoomScale = [[self.imageView.layer valueForKeyPath:@"transform.scale.x"] floatValue];
    float rotate = [[self.imageView.layer valueForKeyPath:@"transform.rotation.z"] floatValue];
    
    float _imageScale = _image.size.width/_originalImageViewSize.width;
    CGSize cropSize = CGSizeMake(self.frame.size.width/zoomScale, self.frame.size.height/zoomScale);
    
    CGPoint cropperViewOrigin = CGPointMake((0.0 - self.imageView.frame.origin.x)/zoomScale,
                                            (0.0 - self.imageView.frame.origin.y)/zoomScale);
    
    if((NSInteger)cropSize.width % 2 == 1)
    {
        cropSize.width = ceil(cropSize.width);
    }
    if((NSInteger)cropSize.height % 2 == 1)
    {
        cropSize.height = ceil(cropSize.height);
    }
    
    CGRect CropRectinImage = CGRectMake((NSInteger)(cropperViewOrigin.x * _imageScale) ,(NSInteger)( cropperViewOrigin.y * _imageScale), (NSInteger)(cropSize.width * _imageScale),(NSInteger)(cropSize.height * _imageScale));
    
    UIImage *rotInputImage = [self.image imageRotatedByRadians:rotate];
    CGImageRef tmp = CGImageCreateWithImageInRect([rotInputImage CGImage], CropRectinImage);
    self.croppedImage = [UIImage imageWithCGImage:tmp scale:self.image.scale orientation:self.image.imageOrientation];
    CGImageRelease(tmp);
    
    if (block)
    {
        block(self.image, self.croppedImage);
    }
}

- (void)reset
{
    self.imageView.transform = CGAffineTransformIdentity;
}

@end

