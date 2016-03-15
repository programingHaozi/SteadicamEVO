//
//  TFSegmentedControl.m
//  Treasure
//
//  Created by xiayiyong on 16/1/15.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFSegmentedControl.h"

@interface TFSegmentedControl ()<TFSegmentedDelegate>

@property (nonatomic,assign)CGFloat widthFoat;
//下划线
@property (nonatomic,strong)UIView *buttonDownView;

@property (nonatomic,assign)NSInteger selectSeugment;

@end

@implementation TFSegmentedControl

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.btnTitleSource = [NSMutableArray array];
        self.selectSeugment = 0;
    }
    
    return self;
}

+ (TFSegmentedControl *)segmentedControlFrame:(CGRect)frame
                                    titleDataSource:(NSArray *)titleDataSouece
                                    backgroundColor:(UIColor *)backgroundColor
                                         titleColor:(UIColor *)titleColor
                                          titleFont:(UIFont *)titleFont
                                        selectColor:(UIColor *)selectColor
                                    buttonDownColor:(UIColor *)buttonDownColor
                                           delegate:(id)delegate
{
    TFSegmentedControl *smc = [[self alloc] initWithFrame:frame];
    smc.backgroundColor           = backgroundColor;
    smc.buttonDownColor           = buttonDownColor;

    smc.titleColor                = titleColor;
    smc.titleFont                 = titleFont;
    smc.selectColor               = selectColor;
    smc.delegate                  = delegate;
    
    [smc addSegumentArray:titleDataSouece];
    
    return smc;
}

- (void)addSegumentArray:(NSArray *)segumentArray
{
    
    // 1.按钮的个数
    NSInteger seugemtNumber = segumentArray.count;
    
    // 2.按钮的宽度
    self.widthFoat = (self.bounds.size.width) / seugemtNumber;
    
    // 3.创建按钮
    for (int i = 0; i < segumentArray.count; i++)
    {
        
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(i * self.widthFoat, 0, self.widthFoat, self.bounds.size.height - 2)];
        
        [btn setTitle:segumentArray[i] forState:UIControlStateNormal];
        [btn.titleLabel setFont:self.titleFont];
        [btn setTitleColor:self.titleColor forState:UIControlStateNormal];
        [btn setTitleColor:self.selectColor forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(changeSegumentAction:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0)
        {
            self.buttonDownView =[[UIView alloc]initWithFrame:CGRectMake(i * self.widthFoat, self.bounds.size.height - 2, self.widthFoat, 2)];
            [self.buttonDownView setBackgroundColor:self.buttonDownColor];
            
            [self addSubview:self.buttonDownView];
        }
        
        btn.tag = i + 100;
        
        [self addSubview:btn];
        
        [self.btnTitleSource addObject:btn];
    }
    
    [[self.btnTitleSource firstObject] setSelected:YES];
}

- (void)changeSegumentAction:(UIButton *)btn
{
    [self selectTheSegument:btn.tag - 100];
}

- (void)selectTheSegument:(NSInteger)segument
{
    
    if (self.selectSeugment != segument)
    {
        
        [self.btnTitleSource[self.selectSeugment] setSelected:NO];
        [self.btnTitleSource[segument] setSelected:YES];
        
        [UIView animateWithDuration:0.2 animations:^{
            
            [self.buttonDownView setFrame:CGRectMake(segument * self.widthFoat,self.bounds.size.height - 2, self.widthFoat, 2)];
        }];
        self.selectSeugment = segument;
        
        if ([self.delegate respondsToSelector:@selector(segumentSelectionChange:)])
        {
            [self.delegate segumentSelectionChange:self.selectSeugment];
        }
    }
}

@end
