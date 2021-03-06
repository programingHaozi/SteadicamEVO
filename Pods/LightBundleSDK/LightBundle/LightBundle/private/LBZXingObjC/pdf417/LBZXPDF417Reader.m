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

#import "LBZXBarcodeFormat.h"
#import "LBZXBinaryBitmap.h"
#import "LBZXBitMatrix.h"
#import "LBZXDecodeHints.h"
#import "LBZXDecoderResult.h"
#import "LBZXDetectorResult.h"
#import "LBZXErrors.h"
#import "LBZXPDF417Common.h"
#import "LBZXPDF417Detector.h"
#import "LBZXPDF417DetectorResult.h"
#import "LBZXPDF417Reader.h"
#import "LBZXPDF417ResultMetadata.h"
#import "LBZXPDF417ScanningDecoder.h"
#import "LBZXResult.h"
#import "LBZXResultPoint.h"

@implementation LBZXPDF417Reader

/**
 * Locates and decodes a PDF417 code in an image.
 *
 * @return a String representing the content encoded by the PDF417 code
 * @return nil if a PDF417 code cannot be found,
 * @return nil if a PDF417 cannot be decoded
 */
- (LBZXResult *)decode:(LBZXBinaryBitmap *)image error:(NSError **)error {
  return [self decode:image hints:nil error:error];
}

- (LBZXResult *)decode:(LBZXBinaryBitmap *)image hints:(LBZXDecodeHints *)hints error:(NSError **)error {
  NSArray *result = [self decode:image hints:hints multiple:NO error:error];
  if (!result || result.count == 0 || !result[0]) {
    if (error) *error = LBZXNotFoundErrorInstance();
    return nil;
  }
  return result[0];
}

- (NSArray *)decodeMultiple:(LBZXBinaryBitmap *)image error:(NSError **)error {
  return [self decodeMultiple:image hints:nil error:error];
}

- (NSArray *)decodeMultiple:(LBZXBinaryBitmap *)image hints:(LBZXDecodeHints *)hints error:(NSError **)error {
  return [self decode:image hints:hints multiple:YES error:error];
}

- (NSArray *)decode:(LBZXBinaryBitmap *)image hints:(LBZXDecodeHints *)hints multiple:(BOOL)multiple error:(NSError **)error {
  NSMutableArray *results = [NSMutableArray array];
  LBZXPDF417DetectorResult *detectorResult = [LBZXPDF417Detector detect:image hints:hints multiple:multiple error:error];
  if (!detectorResult) {
    return nil;
  }
  for (NSArray *points in detectorResult.points) {
    LBZXResultPoint *imageTopLeft = points[4] == [NSNull null] ? nil : points[4];
    LBZXResultPoint *imageBottomLeft = points[5] == [NSNull null] ? nil : points[5];
    LBZXResultPoint *imageTopRight = points[6] == [NSNull null] ? nil : points[6];
    LBZXResultPoint *imageBottomRight = points[7] == [NSNull null] ? nil : points[7];

    LBZXDecoderResult *decoderResult = [LBZXPDF417ScanningDecoder decode:detectorResult.bits
                                                        imageTopLeft:imageTopLeft
                                                     imageBottomLeft:imageBottomLeft
                                                       imageTopRight:imageTopRight
                                                    imageBottomRight:imageBottomRight
                                                    minCodewordWidth:[self minCodewordWidth:points]
                                                    maxCodewordWidth:[self maxCodewordWidth:points]];
    if (!decoderResult) {
      return nil;
    }
    LBZXResult *result = [[LBZXResult alloc] initWithText:decoderResult.text
                                             rawBytes:decoderResult.rawBytes
                                               resultPoints:points
                                               format:kBarcodeFormatPDF417];
    [result putMetadata:kResultMetadataTypeErrorCorrectionLevel value:decoderResult.ecLevel];
    LBZXPDF417ResultMetadata *pdf417ResultMetadata = decoderResult.other;
    if (pdf417ResultMetadata) {
      [result putMetadata:kResultMetadataTypePDF417ExtraMetadata value:pdf417ResultMetadata];
    }
    [results addObject:result];
  }
  return [NSArray arrayWithArray:results];
}

- (int)maxWidth:(LBZXResultPoint *)p1 p2:(LBZXResultPoint *)p2 {
  if (!p1 || !p2 || (id)p1 == [NSNull null] || p2 == (id)[NSNull null]) {
    return 0;
  }
  return abs(p1.x - p2.x);
}

- (int)minWidth:(LBZXResultPoint *)p1 p2:(LBZXResultPoint *)p2 {
  if (!p1 || !p2 || (id)p1 == [NSNull null] || p2 == (id)[NSNull null]) {
    return INT_MAX;
  }
  return abs(p1.x - p2.x);
}

- (int)maxCodewordWidth:(NSArray *)p {
  return MAX(
             MAX([self maxWidth:p[0] p2:p[4]], [self maxWidth:p[6] p2:p[2]] * LBZX_PDF417_MODULES_IN_CODEWORD /
                 LBZX_PDF417_MODULES_IN_STOP_PATTERN),
             MAX([self maxWidth:p[1] p2:p[5]], [self maxWidth:p[7] p2:p[3]] * LBZX_PDF417_MODULES_IN_CODEWORD /
                 LBZX_PDF417_MODULES_IN_STOP_PATTERN));
}

- (int)minCodewordWidth:(NSArray *)p {
  return MIN(
             MIN([self minWidth:p[0] p2:p[4]], [self minWidth:p[6] p2:p[2]] * LBZX_PDF417_MODULES_IN_CODEWORD /
                 LBZX_PDF417_MODULES_IN_STOP_PATTERN),
             MIN([self minWidth:p[1] p2:p[5]], [self minWidth:p[7] p2:p[3]] * LBZX_PDF417_MODULES_IN_CODEWORD /
                 LBZX_PDF417_MODULES_IN_STOP_PATTERN));
}

- (void)reset {
  // nothing needs to be reset
}

@end
