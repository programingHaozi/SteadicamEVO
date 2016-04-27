//
//  TFActionSheet.m
//  TFUILib
//
//  Created by xiayiyong on 16/2/3.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFActionSheet.h"

// 按钮高度
#define BUTTON_H 49.0f
// 屏幕尺寸
#define SCREEN_SIZE [UIScreen mainScreen].bounds.size
// 颜色
#define LCColor(r, g, b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0f]

#define LC_ACTION_SHEET_TITLE_FONT  [UIFont systemFontOfSize:18.0f]

#define LC_DEFAULT_ANIMATION_DURATION 0.3f

#define LC_DEFAULT_BACKGROUND_OPACITY 0.3f


@interface TFActionSheet()

/** 暗黑色的view */
@property (nonatomic, strong) UIView *darkView;

/** 所有按钮的底部view */
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UIWindow *backWindow;

@property(nonatomic) NSInteger cancelButtonIndex;

@property(nonatomic) NSInteger destructiveButtonIndex;

@property(nonatomic) NSInteger firstOtherButtonIndex;

/** 所有按钮 */
@property (nonatomic, strong) NSMutableArray *buttonTitles;

@end

@implementation TFActionSheet

#pragma mark - show block

+ (void) showWithTitle:(NSString *)title
     cancelButtonTitle:(NSString *)cancelButtonTitle
destructiveButtonTitle:(NSString *)destructiveButtonTitle
     otherButtonTitles:(NSArray *)otherButtonTitles
                 block:(void (^)(NSInteger))block
{
    TFActionSheet *alert = [[self alloc]initWithTitle:title
                                             cancelButtonTitle:cancelButtonTitle
                                        destructiveButtonTitle:destructiveButtonTitle
                                             otherButtonTitles:otherButtonTitles
                                                         block:block];
    
    [alert show];
}

+ (void) showWithTitle:(NSString *)title
     cancelButtonTitle:(NSString *)cancelButtonTitle
     otherButtonTitles:(NSArray *)otherButtonTitles
                 block:(void (^)(NSInteger))block
{
    TFActionSheet *alert = [[self alloc]initWithTitle:title
                                             cancelButtonTitle:cancelButtonTitle
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:otherButtonTitles
                                                         block:block];
    
    [alert show];
}

+ (void) showWithTitle:(NSString *)title
     cancelButtonTitle:(NSString *)cancelButtonTitle
destructiveButtonTitle:(NSString *)destructiveButtonTitle
                 block:(void (^)(NSInteger))block
{
    TFActionSheet *alert = [[self alloc]initWithTitle:title
                                             cancelButtonTitle:cancelButtonTitle
                                        destructiveButtonTitle:destructiveButtonTitle
                                             otherButtonTitles:nil
                                                         block:block];
    
    [alert show];
}

+ (void) showWithTitle:(NSString *)title
     buttonTitles:(NSArray *)buttonTitles
                 block:(void (^)(NSInteger))block
{
    TFActionSheet *alert = [[self alloc]initWithTitle:title
                                    cancelButtonTitle:nil
                               destructiveButtonTitle:nil
                                    otherButtonTitles:buttonTitles
                                                block:block];
    
    [alert show];
}

#pragma mark - init block

