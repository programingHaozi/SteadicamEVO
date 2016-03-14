//
//  LGProgressHud.m
//  LGProgressHud
//
//  Created by AQ on 15-5-27.
//  Copyright (c) 2015年 liu. All rights reserved.
//

#import "LGProgressHud.h"
#import "NSString+SelfSize.h"
#define LG_RADIUS 20 //圆环半径

#define LG_TOTAL_GAPS 100

#define TEXT_FONT 10.

#define LG_HUD_GAPS 240

#define LG_TEXT_WIDTH 200

#define LG_BACK_MARGIN 10.

#define LG_MAO_GAP 5

@interface LGProgressHud()
@property (strong,nonatomic) NSTimer *timer;
@property (assign,nonatomic) NSInteger  times;
//@property (assign,nonatomic) 
@property (nonatomic,copy) LGProgressHudBlock block;
@property (nonatomic,assign) TextPositionType positionType;
@property (nonatomic,assign) long long loadedLength;
@property (nonatomic,assign) HudType hudType;
@end

@implementation LGProgressHud

#pragma mark - 视图初始化
- (void)setInitStatus
{
    self.backgroundColor = [UIColor lightGrayColor];
    self.alpha = 0.6;
    
    _gap = 5;
    _textFont = TEXT_FONT;
    _loadingBackColor = [UIColor whiteColor];
    _loadingForeColor = [UIColor blackColor];
    _loadingTextColor = [UIColor whiteColor];
    _progress = nil;
}

- (instancetype)initWithView:(UIView *)view
{
    if(self = [super initWithFrame:view.bounds])
    {
        [self setInitStatus];
    }
    return self;
}

#pragma mark - 显示下载进度的活动视图
#pragma mark 绘图
- (void)drawProgressHud:(CGRect)rect
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
    [str drawAtPoint:proPoint withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.textFont],NSForegroundColorAttributeName:self.loadingTextColor}];
    
    _loadedLength = _progress.loadedLength;
}

#pragma mark 定时器监听
- (void)changeProgress:(NSTimer *)timer
{
    if(_progress.loadedLength != _loadedLength)
    {
        [self setNeedsDisplay];
    }
}

#pragma mark 创建并展示
+ (void)showProgress:(UIView *)view withObject:(LGProgressObject *)obj
{
    LGProgressHud *hud = [[LGProgressHud alloc] initWithView:view];
    hud.hudType = HudTypeProgress;
    hud.progress = obj;
    hud.timer = [NSTimer scheduledTimerWithTimeInterval:0.005 target:hud selector:@selector(changeProgress:) userInfo:nil repeats:YES];
    [view addSubview:hud];
}

#pragma mark - 显示单纯的活动视图，不带文字
#pragma mark 绘图
- (void)drawLoadingHud:(CGRect)rect
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

#pragma mark 创建并展示
+ (void)showLoadingHud:(UIView *)view animated:(HudAnimatedType)animatedType;
{
    LGProgressHud *hud = [[LGProgressHud alloc] initWithView:view];
    hud.hudType = HudTypeLoading;
    hud.timer = [NSTimer scheduledTimerWithTimeInterval:0.005 target:hud selector:@selector(setNeedsDisplay) userInfo:nil repeats:YES];
    [view addSubview:hud];
}

#pragma mark - 创建带文字的活动视图
#pragma mark 绘图
- (void)drawLoadingHud:(CGRect)rect withText:(NSString *)text andPosition:(TextPositionType)positionType
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
    
    [text drawAtPoint:pointTextOri withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.textFont],NSForegroundColorAttributeName:self.loadingTextColor}];
    
    
    if(self.times<LG_HUD_GAPS)
    {
        _times++;
    }
    else
    {
        _times = 0;
    }
}

