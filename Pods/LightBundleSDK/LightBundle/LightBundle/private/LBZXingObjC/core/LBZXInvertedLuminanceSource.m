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
#import "LBZXInvertedLuminanceSource.h"

@interface LBZXInvertedLuminanceSource ()

@property (nonatomic, weak, readonly) LBZXLuminanceSource *delegate;

@end

@implementation LBZXInvertedLuminanceSource

- (id)initWithDelegate:(LBZXLuminanceSource *)delegate {
  self = [super initWithWidth:delegate.width height:delegate.height];
  if (self) {
    _delegate = delegate;
  }

  return self;
}

- (LBZXByteArray *)rowAtY:(int)y row:(LBZXByteArray *)row {
  row = [self.delegate rowAtY:y row:row];
  int width = self.width;
  for (int i = 0; i < width; i++) {
    row.array[i] = (int8_t) (255 - (row.array[i] & 0xFF));
  }
  return row;
}

- (LBZXByteArray *)matrix {
  LBZXByteArray *matrix = [self.delegate matrix];
  int length = self.width * self.height;
  LBZXByteArray *invertedMatrix = [[LBZXByteArray alloc] initWithLength:length];
  for (int i = 0; i < length; i++) {
    invertedMatrix.array[i] = (int8_t) (255 - (matrix.array[i] & 0xFF));
  }
  return invertedMatrix;
}

- (BOOL)cropSupported {
  return self.delegate.cropSupported;
}

- (LBZXLuminanceSource *)crop:(int)left top:(int)top width:(int)aWidth height:(int)aHeight {
  return [[LBZXInvertedLuminanceSource alloc] initWithDelegate:[self.delegate crop:left top:top width:aWidth height:aHeight]];
}

- (BOOL)rotateSupported {
  return self.delegate.rotateSupported;
}

/**
 * @return original delegate LBZXLuminanceSource since invert undoes itself
 */
- (LBZXLuminanceSource *)invert {
  return self.delegate;
}

- (LBZXLuminanceSource *)rotateCounterClockwise {
  return [[LBZXInvertedLuminanceSource alloc] initWithDelegate:[self.delegate rotateCounterClockwise]];
}

- (LBZXLuminanceSource *)rotateCounterClockwise45 {
  return [[LBZXInvertedLuminanceSource alloc] initWithDelegate:[self.delegate rotateCounterClockwise45]];
}

@end