- (instancetype)initWithTitle:(NSString *)title
            cancelButtonTitle:(NSString *)cancelButtonTitle
       destructiveButtonTitle:(NSString *)destructiveButtonTitle
            otherButtonTitles:(NSArray *)otherButtonTitles
                        block:(ActionSheetBlock)block
{
    
    if (self = [super init])
    {
        self.cancelButtonIndex=-1;
        self.destructiveButtonIndex=-1;
        NSInteger buttonIndex = 0;
        
        self.title = title;
        self.buttonTitles = [[NSMutableArray alloc] init];
        
        if (cancelButtonTitle!=nil&&cancelButtonTitle.length>0)
        {
            [self.buttonTitles addObject:cancelButtonTitle];
            self.cancelButtonIndex=buttonIndex++;
        }
        
        if (destructiveButtonTitle!=nil&&destructiveButtonTitle.length>0)
        {
            [self.buttonTitles addObject:destructiveButtonTitle];
            self.destructiveButtonIndex=buttonIndex++;
        }
        
        if (otherButtonTitles!=nil)
        {
            [self.buttonTitles addObjectsFromArray:otherButtonTitles];
        }
        
        self.clickedBlock = block;
    }
    
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
            cancelButtonTitle:(NSString *)cancelButtonTitle
       destructiveButtonTitle:(NSString *)destructiveButtonTitle
                        block:(void (^)(NSInteger))block
{
    self = [self initWithTitle:title cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:nil block:block];
    if (self)
    {
    }
    return self;
}


- (instancetype)initWithTitle:(NSString *)title
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSArray *)otherButtonTitles
                        block:(void (^)(NSInteger))block
{
    self = [self initWithTitle:title cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:nil otherButtonTitles:otherButtonTitles block:block];
    if (self)
    {
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
                 buttonTitles:(NSArray *)buttonTitles
                        block:(void (^)(NSInteger))block
{
    self = [self initWithTitle:title cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:buttonTitles block:block];
    if (self)
    {
    }
    return self;
}

- (void)setupMainView
{
    // 暗黑色的view
    UIView *darkView = [[UIView alloc] init];
    [darkView setAlpha:0];
    [darkView setUserInteractionEnabled:NO];
    [darkView setFrame:(CGRect){0, 0, SCREEN_SIZE}];
    [darkView setBackgroundColor:LCColor(46, 49, 50)];
    [self addSubview:darkView];
    _darkView = darkView;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
    [darkView addGestureRecognizer:tap];
    
    // 所有按钮的底部view
    UIView *bottomView = [[UIView alloc] init];
    [bottomView setBackgroundColor:LCColor(233, 233, 238)];
    _bottomView = bottomView;
    
    // title
    if (self.title&&self.title.length>0)
    {
        CGFloat vSpace = 0;
        CGSize titleSize = [self.title sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13.0f]}];
        if (titleSize.width > SCREEN_SIZE.width - 30.0f)
        {
            vSpace = 15.0f;
        }
        
        UIView *titleBgView = [[UIView alloc] init];
        titleBgView.backgroundColor = [UIColor whiteColor];
        titleBgView.frame = CGRectMake(0, -vSpace, SCREEN_SIZE.width, BUTTON_H + vSpace);
        [bottomView addSubview:titleBgView];
        
        // 标题
        UILabel *label = [[UILabel alloc] init];
        [label setText:self.title];
        [label setNumberOfLines:2.0f];
        [label setTextColor:LCColor(111, 111, 111)];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:[UIFont systemFontOfSize:13.0f]];
        [label setBackgroundColor:[UIColor whiteColor]];
        [label setFrame:CGRectMake(15.0f, 0, SCREEN_SIZE.width - 30.0f, titleBgView.frame.size.height)];
        [titleBgView addSubview:label];
    }
    
    NSString *bundlePath = [[NSBundle bundleForClass:self.class] pathForResource:@"TFActionSheet" ofType:@"bundle"];
    
    if (self.buttonTitles.count)
    {
        // 所有按钮
        for (NSInteger i = self.cancelButtonIndex+1; i < self.buttonTitles.count; i++)
        {
            UIButton *btn = [[UIButton alloc] init];
            [btn setTag:i];
            [btn setBackgroundColor:[UIColor whiteColor]];
            [btn setTitle:self.buttonTitles[i] forState:UIControlStateNormal];
            [[btn titleLabel] setFont:self.textFont];
            UIColor *titleColor = nil;
            if (i == self.destructiveButtonIndex)
            {
                titleColor = LCColor(255, 10, 10);
            }
            else
            {
                
                titleColor = self.textColor ;
            }
            [btn setTitleColor:titleColor forState:UIControlStateNormal];
            
            NSString *linePath = [bundlePath stringByAppendingPathComponent:@"bgImage_HL@2x.png"];
            UIImage *bgImage = [UIImage imageWithContentsOfFile:linePath];
            
            [btn setBackgroundImage:bgImage forState:UIControlStateHighlighted];
            [btn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            CGFloat btnY = BUTTON_H * ((self.cancelButtonIndex==0?i-1:i) + (self.title&&self.title.length>0 ? 1 : 0));
            [btn setFrame:CGRectMake(0, btnY, SCREEN_SIZE.width, BUTTON_H)];
            [bottomView addSubview:btn];
        }
        
        // 所有线条
        for (NSInteger i = self.cancelButtonIndex+1; i < self.buttonTitles.count; i++)
        {
            NSString *linePath = [bundlePath stringByAppendingPathComponent:@"cellLine@2x.png"];
            UIImage *lineImage = [UIImage imageWithContentsOfFile:linePath];
            
            UIImageView *line = [[UIImageView alloc] init];
            [line setImage:lineImage];
            [line setContentMode:UIViewContentModeTop];
            CGFloat lineY = BUTTON_H * ((self.cancelButtonIndex==0?i-1:i) + (self.title&&self.title.length>0 ? 1 : 0));
            [line setFrame:CGRectMake(0, lineY, SCREEN_SIZE.width, 1.0f)];
            [bottomView addSubview:line];
        }
    }
    
    // cancel 按钮
    if (self.cancelButtonIndex==0)
    {
        NSString *linePath = [bundlePath stringByAppendingPathComponent:@"bgImage_HL@2x.png"];
        UIImage *bgImage = [UIImage imageWithContentsOfFile:linePath];
        
        // 取消按钮
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn setTag:0];
        [cancelBtn setBackgroundColor:[UIColor whiteColor]];
        [cancelBtn setTitle:[self.buttonTitles firstObject] forState:UIControlStateNormal];
        [[cancelBtn titleLabel] setFont:self.textFont];
        [cancelBtn setTitleColor:self.textColor forState:UIControlStateNormal];
        [cancelBtn setBackgroundImage:bgImage forState:UIControlStateHighlighted];
        [cancelBtn addTarget:self action:@selector(didClickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat btnY = BUTTON_H * (self.buttonTitles.count - 1 + (self.title&&self.title.length>0 ? 1 : 0)) + 5.0f;
        [cancelBtn setFrame:CGRectMake(0, btnY, SCREEN_SIZE.width, BUTTON_H)];
        [bottomView addSubview:cancelBtn];
    }
    
    CGFloat bottomH = (self.title&&self.title.length>0 ? BUTTON_H : 0) + BUTTON_H * self.buttonTitles.count + (self.cancelButtonIndex==0 ? 5.0f : 0);
    [bottomView setFrame:CGRectMake(0, SCREEN_SIZE.height, SCREEN_SIZE.width, bottomH)];
    
    [self setFrame:(CGRect){0, 0, SCREEN_SIZE}];
}

- (UIWindow *)backWindow
{
    if (_backWindow == nil)
    {
        _backWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _backWindow.windowLevel       = UIWindowLevelStatusBar;
        _backWindow.backgroundColor   = [UIColor clearColor];
        _backWindow.hidden = NO;
    }
    
    return _backWindow;
}

- (void)didClickBtn:(UIButton *)btn
{
    
    [self dismiss:nil];
    
    if (self.clickedBlock)
    {
        
        self.clickedBlock(btn.tag);
    }
}

- (void)didClickCancelBtn
{
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:self.animationDuration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [_darkView setAlpha:0];
                         [_darkView setUserInteractionEnabled:NO];
                         
                         CGRect frame = _bottomView.frame;
                         frame.origin.y += frame.size.height;
                         [_bottomView setFrame:frame];
                         
                     } completion:^(BOOL finished) {
                         
                         if (weakSelf.clickedBlock)
                         {
                             weakSelf.clickedBlock(weakSelf.buttonTitles.count);
                         }
                         
                         [self removeFromSuperview];
                         
                         weakSelf.backWindow.hidden = YES;
                     }];
}

