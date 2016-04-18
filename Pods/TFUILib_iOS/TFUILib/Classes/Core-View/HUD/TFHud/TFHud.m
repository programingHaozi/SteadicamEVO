//
//  TFHud.m
//  TFHud
//
//  Created by xiayiyong on 15-5-27.
//  Copyright (c) 2015年 liu. All rights reserved.
//

#import "TFHud.h"

#define LG_RADIUS 20 //圆环半径
#define LG_TOTAL_GAPS 100
#define TEXT_FONT 12.
#define LG_HUD_GAPS 240
#define LG_TEXT_WIDTH 200
#define LG_BACK_MARGIN 10.
#define LG_MAO_GAP 5

@implementation NSString (SelfSize)

- (CGSize)getSizeFromSelfWithWidth:(CGFloat)width andFont:(CGFloat)font
{
    CGFloat fontT = font;
    if(font<1)
    fontT = 17.;
    UIFont *fontTemp = [UIFont systemFontOfSize:fontT];
    NSDictionary *attribute = @{NSFontAttributeName:fontTemp};
    CGSize labelSize = [self boundingRectWithSize:CGSizeMake(width, 999) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine attributes:attribute context:nil].size;
    return labelSize;
}

- (CGSize)getSizeFromSelfWithWidth:(CGFloat)width andUIFont:(UIFont *)font
{
    UIFont *fontTemp = font;
    if(!font)
    fontTemp = [UIFont systemFontOfSize:17.];
    NSDictionary *attribute = @{NSFontAttributeName:fontTemp};
    CGSize labelSize = [self boundingRectWithSize:CGSizeMake(width, 999) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine attributes:attribute context:nil].size;
    return labelSize;
}
@end

@implementation TFHudProgress

@end

@interface TFHud()

@property (strong,nonatomic) NSTimer *timer;
@property (assign,nonatomic) NSInteger  times;

@property (nonatomic,copy) TFHudBlock block;

@property (nonatomic,assign) long long loadedLength;

@property (nonatomic,assign) TFTextPositionType positionType;
@property (nonatomic,assign) TFHudType hudType;

@property (nonatomic,strong) NSString *title;

@end

@implementation TFHud

#pragma mark - show
+ (void)showWithText:(NSString *)text atView:(UIView *)view
{
    TFHud *hud = [[TFHud alloc] initWithView:view];
    hud.hudType = kHudTypeText;
    hud.title = text;
    [view addSubview:hud];
}

+ (void)showWithProgress:(TFHudProgress *)progress atView:(UIView *)view
{
    TFHud *hud = [[TFHud alloc] initWithView:view];
    hud.hudType = kHudTypeProgress;
    hud.progress = progress;
    hud.timer = [NSTimer scheduledTimerWithTimeInterval:0.005 target:hud selector:@selector(changeProgress:) userInfo:nil repeats:YES];
    [view addSubview:hud];
}

+ (void)showLoadingWithText:(NSString *)text textPosition:(TFTextPositionType)positionType atView:(UIView *)view
{
    if (text == nil || [text length] == 0)
    {
        text = NSLocalizedString(@"loading", @"正在请求中...");
    }
    
    TFHud *hud = [[TFHud alloc] initWithView:view];
    hud.hudType = kHudTypeLoadingText;
    hud.positionType = positionType;
    hud.title = text;
    hud.timer = [NSTimer scheduledTimerWithTimeInterval:0.005 target:hud selector:@selector(setNeedsDisplay) userInfo:nil repeats:YES];
    [view addSubview:hud];
    [hud loadingHudAppearAnimated:kHudAnimatedTypeNone inView:view];
}

+ (void)showLoadingAtView:(UIView *)view
{
    TFHud *hud = [[TFHud alloc] initWithView:view];
    hud.hudType = kHudTypeLoading;
    hud.timer = [NSTimer scheduledTimerWithTimeInterval:0.005 target:hud selector:@selector(setNeedsDisplay) userInfo:nil repeats:YES];
    [view addSubview:hud];
}

