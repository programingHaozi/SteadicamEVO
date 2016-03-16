/*
 * Copyright 2014 LBZXing authors
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

#import "LBZXAztecHighLevelEncoder.h"
#import "LBZXAztecState.h"
#import "LBZXAztecToken.h"
#import "LBZXBitArray.h"
#import "LBZXByteArray.h"

@implementation LBZXAztecState

- (id)initWithToken:(LBZXAztecToken *)token mode:(int)mode binaryBytes:(int)binaryBytes bitCount:(int)bitCount {
  if (self = [super init]) {
    _token = token;
    _mode = mode;
    _binaryShiftByteCount = binaryBytes;
    _bitCount = bitCount;
  }

  return self;
}

+ (LBZXAztecState *)initialState {
  return [[LBZXAztecState alloc] initWithToken:[LBZXAztecToken empty] mode:LBZX_AZTEC_MODE_UPPER binaryBytes:0 bitCount:0];
}

// Create a new state representing this state with a latch to a (not
// necessary different) mode, and then a code.
- (LBZXAztecState *)latchAndAppend:(int)mode value:(int)value {
  int bitCount = self.bitCount;
  LBZXAztecToken *token = self.token;
  if (mode != self.mode) {
    int latch = LBZX_AZTEC_LATCH_TABLE[self.mode][mode];
    token = [token add:latch & 0xFFFF bitCount:latch >> 16];
    bitCount += latch >> 16;
  }
  int latchModeBitCount = mode == LBZX_AZTEC_MODE_DIGIT ? 4 : 5;
  token = [token add:value bitCount:latchModeBitCount];
  return [[LBZXAztecState alloc] initWithToken:token mode:mode binaryBytes:0 bitCount:bitCount + latchModeBitCount];
}

// Create a new state representing this state, with a temporary shift
// to a different mode to output a single value.
- (LBZXAztecState *)shiftAndAppend:(int)mode value:(int)value {
  //assert binaryShiftByteCount == 0 && this.mode != mode;
  LBZXAztecToken *token = self.token;
  int thisModeBitCount = self.mode == LBZX_AZTEC_MODE_DIGIT ? 4 : 5;
  // Shifts exist only to UPPER and PUNCT, both with tokens size 5.
  token = [token add:LBZX_AZTEC_SHIFT_TABLE[self.mode][mode] bitCount:thisModeBitCount];
  token = [token add:value bitCount:5];
  return [[LBZXAztecState alloc] initWithToken:token mode:self.mode binaryBytes:0 bitCount:self.bitCount + thisModeBitCount + 5];
}

// Create a new state representing this state, but an additional character
// output in Binary Shift mode.
- (LBZXAztecState *)addBinaryShiftChar:(int)index {
  LBZXAztecToken *token = self.token;
  int mode = self.mode;
  int bitCount = self.bitCount;
  if (self.mode == LBZX_AZTEC_MODE_PUNCT || self.mode == LBZX_AZTEC_MODE_DIGIT)  {
    int latch = LBZX_AZTEC_LATCH_TABLE[mode][LBZX_AZTEC_MODE_UPPER];
    token = [token add:latch & 0xFFFF bitCount:latch >> 16];
    bitCount += latch >> 16;
    mode = LBZX_AZTEC_MODE_UPPER;
  }
  int deltaBitCount =
    (self.binaryShiftByteCount == 0 || self.binaryShiftByteCount == 31) ? 18 :
    (self.binaryShiftByteCount == 62) ? 9 : 8;
  LBZXAztecState *result = [[LBZXAztecState alloc] initWithToken:token mode:mode binaryBytes:self.binaryShiftByteCount + 1 bitCount:bitCount + deltaBitCount];
  if (result.binaryShiftByteCount == 2047 + 31) {
    // The string is as long as it's allowed to be.  We should end it.
    result = [result endBinaryShift:index + 1];
  }
  return result;
}

// Create the state identical to this one, but we are no longer in
// Binary Shift mode.
- (LBZXAztecState *)endBinaryShift:(int)index {
  if (self.binaryShiftByteCount == 0) {
    return self;
  }
  LBZXAztecToken *token = self.token;
  token = [token addBinaryShift:index - self.binaryShiftByteCount byteCount:self.binaryShiftByteCount];
  return [[LBZXAztecState alloc] initWithToken:token mode:self.mode binaryBytes:0 bitCount:self.bitCount];
}

// Returns true if "this" state is better (or equal) to be in than "that"
// state under all possible circumstances.
- (BOOL)isBetterThanOrEqualTo:(LBZXAztecState *)other {
  int mySize = self.bitCount + (LBZX_AZTEC_LATCH_TABLE[self.mode][other.mode] >> 16);
  if (other.binaryShiftByteCount > 0 &&
      (self.binaryShiftByteCount == 0 || self.binaryShiftByteCount > other.binaryShiftByteCount)) {
    mySize += 10;     // Cost of entering Binary Shift mode.
  }
  return mySize <= other.bitCount;
}

- (LBZXBitArray *)toBitArray:(LBZXByteArray *)text {
  // Reverse the tokens, so that they are in the order that they should
  // be output
  NSMutableArray *symbols = [NSMutableArray array];
  for (LBZXAztecToken *token = [self endBinaryShift:text.length].token; token != nil; token = token.previous) {
    [symbols insertObject:token atIndex:0];
  }
  LBZXBitArray *bitArray = [[LBZXBitArray alloc] init];
  // Add each token to the result.
  for (LBZXAztecToken *symbol in symbols) {
    [symbol appendTo:bitArray text:text];
  }
  return bitArray;
}

- (NSString *)description {
  return [NSString stringWithFormat:@"%@ bits=%d bytes=%d", LBZX_AZTEC_MODE_NAMES[self.mode],
          self.bitCount, self.binaryShiftByteCount];
}

@end
