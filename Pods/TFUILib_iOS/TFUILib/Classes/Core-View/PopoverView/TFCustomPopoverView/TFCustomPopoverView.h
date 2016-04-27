//
//  PopoverView.h
//  Embark
//
//  Created by Oliver Rickard on 20/08/2012.
//  from https://github.com/runway20/PopoverView/tree/master
//
//

#import <UIKit/UIKit.h>
#import "TFBaseLib.h"

/**************** Support both ARC and non-ARC ********************/

#ifndef SUPPORT_ARC
#define SUPPORT_ARC

#if __has_feature(objc_arc_weak)                //objc_arc_weak
#define WEAK weak
#define __WEAK __weak
#define STRONG strong

#define AUTORELEASE self
#define RELEASE self
#define RETAIN self
#define CFTYPECAST(exp) (__bridge exp)
#define TYPECAST(exp) (__bridge_transfer exp)
#define CFRELEASE(exp) CFRelease(exp)
#define DEALLOC self

#elif __has_feature(objc_arc)                   //objc_arc
#define WEAK unsafe_unretained
#define __WEAK __unsafe_unretained
#define STRONG strong

#define AUTORELEASE self
#define RELEASE self
#define RETAIN self
#define CFTYPECAST(exp) (__bridge exp)
#define TYPECAST(exp) (__bridge_transfer exp)
#define CFRELEASE(exp) CFRelease(exp)
#define DEALLOC self

#else                                           //none
#define WEAK assign
#define __WEAK
#define STRONG retain

#define AUTORELEASE autorelease
#define RELEASE release
#define RETAIN retain
#define CFTYPECAST(exp) (exp)
#define TYPECAST(exp) (exp)
#define CFRELEASE(exp) CFRelease(exp)
#define DEALLOC dealloc

#endif
#endif

@interface TFCustomPopoverView : UIView

/**
 *   block监听点击方式
 */
@property (nonatomic, copy) void (^didSelectItemAtIndexHandler)(NSInteger index);

#pragma mark - Class Static Showing Methods

+ (TFCustomPopoverView *)showAtPoint:(CGPoint)point inView:(UIView *)view withText:(NSString *)text;

+ (TFCustomPopoverView *)showAtPoint:(CGPoint)point inView:(UIView *)view withTitle:(NSString *)title withText:(NSString *)text;

+ (TFCustomPopoverView *)showAtPoint:(CGPoint)point inView:(UIView *)view withViewArray:(NSArray *)viewArray block:(IntegerBlock)block;

+ (TFCustomPopoverView *)showAtPoint:(CGPoint)point inView:(UIView *)view withTitle:(NSString *)title withViewArray:(NSArray *)viewArray block:(IntegerBlock)block;

+ (TFCustomPopoverView *)showAtPoint:(CGPoint)point inView:(UIView *)view withStringArray:(NSArray *)stringArray block:(IntegerBlock)block;

+ (TFCustomPopoverView *)showAtPoint:(CGPoint)point inView:(UIView *)view withTitle:(NSString *)title withStringArray:(NSArray *)stringArray block:(IntegerBlock)block;

+ (TFCustomPopoverView *)showAtPoint:(CGPoint)point inView:(UIView *)view withStringArray:(NSArray *)stringArray withImageArray:(NSArray *)imageArray block:(IntegerBlock)block;

+ (TFCustomPopoverView *)showAtPoint:(CGPoint)point inView:(UIView *)view withTitle:(NSString *)title withStringArray:(NSArray *)stringArray withImageArray:(NSArray *)imageArray block:(IntegerBlock)block;

+ (TFCustomPopoverView *)showAtPoint:(CGPoint)point inView:(UIView *)view withTitle:(NSString *)title withContentView:(UIView *)cView ;

+ (TFCustomPopoverView *)showAtPoint:(CGPoint)point inView:(UIView *)view withContentView:(UIView *)cView;

#pragma mark - Showing Methods

- (void)showAtPoint:(CGPoint)point inView:(UIView *)view withContentView:(UIView *)contentView;

- (void)showAtPoint:(CGPoint)point inView:(UIView *)view withText:(NSString *)text;

- (void)showAtPoint:(CGPoint)point inView:(UIView *)view withViewArray:(NSArray *)viewArray;

- (void)showAtPoint:(CGPoint)point inView:(UIView *)view withTitle:(NSString *)title withViewArray:(NSArray *)viewArray;

- (void)showAtPoint:(CGPoint)point inView:(UIView *)view withStringArray:(NSArray *)stringArray;

- (void)showAtPoint:(CGPoint)point inView:(UIView *)view withTitle:(NSString *)title withStringArray:(NSArray *)stringArray;

- (void)showAtPoint:(CGPoint)point inView:(UIView *)view withStringArray:(NSArray *)stringArray withImageArray:(NSArray *)imageArray;

- (void)showAtPoint:(CGPoint)point inView:(UIView *)view withTitle:(NSString *)title withStringArray:(NSArray *)stringArray withImageArray:(NSArray *)imageArray;

#pragma mark - Dismis Methods
- (void)dismiss;
- (void)dismiss:(BOOL)animated;

@end
