//
//  SWTableViewCell.h
//  SWTableViewCell
//
//  Created by Chris Wendel on 9/10/13.
//  Copyright (c) 2013 Chris Wendel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIGestureRecognizerSubclass.h>
#import "SWCellScrollView.h"
#import "SWLongPressGestureRecognizer.h"
#import "SWUtilityButtonTapGestureRecognizer.h"
#import "NSMutableArray+SWUtilityButtons.h"

@class TFSwipeCell;

typedef NS_ENUM(NSInteger, TFSwipeCellState)
{
    kCellStateCenter,
    kCellStateLeft,
    kCellStateRight,
};

@protocol TFSwipeCellDelegate <NSObject>

@optional
- (void)swipeTableViewCell:(TFSwipeCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index;
- (void)swipeTableViewCell:(TFSwipeCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index;
- (void)swipeTableViewCell:(TFSwipeCell *)cell scrollingToState:(TFSwipeCellState)state;
- (BOOL)swipeTableViewCellShouldHideUtilityButtonsOnSwipe:(TFSwipeCell *)cell;
- (BOOL)swipeTableViewCell:(TFSwipeCell *)cell canSwipeToState:(TFSwipeCellState)state;
- (void)swipeTableViewCellDidEndScrolling:(TFSwipeCell *)cell;
- (void)swipeTableViewCell:(TFSwipeCell *)cell didScroll:(UIScrollView *)scrollView;

@end

@interface TFSwipeCell : UITableViewCell

@property (nonatomic, copy) NSArray *leftUtilityButtons;
@property (nonatomic, copy) NSArray *rightUtilityButtons;

@property (nonatomic, weak) id <TFSwipeCellDelegate> delegate;

- (void)setRightUtilityButtons:(NSArray *)rightUtilityButtons WithButtonWidth:(CGFloat) width;
- (void)setLeftUtilityButtons:(NSArray *)leftUtilityButtons WithButtonWidth:(CGFloat) width;
- (void)hideUtilityButtonsAnimated:(BOOL)animated;
- (void)showLeftUtilityButtonsAnimated:(BOOL)animated;
- (void)showRightUtilityButtonsAnimated:(BOOL)animated;

- (BOOL)isUtilityButtonsHidden;

@end
