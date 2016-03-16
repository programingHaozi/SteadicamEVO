/*
 * Copyright 2012 LBZXing authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
#import <Foundation/Foundation.h>
extern const int LBZX_NUM_MASK_PATTERNS;

@class LBZXByteMatrix, LBZXQRCodeErrorCorrectionLevel, LBZXQRCodeMode, LBZXQRCodeVersion;

@interface LBZXQRCode : NSObject

@property (nonatomic, strong) LBZXQRCodeMode *mode;
@property (nonatomic, strong) LBZXQRCodeErrorCorrectionLevel *ecLevel;
@property (nonatomic, strong) LBZXQRCodeVersion *version;
@property (nonatomic, assign) int maskPattern;
@property (nonatomic, strong) LBZXByteMatrix *matrix;

+ (BOOL)isValidMaskPattern:(int)maskPattern;

@end