- (void)show
{
    [self setupMainView];
    self.backWindow.hidden = NO;
    
    [self addSubview:self.bottomView];
    [self.backWindow addSubview:self];
    
    [UIView animateWithDuration:self.animationDuration
                          delay:0 options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [_darkView setAlpha:self.backgroundOpacity];
                         [_darkView setUserInteractionEnabled:YES];
                         
                         CGRect frame = _bottomView.frame;
                         frame.origin.y -= frame.size.height;
                         [_bottomView setFrame:frame];
                     }
                     completion:nil];
}

- (void)dismiss:(UITapGestureRecognizer *)tap
{
    [UIView animateWithDuration:self.animationDuration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [_darkView setAlpha:0];
                         [_darkView setUserInteractionEnabled:NO];
                         
                         CGRect frame = _bottomView.frame;
                         frame.origin.y += frame.size.height;
                         [_bottomView setFrame:frame];
                     } completion:^(BOOL finished) {
                         
                         [self removeFromSuperview];
                         
                         self.backWindow.hidden = YES;
                     }];
}

#pragma mark - getter

- (UIFont *)textFont
{
    if (!_textFont)
    {
        _textFont = LC_ACTION_SHEET_TITLE_FONT;
    }
    
    return _textFont;
}

- (UIColor *)textColor
{
    if (!_textColor)
    {
        _textColor = [UIColor blackColor];
    }
    
    return _textColor;
}

- (CGFloat)animationDuration
{
    if (!_animationDuration)
    {
        _animationDuration = LC_DEFAULT_ANIMATION_DURATION;
    }
    
    return _animationDuration;
}

- (CGFloat)backgroundOpacity
{
    if (!_backgroundOpacity)
    {
        _backgroundOpacity = LC_DEFAULT_BACKGROUND_OPACITY;
    }
    
    return _backgroundOpacity;
}

@end
