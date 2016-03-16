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

#import "LBZXAI01AndOtherAIs.h"
#import "LBZXRSSExpandedGeneralAppIdDecoder.h"

const int LBZX_AI01_HEADER_SIZE = 1 + 1 + 2;

@implementation LBZXAI01AndOtherAIs

- (NSString *)parseInformationWithError:(NSError **)error {
  NSMutableString *buff = [NSMutableString string];

  [buff appendString:@"(01)"];
  int initialGtinPosition = (int)[buff length];
  int firstGtinDigit = [self.generalDecoder extractNumericValueFromBitArray:LBZX_AI01_HEADER_SIZE bits:4];
  [buff appendFormat:@"%d", firstGtinDigit];

  [self encodeCompressedGtinWithoutAI:buff currentPos:LBZX_AI01_HEADER_SIZE + 4 initialBufferPosition:initialGtinPosition];

  return [self.generalDecoder decodeAllCodes:buff initialPosition:LBZX_AI01_HEADER_SIZE + 44 error:error];
}

@end
