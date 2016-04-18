//
//  TFNewsLoopView.m
//  TFUILib
//
//  Created by 张国平 on 16/3/8.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFNewsLoopView.h"

#define LABELTAG 10231

@implementation TFNewsLoopViewItem

@end

@interface TFNewsLoopView ()
{
    UIScrollView *abstractScrollview;
    CGPoint _offsetpy;
    NSInteger autoIndex;
    NSArray *_itemarray;
    CGFloat _height;
    CGFloat _width;
    NSTimer *m_timer;
}

@property (nonatomic, assign) TFNewsLoopViewScrollDirection loopViewScrollDirection;

/**
 *   当前位置
 */
@property(nonatomic,readonly) CGPoint  currentOffset;

/**
 *  返回数据
 */
@property(nonatomic,strong) NSArray   *itemArray;

- (void)makeselfUI;

@end

@implementation TFNewsLoopView

-(void)makeselfUI
{
    autoIndex=0;
    
    if (abstractScrollview)
    {
        [abstractScrollview removeFromSuperview];
        abstractScrollview = nil;
    }
    
    CGSize contSize;
    // 根据滚动方向设置ContentSize
    if (self.loopViewScrollDirection == kNewsLoopViewScrollDirectionVertical)
    {
        contSize = CGSizeMake(self.frame.size.width, ([_itemarray count]+1)*_height);
    }
    else
    {
        contSize = CGSizeMake(([_itemarray count]+1)*_width, self.frame.size.height);
    }
    
    abstractScrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,_width , _height)];
    [self addSubview:abstractScrollview];
    abstractScrollview.showsVerticalScrollIndicator = NO;
    [abstractScrollview setContentSize:contSize];
    
    for (int i=0; i<[_itemarray count]; i++)
    {
        TFNewsLoopViewItem *obj=(TFNewsLoopViewItem*)[_itemarray objectAtIndex:i];
        
        
        CGRect labelFram;
        // 根据滚动方向设置ContentSize
        if (self.loopViewScrollDirection == kNewsLoopViewScrollDirectionVertical)
        {
            labelFram = CGRectMake(0, _height*i, _width, _height);
        }
        else
        {
            labelFram = CGRectMake(_width*i, 0, _width, _height);
        }
        
        UILabel *label=[[UILabel alloc]initWithFrame:labelFram];
        label.backgroundColor = [UIColor clearColor];
        [label setText:obj.title];
        label.tag=LABELTAG+i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapInLabel:)];
        [label addGestureRecognizer:tap];
        label.userInteractionEnabled = YES;
        [abstractScrollview addSubview:label];
        
        if (i==[_itemarray count]-1)
        {
            
            TFNewsLoopViewItem *obj=(TFNewsLoopViewItem*)[_itemarray objectAtIndex:0];
            
            CGRect lastFrame;
            
            if (self.loopViewScrollDirection == kNewsLoopViewScrollDirectionVertical)
            {
                lastFrame = CGRectMake(0, _height*(i+1), _width, _height);
            }
            else
            {
                lastFrame = CGRectMake(_width*(i+1), 0, _width, _height);
            }
            UILabel *labelLast=[[UILabel alloc]initWithFrame:lastFrame];
            [labelLast setText:obj.title];
            labelLast.tag=LABELTAG+i+1;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapInLabel:)];
            [label addGestureRecognizer:tap];
            label.userInteractionEnabled = YES;
            [abstractScrollview addSubview:labelLast];
        }
    }
    
    abstractScrollview.contentOffset=CGPointMake(0, 0);
}

- (void)tapInLabel:(UITapGestureRecognizer*)tap
{
    if (self.didSelectItemAtIndexHandler)
    {
        self.didSelectItemAtIndexHandler(tap.view.tag-LABELTAG);
    }

    NSLog(@"%ld",tap.view.tag-LABELTAG);
    
}

-(CGPoint)currentOffset
{
    return _offsetpy;
}

-(NSArray*)itemArray
{
    return _itemarray;
}

- (instancetype)initWithFrame:(CGRect)frame
                        items:(NSArray*)teams
                    direction:(TFNewsLoopViewScrollDirection)scrollDirection
                        block:(void (^)(NSInteger))block

{
    self = [super initWithFrame:frame];
    if (self)
    {
        _itemarray=teams;
        _offsetpy=CGPointMake(0, 0);
        
        _width=self.frame.size.width;
        _height=self.frame.size.height;
        
        assert([teams count]!=0);
        self.loopViewScrollDirection = scrollDirection;
        self.didSelectItemAtIndexHandler = block;
       
        
    }
    return self;
}

/**
 *  开始时间
 */
- (void)start
{
    if (m_timer == nil)
    {
        m_timer = [NSTimer timerWithTimeInterval:3.0 target:self selector:@selector(updateTitle) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:m_timer forMode:NSRunLoopCommonModes];
    }
}

/**
 *  停止时间
 */
- (void)stop
{
    if ([m_timer isValid])
    {
        [m_timer invalidate];
        m_timer = nil;
    }
    
}

- (void)updateTitle
{
    // 起始位置
    UIView *topLabel = (UIView *)[abstractScrollview viewWithTag:LABELTAG];
    CGPoint point1 = CGPointMake(0, 0);
    point1 = topLabel.frame.origin;
    
    // 最后标签位置
    UIView *lastlabel=(UIView *)[abstractScrollview viewWithTag:LABELTAG+[_itemarray count]];
    
    // 当前标签位置
    CGPoint point = [abstractScrollview contentOffset];
    
    CGPoint pointmiddle=CGPointMake(0,0);
    
    if (self.loopViewScrollDirection == kNewsLoopViewScrollDirectionVertical)
    {
        if (point.y >=lastlabel.frame.origin.y)
        {
            autoIndex=0;
            abstractScrollview.contentOffset = point1;
        }
        
        UIView *view=(UIView*)[abstractScrollview viewWithTag:autoIndex+LABELTAG+1];
        pointmiddle=CGPointMake(0, view.frame.origin.y);
    }
    else
    {
        if (point.x >=lastlabel.frame.origin.x)
        {
            autoIndex=0;
            abstractScrollview.contentOffset = point1;
        }
        UIView *view=(UIView*)[abstractScrollview viewWithTag:autoIndex+LABELTAG+1];
        pointmiddle=CGPointMake(view.frame.origin.x, 0);
    }
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    
    autoIndex +=1;
    abstractScrollview.contentOffset = pointmiddle;
    
    [UIView commitAnimations];
    
}

- (void)setLoopViewScrollDirection:(TFNewsLoopViewScrollDirection)loopViewScrollDirection
{
    _loopViewScrollDirection = loopViewScrollDirection;

    [self makeselfUI];
    [self start];
}

-(void)dealloc
{
    [self stop];
}


@end