+ (void)hideInView:(UIView *)view
{
    for (UIView *viewTemp in view.subviews)
    {
        if([viewTemp isKindOfClass:[TFHud class]])
        {
            TFHud *hud = (TFHud *)viewTemp;
            [hud loadingHudDisappearAnimated:kHudAnimatedTypeNone];
        }
    }
}

#pragma mark - init
- (instancetype)initWithView:(UIView *)view
{
    if(self = [super initWithFrame:view.bounds])
    {
        self.backgroundColor = [UIColor lightGrayColor];
        self.alpha = 0.6;
        
        _gap = 5;
        _textFont = TEXT_FONT;
        _loadingBackColor = [UIColor whiteColor];
        _loadingForeColor = [UIColor blackColor];
        _textColor = [UIColor whiteColor];
        _progress = nil;
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"TFHud dealloc");
}

#pragma mark - 显示下载进度的活动视图
- (void)drawProgress:(CGRect)rect
{
    CGContextRef context =UIGraphicsGetCurrentContext();
    
    CGRect rectTemp = CGRectMake(rect.size.width/2-LG_RADIUS, rect.size.height/2-LG_RADIUS, LG_RADIUS*2,LG_RADIUS*2 );
    
    CGContextSetFillColorWithColor(context, [UIColor lightGrayColor].CGColor);
    CGRect rectBack = CGRectMake(rectTemp.origin.x-LG_BACK_MARGIN, rectTemp.origin.y-LG_BACK_MARGIN, rectTemp.size.width+2*LG_BACK_MARGIN, rectTemp.size.height+2*LG_BACK_MARGIN);
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rectBack cornerRadius:LG_MAO_GAP];
    [bezierPath fill];
    
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextStrokeEllipseInRect(context, rectTemp);
    
    CGFloat eachGap = M_PI*2/_progress.fileLength;
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextAddArc(context, rect.size.width/2, rect.size.height/2, LG_RADIUS, -M_PI/2, -M_PI/2+_progress.loadedLength*eachGap, 0);
    CGContextStrokePath(context);
    
    long long pro = _loadedLength*100/_progress.fileLength;
    NSString *str = [NSString stringWithFormat:@"%lld%%",pro];
    CGSize sizePro = [str getSizeFromSelfWithWidth:320 andFont:TEXT_FONT];
    CGPoint proPoint = CGPointMake(rect.size.width/2-sizePro.width/2, rect.size.height/2-sizePro.height/2);
    [str drawAtPoint:proPoint withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.textFont],NSForegroundColorAttributeName:self.textColor}];
    
    _loadedLength = _progress.loadedLength;
}

// 显示单纯的活动视图，不带文字
- (void)drawLoading:(CGRect)rect
{
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGRect rectTemp = CGRectMake(rect.size.width/2-LG_RADIUS, rect.size.height/2-LG_RADIUS, LG_RADIUS*2,LG_RADIUS*2 );
    
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGRect rectBack = CGRectMake(rectTemp.origin.x-LG_BACK_MARGIN, rectTemp.origin.y-LG_BACK_MARGIN, rectTemp.size.width+2*LG_BACK_MARGIN, rectTemp.size.height+2*LG_BACK_MARGIN);
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rectBack cornerRadius:LG_MAO_GAP];
    [bezierPath fill];

    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, self.loadingBackColor.CGColor);
    CGContextStrokeEllipseInRect(context, rectTemp);
    
    CGFloat eachGap= M_PI*2/LG_HUD_GAPS;
    CGFloat arcLength = M_PI*2/5;
    CGContextSetStrokeColorWithColor(context, self.loadingForeColor.CGColor);
    CGContextAddArc(context, rect.size.width/2, rect.size.height/2, LG_RADIUS, self.times*eachGap, arcLength+self.times*eachGap+eachGap, 0);
    CGContextStrokePath(context);
    if(self.times<LG_HUD_GAPS)
    {
        _times++;
    }
    else
    {
        _times = 0;
    }
}

