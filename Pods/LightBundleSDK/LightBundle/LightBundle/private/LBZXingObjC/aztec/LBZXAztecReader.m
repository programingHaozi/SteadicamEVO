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

#import "LBZXAztecDecoder.h"
#import "LBZXAztecDetector.h"
#import "LBZXAztecDetectorResult.h"
#import "LBZXAztecReader.h"
#import "LBZXBinaryBitmap.h"
#import "LBZXDecodeHints.h"
#import "LBZXDecoderResult.h"
#import "LBZXReader.h"
#import "LBZXResult.h"
#import "LBZXResultPointCallback.h"

@implementation LBZXAztecReader

- (LBZXResult *)decode:(LBZXBinaryBitmap *)image error:(NSError **)error {
  return [self decode:image hints:nil error:error];
}

- (LBZXResult *)decode:(LBZXBinaryBitmap *)image hints:(LBZXDecodeHints *)hints error:(NSError **)error {
  LBZXBitMatrix *matrix = [image blackMatrixWithError:error];
  if (!matrix) {
    return nil;
  }

  LBZXAztecDetector *detector = [[LBZXAztecDetector alloc] initWithImage:matrix];
  NSArray *points = nil;
  LBZXDecoderResult *decoderResult = nil;

  LBZXAztecDetectorResult *detectorResult = [detector detectWithMirror:NO error:error];
  if (detectorResult) {
    points = detectorResult.points;
    decoderResult = [[[LBZXAztecDecoder alloc] init] decode:detectorResult error:error];
  }

  if (decoderResult == nil) {
    detectorResult = [detector detectWithMirror:YES error:nil];
    points = detectorResult.points;
    if (detectorResult) {
      decoderResult = [[[LBZXAztecDecoder alloc] init] decode:detectorResult error:nil];
    }
  }

  if (!decoderResult) {
    return nil;
  }

  if (hints != nil) {
    id <LBZXResultPointCallback> rpcb = hints.resultPointCallback;
    if (rpcb != nil) {
      for (LBZXResultPoint *p in points) {
        [rpcb foundPossibleResultPoint:p];
      }
    }
  }

  LBZXResult *result = [LBZXResult resultWithText:decoderResult.text rawBytes:decoderResult.rawBytes resultPoints:points format:kBarcodeFormatAztec];

  NSMutableArray *byteSegments = decoderResult.byteSegments;
  if (byteSegments != nil) {
    [result putMetadata:kResultMetadataTypeByteSegments value:byteSegments];
  }
  NSString *ecLevel = decoderResult.ecLevel;
  if (ecLevel != nil) {
    [result putMetadata:kResultMetadataTypeErrorCorrectionLevel value:ecLevel];
  }

  return result;
}

- (void)reset {
  // do nothing
}

@end
