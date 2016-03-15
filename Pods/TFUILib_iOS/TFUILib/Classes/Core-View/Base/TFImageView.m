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
    self.tapGesture       = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    self.doubleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(DoubleTapAction:)];
    self.pinchGesture     = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(PinchAction:)];
    self.panGesture       = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGesture)];
    
    [self.doubleTapGesture setNumberOfTapsRequired:2];
    [self.tapGesture requireGestureRecognizerToFail:self.doubleTapGesture];
    
    
}

#pragma mark - Gestures -

-(void)tapAction:(void (^)())actionBlock
{
    if (actionBlock)
    {
        actionBlock();
    }
}

-(void)PinchAction:(void (^)())actionBlock
{
    if (actionBlock)
    {
        actionBlock();
    }
}

-(void)PanAction:(void (^)())actionBlock
{
    if (actionBlock)
    {
        actionBlock();
    }
}
-(void)DoubleTapAction:(void (^)())actionBlock
{
    if (actionBlock)
    {
        actionBlock();
    }
}

@end
