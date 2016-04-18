//
//  TFNavigationMenu.m
//  TFNavigationMenu
//
//  Created by xiayiyong on 02/08/2015.
//  Copyright (c) 2015 xiayiyong. All rights reserved.
//

#import "TFNavigationMenu.h"
#import "UIView+Category.h"

#define HEXCOLOR(c,a)        [UIColor colorWithRed:((c>>16)&0xFF)/255.0 green:((c>>8)&0xFF)/255.0 blue:(c&0xFF)/255.0 alpha:a]

#pragma mark - TFNavigationMenuConfiguration

@interface TFNavigationMenuConfiguration : NSObject
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, strong) UIColor *cellBackgroundColor;
@property (nonatomic, strong) UIColor *cellTextColor;
@property (nonatomic, strong) UIFont *cellTextFont;
@property (nonatomic, strong) UIColor *cellSelectedColor;
@property (nonatomic, strong) UIImage *checkImage;
@property (nonatomic, strong) UIImage *arrowImage;
@property (nonatomic, assign) CGFloat arrowPadding;
@property (nonatomic, assign) NSTimeInterval animationDuration;
@property (nonatomic, strong) UIColor *maskBackgroundColor;
@property (nonatomic, assign) CGFloat maskBackgroundOpacity;
@end

@implementation TFNavigationMenuConfiguration

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSBundle *imageBundle = [NSBundle bundleWithURL:[bundle URLForResource:@"TFNavigationMenu" withExtension:@"bundle"]];
        NSString *checkMarkImagePath = [imageBundle pathForResource:@"checkmark_icon" ofType:@"png"];
        NSString *arrowImagePath = [imageBundle pathForResource:@"arrow_down_icon" ofType:@"png"];
        
        self.cellHeight = 50;
        self.cellBackgroundColor = [UIColor colorWithRed:0/255.0 green:180/255.0 blue:220/255.0 alpha:1.0];
        self.cellTextColor = [UIColor whiteColor];
        self.cellTextFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
        self.cellSelectedColor = [UIColor colorWithRed:0/255.0 green:160/255.0 blue:195/255.0 alpha: 1.0];
        self.checkImage = [UIImage imageWithContentsOfFile:checkMarkImagePath];
        self.animationDuration = 0.5;
        self.arrowImage = [UIImage imageWithContentsOfFile:arrowImagePath];
        self.arrowPadding = 15;
        self.maskBackgroundColor = [UIColor blackColor];
        self.maskBackgroundOpacity = 0.3;
    }
    return self;
}

@end

#pragma mark - TFNavigationMenuTableCell

@interface TFNavigationMenuTableCell : UITableViewCell

@property (nonatomic, strong) UIImageView *checkImageView;
@property (strong, nonatomic) UIImageView *lineImageView;
@property (nonatomic, strong) TFNavigationMenuConfiguration *configuration;

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                configuration:(TFNavigationMenuConfiguration *)configuration;

@end

@implementation TFNavigationMenuTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                configuration:(TFNavigationMenuConfiguration *)configuration
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.configuration = configuration;
        
        self.contentView.backgroundColor = self.configuration.cellBackgroundColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.textAlignment = NSTextAlignmentLeft;
        self.textLabel.textColor = self.configuration.cellTextColor;
        self.textLabel.font = self.configuration.cellTextFont;
        
        self.checkImageView = [[UIImageView alloc] init];
        self.checkImageView.hidden = YES;
        self.checkImageView.image = self.configuration.checkImage;
        self.checkImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.checkImageView];
        
        self.lineImageView = [[UIImageView alloc] init];
        self.lineImageView.backgroundColor = HEXCOLOR(0xDFDFDD, 1);
        [self.contentView addSubview:self.lineImageView];
        
        UIView *backgroundView=[[UIView alloc]init];
        [backgroundView setBackgroundColor:self.configuration.cellBackgroundColor];
        self.backgroundView=backgroundView;
        
        UILabel *selectedBackgroundView=[[UILabel alloc]init];
        [selectedBackgroundView setBackgroundColor:self.configuration.cellSelectedColor];
        self.selectedBackgroundView=selectedBackgroundView;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.selectedBackgroundView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.contentView.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);

    self.textLabel.frame = CGRectMake(20, 0, self.frame.size.width, self.frame.size.height);
    self.checkImageView.frame=CGRectMake(self.frame.size.width - 50, (self.frame.size.height - 30)/2, 30, 30);
    self.lineImageView.frame=CGRectMake(0, self.frame.size.height-0.5, self.frame.size.width, 0.5);
}