#pragma mark 获取活动视图背景的frame
- (CGRect)loadingHudBackRect:(CGSize)size centre:(CGPoint)point position:(TextPositionType)positionType
{
    CGRect rectTemp;
    switch (positionType) {
        case TextPositionTypeLeft:
        {
            CGFloat rectW = LG_BACK_MARGIN + size.width + self.gap + LG_RADIUS*2 + LG_BACK_MARGIN;
            CGFloat rectH = LG_BACK_MARGIN+LG_RADIUS*2+LG_BACK_MARGIN;
            rectTemp = CGRectMake(point.x-rectW/2, point.y-rectH/2,rectW,rectH);
            break;
        }
        case TextPositionTypeRight:
        {
            CGFloat rectW = LG_BACK_MARGIN + size.width + self.gap + LG_RADIUS*2 + LG_BACK_MARGIN;
            CGFloat rectH = LG_BACK_MARGIN+LG_RADIUS*2+LG_BACK_MARGIN;
            rectTemp = CGRectMake(point.x-rectW/2, point.y-rectH/2,rectW,rectH);
            break;
        }
        case TextPositionTypeTop:
        {
            CGFloat rectW = LG_BACK_MARGIN + (size.width>LG_RADIUS*2?size.width:LG_RADIUS*2) + LG_BACK_MARGIN;
            CGFloat rectH = LG_BACK_MARGIN+size.height+self.gap+LG_RADIUS*2+LG_BACK_MARGIN;
            rectTemp = CGRectMake(point.x-rectW/2, point.y-rectH/2,rectW,rectH);
            break;
        }
        case TextPositionTypeBottle:
        {
            CGFloat rectW = LG_BACK_MARGIN + (size.width>LG_RADIUS*2?size.width:LG_RADIUS*2) + LG_BACK_MARGIN;
            CGFloat rectH = LG_BACK_MARGIN+size.height+self.gap+LG_RADIUS*2+LG_BACK_MARGIN;
            rectTemp = CGRectMake(point.x-rectW/2, point.y-rectH/2,rectW,rectH);
            break;
        }
        case TextPositionTypeCentre:
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

#pragma mark 获取活动视图圆环的frame
- (CGRect)loadingHudRect:(CGSize)size textOrign:(CGPoint)point position:(TextPositionType)positionType
{
    CGRect rectTemp;
    switch (positionType) {
        case TextPositionTypeLeft:
            rectTemp = CGRectMake(point.x+size.width+self.gap, point.y+size.height/2-LG_RADIUS, LG_RADIUS*2,LG_RADIUS*2);
            break;
        case TextPositionTypeRight:
            rectTemp = CGRectMake(point.x-LG_RADIUS*2-self.gap, point.y+size.height/2-LG_RADIUS, LG_RADIUS*2,LG_RADIUS*2 );
            break;
        case TextPositionTypeTop:
            rectTemp = CGRectMake(point.x+size.width/2-LG_RADIUS, point.y+size.height+self.gap, LG_RADIUS*2,LG_RADIUS*2 );
            break;
        case TextPositionTypeBottle:
            rectTemp = CGRectMake(point.x+size.width/2-LG_RADIUS, point.y-2*LG_RADIUS-self.gap, LG_RADIUS*2,LG_RADIUS*2 );
            break;
        case TextPositionTypeCentre:
            rectTemp = CGRectMake(point.x+size.width/2-LG_RADIUS, point.y+size.height/2-LG_RADIUS, LG_RADIUS*2,LG_RADIUS*2 );
            break;
        default:
            break;
    }
    
    return rectTemp;
}

#pragma mark 获取活动视图文字的起点point
- (CGPoint)textOrignPoint:(CGRect)rect text:(NSString *)text positionType:(TextPositionType)positionType
{
    CGFloat textOriginalX = 0;
    CGFloat textOriginalY = 0;
    if(text)
    {
        CGSize sizeTemp = [text getSizeFromSelfWithWidth:LG_TEXT_WIDTH andFont:self.textFont];

        switch (positionType) {
            case TextPositionTypeLeft:
                textOriginalX = rect.size.width/2-(LG_RADIUS*2+sizeTemp.width+self.gap)/2;
                textOriginalY = rect.size.height/2- sizeTemp.height/2;
                break;
            case TextPositionTypeRight:
                textOriginalX = rect.size.width/2+(LG_RADIUS*2+sizeTemp.width+self.gap)/2-sizeTemp.width;
                textOriginalY = rect.size.height/2- sizeTemp.height/2;
                break;
            case TextPositionTypeTop:
                textOriginalX = rect.size.width/2-sizeTemp.width/2;
                textOriginalY = rect.size.height/2-(LG_RADIUS*2+sizeTemp.height+self.gap)/2;
                break;
            case TextPositionTypeBottle:
                textOriginalX = rect.size.width/2-sizeTemp.width/2;
                textOriginalY = rect.size.height/2+(LG_RADIUS*2+sizeTemp.height+self.gap)/2-sizeTemp.height;
                break;
            case TextPositionTypeCentre:
                textOriginalX = rect.size.width/2-sizeTemp.width/2;
                textOriginalY = rect.size.height/2- sizeTemp.height/2;
                break;
            default:
                break;
        }
    }
    
    return CGPointMake(textOriginalX, textOriginalY);
}

#pragma mark 创建并展示带文字的活动视图
+ (void)showLoadingHud:(UIView *)view withText:(NSString *)text textPosition:(TextPositionType)positionType animated:(HudAnimatedType)animatedType
{
    LGProgressHud *hud = [[LGProgressHud alloc] initWithView:view];
    hud.hudType = HudTypeLoadingText;
    hud.positionType = positionType;
    hud.title = text;
    hud.timer = [NSTimer scheduledTimerWithTimeInterval:0.005 target:hud selector:@selector(setNeedsDisplay) userInfo:nil repeats:YES];
    [view addSubview:hud];
    [hud loadingHudAppearAnimated:animatedType inView:view];
}

#pragma mark -绘图重载
- (void)drawRect:(CGRect)rect
{
    
    if(self.hudType == HudTypeHud)
    {
        [self drawText:self.title rect:rect];
    }
    else if(self.hudType == HudTypeLoadingText)
    {
        [self drawLoadingHud:rect withText:self.title andPosition:self.positionType];
    }
    else if(self.hudType == HudTypeLoading)
    {
        [self drawLoadingHud:rect];
    }
    else
    {
        [self drawProgressHud:rect];
    }
}

#pragma mark - 结果视图(在设置的时间过后会消失)
#pragma mark 绘图：带文字，不消失
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
    
    //NSMutableString *str = [NSMutableString string];
    
    [text drawAtPoint:point withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.textFont],NSForegroundColorAttributeName:self.loadingTextColor}];
    
}



