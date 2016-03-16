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

#import "LBZXGlobalHistogramBinarizer.h"
#import "LBZXBitArray.h"
#import "LBZXBitMatrix.h"
#import "LBZXByteArray.h"
#import "LBZXErrors.h"
#import "LBZXIntArray.h"
#import "LBZXLuminanceSource.h"

const int LBZX_LUMINANCE_BITS = 5;
const int LBZX_LUMINANCE_SHIFT = 8 - LBZX_LUMINANCE_BITS;
const int LBZX_LUMINANCE_BUCKETS = 1 << LBZX_LUMINANCE_BITS;

@interface LBZXGlobalHistogramBinarizer ()

@property (nonatomic, strong) LBZXByteArray *luminances;
@property (nonatomic, strong) LBZXIntArray *buckets;

@end

@implementation LBZXGlobalHistogramBinarizer

- (id)initWithSource:(LBZXLuminanceSource *)source {
  if (self = [super initWithSource:source]) {
    _luminances = [[LBZXByteArray alloc] initWithLength:0];
    _buckets = [[LBZXIntArray alloc] initWithLength:LBZX_LUMINANCE_BUCKETS];
  }

  return self;
}

- (LBZXBitArray *)blackRow:(int)y row:(LBZXBitArray *)row error:(NSError **)error {
  LBZXLuminanceSource *source = self.luminanceSource;
  int width = source.width;
  if (row == nil || row.size < width) {
    row = [[LBZXBitArray alloc] initWithSize:width];
  } else {
    [row clear];
  }

  [self initArrays:width];
  LBZXByteArray *localLuminances = [source rowAtY:y row:self.luminances];
  LBZXIntArray *localBuckets = self.buckets;
  for (int x = 0; x < width; x++) {
    int pixel = localLuminances.array[x] & 0xff;
    localBuckets.array[pixel >> LBZX_LUMINANCE_SHIFT]++;
  }
  int blackPoint = [self estimateBlackPoint:localBuckets];
  if (blackPoint == -1) {
    if (error) *error = LBZXNotFoundErrorInstance();
    return nil;
  }

  int left = localLuminances.array[0] & 0xff;
  int center = localLuminances.array[1] & 0xff;
  for (int x = 1; x < width - 1; x++) {
    int right = localLuminances.array[x + 1] & 0xff;
    // A simple -1 4 -1 box filter with a weight of 2.
    int luminance = ((center << 2) - left - right) >> 1;
    if (luminance < blackPoint) {
      [row set:x];
    }
    left = center;
    center = right;
  }

  return row;
}

- (LBZXBitMatrix *)blackMatrixWithError:(NSError **)error {
  LBZXLuminanceSource *source = self.luminanceSource;
  int width = source.width;
  int height = source.height;
  LBZXBitMatrix *matrix = [[LBZXBitMatrix alloc] initWithWidth:width height:height];

  // Quickly calculates the histogram by sampling four rows from the image. This proved to be
  // more robust on the blackbox tests than sampling a diagonal as we used to do.
  [self initArrays:width];

  // We delay reading the entire image luminance until the black point estimation succeeds.
  // Although we end up reading four rows twice, it is consistent with our motto of
  // "fail quickly" which is necessary for continuous scanning.
  LBZXIntArray *localBuckets = self.buckets;
  for (int y = 1; y < 5; y++) {
    int row = height * y / 5;
    LBZXByteArray *localLuminances = [source rowAtY:row row:self.luminances];
    int right = (width << 2) / 5;
    for (int x = width / 5; x < right; x++) {
      int pixel = localLuminances.array[x] & 0xff;
      localBuckets.array[pixel >> LBZX_LUMINANCE_SHIFT]++;
    }
  }
  int blackPoint = [self estimateBlackPoint:localBuckets];
  if (blackPoint == -1) {
    if (error) *error = LBZXNotFoundErrorInstance();
    return nil;
  }

  LBZXByteArray *localLuminances = source.matrix;
  for (int y = 0; y < height; y++) {
    int offset = y * width;
    for (int x = 0; x < width; x++) {
      int pixel = localLuminances.array[offset + x] & 0xff;
      if (pixel < blackPoint) {
        [matrix setX:x y:y];
      }
    }
  }

  return matrix;
}

- (LBZXBinarizer *)createBinarizer:(LBZXLuminanceSource *)source {
  return [[LBZXGlobalHistogramBinarizer alloc] initWithSource:source];
}

- (void)initArrays:(int)luminanceSize {
  if (self.luminances.length < luminanceSize) {
    self.luminances = [[LBZXByteArray alloc] initWithLength:luminanceSize];
  }

  for (int x = 0; x < LBZX_LUMINANCE_BUCKETS; x++) {
    self.buckets.array[x] = 0;
  }
}

- (int)estimateBlackPoint:(LBZXIntArray *)buckets {
  // Find the tallest peak in the histogram.
  int numBuckets = buckets.length;
  int maxBucketCount = 0;
  int firstPeak = 0;
  int firstPeakSize = 0;
  for (int x = 0; x < numBuckets; x++) {
    if (buckets.array[x] > firstPeakSize) {
      firstPeak = x;
      firstPeakSize = buckets.array[x];
    }
    if (buckets.array[x] > maxBucketCount) {
      maxBucketCount = buckets.array[x];
    }
  }

  // Find the second-tallest peak which is somewhat far from the tallest peak.
  int secondPeak = 0;
  int secondPeakScore = 0;
  for (int x = 0; x < numBuckets; x++) {
    int distanceToBiggest = x - firstPeak;
    // Encourage more distant second peaks by multiplying by square of distance.
    int score = buckets.array[x] * distanceToBiggest * distanceToBiggest;
    if (score > secondPeakScore) {
      secondPeak = x;
      secondPeakScore = score;
    }
  }

  // Make sure firstPeak corresponds to the black peak.
  if (firstPeak > secondPeak) {
    int temp = firstPeak;
    firstPeak = secondPeak;
    secondPeak = temp;
  }

  // If there is too little contrast in the image to pick a meaningful black point, throw rather
  // than waste time trying to decode the image, and risk false positives.
  if (secondPeak - firstPeak <= numBuckets >> 4) {
    return -1;
  }

  // Find a valley between them that is low and closer to the white peak.
  int bestValley = secondPeak - 1;
  int bestValleyScore = -1;
  for (int x = secondPeak - 1; x > firstPeak; x--) {
    int fromFirst = x - firstPeak;
    int score = fromFirst * fromFirst * (secondPeak - x) * (maxBucketCount - buckets.array[x]);
    if (score > bestValleyScore) {
      bestValley = x;
      bestValleyScore = score;
    }
  }

  return bestValley << LBZX_LUMINANCE_SHIFT;
}

@end
