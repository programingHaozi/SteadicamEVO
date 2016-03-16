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

#import "LBZXBinarizer.h"
#import "LBZXBinaryBitmap.h"
#import "LBZXBitArray.h"
#import "LBZXBitMatrix.h"

@interface LBZXBinaryBitmap ()

@property (nonatomic, strong, readonly) LBZXBinarizer *binarizer;
@property (nonatomic, strong) LBZXBitMatrix *matrix;

@end

@implementation LBZXBinaryBitmap

- (id)initWithBinarizer:(LBZXBinarizer *)binarizer {
  if (self = [super init]) {
    if (binarizer == nil) {
      [NSException raise:NSInvalidArgumentException format:@"Binarizer must be non-null."];
    }

    _binarizer = binarizer;
  }

  return self;
}

+ (id)binaryBitmapWithBinarizer:(LBZXBinarizer *)binarizer {
  return [[self alloc] initWithBinarizer:binarizer];
}

- (int)width {
  return self.binarizer.width;
}

- (int)height {
  return self.binarizer.height;
}

- (LBZXBitArray *)blackRow:(int)y row:(LBZXBitArray *)row error:(NSError **)error {
  return [self.binarizer blackRow:y row:row error:error];
}

- (LBZXBitMatrix *)blackMatrixWithError:(NSError **)error {
  if (self.matrix == nil) {
    self.matrix = [self.binarizer blackMatrixWithError:error];
  }
  return self.matrix;
}

- (BOOL)cropSupported {
  return [self.binarizer luminanceSource].cropSupported;
}

- (LBZXBinaryBitmap *)crop:(int)left top:(int)top width:(int)aWidth height:(int)aHeight {
  LBZXLuminanceSource *newSource = [[self.binarizer luminanceSource] crop:left top:top width:aWidth height:aHeight];
  return [[LBZXBinaryBitmap alloc] initWithBinarizer:[self.binarizer createBinarizer:newSource]];
}

- (BOOL)rotateSupported {
  return [self.binarizer luminanceSource].rotateSupported;
}

- (LBZXBinaryBitmap *)rotateCounterClockwise {
  LBZXLuminanceSource *newSource = [[self.binarizer luminanceSource] rotateCounterClockwise];
  return [[LBZXBinaryBitmap alloc] initWithBinarizer:[self.binarizer createBinarizer:newSource]];
}

- (LBZXBinaryBitmap *)rotateCounterClockwise45 {
  LBZXLuminanceSource *newSource = [[self.binarizer luminanceSource] rotateCounterClockwise45];
  return [[LBZXBinaryBitmap alloc] initWithBinarizer:[self.binarizer createBinarizer:newSource]];
}

- (NSString *)description {
  LBZXBitMatrix *matrix = [self blackMatrixWithError:nil];
  if (matrix) {
    return [matrix description];
  } else {
    return @"";
  }
}

@end
