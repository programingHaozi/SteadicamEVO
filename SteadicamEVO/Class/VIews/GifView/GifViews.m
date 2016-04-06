//
//  GifViews.m
//  SteadicamEVO
//
//  Created by 耗子 on 16/4/5.
//  Copyright © 2016年 haozi. All rights reserved.
//

#import "GifViews.h"
#import <MediaPlayer/MediaPlayer.h>

@interface GifViews()

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) UIWebView *gifView;

@property (nonatomic, strong) TFLabel *promptLabel;

@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;

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
    self.bgImageView = [[UIImageView alloc]init];
    self.bgImageView.image = IMAGE(@"guideGifBg");
    [self addSubview:self.bgImageView];
    
//    self.gifView = [[UIWebView alloc]init];
    
//    //自动调整尺寸
//    self.gifView.scalesPageToFit = YES;
//    //禁止滚动
//    self.gifView.scrollView.scrollEnabled = NO;
//    //设置透明效果
//    self.gifView.backgroundColor = [UIColor clearColor];
//    self.gifView.opaque = 0;
//    
//    [self addSubview:self.gifView];
    
   
    self.moviePlayer = [[MPMoviePlayerController alloc]init];
    self.moviePlayer.controlStyle = MPMovieControlStyleNone;
    self.moviePlayer.shouldAutoplay = YES;
    self.moviePlayer.repeatMode = MPMovieRepeatModeOne;
    [self.moviePlayer setFullscreen:YES animated:YES];
    self.moviePlayer.scalingMode = MPMovieScalingModeFill;
    
    [self addSubview:self.moviePlayer.view];
    
    
//    self.promptLabel = [[TFLabel alloc]init];
//    self.promptLabel.backgroundColor = [UIColor clearColor];
//    self.promptLabel.textColor = [UIColor whiteColor];
//    self.promptLabel.numberOfLines = 0;
//    self.promptLabel.verticalTextAlignment = UIControlContentVerticalAlignmentTop;
//    self.promptLabel.text = @"Series of GIFs to show how to use EVO";
//    
//    [self addSubview:self.promptLabel];
    
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
    
//    [self.gifView mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.top.equalTo(weakSelf.mas_top).offset(0);
//        make.left.equalTo(weakSelf.mas_left).offset(0);
//        make.bottom.equalTo(weakSelf.mas_bottom).offset(0);
//        make.right.equalTo(weakSelf.mas_right).offset(0);
//    }];
    
    [self.moviePlayer.view mas_makeConstraints:^(MASConstraintMaker *make) {
        
                make.top.equalTo(weakSelf.mas_top).offset(0);
                make.left.equalTo(weakSelf.mas_left).offset(0);
                make.bottom.equalTo(weakSelf.mas_bottom).offset(0);
                make.right.equalTo(weakSelf.mas_right).offset(0);
    }];
    
//    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.top.equalTo(weakSelf.mas_top).offset(65);
//        make.left.equalTo(weakSelf.mas_left).offset(35);
//        make.bottom.equalTo(weakSelf.mas_bottom).offset(0);
//        make.right.equalTo(weakSelf.mas_right).offset(-35);
//    }];
}

-(void)bindData
{
    [RACObserve(self, moviePath) subscribeNext:^(NSString * str) {
        
        if (self.moviePlayer && str)
        {
//            if (self.moviePlayer.playbackState == MPMoviePlaybackStatePlaying)
//            {
//                return ;
//            }
            
            NSURL *url = [NSURL fileURLWithPath:str];
            [self.moviePlayer setContentURL:url];
            [self.moviePlayer play];
        }
    }];
}

@end
