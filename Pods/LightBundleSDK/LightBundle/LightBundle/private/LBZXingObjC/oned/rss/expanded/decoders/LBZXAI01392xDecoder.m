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

#import "LBZXAI01392xDecoder.h"
#import "LBZXBitArray.h"
#import "LBZXErrors.h"
#import "LBZXRSSExpandedDecodedInformation.h"
#import "LBZXRSSExpandedGeneralAppIdDecoder.h"

const int LBZX_AI01392x_HEADER_SIZE = 5 + 1 + 2;
const int LBZX_AI01392x_LAST_DIGIT_SIZE = 2;

@implementation LBZXAI01392xDecoder

- (NSString *)parseInformationWithError:(NSError **)error {
  if (self.information.size < LBZX_AI01392x_HEADER_SIZE + LBZX_AI01_GTIN_SIZE) {
    if (error) *error = LBZXNotFoundErrorInstance();
    return nil;
  }
  NSMutableString *buf = [NSMutableString string];
  [self encodeCompressedGtin:buf currentPos:LBZX_AI01392x_HEADER_SIZE];
  int lastAIdigit = [self.generalDecoder extractNumericValueFromBitArray:LBZX_AI01392x_HEADER_SIZE + LBZX_AI01_GTIN_SIZE bits:LBZX_AI01392x_LAST_DIGIT_SIZE];
  [buf appendFormat:@"(392%d)", lastAIdigit];
  LBZXRSSExpandedDecodedInformation *decodedInformation = [self.generalDecoder decodeGeneralPurposeField:LBZX_AI01392x_HEADER_SIZE + LBZX_AI01_GTIN_SIZE + LBZX_AI01392x_LAST_DIGIT_SIZE remaining:nil];
  [buf appendString:decodedInformation.theNewString];
  return buf;
}

@end