@end

#pragma mark - TFNavigationMenuTableView

@interface TFNavigationMenuTableView : UITableView <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, assign) NSUInteger selectedIndexPath;

@property (nonatomic, strong) TFNavigationMenuConfiguration *configuration;

@property (nonatomic, copy) void(^didSelectItemAtIndexHandler)(NSUInteger indexPath);

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items configuration:(TFNavigationMenuConfiguration *)configuration;

@end

@implementation TFNavigationMenuTableView

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items configuration:(TFNavigationMenuConfiguration *)configuration
{
    self = [super initWithFrame:frame style:UITableViewStylePlain];
    if (self) {
        self.items = items;
        self.selectedIndexPath = 0;
        self.configuration = configuration;
        
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor clearColor];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.bounces=NO;
    }
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.configuration.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.configuration.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TFNavigationMenuTableCell *cell = [[TFNavigationMenuTableCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                                       reuseIdentifier:@"TFNavigationMenuTableCell"
                                                                         configuration:self.configuration];
    cell.textLabel.text = self.items[indexPath.row];
    cell.checkImageView.hidden = indexPath.row!=self.selectedIndexPath?YES:NO;

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexPath = indexPath.row;
    self.didSelectItemAtIndexHandler(indexPath.row);
    [self reloadData];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TFNavigationMenuTableCell *cell = (TFNavigationMenuTableCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.checkImageView.hidden = YES;
}

@end

#pragma mark - TFNavigationMenu

@interface TFNavigationMenu()

@property (nonatomic, strong) UIButton *menuButton;
@property (nonatomic, strong) UILabel *menuLabel;
@property (nonatomic, strong) UIImageView *menuArrowImageView;

@property (nonatomic, strong) TFNavigationMenuTableView *tableView;

@property (nonatomic, strong) UIButton *maskButton;
@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, strong) TFNavigationMenuConfiguration *configuration;

@property (nonatomic, strong) NSArray *items;

@property (nonatomic, assign) CGFloat offsetY;

@end

@implementation TFNavigationMenu

- (instancetype)initWithItems:(NSArray *)items block:(TFNavigationMenuBlock)block
{
    self = [super initWithFrame:CGRectMake(0, 0, 120, 44)];
    if (self) {
        
        self.offsetY=64;
        self.configuration = [[TFNavigationMenuConfiguration alloc] init];
        self.items = items;
        
        __weak typeof(self) weakSelf = self;
        
        self.menuButton = [[UIButton alloc] initWithFrame:self.frame];
        [self.menuButton addTarget:self action:@selector(menuButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        
        self.menuLabel = [[UILabel alloc] init];
        self.menuLabel.text = items.firstObject;
        self.menuLabel.textAlignment = NSTextAlignmentCenter;
        self.menuLabel.textColor = self.configuration.textColor;
        self.menuLabel.font = self.configuration.textFont;
        
        self.menuArrowImageView = [[UIImageView alloc] init];
        self.menuArrowImageView.image=self.configuration.arrowImage;
        
        self.maskView = [[UIView alloc] init];
        self.maskView.frame=CGRectMake(0, self.offsetY, [UIScreen mainScreen].bounds.size.width , [UIScreen mainScreen].bounds.size.height-self.offsetY);
        self.maskView.backgroundColor = self.configuration.maskBackgroundColor;
        self.maskView.clipsToBounds=YES;
        
        self.maskButton = [[UIButton alloc] init];
        self.maskButton.frame=self.maskView.frame;
        self.maskButton.backgroundColor = [UIColor clearColor];
        [self.maskButton addTarget:self action:@selector(menuButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        
        self.didSelectItemAtIndexHandler=block;
        
        self.tableView = [[TFNavigationMenuTableView alloc] initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,(CGFloat)(self.items.count) * self.configuration.cellHeight)
                                                                    items:items
                                                            configuration:self.configuration];
        self.tableView.didSelectItemAtIndexHandler = ^(NSUInteger index){
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.didSelectItemAtIndexHandler(index);
            strongSelf.menuLabel.text = items[index];
            [strongSelf hideMenu];
            [strongSelf layoutSubviews];
        };
        
        [self addSubview:self.menuButton];
        [self.menuButton addSubview:self.menuLabel];
        [self.menuButton addSubview:self.menuArrowImageView];
        
        [self.maskView addSubview:self.maskButton];
        [self.maskView addSubview:self.tableView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.menuLabel sizeToFit];
    self.menuLabel.center = CGPointMake(self.frame.size.width / 2.f, self.frame.size.height / 2.f);
    [self.menuArrowImageView sizeToFit];
    self.menuArrowImageView.center = CGPointMake(CGRectGetMaxX(self.menuLabel.frame) + self.configuration.arrowPadding, self.frame.size.height / 2.f);
}

- (void)showMenu
{
    [self.tableView reloadData];
    
    [self.topViewController.view addSubview:self.maskView];
    
    [self rotateArrow];
    
    self.maskView.backgroundColor = HEXCOLOR(0x000000, 0);
    
    self.tableView.frame = CGRectMake(self.tableView.frame.origin.x,
                                      -(CGFloat)(self.items.count) * self.configuration.cellHeight,
                                      self.tableView.frame.size.width,
                                      self.tableView.frame.size.height);
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:self.configuration.animationDuration
                          delay:0
         usingSpringWithDamping:.7
          initialSpringVelocity:.2
                        options:0
                     animations:^{
                         self.tableView.frame = CGRectMake(self.tableView.frame.origin.x,
                                                           0,
                                                           self.tableView.frame.size.width,
                                                           self.tableView.frame.size.height);
                         self.maskView.backgroundColor = HEXCOLOR(0x000000, self.configuration.maskBackgroundOpacity);
                     }
                     completion:nil];
}

- (void)hideMenu
{
    [self rotateArrow];

    self.maskView.backgroundColor = HEXCOLOR(0x000000, self.configuration.maskBackgroundOpacity);
    
    [UIView animateWithDuration:self.configuration.animationDuration
                          delay:0
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.tableView.frame = CGRectMake(self.tableView.frame.origin.x,
                                                           -(CGFloat)(self.items.count) * self.configuration.cellHeight,
                                                           self.tableView.frame.size.width,
                                                           self.tableView.frame.size.height);
                         self.maskView.backgroundColor = HEXCOLOR(0x000000, 0);
                     }
                     completion:^(BOOL finished) {
                         [self.maskView removeFromSuperview];
                     }];
    
}

- (void)rotateArrow
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:self.configuration.animationDuration
                     animations:^{
                         __strong typeof(weakSelf) strongSelf = weakSelf;
                         strongSelf.menuArrowImageView.transform = CGAffineTransformRotate(strongSelf.menuArrowImageView.transform, 180 * (CGFloat)(M_PI / 180));
                     }];
}

