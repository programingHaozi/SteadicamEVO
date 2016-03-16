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

#import <QuartzCore/QuartzCore.h>

@class LBZXBitMatrix;

@interface LBZXImage : NSObject

@property (nonatomic, assign, readonly) CGImageRef cgimage;

- (LBZXImage *)initWithCGImageRef:(CGImageRef)image;
- (LBZXImage *)initWithURL:(NSURL const *)url;
- (size_t)width;
- (size_t)height;
+ (LBZXImage *)imageWithMatrix:(LBZXBitMatrix *)matrix;
+ (LBZXImage *)imageWithMatrix:(LBZXBitMatrix *)matrix onColor:(CGColorRef)onColor offColor:(CGColorRef)offColor;

@end
