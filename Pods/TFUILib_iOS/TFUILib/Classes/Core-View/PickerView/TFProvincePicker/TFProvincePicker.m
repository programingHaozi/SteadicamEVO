//
//  TFProvincePicker.m
//  Treasure
//
//  Created by xiayiyong on 16/1/25.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFProvincePicker.h"
#import "TFBaseLib.h"
#import <Masonry.h>

#pragma mark -
#pragma mark MoreFunctionViewCell

@interface TFProvinceItemCell : UICollectionViewCell

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) NSString  *data;

@end

@implementation TFProvinceItemCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clipsToBounds=YES;
        self.backgroundColor=[UIColor clearColor];
        
        self.clipsToBounds=YES;
        
        UIView *backgroundView=[[UIView alloc]init];
        [backgroundView setBackgroundColor:HEXCOLOR(0x666666, 1)];
        self.selectedBackgroundView=backgroundView;
        
        self.titleLabel = UILabel.new;
        self.titleLabel.textAlignment=NSTextAlignmentCenter;
        self.titleLabel.textColor=HEXCOLOR(0x333333, 1);
        self.titleLabel.font=FONT(15);
        self.titleLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.titleLabel.layer.borderWidth = 1.0;
        
        [self.contentView addSubview:self.titleLabel];
        
        WS(weaksekf)
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weaksekf);
            make.centerY.equalTo(weaksekf);
            make.top.equalTo(weaksekf).offset(5);
            make.left.equalTo(weaksekf).offset(5);
            
        }];
    }
    return self;
}

-(void)setData:(NSString *)data
{
    _data=data;
    self.titleLabel.text=data;
}

@end

@interface TFProvincePicker ()<UICollectionViewDataSource,UICollectionViewDelegate>

#define ANIMATION_DURATION_TIME 0.3

@property (nonatomic, strong) TFProvincePickerBlock block;

@property (nonatomic, strong) UIButton *maskView;

@property (nonatomic, strong) UIView *alertView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSArray *dataArray;

@property (assign, nonatomic) NSInteger numOfRow;

@end

#pragma mark -
#pragma mark TFProvincePicker

@implementation TFProvincePicker

#pragma mark - UICollectionViewDataSource

+ (void)showWithBlock:(TFProvincePickerBlock)block
{
    TFProvincePicker *view=[[TFProvincePicker alloc]initWithBlock:block];
    [view show:^(BOOL finished) {
        
    }];
}

- (id)initWithBlock:(TFProvincePickerBlock)block
{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (self)
    {
        self.clipsToBounds=YES;
        self.backgroundColor = [UIColor clearColor];
        
        self.numOfRow=8;
        
        [self addSubview:self.backgroundView];
        [self addSubview:self.alertView];
        [self.alertView addSubview:self.titleLabel];
        [self.alertView addSubview:self.collectionView];
        
        [self autolayoutViews];
        
        self.block=block;
        
    }
    return self;
}

+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

-(void)autolayoutViews
{
    WS(weakSelf)
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.alertView).offset(10);
        make.top.equalTo(weakSelf.alertView).offset(-10);;
        make.right.equalTo(weakSelf.alertView);
        make.height.equalTo(@(44));
    }];

    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.alertView);
        make.top.equalTo(weakSelf.titleLabel.mas_bottom);
        make.right.equalTo(weakSelf.alertView);
        make.bottom.equalTo(weakSelf.alertView);
    }];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"TFProvinceItemCell";
    TFProvinceItemCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.data=self.dataArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *data=self.dataArray[indexPath.row];
    
    WS(weakSelf)
    [self hide:^(BOOL finished) {
        if (weakSelf.block)
        {
            weakSelf.block(data);
        }
    }];
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark show hide

- (void)show:(void (^)(BOOL finished))completion
{
    self.backgroundView.alpha = 0;
    self.alertView.frame = CGRectMake(0, SCREEN_HEIGHT, self.alertView.frame.size.width, self.alertView.frame.size.height);
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:ANIMATION_DURATION_TIME
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                              weakSelf.backgroundView.alpha = 1;
                              _alertView.frame = CGRectMake(0, SCREEN_HEIGHT-_alertView.frame.size.height, _alertView.frame.size.width, _alertView.frame.size.height);
                          } completion:^(BOOL finished) {
                              if (completion) {
                                  completion(finished);
                              }
                          }];
}

- (void)hide:(void (^)(BOOL finished))completion
{
    __weak typeof(self) weakSelf = self;
    
    [UIView animateKeyframesWithDuration:ANIMATION_DURATION_TIME
                                   delay:0
                                 options:UIViewKeyframeAnimationOptionLayoutSubviews
                              animations:^{
                                  weakSelf.backgroundView.alpha = 0;
                                  _alertView.frame = CGRectMake(0, SCREEN_HEIGHT, _alertView.frame.size.width, _alertView.frame.size.height);
                              }
                              completion:^(BOOL finished) {
                                  [self removeFromSuperview];
                                  if (completion) {
                                      completion(finished);
                                  }
                              }];
}

-(void)cancelButtonClick
{
    [self hide:^(BOOL finished) {
        
    }];
}

#pragma mark -
#pragma mark setter getter
-(NSArray *)dataArray
{
    if (_dataArray==nil)
    {
        _dataArray = @[@"云",@"京",@"吉",@"宁",@"新",@"晋",@"桂",@"沪"
                             ,@"浙",@"渝",@"琼",@"甘",@"皖",@"粤",@"苏",@"蒙"
                             ,@"藏",@"豫",@"贵",@"辽",@"鄂",@"闽",@"陕",@"青"
                             ,@"鲁",@"黑",@"津",@"冀",@"赣",@"湘",@"川"];
    }
    
    return _dataArray;
}

-(UIButton *)backgroundView
{
    if (_maskView==nil)
    {
        _maskView = [[UIButton alloc] initWithFrame:self.frame];
        _maskView.backgroundColor = HEXCOLOR(0X000008,0.5);
        [_maskView addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _maskView;
}

-(UIView *)alertView
{
    if (_alertView==nil)
    {
        _alertView = [[UIView alloc] init];
        _alertView.frame=CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, [self alertViewHeight]);
        _alertView.backgroundColor=HEXCOLOR(0xeeeeee, 1);;
    }
    
    return _alertView;
}

-(UILabel *)titleLabel
{
    if (_titleLabel==nil)
    {
        _titleLabel = UILabel.new;
        _titleLabel.text=@"请选择车牌前缀";
        _titleLabel.textAlignment=NSTextAlignmentLeft;
        _titleLabel.textColor=HEXCOLOR(0x333333, 1);
        _titleLabel.font=FONT(15);
    }
    
    return _titleLabel;
}

-(UICollectionView *)collectionView
{
    if (_collectionView==nil)
    {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.itemSize=CGSizeMake(SCREEN_WIDTH/self.numOfRow,SCREEN_WIDTH/self.numOfRow);;
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor=[UIColor whiteColor];
        [_collectionView registerClass:[TFProvinceItemCell class] forCellWithReuseIdentifier:@"TFProvinceItemCell"];
        [_collectionView setDelegate:self];
        [_collectionView setDataSource:self];
        [_collectionView setScrollEnabled:NO];
    }
    
    return _collectionView;
}

-(CGFloat)alertViewHeight
{
    CGFloat xxx=SCREEN_WIDTH/self.numOfRow;
    NSInteger yyy=self.dataArray.count/self.numOfRow+(self.dataArray.count%self.numOfRow!=0?1:0);
    int height=xxx*yyy+44;
    return height;
}

@end