- (void)menuButtonTapped
{
    if (self.maskView.superview==nil)
    {
        [self showMenu];
    }
    else
    {
        [self hideMenu];
    }
}

- (void)setTextColor:(UIColor *)textColor
{
    self.configuration.textColor = textColor;
    self.menuLabel.textColor = self.configuration.textColor;
}

- (void)setTextFont:(UIFont *)textFont
{
    self.configuration.textFont = textFont;
    self.menuLabel.font = self.configuration.textFont;
}

- (void)setCellHeight:(CGFloat)cellHeight
{
    self.configuration.cellHeight = cellHeight;
}

- (void)setCellBackgroundColor:(UIColor *)cellBackgroundColor
{
    self.configuration.cellBackgroundColor = cellBackgroundColor;
}

- (void)setCellTextColor:(UIColor *)cellTextColor
{
    self.configuration.cellTextColor = cellTextColor;
}

- (void)setCellTextFont:(UIFont *)cellTextFont
{
    self.configuration.cellTextFont = cellTextFont;
    self.menuLabel.font = self.configuration.cellTextFont;
}

- (void)setCellSelectedColor:(UIColor *)cellSelectedColor
{
    self.configuration.cellSelectedColor = cellSelectedColor;
}

- (void)setCheckImage:(UIImage *)checkImage
{
    self.configuration.checkImage = checkImage;
}

- (void)setAnimationDuration:(NSTimeInterval)animationDuration
{
    self.configuration.animationDuration = animationDuration;
}

- (void)setArrowImage:(UIImage *)arrowImage
{
    self.configuration.arrowImage = arrowImage;
    self.menuArrowImageView.image = self.configuration.arrowImage;
}

- (void)setArrowPadding:(CGFloat)arrowPadding
{
    self.configuration.arrowPadding = arrowPadding;
}

- (void)setMaskBackgroundColor:(UIColor *)maskBackgroundColor
{
    self.configuration.maskBackgroundColor = maskBackgroundColor;
}

- (void)setMaskBackgroundOpacity:(CGFloat)maskBackgroundOpacity
{
    self.configuration.maskBackgroundOpacity = maskBackgroundOpacity;
}

@end
