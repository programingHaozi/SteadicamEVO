//
//  CustomPicker.m
//  Grape-ToC-Iphone
//
//  Created by Xuehan Gong on 14-6-10.
//  Copyright (c) 2014年 Chexiang. All rights reserved.
//

#import "LBCustomPicker.h"

#define BTN_WIDTH 70
#define BTN_HEIGHT 40

#define DATE_PICK_HEIGHT 220

#define PICKER_DURATION 0.3

@interface LBCustomPicker()

@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIButton *btnCancel;
@property (nonatomic, strong) UIButton *btnConfirm;

@end

@implementation LBCustomPicker

@synthesize delegate;

@synthesize datePicker;
@synthesize btnCancel;
@synthesize btnConfirm;

- (id)initWithFrame:(CGRect)frame type:(dateSelectType) type
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.frame = CGRectMake(0, BTN_HEIGHT+DATE_PICK_HEIGHT, frame.size.width, frame.size.height);
        self.backgroundColor = [UIColor clearColor];
        
        UIButton *mask = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - (BTN_HEIGHT+DATE_PICK_HEIGHT))];
        mask.backgroundColor = [UIColor clearColor];
        [mask addTarget:self action:@selector(onClickCancel) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:mask];
        
        UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, mask.frame.size.height, frame.size.width, BTN_HEIGHT+DATE_PICK_HEIGHT)];
        bg.backgroundColor = [UIColor whiteColor];
        [self addSubview:bg];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, mask.frame.size.height, self.frame.size.width, 1)];
        line.backgroundColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0];
        [self addSubview:line];
        
        line = [[UIView alloc] initWithFrame:CGRectMake(0, mask.frame.size.height+BTN_HEIGHT, self.frame.size.width, 1)];
        line.backgroundColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0];
        [self addSubview:line];
        
        btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(0, mask.frame.size.height, BTN_WIDTH, BTN_HEIGHT)];
        btnCancel.backgroundColor = [UIColor clearColor];
        [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
        [btnCancel.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [btnCancel setTitleColor:[UIColor colorWithRed:13/255.0 green:148/255.0 blue:252/255.0 alpha:1.0] forState:UIControlStateNormal];
        [btnCancel addTarget:self action:@selector(onClickCancel) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnCancel];
        
        btnConfirm = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-BTN_WIDTH, mask.frame.size.height, BTN_WIDTH, BTN_HEIGHT)];
        btnConfirm.backgroundColor = [UIColor clearColor];
        [btnConfirm setTitle:@"确认" forState:UIControlStateNormal];
        [btnConfirm.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [btnConfirm setTitleColor:[UIColor colorWithRed:13/255.0 green:148/255.0 blue:252/255.0 alpha:1.0] forState:UIControlStateNormal];
        [btnConfirm addTarget:self action:@selector(onClickConfirm) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnConfirm];
        
        datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, mask.frame.size.height+BTN_HEIGHT+1, self.frame.size.width, DATE_PICK_HEIGHT)];
        datePicker.backgroundColor = [UIColor whiteColor];
        [datePicker setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        // [datePicker setMaximumDate:[NSDate date]];
        [datePicker setDatePickerMode:(UIDatePickerMode)type];
        [self addSubview:datePicker];
        
        [self show:^(BOOL finished) {
            
        }];
    }
    return self;
}

- (void)onClickCancel
{
    [self dismiss:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)onClickConfirm
{
    [self dismiss:^(BOOL finished) {
        if ([delegate respondsToSelector:@selector(selectDate:)]) {
            [delegate selectDate:[NSString stringWithFormat:@"%d", (int)[datePicker.date timeIntervalSince1970]]];
        }
        [self removeFromSuperview];
    }];
}

- (void)show:(void (^)(BOOL finished))completion
{
    [UIView animateKeyframesWithDuration:PICKER_DURATION
                                   delay:0
                                 options:UIViewKeyframeAnimationOptionLayoutSubviews
                              animations:^{
                                  [self setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
                              }
                              completion:^(BOOL finished) {
                                  if (completion) {
                                      completion(finished);
                                  }
                              }];
}

- (void)dismiss:(void (^)(BOOL finished))completion
{
    [UIView animateKeyframesWithDuration:PICKER_DURATION
                                   delay:0
                                 options:UIViewKeyframeAnimationOptionLayoutSubviews
                              animations:^{
                                  NSLog(@"height:%f", self.frame.size.height);
                                  [self setFrame:CGRectMake(0, BTN_HEIGHT+DATE_PICK_HEIGHT, self.frame.size.width, self.frame.size.height)];
                              }
                              completion:^(BOOL finished) {
                                  if (completion) {
                                      completion(finished);
                                  }
                              }];
}

@end
