//
//  TFNavigationDropdownMenuConfiguration.m
//  TFNavigationDropdownMenu
//
//  Created by xiayiyong on 02/08/2015.
//  Copyright (c) 2015 xiayiyong. All rights reserved.
//

#import "TFNavigationDropdownMenuConfiguration.h"

@implementation TFNavigationDropdownMenuConfiguration

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setDefaultValue];
    }
    return self;
}

- (void)setDefaultValue
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSBundle *imageBundle = [NSBundle bundleWithURL:[bundle URLForResource:@"TFNavigationDropdownMenu" withExtension:@"bundle"]];
    NSString *checkMarkImagePath = [imageBundle pathForResource:@"checkmark_icon" ofType:@"png"];
    NSString *arrowImagePath = [imageBundle pathForResource:@"arrow_down_icon" ofType:@"png"];
    
    self.cellHeight = 50;
    self.cellBackgroundColor = [UIColor colorWithRed:0/255.0 green:180/255.0 blue:220/255.0 alpha:1.0];
    self.cellTextLabelColor = [UIColor whiteColor];
    self.cellTextLabelFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
    self.cellSelectionColor = [UIColor colorWithRed:0/255.0 green:160/255.0 blue:195/255.0 alpha: 1.0];
    self.checkMarkImage = [UIImage imageWithContentsOfFile:checkMarkImagePath];
    self.animationDuration = 0.5;
    self.arrowImage = [UIImage imageWithContentsOfFile:arrowImagePath];
    self.arrowPadding = 15;
    self.maskBackgroundColor = [UIColor blackColor];
    self.maskBackgroundOpacity = 0.3;
}

@end