// 创建带文字的活动视图
- (void)drawLoading:(CGRect)rect withText:(NSString *)text andPosition:(TFTextPositionType)positionType
{
    CGPoint pointTextOri = [self textOrignPoint:rect text:text positionType:positionType];
    CGSize sizeTemp ;
    if(text)
    {
        sizeTemp = [text getSizeFromSelfWithWidth:LG_TEXT_WIDTH andFont:self.textFont];
        
    }
    
    CGContextRef context =UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGRect rectBack = [self loadingHudBackRect:sizeTemp centre:CGPointMake(rect.size.width/2, rect.size.height/2) position:positionType];
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rectBack cornerRadius:LG_MAO_GAP];
    [bezierPath fill];
    
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, self.loadingBackColor.CGColor);
    CGRect rectTemp = [self loadingHudRect:sizeTemp textOrign:pointTextOri position:positionType];
    CGContextStrokeEllipseInRect(context, rectTemp);
    
    CGFloat eachGap= M_PI*2/LG_HUD_GAPS;
    CGFloat arcLength = M_PI*2/5;
    CGContextSetStrokeColorWithColor(context, self.loadingForeColor.CGColor);
    CGContextAddArc(context,rectTemp.origin.x+rectTemp.size.width/2,rectTemp.origin.y+rectTemp.size.height/2, LG_RADIUS, self.times*eachGap, arcLength+self.times*eachGap+eachGap, 0);
    CGContextStrokePath(context);
    
    [text drawAtPoint:pointTextOri withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.textFont],NSForegroundColorAttributeName:self.textColor}];
    
    
    if(self.times<LG_HUD_GAPS)
    {
        _times++;
    }
    else
    {
        _times = 0;
    }
}

// 结果视图(在设置的时间过后会消失) 绘图：带文字，不消失
- (void)drawText:(NSString *)text rect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGSize size ;
    CGPoint point = CGPointMake(rect.size.width/2, rect.size.height/2);
    if(text)
    {
        size = [text getSizeFromSelfWithWidth:200 andFont:TEXT_FONT];
        point = CGPointMake(point.x-size.width/2, point.y-size.height/2);
    }
    
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGRect rectBack = CGRectMake(point.x-LG_BACK_MARGIN, point.y-LG_BACK_MARGIN,size.width+2*LG_BACK_MARGIN, size.height+2*LG_BACK_MARGIN);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rectBack cornerRadius:LG_MAO_GAP];
    [path fill];
    
    [text drawAtPoint:point withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.textFont],NSForegroundColorAttributeName:self.textColor}];
}

// 绘图重载
- (void)drawRect:(CGRect)rect
{
    if(self.hudType == kHudTypeText)
    {
        [self drawText:self.title rect:rect];
    }
    else if(self.hudType == kHudTypeLoadingText)
    {
        [self drawLoading:rect withText:self.title andPosition:self.positionType];
    }
    else if(self.hudType == kHudTypeLoading)
    {
        [self drawLoading:rect];
    }
    else
    {
        [self drawProgress:rect];
    }
}

