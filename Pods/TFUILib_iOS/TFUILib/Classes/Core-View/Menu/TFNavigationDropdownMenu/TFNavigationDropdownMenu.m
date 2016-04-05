//
//  TFNavigationDropdownMenu.m
//  TFNavigationDropdownMenu
//
//  Created by xiayiyong on 02/08/2015.
//  Copyright (c) 2015 xiayiyong. All rights reserved.
//

#import "TFNavigationDropdownMenu.h"
#import "TFNavigationDropdownMenutTableView.h"

@interface TFNavigationDropdownMenu()
@property (nonatomic, strong) UIView *tableContainerView;

@property (nonatomic, strong) UIButton *menuButton;
@property (nonatomic, strong) UILabel *menuTitle;
@property (nonatomic, strong) UIImageView *menuArrow;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) TFNavigationDropdownMenutTableView *tableView;

@property (nonatomic, strong) TFNavigationDropdownMenuConfiguration *configuration;

@property (nonatomic, assign) BOOL isShown;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, assign) CGFloat navigationBarHeight;
@property (nonatomic, assign) CGRect mainScreenBounds;

@end

@implementation TFNavigationDropdownMenu

- (instancetype)initWithFrame:(CGRect)frame
                        title:(NSString *)title
                        items:(NSArray *)items
                containerView:(UIView *)containerView
{
    self = [super initWithFrame:frame];
    if (self) {
        // Init properties
        self.configuration = [[TFNavigationDropdownMenuConfiguration alloc] init];
        self.tableContainerView = containerView;
        self.navigationBarHeight = 44;
        self.mainScreenBounds = [UIScreen mainScreen].bounds;
        self.isShown = NO;
        self.items = items;
        
        // Init button as navigation title
        self.menuButton = [[UIButton alloc] initWithFrame:frame];
        [self.menuButton addTarget:self action:@selector(menuButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.menuButton];
        
        self.menuTitle = [[UILabel alloc] initWithFrame:frame];
        self.menuTitle.text = title;
        self.menuTitle.textColor = [UINavigationBar appearance].titleTextAttributes[NSForegroundColorAttributeName];
        self.menuTitle.textAlignment = NSTextAlignmentCenter;
        self.menuTitle.font = self.configuration.cellTextLabelFont;
        [self.menuButton addSubview:self.menuTitle];
        
        self.menuArrow = [[UIImageView alloc] initWithImage:self.configuration.arrowImage];
        [self.menuButton addSubview:self.menuArrow];
        
        // Init table view
        self.tableView = [[TFNavigationDropdownMenutTableView alloc] initWithFrame:CGRectMake(self.mainScreenBounds.origin.x,
                                                                       self.mainScreenBounds.origin.y,
                                                                       self.mainScreenBounds.size.width,
                                                                       self.mainScreenBounds.size.height + 300 - 64)
                                                      items:items
                                              configuration:self.configuration];
        __weak typeof(self) weakSelf = self;
        self.tableView.selectRowAtIndexPathHandler = ^(NSUInteger indexPath){
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.didSelectItemAtIndexHandler(indexPath);
            [strongSelf setMenuTitleText:items[indexPath]];
            [strongSelf hideMenu];
            strongSelf.isShown = NO;
            [strongSelf layoutSubviews];
        };
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.menuTitle sizeToFit];
    self.menuTitle.center = CGPointMake(self.frame.size.width / 2.f, self.frame.size.height / 2.f);
    [self.menuArrow sizeToFit];
    self.menuArrow.center = CGPointMake(CGRectGetMaxX(self.menuTitle.frame) + self.configuration.arrowPadding, self.frame.size.height / 2.f);
}

- (void)showMenu
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 300)];
    headerView.backgroundColor = self.configuration.cellBackgroundColor;
    self.tableView.tableHeaderView = headerView;
    
    [self.tableView reloadData];
    
    self.backgroundView = [[UIView alloc] initWithFrame:self.mainScreenBounds];
    self.backgroundView.backgroundColor = self.configuration.maskBackgroundColor;
    
    [self.tableContainerView addSubview:self.backgroundView];
    [self.tableContainerView addSubview:self.tableView];
    
    [self rotateArrow];
    
    self.backgroundView.alpha = 0;
    
    self.tableView.frame = CGRectMake(self.tableView.frame.origin.x,
                                      -(CGFloat)(self.items.count) * self.configuration.cellHeight - 300,
                                      self.tableView.frame.size.width,
                                      self.tableView.frame.size.height);
    
    [UIView animateWithDuration:self.configuration.animationDuration * 1.5f
                          delay:0
         usingSpringWithDamping:.7
          initialSpringVelocity:.5
                        options:0
                     animations:^{
                         self.tableView.frame = CGRectMake(self.tableView.frame.origin.x,
                                                           -300,
                                                           self.tableView.frame.size.width,
                                                           self.tableView.frame.size.height);
                         self.backgroundView.alpha = self.configuration.maskBackgroundOpacity;
                     }
                     completion:nil];
}

