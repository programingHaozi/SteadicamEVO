//
//  GifViews.m
//  SteadicamEVO
//
//  Created by 耗子 on 16/4/5.
//  Copyright © 2016年 haozi. All rights reserved.
//

#import "GifViews.h"


@interface GifViews()

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, strong) AVAsset *movieAsset;

@property (nonatomic, strong) AVPlayerItem *playerItem;

@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@end

@implementation GifViews

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self initViews];
        [self autolayoutViews];
        [self bindData];
    }
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self initViews];
        [self autolayoutViews];
        [self bindData];
    }
    
    return self;
}

- (void)initViews
{
    self.bgImageView       = [[UIImageView alloc]init];
    self.bgImageView.image = IMAGE(@"guideGifBg");
    [self addSubview:self.bgImageView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(runLoopTheMovie:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
}

-(void)autolayoutViews
{
    WS(weakSelf)
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakSelf.mas_top).offset(0);
        make.left.equalTo(weakSelf.mas_left).offset(0);
        make.bottom.equalTo(weakSelf.mas_bottom).offset(0);
        make.right.equalTo(weakSelf.mas_right).offset(0);
    }];
}

-(void)bindData
{
    [RACObserve(self, moviePath) subscribeNext:^(NSString * str) {
        
        [self reset];
        
        if ([str hasSuffix:@"png"])
        {
            self.bgImageView.image = [UIImage imageWithContentsOfFile:str];
        }
        else if ([str hasSuffix:@"mov"])
        {
            NSURL *url = [NSURL fileURLWithPath:str];
            
            self.movieAsset               = [AVURLAsset URLAssetWithURL:url options:nil];
            self.playerItem               = [AVPlayerItem playerItemWithAsset:self.movieAsset];
            self.player                   = [AVPlayer playerWithURL:url];
            self.player.muted             = YES;
            self.playerLayer              = [AVPlayerLayer playerLayerWithPlayer:self.player];
            self.playerLayer.frame        = self.bounds;
            self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            
            [self.layer addSublayer:self.playerLayer];
            [self.player play];
        }
        
    }];
    
    [RACObserve(self, mas_width) subscribeNext:^(id x) {
        NSLog(@"%f",self.width);
    }];
}

#pragma mark - private method -

-(void)reset
{
    self.bgImageView.image = IMAGE(@"guideGifBg");
    
    [self.playerLayer removeFromSuperlayer];
    
    self.playerLayer = nil;
}

- (void)runLoopTheMovie:(NSNotification *)n{
    //注册的通知  可以自动把 AVPlayerItem 对象传过来，只要接收一下就OK
    
    AVPlayerItem * p = [n object];
    //关键代码
    [p seekToTime:kCMTimeZero];
    
    [self.player play];
}

@end
