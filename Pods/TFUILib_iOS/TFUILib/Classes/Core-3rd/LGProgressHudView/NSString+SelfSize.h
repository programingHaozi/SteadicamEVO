//
//  NSString+SelfSize.h
//  Mamahome
//
//  Created by AQ on 15-4-21.
//  Copyright (c) 2015年 OIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h> 
@interface NSString (SelfSize)
- (CGSize)getSizeFromSelfWithWidth:(CGFloat)width andFont:(CGFloat)font;
- (CGSize)getSizeFromSelfWithWidth:(CGFloat)width andUIFont:(UIFont *)font;
@end
