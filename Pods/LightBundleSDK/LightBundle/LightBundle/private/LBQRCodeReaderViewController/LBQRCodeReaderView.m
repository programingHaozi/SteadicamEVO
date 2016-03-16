/*
 * LBQRCodeReaderViewController
 *
 * Copyright 2014-present Yannick Loriot.
 * http://yannickloriot.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import "LBQRCodeReaderView.h"
#import "LBLineBlueView.h"

@interface LBQRCodeReaderView ()
@property (nonatomic, strong) CAShapeLayer *overlay;

@end

@implementation LBQRCodeReaderView

@synthesize bottomTitle;

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        [self addOverlay];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    //虚线框距离屏幕左右边缘的边距  原来为50
    float margin = (self.frame.size.width - 200)/2;
    
    CGRect innerRect = CGRectInset(rect, margin, margin);
    
    CGFloat minSize = MIN(innerRect.size.width, innerRect.size.height);
    if (innerRect.size.width != minSize) {
        innerRect.origin.x   += (innerRect.size.width - minSize) / 2;
        innerRect.size.width = minSize;
    }
    else if (innerRect.size.height != minSize) {
        innerRect.origin.y    += (innerRect.size.height - minSize) / 2;
        innerRect.size.height = minSize;
    }
    
    CGRect offsetRect = CGRectOffset(innerRect, 0, 0);
    
    _overlay.path = [UIBezierPath bezierPathWithRoundedRect:offsetRect cornerRadius:0].CGPath;
    
//    //导航栏view
//    UIView *navView = [[UIView alloc] init];
//    navView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"nav_bg"]];
//    navView.frame = CGRectMake(0, 0, self.frame.size.width, 65);
//    [self addSubview:navView];
//    [self bringSubviewToFront:navView];
    
//    UILabel *titleLable = [[UILabel alloc] init];
//    titleLable.backgroundColor = [UIColor clearColor];
//    titleLable.frame = CGRectMake((self.frame.size.width-100)/2, 27, 100, 30);
//    titleLable.text = @"设备激活";
//    titleLable.textAlignment = NSTextAlignmentCenter;
//    titleLable.textColor = [UIColor whiteColor];
//    [navView addSubview:titleLable];
    
//    UIButton *backButton = [[UIButton alloc] init];
//    backButton.frame = CGRectMake(5, 15, 50, 50);
//    //backButton.backgroundColor = [UIColor clearColor];
//    //[backButton setImage:[UIImage imageNamed:@"nav_back_nor"] forState:UIControlStateNormal];
//    //[backButton setImage:[UIImage imageNamed:@"nav_back_nor"] forState:UIControlStateHighlighted];
//    [backButton setTitle:@"关闭" forState:UIControlStateNormal];
//    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    [navView addSubview:backButton];
    
    
    
    //新增半透明黑色背景
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor blackColor];
    topView.alpha = 0.5;
    topView.frame = CGRectMake(0, 0, self.frame.size.width, innerRect.origin.y);
    [self addSubview:topView];
    
    UIView *leftView = [[UIView alloc] init];
    leftView.backgroundColor = [UIColor blackColor];
    leftView.alpha = 0.5;
    leftView.frame = CGRectMake(0, topView.frame.size.height, margin, 200);
    [self addSubview:leftView];
    
    UIView *rightView = [[UIView alloc] init];
    rightView.backgroundColor = [UIColor blackColor];
    rightView.alpha = 0.5;
    rightView.frame = CGRectMake(self.frame.size.width-margin, topView.frame.size.height, margin, 200);
    [self addSubview:rightView];
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor blackColor];
    bottomView.alpha = 0.5;
    bottomView.frame = CGRectMake(0, topView.frame.size.height+200, self.frame.size.width, self.frame.size.height-(topView.frame.size.height+200));
    [self addSubview:bottomView];
    
    UIView *blueView = [[LBLineBlueView alloc] initWithFrame:CGRectMake((self.frame.size.width - 200)/2, topView.frame.size.height, 200+1, 200)];
    blueView.alpha = 1;
    [self addSubview:blueView];
    
    UILabel *explainLable = [[UILabel alloc] init];
    explainLable.frame = CGRectMake(0, bottomView.frame.origin.y+15, self.frame.size.width, 30);
    explainLable.text = @"请扫描二维码";
    if (bottomTitle) {
        explainLable.text = bottomTitle;
    }
    explainLable.textAlignment = NSTextAlignmentCenter;
    explainLable.textColor = [UIColor whiteColor];
    [self addSubview:explainLable];
}

#pragma mark - Private Methods

- (void)addOverlay
{
    _overlay = [[CAShapeLayer alloc] init];
    _overlay.backgroundColor = [UIColor clearColor].CGColor;
    _overlay.fillColor       = [UIColor clearColor].CGColor;
    _overlay.strokeColor     = [UIColor whiteColor].CGColor;
    _overlay.lineWidth       = 0.5;
    _overlay.lineDashPattern = @[@7.0, @7.0];
    _overlay.lineDashPhase   = 0;
    
    [self.layer addSublayer:_overlay];
}

@end
