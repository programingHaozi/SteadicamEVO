
#import <UIKit/UIKit.h>

@interface UIView (TFToast)

/**
 *  在顶部显示一个Toast，持续2.5秒
 *
 *  @param text 要显示的文字
 */
- (void)showToast:(NSString*)text;

/**
 *  显示Toast视图
 *
 *  @param text 提示信息
 */
-(void)showToastWithText:(NSString *)text;

@end
