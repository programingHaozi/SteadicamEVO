
#import <UIKit/UIKit.h>

@interface UITextView (Placeholder)

/**
 *  占位符Label
 */
@property (nonatomic, readonly) UILabel *placeholderLabel;

/**
 *  占位符内容
 */
@property (nonatomic, strong) NSString *placeholder;

/**
 *  占位符颜色
 */
@property (nonatomic, strong) UIColor *placeholderColor;

/**
 *  占位符颜色
 */
@property (nonatomic, strong) UIFont *placeholderFont;

@end
