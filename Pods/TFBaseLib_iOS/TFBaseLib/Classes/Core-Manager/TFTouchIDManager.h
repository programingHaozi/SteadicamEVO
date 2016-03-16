//
//  TFTouchIDManager.h
//  TFTouchIDManager
//
//  Created by xiayiyong on 15/7/1.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LocalAuthentication/LocalAuthentication.h>

/**
 *  指纹识别touchId管理类
 */
@interface TFTouchIDManager : NSObject

/**
 *  TouchIdValidationFailureBack
 *  @param result LAError枚举
 */
typedef void(^TouchIdValidationFailureBack)(LAError result, NSString *errorMessage);

/**
 *  检查touchID是否可用
 *
 *  @return 
 */
+ (BOOL)checkTouch;

/**
 *  TouchId 验证
 *
 *  @param localizedReason TouchId信息
 *  @param title           验证错误按钮title
 *  @param backSucces      成功返回block
 *  @param backFailure     失败返回block
 */
+ (void)startTouchIDWithMessage:(NSString *)localizedReason
         fallbackTitle:(NSString *)fallbackTitle
          succes:(void(^)())successBlock
         failure:(TouchIdValidationFailureBack)failureBlock;

@end
