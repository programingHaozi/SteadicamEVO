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
#import "LBZXPDF417BarcodeRow.h"

@interface LBZXPDF417BarcodeRow ()

//A tacker for position in the bar
@property (nonatomic, assign) int currentLocation;

@end

@implementation LBZXPDF417BarcodeRow

+ (LBZXPDF417BarcodeRow *)barcodeRowWithWidth:(int)width {
  return [[LBZXPDF417BarcodeRow alloc] initWithWidth:width];
}

- (id)initWithWidth:(int)width {
  if (self = [super init]) {
    _row = [[LBZXByteArray alloc] initWithLength:width];
    _currentLocation = 0;
  }
  return self;
}

- (void)setX:(int)x value:(int8_t)value {
  self.row.array[x] = value;
}

- (void)setX:(int)x black:(BOOL)black {
  self.row.array[x] = (int8_t) (black ? 1 : 0);
}

- (void)addBar:(BOOL)black width:(int)width {
  for (int ii = 0; ii < width; ii++) {
    [self setX:self.currentLocation++ black:black];
  }
}

- (LBZXByteArray *)scaledRow:(int)scale {
  LBZXByteArray *output = [[LBZXByteArray alloc] initWithLength:self.row.length * scale];
  for (int i = 0; i < output.length; i++) {
    output.array[i] = self.row.array[i / scale];
  }
  return output;
}

@end
