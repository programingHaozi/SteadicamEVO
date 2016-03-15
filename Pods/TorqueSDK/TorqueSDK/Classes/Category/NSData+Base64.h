//
//  NSData+Base64.h
//  TorqueSDK
//
//  Created by huxianchen on 15/3/4.
//  Copyright (c) 2015年 saike. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Base64)

- (NSString *)base64Encoding;

+ (id)dataWithBase64EncodedString:(NSString *)string;

@end