+ (void)showHud:(UIView *)view title:(NSString *)title animated:(HudAnimatedType)animtedType
{
    LGProgressHud *hud = [[LGProgressHud alloc] initWithView:view];
    hud.hudType = HudTypeHud;
    hud.title = title;
    [view addSubview:hud];

}


#pragma mark -移除活动视图

+ (void)hideAllHudInView:(UIView *)view animated:(HudAnimatedType)animatedType
{
    for (UIView *viewTemp in view.subviews) {
        if([viewTemp isKindOfClass:[LGProgressHud class]])
        {
            LGProgressHud *hud = (LGProgressHud *)viewTemp;
            [hud loadingHudDisappearAnimated:animatedType];
        }
    }
}

#pragma mark -动画效果
#pragma mark 活动视图出现时的动画
- (void)loadingHudAppearAnimated:(HudAnimatedType)animatedType inView:(UIView *)view
{
    
    switch (animatedType) {
        case HudAnimatedTypeNone:
            break;
        case HudAnimatedTypeLeft:
        {
            self.frame = CGRectMake(-self.frame.size.width,0, self.frame.size.width, self.frame.size.height);
            [UIView animateWithDuration:0.5 animations:^{
                self.frame = CGRectMake(0,0, self.frame.size.width, self.frame.size.height);
            }];
            break;
        }
        case HudAnimatedTypeRight:
        {
            self.frame = CGRectMake(self.frame.size.width,0, self.frame.size.width, self.frame.size.height);
            [UIView animateWithDuration:0.5 animations:^{
                self.frame = CGRectMake(0,0, self.frame.size.width, self.frame.size.height);
            }];
            break;
        }
        case HudAnimatedTypeTop:
        {
            self.frame = CGRectMake(0,-self.frame.size.height, self.frame.size.width, self.frame.size.height);
            [UIView animateWithDuration:0.5 animations:^{
                self.frame = CGRectMake(0,0, self.frame.size.width, self.frame.size.height);
            }];
            break;
        }
        case HudAnimatedTypeBottle:
        {
            self.frame = CGRectMake(0,self.frame.size.height, self.frame.size.width, self.frame.size.height);
            [UIView animateWithDuration:0.5 animations:^{
                self.frame = CGRectMake(0,0, self.frame.size.width, self.frame.size.height);
            }];
            break;
        }
        case HudAnimatedTypeChangeGradually:
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

#pragma mark 活动视图消失时的动画
- (void)loadingHudDisappearAnimated:(HudAnimatedType)animatedType
{
    
    switch (animatedType) {
        case HudAnimatedTypeNone:
            [self removeFromSuperview];
            break;
        case HudAnimatedTypeLeft:
        {
            [UIView animateWithDuration:0.5 animations:^{
                self.frame = CGRectMake(-self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
            break;
        }
        case HudAnimatedTypeRight:
        {
            [UIView animateWithDuration:0.5 animations:^{
                self.frame = CGRectMake(self.frame.size.width,0, self.frame.size.width, self.frame.size.height);
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
            break;
        }
        case HudAnimatedTypeTop:
        {
            [UIView animateWithDuration:0.5 animations:^{
                self.frame = CGRectMake(0, -self.frame.size.height, self.frame.size.width, self.frame.size.height);
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
            break;
        }
        case HudAnimatedTypeBottle:
        {
            [UIView animateWithDuration:0.5 animations:^{
                self.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
            break;
        }
        case HudAnimatedTypeChangeGradually:
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

- (void)dealloc
{
    NSLog(@"LGProgressHud dealloc");
}

@end
