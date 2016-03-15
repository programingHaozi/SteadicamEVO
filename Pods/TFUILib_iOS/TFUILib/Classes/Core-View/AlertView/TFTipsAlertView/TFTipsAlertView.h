//
//  TFTipsAlert.h
//  TF-ToC-Iphone
//
//  Created by Xuehan Gong on 14-5-7.
//  Copyright (c) 2014年 Chexiang. All rights reserved.
//

#import "TFCustomAlertView.h"
#import "TFLabel.h"
#import "TFButton.h"

/**
 *  TFTipsContentDelegate
 */
@protocol TFTipsContentDelegate <NSObject>

/**
 *  点击确认按钮
 */
- (void)confirmButtonClicked;

/**
 *  点击取消按钮
 */
- (void)cancelButtonClicked;

@end

#pragma mark - TFTipsAlert

/**
 *  TFTipsAlertViewDelegate
 */
@protocol TFTipsAlertViewDelegate;

/**
 *  TFTipsAlertView
 */
@interface TFTipsAlertView : TFCustomAlertView <TFTipsContentDelegate>

/**
 *  代理
 */
@property (nonatomic, weak) id<TFTipsAlertViewDelegate> delegate;

/**
 *  初始化TFTipsAlertView
 *
 *  @param title    标题
 *  @param delegate 代理
 *  @param content  内容
 *  @param confirm  确认按钮
 *  @param cancel   取消按钮
 *
 *  @return TFTipsAlertView
 */
- (id)initWithTitle:(NSString *)title
           delegate:(id<TFTipsAlertViewDelegate>)delegate
            content:(NSString *)content
      confirmButton:(NSString *)confirm
       cancelButton:(NSString *)cancel;

/**
 *  初始化TFTipsAlertView
 *
 *  @param title    标题
 *  @param subtitle 副标题
 *  @param delegate 代理
 *  @param confirm  确认按钮
 *  @param cancel   取消按钮
 *
 *  @return TFTipsAlertView
 */
- (id)initWithTitle:(NSString *)title
           subtitle:(NSString *)subtitle
           delegate:(id<TFTipsAlertViewDelegate>)delegate
      confirmButton:(NSString *)confirm
       cancelButton:(NSString *)cancel;

@end

/**
 *  TFTipsAlertViewDelegate
 */
@protocol TFTipsAlertViewDelegate <NSObject>

/**
 *  点击代理方法
 *
 *  @param index     0是取消，1是确认
 */
- (void)tipsAlertView:(TFCustomAlertView *)alertView
 clickedButtonAtIndex:(NSInteger)index;

@end

#pragma mark - SingleButtonContent

/**
 *  SingleButtonContent
 */
@interface SingleButtonContent : TFView

/**
 *  代理
 */
@property (nonatomic, weak) id<TFTipsContentDelegate> delegate;

/**
 *  标题视图
 */
@property (nonatomic, weak) IBOutlet TFView *titleView;

/**
 *  标题Label
 */
@property (nonatomic, weak) IBOutlet TFLabel *title_lbl;

/**
 *  内容Label
 */
@property (nonatomic, weak) IBOutlet TFLabel  *content_lbl;

/**
 *  按钮容器视图
 */
@property (nonatomic, weak) IBOutlet TFView *buttonContainerView;

/**
 *  确认按钮
 */
@property (nonatomic, weak) IBOutlet TFButton *confirm_btn;

/**
 *  滚动视图
 */
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

/**
 *  初始化SingleButtonContent
 *
 *  @param title   标题
 *  @param content 内容
 *  @param confirm 确认按钮标题
 *
 *  @return SingleButtonContent
 */
+ (SingleButtonContent *)singleButtonContentWithTitle:(NSString *)title
                                              content:(NSString *)content
                                        confirmButton:(NSString *)confirm;

/**
 *  点击确认按钮
 *
 *  @param sender 确认按钮
 */
- (IBAction)confirmButtonClicked:(id)sender;

@end

#pragma mark - DoubleButtonContent

/**
 *  DoubleButtonContent
 */
@interface DoubleButtonContent : TFView

/**
 *  代理
 */
@property (nonatomic, weak) id<TFTipsContentDelegate> delegate;

/**
 *  标题视图
 */
@property (nonatomic, weak) IBOutlet TFView *titleView;

/**
 *  标题Label
 */
@property (nonatomic, weak) IBOutlet TFLabel *title_lbl;

/**
 *  内容Label
 */
@property (nonatomic, weak) IBOutlet TFLabel *content_lbl;

/**
 *  按钮容器视图
 */
@property (nonatomic, weak) IBOutlet TFView *buttonContainerView;

/**
 *  确认按钮
 */
@property (nonatomic, weak) IBOutlet TFButton *confirm_btn;

/**
 *  取消按钮
 */
@property (nonatomic, weak) IBOutlet TFButton *cancel_btn;

/**
 *  滚动视图
 */
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

/**
 *  初始化DoubleButtonContent
 *
 *  @param title   白哦提
 *  @param content 内容
 *  @param confirm 确认按钮标题
 *  @param cancel  取消按钮标题
 *
 *  @return DoubleButtonContent
 */
+ (DoubleButtonContent *)doubleButtonContentWithTitle:(NSString *)title
                                              content:(NSString *)content
                                        confrimButton:(NSString *)confirm
                                         cancelButton:(NSString *)cancel;

/**
 *  点击确认按钮
 *
 *  @param sender 确认按钮
 */
- (IBAction)confirmButtonClicked:(id)sender;

/**
 *  点击取消按钮
 *
 *  @param sender 取消按钮
 */
- (IBAction)cancelButtonClicked:(id)sender;

@end

#pragma mark - SubtitleDoubleButtonContent

/**
 *  SubtitleDoubleButtonContent
 */
@interface SubtitleDoubleButtonContent : TFView

/**
 *  标题Label
 */
@property (nonatomic, weak) IBOutlet TFLabel *title_lbl;

/**
 *  副标题Label
 */
@property (nonatomic, weak) IBOutlet TFLabel *subtitle_lbl;

/**
 *  确认按钮
 */
@property (nonatomic, weak) IBOutlet TFButton *confirm_btn;

/**
 *  取消按钮
 */
@property (nonatomic, weak) IBOutlet TFButton *cancel_btn;

/**
 *  代理
 */
@property (nonatomic, weak) id<TFTipsContentDelegate> delegate;

/**
 *  初始化SubtitleDoubleButtonContent
 *
 *  @param title    标题
 *  @param subtitle 副标题
 *  @param confirm  确认按钮标题
 *  @param cancel   取消按钮标题
 *
 *  @return SubtitleDoubleButtonContent
 */
+ (SubtitleDoubleButtonContent *)subtitleDoubleButtonContentWithTitle:(NSString *)title
                                                             subtitle:(NSString *)subtitle
                                                        confrimButton:(NSString *)confirm
                                                         cancelButton:(NSString *)cancel;

/**
 *  点击确认按钮
 *
 *  @param sender 确认按钮
 */
- (IBAction)confirmButtonClicked:(id)sender;

/**
 *  点击取消按钮
 *
 *  @param sender 取消按钮
 */
- (IBAction)cancelButtonClicked:(id)sender;

@end
