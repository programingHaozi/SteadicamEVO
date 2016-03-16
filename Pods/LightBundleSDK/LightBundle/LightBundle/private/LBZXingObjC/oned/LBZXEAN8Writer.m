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

#import "LBZXBarcodeFormat.h"
#import "LBZXBoolArray.h"
#import "LBZXEAN8Writer.h"
#import "LBZXUPCEANReader.h"

const int LBZX_EAN8_CODE_WIDTH = 3 + (7 * 4) + 5 + (7 * 4) + 3;

@implementation LBZXEAN8Writer

- (LBZXBitMatrix *)encode:(NSString *)contents format:(LBZXBarcodeFormat)format width:(int)width height:(int)height hints:(LBZXEncodeHints *)hints error:(NSError **)error {
  if (format != kBarcodeFormatEan8) {
    [NSException raise:NSInvalidArgumentException format:@"Can only encode EAN_8"];
  }
  return [super encode:contents format:format width:width height:height hints:hints error:error];
}

/**
 * Returns a byte array of horizontal pixels (FALSE = white, TRUE = black)
 */
- (LBZXBoolArray *)encode:(NSString *)contents {
  if ([contents length] != 8) {
    [NSException raise:NSInvalidArgumentException format:@"Requested contents should be 8 digits long, but got %d", (int)[contents length]];
  }

  LBZXBoolArray *result = [[LBZXBoolArray alloc] initWithLength:LBZX_EAN8_CODE_WIDTH];
  int pos = 0;

  pos += [self appendPattern:result pos:pos pattern:LBZX_UPC_EAN_START_END_PATTERN patternLen:LBZX_UPC_EAN_START_END_PATTERN_LEN startColor:YES];

  for (int i = 0; i <= 3; i++) {
    int digit = [[contents substringWithRange:NSMakeRange(i, 1)] intValue];
    pos += [self appendPattern:result pos:pos pattern:LBZX_UPC_EAN_L_PATTERNS[digit] patternLen:LBZX_UPC_EAN_L_PATTERNS_SUB_LEN startColor:FALSE];
  }

  pos += [self appendPattern:result pos:pos pattern:LBZX_UPC_EAN_MIDDLE_PATTERN patternLen:LBZX_UPC_EAN_MIDDLE_PATTERN_LEN startColor:FALSE];

  for (int i = 4; i <= 7; i++) {
    int digit = [[contents substringWithRange:NSMakeRange(i, 1)] intValue];
    pos += [super appendPattern:result pos:pos pattern:LBZX_UPC_EAN_L_PATTERNS[digit] patternLen:LBZX_UPC_EAN_L_PATTERNS_SUB_LEN startColor:YES];
  }

  [self appendPattern:result pos:pos pattern:LBZX_UPC_EAN_START_END_PATTERN patternLen:LBZX_UPC_EAN_START_END_PATTERN_LEN startColor:YES];

  return result;
}

@end