// 获取活动视图背景的frame
- (CGRect)loadingHudBackRect:(CGSize)size centre:(CGPoint)point position:(TFTextPositionType)positionType
{
    CGRect rectTemp;
    switch (positionType)
    {
        case kTextPositionTypeLeft:
        {
            CGFloat rectW = LG_BACK_MARGIN + size.width + self.gap + LG_RADIUS*2 + LG_BACK_MARGIN;
            CGFloat rectH = LG_BACK_MARGIN+LG_RADIUS*2+LG_BACK_MARGIN;
            rectTemp = CGRectMake(point.x-rectW/2, point.y-rectH/2,rectW,rectH);
            break;
        }
        case kTextPositionTypeRight:
        {
            CGFloat rectW = LG_BACK_MARGIN + size.width + self.gap + LG_RADIUS*2 + LG_BACK_MARGIN;
            CGFloat rectH = LG_BACK_MARGIN+LG_RADIUS*2+LG_BACK_MARGIN;
            rectTemp = CGRectMake(point.x-rectW/2, point.y-rectH/2,rectW,rectH);
            break;
        }
        case kTextPositionTypeTop:
        {
            CGFloat rectW = LG_BACK_MARGIN + (size.width>LG_RADIUS*2?size.width:LG_RADIUS*2) + LG_BACK_MARGIN;
            CGFloat rectH = LG_BACK_MARGIN+size.height+self.gap+LG_RADIUS*2+LG_BACK_MARGIN;
            rectTemp = CGRectMake(point.x-rectW/2, point.y-rectH/2,rectW,rectH);
            break;
        }
        case kTextPositionTypeBottom:
        {
            CGFloat rectW = LG_BACK_MARGIN + (size.width>LG_RADIUS*2?size.width:LG_RADIUS*2) + LG_BACK_MARGIN;
            CGFloat rectH = LG_BACK_MARGIN+size.height+self.gap+LG_RADIUS*2+LG_BACK_MARGIN;
            rectTemp = CGRectMake(point.x-rectW/2, point.y-rectH/2,rectW,rectH);
            break;
        }
        case kTextPositionTypeCenter:
        {
            CGFloat rectW = LG_BACK_MARGIN + (size.width>LG_RADIUS*2?size.width:LG_RADIUS*2) + LG_BACK_MARGIN;
            CGFloat rectH = LG_BACK_MARGIN+LG_RADIUS*2+LG_BACK_MARGIN;
            rectTemp = CGRectMake(point.x-rectW/2, point.y-rectH/2,rectW,rectH);
            break;
        }
        default:
            break;
    }
    
    return rectTemp;
}

// 获取活动视图圆环的frame
- (CGRect)loadingHudRect:(CGSize)size textOrign:(CGPoint)point position:(TFTextPositionType)positionType
{
    CGRect rectTemp;
    switch (positionType)
    {
        case kTextPositionTypeLeft:
            rectTemp = CGRectMake(point.x+size.width+self.gap, point.y+size.height/2-LG_RADIUS, LG_RADIUS*2,LG_RADIUS*2);
            break;
        case kTextPositionTypeRight:
            rectTemp = CGRectMake(point.x-LG_RADIUS*2-self.gap, point.y+size.height/2-LG_RADIUS, LG_RADIUS*2,LG_RADIUS*2 );
            break;
        case kTextPositionTypeTop:
            rectTemp = CGRectMake(point.x+size.width/2-LG_RADIUS, point.y+size.height+self.gap, LG_RADIUS*2,LG_RADIUS*2 );
            break;
        case kTextPositionTypeBottom:
            rectTemp = CGRectMake(point.x+size.width/2-LG_RADIUS, point.y-2*LG_RADIUS-self.gap, LG_RADIUS*2,LG_RADIUS*2 );
            break;
        case kTextPositionTypeCenter:
            rectTemp = CGRectMake(point.x+size.width/2-LG_RADIUS, point.y+size.height/2-LG_RADIUS, LG_RADIUS*2,LG_RADIUS*2 );
            break;
        default:
            break;
    }
    
    return rectTemp;
}

// 获取活动视图文字的起点point
- (CGPoint)textOrignPoint:(CGRect)rect text:(NSString *)text positionType:(TFTextPositionType)positionType
{
    CGFloat textOriginalX = 0;
    CGFloat textOriginalY = 0;
    if(text)
    {
        CGSize sizeTemp = [text getSizeFromSelfWithWidth:LG_TEXT_WIDTH andFont:self.textFont];

        switch (positionType)
        {
            case kTextPositionTypeLeft:
                textOriginalX = rect.size.width/2-(LG_RADIUS*2+sizeTemp.width+self.gap)/2;
                textOriginalY = rect.size.height/2- sizeTemp.height/2;
                break;
            case kTextPositionTypeRight:
                textOriginalX = rect.size.width/2+(LG_RADIUS*2+sizeTemp.width+self.gap)/2-sizeTemp.width;
                textOriginalY = rect.size.height/2- sizeTemp.height/2;
                break;
            case kTextPositionTypeTop:
                textOriginalX = rect.size.width/2-sizeTemp.width/2;
                textOriginalY = rect.size.height/2-(LG_RADIUS*2+sizeTemp.height+self.gap)/2;
                break;
            case kTextPositionTypeBottom:
                textOriginalX = rect.size.width/2-sizeTemp.width/2;
                textOriginalY = rect.size.height/2+(LG_RADIUS*2+sizeTemp.height+self.gap)/2-sizeTemp.height;
                break;
            case kTextPositionTypeCenter:
                textOriginalX = rect.size.width/2-sizeTemp.width/2;
                textOriginalY = rect.size.height/2- sizeTemp.height/2;
                break;
            default:
                break;
        }
    }
    
    return CGPointMake(textOriginalX, textOriginalY);
}