- (void)hideMenu
{
    [self rotateArrow];
    
    self.backgroundView.alpha = self.configuration.maskBackgroundOpacity;
    
    [UIView animateWithDuration:self.configuration.animationDuration * 1.5f
                          delay:0
         usingSpringWithDamping:.7
          initialSpringVelocity:.5
                        options:0
                     animations:^{
                         self.tableView.frame = CGRectMake(self.tableView.frame.origin.x,
                                                           -200,
                                                           self.tableView.frame.size.width,
                                                           self.tableView.frame.size.height);
                         self.backgroundView.alpha = self.configuration.maskBackgroundOpacity;
                         
                     }
                     completion:nil];
    
    [UIView animateWithDuration:self.configuration.animationDuration
                          delay:0
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.tableView.frame = CGRectMake(self.tableView.frame.origin.x,
                                                           -(CGFloat)(self.items.count) * self.configuration.cellHeight - 300,
                                                           self.tableView.frame.size.width,
                                                           self.tableView.frame.size.height);
                         self.backgroundView.alpha = 0;
                     } completion:^(BOOL finished) {
                         [self.tableView removeFromSuperview];
                         [self.backgroundView removeFromSuperview];
                     }];
    
}

- (void)rotateArrow
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:self.configuration.animationDuration
                     animations:^{
                         __strong typeof(weakSelf) strongSelf = weakSelf;
                         strongSelf.menuArrow.transform = CGAffineTransformRotate(strongSelf.menuArrow.transform, 180 * (CGFloat)(M_PI / 180));
                     }];
}

- (void)setMenuTitleText:(NSString *)title
{
    self.menuTitle.text = title;
}

- (void)menuButtonTapped:(UIButton *)sender
{
    self.isShown = !self.isShown;
    if (self.isShown)
    {
        [self showMenu];
    }
    else
    {
        [self hideMenu];
    }
}

#pragma mark - Setters
- (void)setCellHeight:(CGFloat)cellHeight
{
    self.configuration.cellHeight = cellHeight;
}

- (void)setCellBackgroundColor:(UIColor *)cellBackgroundColor
{
    self.configuration.cellBackgroundColor = cellBackgroundColor;
}

- (void)setCellTextLabelColor:(UIColor *)cellTextLabelColor
{
    self.configuration.cellTextLabelColor = cellTextLabelColor;
}

- (void)setCellTextLabelFont:(UIFont *)cellTextLabelFont
{
    self.configuration.cellTextLabelFont = cellTextLabelFont;
    self.menuTitle.font = self.configuration.cellTextLabelFont;
}

- (void)setCellSelectionColor:(UIColor *)cellSelectionColor
{
    self.configuration.cellSelectionColor = cellSelectionColor;
}

- (void)setCheckMarkImage:(UIImage *)checkMarkImage
{
    self.configuration.checkMarkImage = checkMarkImage;
}

- (void)setAnimationDuration:(NSTimeInterval)animationDuration
{
    self.configuration.animationDuration = animationDuration;
}

- (void)setArrowImage:(UIImage *)arrowImage
{
    self.configuration.arrowImage = arrowImage;
    self.menuArrow.image = self.configuration.arrowImage;
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
