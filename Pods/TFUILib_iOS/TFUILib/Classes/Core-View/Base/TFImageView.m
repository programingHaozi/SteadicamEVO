//
//  TFImageView.m
//  TFUILib
//
//  Created by xiayiyong on 16/1/12.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFImageView.h"

@interface TFImageView()

@property (nonatomic, strong) UITapGestureRecognizer * tapGesture;

@property (nonatomic, strong) UIPanGestureRecognizer * panGesture;

@property (nonatomic, strong) UIPinchGestureRecognizer * pinchGesture;

@property (nonatomic, strong) UITapGestureRecognizer * doubleTapGesture;

@property (nonatomic, strong) void (^tapActionBlock)();
@property (nonatomic, strong) void (^pinchActionBlock)();
@property (nonatomic, strong) void (^panActionBlock)();
@property (nonatomic, strong) void (^doubleActionBlock)();

@end

@implementation TFImageView

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self setUp];
    }

    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setUp];
    }

    return self;
}

#pragma mark - Set -

-(void)setPlaceholderImage:(UIImage *)placeholderImage
{
    self.image = placeholderImage;
}

- (void)setEnableTap:(BOOL)enableTap
{
    if (enableTap)
    {
        [self addGestureRecognizer:self.tapGesture];
    }
    else
    {
        [self removeGestureRecognizer:self.tapGesture];
    }
}

-(void)setEnablePan:(BOOL)enablePan
{
    if (enablePan)
    {
        [self addGestureRecognizer:self.panGesture];
    }
    else
    {
        [self removeGestureRecognizer:self.panGesture];
    }
}

-(void)setEnablePinch:(BOOL)enablePinch
{
    if (enablePinch)
    {
        [self addGestureRecognizer:self.pinchGesture];
    }
    else
    {
        [self removeGestureRecognizer:self.pinchGesture];
    }
}

-(void)setEnableDoubleTap:(BOOL)enableDoubleTap
{
    if (enableDoubleTap)
    {
        [self addGestureRecognizer:self.doubleTapGesture];
    }
    else
    {
        [self removeGestureRecognizer:self.doubleTapGesture];
    }
}

#pragma mark - Set Up -

- (void)setUp
{
    self.userInteractionEnabled = YES;
    self.tapGesture       = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTapAction:)];
    self.doubleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageDoubleTapAction:)];
    self.pinchGesture     = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(imagePinchAction:)];
    self.panGesture       = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(imagePanGesture)];

    [self.doubleTapGesture setNumberOfTapsRequired:2];
    [self.tapGesture requireGestureRecognizerToFail:self.doubleTapGesture];


}

#pragma mark-action

- (void)imageTapAction:(id)sender
{
    if (self.tapActionBlock)
    {
        self.tapActionBlock();
    }
}

- (void)imageDoubleTapAction:(id)sender
{
    if (self.doubleActionBlock)
    {
        self.doubleActionBlock();
    }
}

- (void)imagePinchAction:(id)sender
{
    if (self.pinchActionBlock)
    {
        self.pinchActionBlock();
    }
}

- (void)imagePanGesture:(id)sender
{
    if (self.panActionBlock)
    {
        self.panActionBlock();
    }
}

#pragma mark - Gestures -

-(void)tapAction:(void (^)())actionBlock
{
    self.tapActionBlock = actionBlock;
}

-(void)pinchAction:(void (^)())actionBlock
{
    self.pinchActionBlock = actionBlock;
}

-(void)panAction:(void (^)())actionBlock
{
    self.panActionBlock = actionBlock;
}

-(void)doubleTapAction:(void (^)())actionBlock
{
    self.doubleActionBlock = actionBlock;
}

@end
