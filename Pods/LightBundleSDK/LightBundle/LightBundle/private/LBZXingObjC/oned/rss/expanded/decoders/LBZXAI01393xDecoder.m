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

#import "LBZXAI01393xDecoder.h"
#import "LBZXBitArray.h"
#import "LBZXErrors.h"
#import "LBZXRSSExpandedDecodedInformation.h"
#import "LBZXRSSExpandedGeneralAppIdDecoder.h"

@implementation LBZXAI01393xDecoder

const int LBZX_AI01393xDecoder_HEADER_SIZE = 5 + 1 + 2;
const int LBZX_AI01393xDecoder_LAST_DIGIT_SIZE = 2;
const int LBZX_AI01393xDecoder_FIRST_THREE_DIGITS_SIZE = 10;

- (NSString *)parseInformationWithError:(NSError **)error {
  if (self.information.size < LBZX_AI01393xDecoder_HEADER_SIZE + LBZX_AI01_GTIN_SIZE) {
    if (error) *error = LBZXNotFoundErrorInstance();
    return nil;
  }

  NSMutableString *buf = [NSMutableString string];

  [self encodeCompressedGtin:buf currentPos:LBZX_AI01393xDecoder_HEADER_SIZE];

  int lastAIdigit = [self.generalDecoder extractNumericValueFromBitArray:LBZX_AI01393xDecoder_HEADER_SIZE + LBZX_AI01_GTIN_SIZE
                                                                    bits:LBZX_AI01393xDecoder_LAST_DIGIT_SIZE];

  [buf appendFormat:@"(393%d)", lastAIdigit];

  int firstThreeDigits = [self.generalDecoder extractNumericValueFromBitArray:LBZX_AI01393xDecoder_HEADER_SIZE + LBZX_AI01_GTIN_SIZE + LBZX_AI01393xDecoder_LAST_DIGIT_SIZE
                                                                         bits:LBZX_AI01393xDecoder_FIRST_THREE_DIGITS_SIZE];
  if (firstThreeDigits / 100 == 0) {
    [buf appendString:@"0"];
  }
  if (firstThreeDigits / 10 == 0) {
    [buf appendString:@"0"];
  }
  [buf appendFormat:@"%d", firstThreeDigits];

  LBZXRSSExpandedDecodedInformation *generalInformation = [self.generalDecoder decodeGeneralPurposeField:LBZX_AI01393xDecoder_HEADER_SIZE + LBZX_AI01_GTIN_SIZE + LBZX_AI01393xDecoder_LAST_DIGIT_SIZE + LBZX_AI01393xDecoder_FIRST_THREE_DIGITS_SIZE
                                                                                  remaining:nil];
  [buf appendString:generalInformation.theNewString];

  return buf;
}

@end
