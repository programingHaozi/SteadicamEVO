/*
 * Copyright 2013 LBZXing authors
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
@class LBZXBitMatrix, LBZXResultPoint;

@interface LBZXPDF417BoundingBox : NSObject

@property (nonatomic, assign, readonly) int minX;
@property (nonatomic, assign, readonly) int maxX;
@property (nonatomic, assign, readonly) int minY;
@property (nonatomic, assign, readonly) int maxY;
@property (nonatomic, strong, readonly) LBZXResultPoint *topLeft;
@property (nonatomic, strong, readonly) LBZXResultPoint *topRight;
@property (nonatomic, strong, readonly) LBZXResultPoint *bottomLeft;
@property (nonatomic, strong, readonly) LBZXResultPoint *bottomRight;

- (id)initWithImage:(LBZXBitMatrix *)image topLeft:(LBZXResultPoint *)topLeft bottomLeft:(LBZXResultPoint *)bottomLeft
           topRight:(LBZXResultPoint *)topRight bottomRight:(LBZXResultPoint *)bottomRight;
- (id)initWithBoundingBox:(LBZXPDF417BoundingBox *)boundingBox;

+ (LBZXPDF417BoundingBox *)mergeLeftBox:(LBZXPDF417BoundingBox *)leftBox rightBox:(LBZXPDF417BoundingBox *)rightBox;
- (LBZXPDF417BoundingBox *)addMissingRows:(int)missingStartRows missingEndRows:(int)missingEndRows isLeft:(BOOL)isLeft;

@end
