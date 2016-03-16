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

#import "LBZXErrors.h"
#import "LBZXGenericMultipleBarcodeReader.h"
#import "LBZXReader.h"
#import "LBZXResultPoint.h"

const int LBZX_MIN_DIMENSION_TO_RECUR = 100;
const int LBZX_MAX_DEPTH = 4;

@interface LBZXGenericMultipleBarcodeReader ()

@property (nonatomic, weak, readonly) id<LBZXReader> delegate;

@end

@implementation LBZXGenericMultipleBarcodeReader

- (id)initWithDelegate:(id<LBZXReader>)delegate {
  if (self = [super init]) {
    _delegate = delegate;
  }

  return self;
}

- (NSArray *)decodeMultiple:(LBZXBinaryBitmap *)image error:(NSError **)error {
  return [self decodeMultiple:image hints:nil error:error];
}

- (NSArray *)decodeMultiple:(LBZXBinaryBitmap *)image hints:(LBZXDecodeHints *)hints error:(NSError **)error {
  NSMutableArray *results = [NSMutableArray array];
  if (![self doDecodeMultiple:image hints:hints results:results xOffset:0 yOffset:0 currentDepth:0 error:error]) {
    return nil;
  } else if (results.count == 0) {
    if (error) *error = LBZXNotFoundErrorInstance();
    return nil;
  }
  return results;
}

- (BOOL)doDecodeMultiple:(LBZXBinaryBitmap *)image hints:(LBZXDecodeHints *)hints results:(NSMutableArray *)results
                 xOffset:(int)xOffset yOffset:(int)yOffset currentDepth:(int)currentDepth error:(NSError **)error {
  if (currentDepth > LBZX_MAX_DEPTH) {
    return YES;
  }

  LBZXResult *result = [self.delegate decode:image hints:hints error:error];
  if (!result) {
    return NO;
  }

  BOOL alreadyFound = NO;
  for (LBZXResult *existingResult in results) {
    if ([[existingResult text] isEqualToString:[result text]]) {
      alreadyFound = YES;
      break;
    }
  }
  if (!alreadyFound) {
    [results addObject:[self translateResultPoints:result xOffset:xOffset yOffset:yOffset]];
  }
  NSMutableArray *resultPoints = [result resultPoints];
  if (resultPoints == nil || [resultPoints count] == 0) {
    return YES;
  }
  int width = [image width];
  int height = [image height];
  float minX = width;
  float minY = height;
  float maxX = 0.0f;
  float maxY = 0.0f;
  for (LBZXResultPoint *point in resultPoints) {
    float x = [point x];
    float y = [point y];
    if (x < minX) {
      minX = x;
    }
    if (y < minY) {
      minY = y;
    }
    if (x > maxX) {
      maxX = x;
    }
    if (y > maxY) {
      maxY = y;
    }
  }

  if (minX > LBZX_MIN_DIMENSION_TO_RECUR) {
    return [self doDecodeMultiple:[image crop:0 top:0 width:(int)minX height:height] hints:hints results:results xOffset:xOffset yOffset:yOffset currentDepth:currentDepth + 1 error:error];
  }
  if (minY > LBZX_MIN_DIMENSION_TO_RECUR) {
    return [self doDecodeMultiple:[image crop:0 top:0 width:width height:(int)minY] hints:hints results:results xOffset:xOffset yOffset:yOffset currentDepth:currentDepth + 1 error:error];
  }
  if (maxX < width - LBZX_MIN_DIMENSION_TO_RECUR) {
    return [self doDecodeMultiple:[image crop:(int)maxX top:0 width:width - (int)maxX height:height] hints:hints results:results xOffset:xOffset + (int)maxX yOffset:yOffset currentDepth:currentDepth + 1 error:error];
  }
  if (maxY < height - LBZX_MIN_DIMENSION_TO_RECUR) {
    return [self doDecodeMultiple:[image crop:0 top:(int)maxY width:width height:height - (int)maxY] hints:hints results:results xOffset:xOffset yOffset:yOffset + (int)maxY currentDepth:currentDepth + 1 error:error];
  }

  return YES;
}

- (LBZXResult *)translateResultPoints:(LBZXResult *)result xOffset:(int)xOffset yOffset:(int)yOffset {
  NSArray *oldResultPoints = [result resultPoints];
  if (oldResultPoints == nil) {
    return result;
  }
  NSMutableArray *newResultPoints = [NSMutableArray arrayWithCapacity:[oldResultPoints count]];
  for (LBZXResultPoint *oldPoint in oldResultPoints) {
    [newResultPoints addObject:[[LBZXResultPoint alloc] initWithX:[oldPoint x] + xOffset y:[oldPoint y] + yOffset]];
  }

  LBZXResult *newResult = [LBZXResult resultWithText:result.text rawBytes:result.rawBytes resultPoints:newResultPoints format:result.barcodeFormat];
  [newResult putAllMetadata:result.resultMetadata];
  return newResult;
}

@end
