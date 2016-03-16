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
#import "LBZXBitArray.h"
#import "LBZXErrors.h"
#import "LBZXIntArray.h"
#import "LBZXResult.h"
#import "LBZXResultMetadataType.h"
#import "LBZXResultPoint.h"
#import "LBZXUPCEANExtension2Support.h"
#import "LBZXUPCEANReader.h"

@interface LBZXUPCEANExtension2Support ()

@property (nonatomic, strong, readonly) LBZXIntArray *decodeMiddleCounters;

@end

@implementation LBZXUPCEANExtension2Support

- (id)init {
  if (self = [super init]) {
    _decodeMiddleCounters = [[LBZXIntArray alloc] initWithLength:4];
  }

  return self;
}

- (LBZXResult *)decodeRow:(int)rowNumber row:(LBZXBitArray *)row extensionStartRange:(NSRange)extensionStartRange error:(NSError **)error {
  NSMutableString *resultString = [NSMutableString string];
  int end = [self decodeMiddle:row startRange:extensionStartRange result:resultString error:error];
  if (end == -1) {
    return nil;
  }

  NSMutableDictionary *extensionData = [self parseExtensionString:resultString];

  LBZXResult *extensionResult = [[LBZXResult alloc] initWithText:resultString
                                                     rawBytes:nil
                                                 resultPoints:@[[[LBZXResultPoint alloc] initWithX:(extensionStartRange.location + NSMaxRange(extensionStartRange)) / 2.0f y:rowNumber],
                                                                [[LBZXResultPoint alloc] initWithX:end y:rowNumber]]
                                                       format:kBarcodeFormatUPCEANExtension];
  if (extensionData != nil) {
    [extensionResult putAllMetadata:extensionData];
  }
  return extensionResult;
}

- (int)decodeMiddle:(LBZXBitArray *)row startRange:(NSRange)startRange result:(NSMutableString *)result error:(NSError **)error {
  LBZXIntArray *counters = self.decodeMiddleCounters;
  [counters clear];
  int end = [row size];
  int rowOffset = (int)NSMaxRange(startRange);

  int checkParity = 0;

  for (int x = 0; x < 2 && rowOffset < end; x++) {
    int bestMatch = [LBZXUPCEANReader decodeDigit:row counters:counters rowOffset:rowOffset patternType:LBZX_UPC_EAN_PATTERNS_L_AND_G_PATTERNS error:error];
    if (bestMatch == -1) {
      return -1;
    }
    [result appendFormat:@"%C", (unichar)('0' + bestMatch % 10)];
    rowOffset += [counters sum];
    if (bestMatch >= 10) {
      checkParity |= 1 << (1 - x);
    }
    if (x != 1) {
      // Read off separator if not last
      rowOffset = [row nextSet:rowOffset];
      rowOffset = [row nextUnset:rowOffset];
    }
  }

  if (result.length != 2) {
    if (error) *error = LBZXNotFoundErrorInstance();
    return -1;
  }

  if ([result intValue] % 4 != checkParity) {
    if (error) *error = LBZXNotFoundErrorInstance();
    return -1;
  }

  return rowOffset;
}

/**
 * @param raw raw content of extension
 * @return formatted interpretation of raw content as a NSDictionary mapping
 *  one LBZXResultMetadataType to appropriate value, or nil if not known
 */
- (NSMutableDictionary *)parseExtensionString:(NSString *)raw {
  if (raw.length != 2) {
    return nil;
  }
  return [NSMutableDictionary dictionaryWithObject:@([raw intValue])
                                            forKey:@(kResultMetadataTypeIssueNumber)];
}

@end
