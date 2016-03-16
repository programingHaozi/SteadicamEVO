//
//  CustomPicker.h
//  Grape-ToC-Iphone
//
//  Created by Xuehan Gong on 14-6-10.
//  Copyright (c) 2014年 Chexiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    kDateSelectTypeTime         = 0,
    kDateSelectTypeDate         = 1,
    kDateSelectTypeDateAndTime  = 2,
}dateSelectType;

@protocol LBCustomPickerDelegate <NSObject>

- (void)selectDate:(NSString *)ts;

@end

@interface LBCustomPicker : UIView

@property (nonatomic, assign) id<LBCustomPickerDelegate> delegate;

- (id)initWithFrame:(CGRect)frame type:(dateSelectType) type;
- (void)show:(void (^)(BOOL finished))completion;
- (void)dismiss:(void (^)(BOOL finished))completion;
- (void)onClickCancel;

@end