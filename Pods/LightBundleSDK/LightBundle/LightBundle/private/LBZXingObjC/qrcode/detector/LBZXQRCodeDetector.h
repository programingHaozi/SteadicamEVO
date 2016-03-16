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

@class LBZXBitMatrix, LBZXDecodeHints, LBZXDetectorResult, LBZXPerspectiveTransform, LBZXQRCodeAlignmentPattern, LBZXQRCodeFinderPatternInfo, LBZXResultPoint;
@protocol LBZXResultPointCallback;

/**
 * Encapsulates logic that can detect a QR Code in an image, even if the QR Code
 * is rotated or skewed, or partially obscured.
 */
@interface LBZXQRCodeDetector : NSObject

@property (nonatomic, strong, readonly) LBZXBitMatrix *image;
@property (nonatomic, weak, readonly) id <LBZXResultPointCallback> resultPointCallback;

- (id)initWithImage:(LBZXBitMatrix *)image;

/**
 * Detects a QR Code in an image, simply.
 *
 * @return LBZXDetectorResult encapsulating results of detecting a QR Code or nil
 * if no QR Code can be found
 */
- (LBZXDetectorResult *)detectWithError:(NSError **)error;

/**
 * Detects a QR Code in an image, simply.
 *
 * @param hints optional hints to detector
 * @return LBZXDetectorResult encapsulating results of detecting a QR Code
 * @return nil if QR Code cannot be found
 * @return nil if a QR Code cannot be decoded
 */
- (LBZXDetectorResult *)detect:(LBZXDecodeHints *)hints error:(NSError **)error;

- (LBZXDetectorResult *)processFinderPatternInfo:(LBZXQRCodeFinderPatternInfo *)info error:(NSError **)error;

/**
 * Computes an average estimated module size based on estimated derived from the positions
 * of the three finder patterns.
 */
- (float)calculateModuleSize:(LBZXResultPoint *)topLeft topRight:(LBZXResultPoint *)topRight bottomLeft:(LBZXResultPoint *)bottomLeft;

/**
 * Attempts to locate an alignment pattern in a limited region of the image, which is
 * guessed to contain it. This method uses LBZXAlignmentPattern.
 *
 * @param overallEstModuleSize estimated module size so far
 * @param estAlignmentX x coordinate of center of area probably containing alignment pattern
 * @param estAlignmentY y coordinate of above
 * @param allowanceFactor number of pixels in all directions to search from the center
 * @return LBZXAlignmentPattern if found, or nil if an unexpected error occurs during detection
 */
- (LBZXQRCodeAlignmentPattern *)findAlignmentInRegion:(float)overallEstModuleSize estAlignmentX:(int)estAlignmentX estAlignmentY:(int)estAlignmentY allowanceFactor:(float)allowanceFactor error:(NSError **)error;

@end
