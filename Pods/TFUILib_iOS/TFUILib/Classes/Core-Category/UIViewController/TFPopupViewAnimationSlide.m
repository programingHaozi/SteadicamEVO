//
//  TFPopupViewAnimationSlide.m
//  TFPopupViewController
//
//  Created by xiayiyong on 15/3/5.
//  Copyright (c) 2015年 xiayiyong. All rights reserved.
//

#import "TFPopupViewAnimationSlide.h"

@implementation TFPopupViewAnimationSlide
- (void)showView:(UIView *)popupView overlayView:(UIView *)overlayView{
    
    CGSize sourceSize = overlayView.bounds.size;
    CGSize popupSize = popupView.bounds.size;
    CGRect popupStartRect;
    switch (_type) {
        case TFPopupViewAnimationSlideTypeBottomTop:
        case TFPopupViewAnimationSlideTypeBottomBottom:
            popupStartRect = CGRectMake((sourceSize.width - popupSize.width) / 2,
                                        sourceSize.height,
                                        popupSize.width,
                                        popupSize.height);
            
            break;
        case TFPopupViewAnimationSlideTypeLeftLeft:
        case TFPopupViewAnimationSlideTypeLeftRight:
            popupStartRect = CGRectMake(-sourceSize.width,
                                        (sourceSize.height - popupSize.height) / 2,
                                        popupSize.width,
                                        popupSize.height);
            break;
            
        case TFPopupViewAnimationSlideTypeTopTop:
        case TFPopupViewAnimationSlideTypeTopBottom:
            popupStartRect = CGRectMake((sourceSize.width - popupSize.width) / 2,
                                        -popupSize.height,
                                        popupSize.width,
                                        popupSize.height);
            break;
            
        default:
            popupStartRect = CGRectMake(sourceSize.width,
                                        (sourceSize.height - popupSize.height) / 2,
                                        popupSize.width,
                                        popupSize.height);
            break;
    }
    CGRect popupEndRect = CGRectMake((sourceSize.width - popupSize.width) / 2,
                                     (sourceSize.height - popupSize.height) / 2,
                                     popupSize.width,
                                     popupSize.height);
    
    // Set starting properties
    popupView.frame = popupStartRect;
    popupView.alpha = 1.0f;
    [UIView animateWithDuration:0.25 delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        popupView.frame = popupEndRect;
    } completion:nil];

    
}
- (void)dismissView:(UIView *)popupView overlayView:(UIView *)overlayView completion:(void (^)(void))completion{
    CGSize sourceSize = overlayView.bounds.size;
    CGSize popupSize = popupView.bounds.size;
    CGRect popupEndRect;
    switch (_type) {
        case TFPopupViewAnimationSlideTypeBottomTop:
        case TFPopupViewAnimationSlideTypeTopTop:
            popupEndRect = CGRectMake((sourceSize.width - popupSize.width) / 2,
                                      -popupSize.height,
                                      popupSize.width,
                                      popupSize.height);
            break;
        case TFPopupViewAnimationSlideTypeBottomBottom:
        case TFPopupViewAnimationSlideTypeTopBottom:
            popupEndRect = CGRectMake((sourceSize.width - popupSize.width) / 2,
                                      sourceSize.height,
                                      popupSize.width,
                                      popupSize.height);
            break;
        case TFPopupViewAnimationSlideTypeLeftRight:
        case TFPopupViewAnimationSlideTypeRightRight:
            popupEndRect = CGRectMake(sourceSize.width,
                                      popupView.frame.origin.y,
                                      popupSize.width,
                                      popupSize.height);
            break;
        default:
            popupEndRect = CGRectMake(-popupSize.width,
                                      popupView.frame.origin.y,
                                      popupSize.width,
                                      popupSize.height);
            break;
    }
    
    [UIView animateWithDuration:0.25 delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        popupView.frame = popupEndRect;
        overlayView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        completion();
    }];

}
@end
