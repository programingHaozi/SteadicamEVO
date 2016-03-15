
#import <UIKit/UIKit.h>

/**
 *  顶部显示toast
 */
extern NSString * const TFToastPositionTop;

/**
 *  中部显示toast
 */
extern NSString * const TFToastPositionCenter;

/**
 *  底部显示toast
 */
extern NSString * const TFToastPositionBottom;

@interface UIView (TFToast)

// each makeToast method creates a view and displays it as toast

/**
 *  显示toast
 *
 *  @param message 信息
 */
- (void)makeToast:(NSString *)message;

/**
 *  显示toast
 *
 *  @param message  信息
 *  @param interval 持续时间
 *  @param position 位置（NSString：top，center，bottom，或者是CGPoint）
 */
- (void)makeToast:(NSString *)message
         duration:(NSTimeInterval)interval
         position:(id)position;

/**
 *  显示toast
 *
 *  @param message  信息
 *  @param interval 持续时间
 *  @param position 位置（NSString：top，center，bottom，或者是CGPoint）
 *  @param image    图片
 */
- (void)makeToast:(NSString *)message
         duration:(NSTimeInterval)interval
         position:(id)position
            image:(UIImage *)image;

/**
 *  显示toast
 *
 *  @param message  信息
 *  @param interval 持续时间
 *  @param position 位置（NSString：top，center，bottom，或者是CGPoint）
 *  @param title    标题
 */
- (void)makeToast:(NSString *)message
         duration:(NSTimeInterval)interval
         position:(id)position
            title:(NSString *)title;

/**
 *  显示toast
 *
 *  @param message  信息
 *  @param interval 持续时间
 *  @param position 位置（NSString：top，center，bottom，或者是CGPoint）（NSString：top，center，bottom，或者是CGPoint）
 *  @param title    标题
 *  @param image    图片
 */
- (void)makeToast:(NSString *)message duration:(NSTimeInterval)interval position:(id)position title:(NSString *)title image:(UIImage *)image;

// displays toast with an activity spinner

/**
 *  显示指示器toast
 */
- (void)makeToastActivity;

/**
 *  显示指示器toast
 *
 *  @param position 位置（NSString：top，center，bottom，或者是CGPoint）
 */
- (void)makeToastActivity:(id)position;

/**
 *  隐藏toast指示器
 */
- (void)hideToastActivity;

// the showToast methods display any view as toast

/**
 *  显示带视图的toast
 *
 *  @param toast 视图
 */
- (void)showToast:(UIView *)toast;

/**
 *  显示带视图的toast
 *
 *  @param toast    视图
 *  @param interval 持续时间
 *  @param point    位置（NSString：top，center，bottom，或者是CGPoint）
 */
- (void)showToast:(UIView *)toast
         duration:(NSTimeInterval)interval
         position:(id)point;

/**
 *  显示带视图的toast
 *
 *  @param toast       视图
 *  @param interval    持续时间
 *  @param point       位置（NSString：top，center，bottom，或者是CGPoint）
 *  @param tapCallback 点击回调
 */
- (void)showToast:(UIView *)toast
         duration:(NSTimeInterval)interval
         position:(id)point
      tapCallback:(void(^)(void))tapCallback;

@end
