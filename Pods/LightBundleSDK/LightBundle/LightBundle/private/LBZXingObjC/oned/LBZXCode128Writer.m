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

#import "LBZXBoolArray.h"
#import "LBZXCode128Reader.h"
#import "LBZXCode128Writer.h"

// Dummy characters used to specify control characters in input
const unichar LBZX_CODE128_ESCAPE_FNC_1 = L'\u00f1';
const unichar LBZX_CODE128_ESCAPE_FNC_2 = L'\u00f2';
const unichar LBZX_CODE128_ESCAPE_FNC_3 = L'\u00f3';
const unichar LBZX_CODE128_ESCAPE_FNC_4 = L'\u00f4';

@implementation LBZXCode128Writer

- (LBZXBitMatrix *)encode:(NSString *)contents format:(LBZXBarcodeFormat)format width:(int)width height:(int)height hints:(LBZXEncodeHints *)hints error:(NSError **)error {
  if (format != kBarcodeFormatCode128) {
    [NSException raise:NSInvalidArgumentException format:@"Can only encode CODE_128"];
  }
  return [super encode:contents format:format width:width height:height hints:hints error:error];
}

- (LBZXBoolArray *)encode:(NSString *)contents {
  int length = (int)[contents length];
  // Check length
  if (length < 1 || length > 80) {
    [NSException raise:NSInvalidArgumentException format:@"Contents length should be between 1 and 80 characters, but got %d", length];
  }
  // Check content
  for (int i = 0; i < length; i++) {
    unichar c = [contents characterAtIndex:i];
    if (c < ' ' || c > '~') {
      switch (c) {
        case LBZX_CODE128_ESCAPE_FNC_1:
        case LBZX_CODE128_ESCAPE_FNC_2:
        case LBZX_CODE128_ESCAPE_FNC_3:
        case LBZX_CODE128_ESCAPE_FNC_4:
          break;
        default:
          [NSException raise:NSInvalidArgumentException format:@"Bad character in input: %C", c];
      }
    }
  }

  NSMutableArray *patterns = [NSMutableArray array]; // temporary storage for patterns
  int checkSum = 0;
  int checkWeight = 1;
  int codeSet = 0; // selected code (CODE_CODE_B or CODE_CODE_C)
  int position = 0; // position in contents

  while (position < length) {
    //Select code to use
    int requiredDigitCount = codeSet == LBZX_CODE128_CODE_CODE_C ? 2 : 4;
    int newCodeSet;
    if ([self isDigits:contents start:position length:requiredDigitCount]) {
      newCodeSet = LBZX_CODE128_CODE_CODE_C;
    } else {
      newCodeSet = LBZX_CODE128_CODE_CODE_B;
    }

    //Get the pattern index
    int patternIndex;
    if (newCodeSet == codeSet) {
      // Encode the current character
      // First handle escapes
      switch ([contents characterAtIndex:position]) {
        case LBZX_CODE128_ESCAPE_FNC_1:
          patternIndex = LBZX_CODE128_CODE_FNC_1;
          break;
        case LBZX_CODE128_ESCAPE_FNC_2:
          patternIndex = LBZX_CODE128_CODE_FNC_2;
          break;
        case LBZX_CODE128_ESCAPE_FNC_3:
          patternIndex = LBZX_CODE128_CODE_FNC_3;
          break;
        case LBZX_CODE128_ESCAPE_FNC_4:
          patternIndex = LBZX_CODE128_CODE_FNC_4_B; // FIXME if this ever outputs Code A
          break;
        default:
          // Then handle normal characters otherwise
          if (codeSet == LBZX_CODE128_CODE_CODE_B) {
            patternIndex = [contents characterAtIndex:position] - ' ';
          } else { // CODE_CODE_C
            patternIndex = [[contents substringWithRange:NSMakeRange(position, 2)] intValue];
            position++; // Also incremented below
          }
      }
      position++;
    } else {
      // Should we change the current code?
      // Do we have a code set?
      if (codeSet == 0) {
        // No, we don't have a code set
        if (newCodeSet == LBZX_CODE128_CODE_CODE_B) {
          patternIndex = LBZX_CODE128_CODE_START_B;
        } else {
          // CODE_CODE_C
          patternIndex = LBZX_CODE128_CODE_START_C;
        }
      } else {
        // Yes, we have a code set
        patternIndex = newCodeSet;
      }
      codeSet = newCodeSet;
    }

    // Get the pattern
    NSMutableArray *pattern = [NSMutableArray array];
    for (int i = 0; i < sizeof(LBZX_CODE128_CODE_PATTERNS[patternIndex]) / sizeof(int); i++) {
      [pattern addObject:@(LBZX_CODE128_CODE_PATTERNS[patternIndex][i])];
    }
    [patterns addObject:pattern];

    // Compute checksum
    checkSum += patternIndex * checkWeight;
    if (position != 0) {
      checkWeight++;
    }
  }

  // Compute and append checksum
  checkSum %= 103;
  NSMutableArray *pattern = [NSMutableArray array];
  for (int i = 0; i < sizeof(LBZX_CODE128_CODE_PATTERNS[checkSum]) / sizeof(int); i++) {
    [pattern addObject:@(LBZX_CODE128_CODE_PATTERNS[checkSum][i])];
  }
  [patterns addObject:pattern];

  // Append stop code
  pattern = [NSMutableArray array];
  for (int i = 0; i < sizeof(LBZX_CODE128_CODE_PATTERNS[LBZX_CODE128_CODE_STOP]) / sizeof(int); i++) {
    [pattern addObject:@(LBZX_CODE128_CODE_PATTERNS[LBZX_CODE128_CODE_STOP][i])];
  }
  [patterns addObject:pattern];

  // Compute code width
  int codeWidth = 0;
  for (pattern in patterns) {
    for (int i = 0; i < pattern.count; i++) {
      codeWidth += [pattern[i] intValue];
    }
  }

  // Compute result
  LBZXBoolArray *result = [[LBZXBoolArray alloc] initWithLength:codeWidth];
  int pos = 0;
  for (NSArray *patternArray in patterns) {
    int patternLen = (int)[patternArray count];
    int pattern[patternLen];
    for(int i = 0; i < patternLen; i++) {
      pattern[i] = [patternArray[i] intValue];
    }

    pos += [self appendPattern:result pos:pos pattern:pattern patternLen:patternLen startColor:YES];
  }

  return result;
}

- (BOOL)isDigits:(NSString *)value start:(int)start length:(unsigned int)length {
  int end = start + length;
  int last = (int)[value length];
  for (int i = start; i < end && i < last; i++) {
    unichar c = [value characterAtIndex:i];
    if (c < '0' || c > '9') {
      if (c != LBZX_CODE128_ESCAPE_FNC_1) {
        return NO;
      }
      end++; // ignore FNC_1
    }
  }
  return end <= last; // end > last if we've run out of string
}

@end
