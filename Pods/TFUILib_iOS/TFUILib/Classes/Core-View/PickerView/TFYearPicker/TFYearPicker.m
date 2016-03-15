//
//  TFYearPicker.m
//  TFUILib
//
//  Created by xiayiyong on 16/1/12.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFYearPicker.h"
#import "TFBaseLib.h"
#import <Masonry.h>

#define BTN_WIDTH 70
#define BTN_HEIGHT 40

#define DATE_PICK_HEIGHT 220

#define ANIMATION_DURATION_TIME 0.3

#define kStartYear 2000

@interface TFYearPicker ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, strong) TFYearPickerBlock block;

@property (nonatomic, strong) NSMutableArray *yearArray;

@property (nonatomic, strong) UIPickerView *yearPicker;

@property (nonatomic, strong) UIButton *maskButton;
@property (nonatomic, strong) UIView *alertView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *okButton;

@property (nonatomic,assign) NSInteger minYear;
@property (nonatomic,assign) NSInteger maxYear;
@property (nonatomic,strong) NSString *currentYear;

@end

@implementation TFYearPicker

+ (void)showWithBlock:(TFYearPickerBlock)block
{
    TFYearPicker *view=[[TFYearPicker alloc]initWithBlock:block];
    [view show:^(BOOL finished) {
        
    }];
}

- (id)initWithBlock:(TFYearPickerBlock)block
{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        self.maskButton = [[UIButton alloc] initWithFrame:self.frame];
        self.maskButton.backgroundColor = HEXCOLOR(0X000008,0.5) ;
        [self.maskButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.maskButton];
        
        self.alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, BTN_HEIGHT+DATE_PICK_HEIGHT)];
        self.alertView.backgroundColor = HEXCOLOR(0XFAFAFD,  1);
        [self addSubview:self.alertView];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, BTN_HEIGHT, self.frame.size.width, 0.5)];
        lineView.backgroundColor = HEXCOLOR(0XEFEFF4,  1);
        [self.alertView addSubview:lineView];
        
        self.cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, BTN_WIDTH, BTN_HEIGHT)];
        self.cancelButton.backgroundColor = [UIColor clearColor];
        [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancelButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [self.cancelButton setTitleColor:HEXCOLOR(0X333333,  1) forState:UIControlStateNormal];
        [self.cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.alertView addSubview:self.cancelButton];
        
        self.okButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-BTN_WIDTH, 0, BTN_WIDTH, BTN_HEIGHT)];
        self.okButton.backgroundColor = [UIColor clearColor];
        [self.okButton setTitle:@"确认" forState:UIControlStateNormal];
        [self.okButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [self.okButton setTitleColor:HEXCOLOR(0X03A9F4,  1) forState:UIControlStateNormal];
        [self.okButton setTitleColor:HEXCOLOR(0X0077DD,  1) forState:UIControlStateHighlighted];
        [self.okButton addTarget:self action:@selector(okButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.alertView addSubview:self.okButton];
        
        self.yearPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, BTN_HEIGHT+1, self.frame.size.width, DATE_PICK_HEIGHT)];
        self.yearPicker.backgroundColor = [UIColor whiteColor];
        self.yearPicker.delegate=self;
        self.yearPicker.dataSource=self;
        [self.alertView addSubview:self.yearPicker];
        
        [self.yearPicker selectRow:self.yearArray.count-1 inComponent:0 animated:YES];
        
        self.block=block;
        
    }
    return self;
}

#pragma -mark - picker view delegate

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.yearArray count];
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%@年",self.yearArray[row]];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.currentYear = self.yearArray[row];
}

- (void)show:(void (^)(BOOL finished))completion
{
    self.maskButton.alpha = 0;
    self.alertView.frame = CGRectMake(0, SCREEN_HEIGHT, self.alertView.frame.size.width, self.alertView.frame.size.height);
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    
    [UIView animateWithDuration:ANIMATION_DURATION_TIME
                          delay:0
                        options:UIViewAnimationOptionCurveLinear animations:^{
                            self.maskButton.alpha = 1;
                            [self.alertView setFrame:CGRectMake(0, SCREEN_HEIGHT-(DATE_PICK_HEIGHT+BTN_HEIGHT), self.alertView.frame.size.width, self.alertView.frame.size.height)];
                        } completion:^(BOOL finished) {
                            if (completion) {
                                completion(finished);
                            }
                        }];
}

- (void)hide:(void (^)(BOOL finished))completion
{
    [UIView animateKeyframesWithDuration:ANIMATION_DURATION_TIME
                                   delay:0
                                 options:UIViewKeyframeAnimationOptionLayoutSubviews
                              animations:^{
                                  self.maskButton.alpha = 0;
                                  [self.alertView setFrame:CGRectMake(0, SCREEN_HEIGHT, self.alertView.frame.size.width, self.alertView.frame.size.height)];
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

-(void)okButtonClick
{
    WS(weakSelf)
    [self hide:^(BOOL finished) {
        if (weakSelf.block)
        {
            weakSelf.block(weakSelf.currentYear);
        }
    }];
}

-(NSString *)currentYear
{
    NSInteger row=[self.yearPicker selectedRowInComponent:0];
    NSString *year=self.yearArray[row];
    NSLog(@"year=%@",year);
    return year;
}

-(NSInteger)maxYear
{
    if (_maxYear==0)
    {
        NSDate *dateNow = [NSDate date];
        _maxYear = [[NSDate stringFromTime:dateNow format:@"yyyy"]integerValue];
    }
    
    return _maxYear;
}

-(NSInteger)minYear
{
    if (_minYear==0)
    {
        _minYear = kStartYear;
    }
    
    return _minYear;
}

-(NSMutableArray *)yearArray
{
    if (_yearArray==nil)
    {
        _yearArray=[[NSMutableArray alloc]init];
        for (NSInteger year = self.minYear; year<=self.maxYear ; year++)
        {
            [_yearArray addObject:[NSString stringWithFormat:@"%ld",year]];
        }
    }
    
    return _yearArray;
}

@end