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

#import "LBZXByteArray.h"
#import "LBZXDecoderResult.h"
#import "LBZXDetectorResult.h"
#import "LBZXMultiDetector.h"
#import "LBZXQRCodeDecoder.h"
#import "LBZXQRCodeDecoderMetaData.h"
#import "LBZXQRCodeMultiReader.h"
#import "LBZXResult.h"

@implementation LBZXQRCodeMultiReader

- (NSArray *)decodeMultiple:(LBZXBinaryBitmap *)image error:(NSError **)error {
  return [self decodeMultiple:image hints:nil error:error];
}

- (NSArray *)decodeMultiple:(LBZXBinaryBitmap *)image hints:(LBZXDecodeHints *)hints error:(NSError **)error {
  LBZXBitMatrix *matrix = [image blackMatrixWithError:error];
  if (!matrix) {
    return nil;
  }
  NSMutableArray *results = [NSMutableArray array];
  NSArray *detectorResults = [[[LBZXMultiDetector alloc] initWithImage:matrix] detectMulti:hints error:error];
  if (!detectorResults) {
    return nil;
  }
  for (LBZXDetectorResult *detectorResult in detectorResults) {
    LBZXDecoderResult *decoderResult = [[self decoder] decodeMatrix:[detectorResult bits] hints:hints error:nil];
    if (decoderResult) {
      NSMutableArray *points = [[detectorResult points] mutableCopy];
      // If the code was mirrored: swap the bottom-left and the top-right points.
      if ([decoderResult.other isKindOfClass:[LBZXQRCodeDecoderMetaData class]]) {
        [(LBZXQRCodeDecoderMetaData *)decoderResult.other applyMirroredCorrection:points];
      }
      LBZXResult *result = [LBZXResult resultWithText:decoderResult.text
                                         rawBytes:decoderResult.rawBytes
                                     resultPoints:points
                                           format:kBarcodeFormatQRCode];
      NSMutableArray *byteSegments = decoderResult.byteSegments;
      if (byteSegments != nil) {
        [result putMetadata:kResultMetadataTypeByteSegments value:byteSegments];
      }
      NSString *ecLevel = decoderResult.ecLevel;
      if (ecLevel != nil) {
        [result putMetadata:kResultMetadataTypeErrorCorrectionLevel value:ecLevel];
      }
      if ([decoderResult hasStructuredAppend]) {
        [result putMetadata:kResultMetadataTypeStructuredAppendSequence
                      value:@(decoderResult.structuredAppendSequenceNumber)];
        [result putMetadata:kResultMetadataTypeStructuredAppendParity
                      value:@(decoderResult.structuredAppendParity)];
      }
      [results addObject:result];
    }
  }

  results = [self processStructuredAppend:results];
  return results;
}

- (NSMutableArray *)processStructuredAppend:(NSMutableArray *)results {
  BOOL hasSA = NO;

  // first, check, if there is at least on SA result in the list
  for (LBZXResult *result in results) {
    if (result.resultMetadata[@(kResultMetadataTypeStructuredAppendSequence)]) {
      hasSA = YES;
      break;
    }
  }
  if (!hasSA) {
    return results;
  }

  // it is, second, split the lists and built a new result list
  NSMutableArray *newResults = [NSMutableArray array];
  NSMutableArray *saResults = [NSMutableArray array];
  for (LBZXResult *result in results) {
    [newResults addObject:result];
    if (result.resultMetadata[@(kResultMetadataTypeStructuredAppendSequence)]) {
      [saResults addObject:result];
    }
  }
  // sort and concatenate the SA list items
  [saResults sortUsingComparator:^NSComparisonResult(LBZXResult *a, LBZXResult *b) {
    int aNumber = [a.resultMetadata[@(kResultMetadataTypeStructuredAppendSequence)] intValue];
    int bNumber = [b.resultMetadata[@(kResultMetadataTypeStructuredAppendSequence)] intValue];
    if (aNumber < bNumber) {
      return NSOrderedAscending;
    }
    if (aNumber > bNumber) {
      return NSOrderedDescending;
    }
    return NSOrderedSame;
  }];
  NSMutableString *concatedText = [NSMutableString string];
  int rawBytesLen = 0;
  int byteSegmentLength = 0;
  for (LBZXResult *saResult in saResults) {
    [concatedText appendString:saResult.text];
    rawBytesLen += saResult.rawBytes.length;
    if (saResult.resultMetadata[@(kResultMetadataTypeByteSegments)]) {
      for (LBZXByteArray *segment in saResult.resultMetadata[@(kResultMetadataTypeByteSegments)]) {
        byteSegmentLength += segment.length;
      }
    }
  }
  LBZXByteArray *newRawBytes = [[LBZXByteArray alloc] initWithLength:rawBytesLen];
  LBZXByteArray *newByteSegment = [[LBZXByteArray alloc] initWithLength:byteSegmentLength];
  int newRawBytesIndex = 0;
  int byteSegmentIndex = 0;
  for (LBZXResult *saResult in saResults) {
    memcpy(newRawBytes.array, saResult.rawBytes.array, saResult.rawBytes.length * sizeof(int8_t));
    newRawBytesIndex += saResult.rawBytes.length;
    if (saResult.resultMetadata[@(kResultMetadataTypeByteSegments)]) {
      for (LBZXByteArray *segment in saResult.resultMetadata[@(kResultMetadataTypeByteSegments)]) {
        memcpy(newByteSegment.array, segment.array, segment.length * sizeof(int8_t));
        byteSegmentIndex += segment.length;
      }
    }
  }
  LBZXResult *newResult = [[LBZXResult alloc] initWithText:concatedText rawBytes:newRawBytes resultPoints:@[] format:kBarcodeFormatQRCode];
  if (byteSegmentLength > 0) {
    NSMutableArray *byteSegmentList = [NSMutableArray array];
    [byteSegmentList addObject:newByteSegment];
    [newResult putMetadata:kResultMetadataTypeByteSegments value:byteSegmentList];
  }
  [newResults addObject:newResult];
  return newResults;
}

@end
