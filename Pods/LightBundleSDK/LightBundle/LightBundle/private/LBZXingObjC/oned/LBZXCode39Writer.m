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

#import "LBZXBitMatrix.h"
#import "LBZXBoolArray.h"
#import "LBZXCode39Reader.h"
#import "LBZXCode39Writer.h"
#import "LBZXIntArray.h"

@implementation LBZXCode39Writer

- (LBZXBitMatrix *)encode:(NSString *)contents format:(LBZXBarcodeFormat)format width:(int)width height:(int)height hints:(LBZXEncodeHints *)hints error:(NSError **)error {
  if (format != kBarcodeFormatCode39) {
    [NSException raise:NSInvalidArgumentException format:@"Can only encode CODE_39."];
  }
  return [super encode:contents format:format width:width height:height hints:hints error:error];
}

- (LBZXBoolArray *)encode:(NSString *)contents {
  int length = (int)[contents length];
  if (length > 80) {
    [NSException raise:NSInvalidArgumentException
                format:@"Requested contents should be less than 80 digits long, but got %d", length];
  }

  LBZXIntArray *widths = [[LBZXIntArray alloc] initWithLength:9];
  int codeWidth = 24 + 1 + length;
  for (int i = 0; i < length; i++) {
    NSUInteger indexInString = [LBZX_CODE39_ALPHABET_STRING rangeOfString:[contents substringWithRange:NSMakeRange(i, 1)]].location;
    if (indexInString == NSNotFound) {
      [NSException raise:NSInvalidArgumentException format:@"Bad contents: %@", contents];
    }
    [self toIntArray:LBZX_CODE39_CHARACTER_ENCODINGS[indexInString] toReturn:widths];
    codeWidth += [widths sum];
  }
  LBZXBoolArray *result = [[LBZXBoolArray alloc] initWithLength:codeWidth];
  [self toIntArray:LBZX_CODE39_CHARACTER_ENCODINGS[39] toReturn:widths];
  int pos = [self appendPattern:result pos:0 pattern:widths.array patternLen:widths.length startColor:YES];
  LBZXIntArray *narrowWhite = [[LBZXIntArray alloc] initWithInts:1, -1];
  pos += [self appendPattern:result pos:pos pattern:narrowWhite.array patternLen:narrowWhite.length startColor:NO];
  //append next character to byte matrix
  for (int i = 0; i < length; i++) {
    NSUInteger indexInString = [LBZX_CODE39_ALPHABET_STRING rangeOfString:[contents substringWithRange:NSMakeRange(i, 1)]].location;
    [self toIntArray:LBZX_CODE39_CHARACTER_ENCODINGS[indexInString] toReturn:widths];
    pos += [self appendPattern:result pos:pos pattern:widths.array patternLen:widths.length startColor:YES];
    pos += [self appendPattern:result pos:pos pattern:narrowWhite.array patternLen:narrowWhite.length startColor:NO];
  }

  [self toIntArray:LBZX_CODE39_CHARACTER_ENCODINGS[39] toReturn:widths];
  [self appendPattern:result pos:pos pattern:widths.array patternLen:widths.length startColor:YES];
  return result;
}

- (void)toIntArray:(int)a toReturn:(LBZXIntArray *)toReturn {
  for (int i = 0; i < 9; i++) {
    int temp = a & (1 << (8 - i));
    toReturn.array[i] = temp == 0 ? 1 : 2;
  }
}

@end