// 动画效果 活动视图出现时的动画
- (void)loadingHudAppearAnimated:(TFHudAnimatedType)animatedType inView:(UIView *)view
{
    switch (animatedType)
    {
        case kHudAnimatedTypeNone:
            break;
        case kHudAnimatedTypeLeft:
        {
            self.frame = CGRectMake(-self.frame.size.width,0, self.frame.size.width, self.frame.size.height);
            [UIView animateWithDuration:0.5 animations:^{
                self.frame = CGRectMake(0,0, self.frame.size.width, self.frame.size.height);
            }];
            break;
        }
        case kHudAnimatedTypeRight:
        {
            self.frame = CGRectMake(self.frame.size.width,0, self.frame.size.width, self.frame.size.height);
            [UIView animateWithDuration:0.5 animations:^{
                self.frame = CGRectMake(0,0, self.frame.size.width, self.frame.size.height);
            }];
            break;
        }
        case kHudAnimatedTypeTop:
        {
            self.frame = CGRectMake(0,-self.frame.size.height, self.frame.size.width, self.frame.size.height);
            [UIView animateWithDuration:0.5 animations:^{
                self.frame = CGRectMake(0,0, self.frame.size.width, self.frame.size.height);
            }];
            break;
        }
        case kHudAnimatedTypeBottom:
        {
            self.frame = CGRectMake(0,self.frame.size.height, self.frame.size.width, self.frame.size.height);
            [UIView animateWithDuration:0.5 animations:^{
                self.frame = CGRectMake(0,0, self.frame.size.width, self.frame.size.height);
            }];
            break;
        }
        case kHudAnimatedTypeChangeGradually:
        {
            self.alpha = 0;
            [UIView animateWithDuration:1.5 animations:^{
                self.alpha = 1;
            } completion:^(BOOL finished) {
                
            }];
            
            break;
        }
        default:
            break;
    }
}

// 活动视图消失时的动画
- (void)loadingHudDisappearAnimated:(TFHudAnimatedType)animatedType
{
    switch (animatedType)
    {
        case kHudAnimatedTypeNone:
            [self removeFromSuperview];
            break;
        case kHudAnimatedTypeLeft:
        {
            [UIView animateWithDuration:0.5 animations:^{
                self.frame = CGRectMake(-self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
            break;
        }
        case kHudAnimatedTypeRight:
        {
            [UIView animateWithDuration:0.5 animations:^{
                self.frame = CGRectMake(self.frame.size.width,0, self.frame.size.width, self.frame.size.height);
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
            break;
        }
        case kHudAnimatedTypeTop:
        {
            [UIView animateWithDuration:0.5 animations:^{
                self.frame = CGRectMake(0, -self.frame.size.height, self.frame.size.width, self.frame.size.height);
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
            break;
        }
        case kHudAnimatedTypeBottom:
        {
            [UIView animateWithDuration:0.5 animations:^{
                self.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
            break;
        }
        case kHudAnimatedTypeChangeGradually:
        {
            [UIView animateWithDuration:1.5 animations:^{
                self.alpha = 0;
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
            break;
        }
            
        default:
            break;
    }
}

// 定时器监听
- (void)changeProgress:(NSTimer *)timer
{
    if(_progress.loadedLength != _loadedLength)
    {
        [self setNeedsDisplay];
    }
}

@end
