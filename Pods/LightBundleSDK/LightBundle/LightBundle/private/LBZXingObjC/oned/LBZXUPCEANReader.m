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

#import "LBZXBitArray.h"
#import "LBZXDecodeHints.h"
#import "LBZXEANManufacturerOrgSupport.h"
#import "LBZXErrors.h"
#import "LBZXIntArray.h"
#import "LBZXResult.h"
#import "LBZXResultPoint.h"
#import "LBZXResultPointCallback.h"
#import "LBZXUPCEANReader.h"
#import "LBZXUPCEANExtensionSupport.h"

static int LBZX_UPC_EAN_MAX_AVG_VARIANCE;
static int LBZX_UPC_EAN_MAX_INDIVIDUAL_VARIANCE;

/**
 * Start/end guard pattern.
 */
const int LBZX_UPC_EAN_START_END_PATTERN_LEN = 3;
const int LBZX_UPC_EAN_START_END_PATTERN[LBZX_UPC_EAN_START_END_PATTERN_LEN] = {1, 1, 1};

/**
 * Pattern marking the middle of a UPC/EAN pattern, separating the two halves.
 */
const int LBZX_UPC_EAN_MIDDLE_PATTERN_LEN = 5;
const int LBZX_UPC_EAN_MIDDLE_PATTERN[LBZX_UPC_EAN_MIDDLE_PATTERN_LEN] = {1, 1, 1, 1, 1};

/**
 * "Odd", or "L" patterns used to encode UPC/EAN digits.
 */
const int LBZX_UPC_EAN_L_PATTERNS_LEN = 10;
const int LBZX_UPC_EAN_L_PATTERNS_SUB_LEN = 4;
const int LBZX_UPC_EAN_L_PATTERNS[LBZX_UPC_EAN_L_PATTERNS_LEN][LBZX_UPC_EAN_L_PATTERNS_SUB_LEN] = {
  {3, 2, 1, 1}, // 0
  {2, 2, 2, 1}, // 1
  {2, 1, 2, 2}, // 2
  {1, 4, 1, 1}, // 3
  {1, 1, 3, 2}, // 4
  {1, 2, 3, 1}, // 5
  {1, 1, 1, 4}, // 6
  {1, 3, 1, 2}, // 7
  {1, 2, 1, 3}, // 8
  {3, 1, 1, 2}  // 9
};

/**
 * As above but also including the "even", or "G" patterns used to encode UPC/EAN digits.
 */
const int LBZX_UPC_EAN_L_AND_G_PATTERNS_LEN = 20;
const int LBZX_UPC_EAN_L_AND_G_PATTERNS_SUB_LEN = 4;
const int LBZX_UPC_EAN_L_AND_G_PATTERNS[LBZX_UPC_EAN_L_AND_G_PATTERNS_LEN][LBZX_UPC_EAN_L_AND_G_PATTERNS_SUB_LEN] = {
  {3, 2, 1, 1}, // 0
  {2, 2, 2, 1}, // 1
  {2, 1, 2, 2}, // 2
  {1, 4, 1, 1}, // 3
  {1, 1, 3, 2}, // 4
  {1, 2, 3, 1}, // 5
  {1, 1, 1, 4}, // 6
  {1, 3, 1, 2}, // 7
  {1, 2, 1, 3}, // 8
  {3, 1, 1, 2}, // 9
  {1, 1, 2, 3}, // 10 reversed 0
  {1, 2, 2, 2}, // 11 reversed 1
  {2, 2, 1, 2}, // 12 reversed 2
  {1, 1, 4, 1}, // 13 reversed 3
  {2, 3, 1, 1}, // 14 reversed 4
  {1, 3, 2, 1}, // 15 reversed 5
  {4, 1, 1, 1}, // 16 reversed 6
  {2, 1, 3, 1}, // 17 reversed 7
  {3, 1, 2, 1}, // 18 reversed 8
  {2, 1, 1, 3}  // 19 reversed 9
};

@interface LBZXUPCEANReader ()

@property (nonatomic, strong, readonly) NSMutableString *decodeRowNSMutableString;
@property (nonatomic, strong, readonly) LBZXUPCEANExtensionSupport *extensionReader;
@property (nonatomic, strong, readonly) LBZXEANManufacturerOrgSupport *eanManSupport;

@end

@implementation LBZXUPCEANReader

+ (void)initialize {
  LBZX_UPC_EAN_MAX_AVG_VARIANCE = (int)(LBZX_ONED_PATTERN_MATCH_RESULT_SCALE_FACTOR * 0.48f);
  LBZX_UPC_EAN_MAX_INDIVIDUAL_VARIANCE = (int)(LBZX_ONED_PATTERN_MATCH_RESULT_SCALE_FACTOR * 0.7f);
}

- (id)init {
  if (self = [super init]) {
    _decodeRowNSMutableString = [NSMutableString stringWithCapacity:20];
    _extensionReader = [[LBZXUPCEANExtensionSupport alloc] init];
    _eanManSupport = [[LBZXEANManufacturerOrgSupport alloc] init];
  }

  return self;
}

+ (NSRange)findStartGuardPattern:(LBZXBitArray *)row error:(NSError **)error {
  BOOL foundStart = NO;
  NSRange startRange = NSMakeRange(NSNotFound, 0);
  int nextStart = 0;
  LBZXIntArray *counters = [[LBZXIntArray alloc] initWithLength:LBZX_UPC_EAN_START_END_PATTERN_LEN];
  while (!foundStart) {
    [counters clear];
    startRange = [self findGuardPattern:row rowOffset:nextStart
                             whiteFirst:NO
                                pattern:LBZX_UPC_EAN_START_END_PATTERN
                             patternLen:LBZX_UPC_EAN_START_END_PATTERN_LEN
                               counters:counters
                                  error:error];
    if (startRange.location == NSNotFound) {
      return startRange;
    }
    int start = (int)startRange.location;
    nextStart = (int)NSMaxRange(startRange);
    // Make sure there is a quiet zone at least as big as the start pattern before the barcode.
    // If this check would run off the left edge of the image, do not accept this barcode,
    // as it is very likely to be a false positive.
    int quietStart = start - (nextStart - start);
    if (quietStart >= 0) {
      foundStart = [row isRange:quietStart end:start value:NO];
    }
  }
  return startRange;
}

- (LBZXResult *)decodeRow:(int)rowNumber row:(LBZXBitArray *)row hints:(LBZXDecodeHints *)hints error:(NSError **)error {
  return [self decodeRow:rowNumber row:row startGuardRange:[[self class] findStartGuardPattern:row error:error] hints:hints error:error];
}

- (LBZXResult *)decodeRow:(int)rowNumber row:(LBZXBitArray *)row startGuardRange:(NSRange)startGuardRange hints:(LBZXDecodeHints *)hints error:(NSError **)error {
  id<LBZXResultPointCallback> resultPointCallback = hints == nil ? nil : hints.resultPointCallback;

  if (resultPointCallback != nil) {
    [resultPointCallback foundPossibleResultPoint:[[LBZXResultPoint alloc] initWithX:(startGuardRange.location + NSMaxRange(startGuardRange)) / 2.0f y:rowNumber]];
  }

  NSMutableString *result = [NSMutableString string];
  int endStart = [self decodeMiddle:row startRange:startGuardRange result:result error:error];
  if (endStart == -1) {
    return nil;
  }

  if (resultPointCallback != nil) {
    [resultPointCallback foundPossibleResultPoint:[[LBZXResultPoint alloc] initWithX:endStart y:rowNumber]];
  }

  NSRange endRange = [self decodeEnd:row endStart:endStart error:error];
  if (endRange.location == NSNotFound) {
    return nil;
  }

  if (resultPointCallback != nil) {
    [resultPointCallback foundPossibleResultPoint:[[LBZXResultPoint alloc] initWithX:(endRange.location + NSMaxRange(endRange)) / 2.0f y:rowNumber]];
  }

  // Make sure there is a quiet zone at least as big as the end pattern after the barcode. The
  // spec might want more whitespace, but in practice this is the maximum we can count on.
  int end = (int)NSMaxRange(endRange);
  int quietEnd = end + (end - (int)endRange.location);
  if (quietEnd >= [row size] || ![row isRange:end end:quietEnd value:NO]) {
    if (error) *error = LBZXNotFoundErrorInstance();
    return nil;
  }

  NSString *resultString = [result description];
  // UPC/EAN should never be less than 8 chars anyway
  if ([resultString length] < 8) {
    if (error) *error = LBZXFormatErrorInstance();
    return nil;
  }
  if (![self checkChecksum:resultString error:error]) {
    if (error) *error = LBZXChecksumErrorInstance();
    return nil;
  }

  float left = (float)(NSMaxRange(startGuardRange) + startGuardRange.location) / 2.0f;
  float right = (float)(NSMaxRange(endRange) + endRange.location) / 2.0f;
  LBZXBarcodeFormat format = [self barcodeFormat];

  LBZXResult *decodeResult = [LBZXResult resultWithText:resultString
                                           rawBytes:nil
                                       resultPoints:@[[[LBZXResultPoint alloc] initWithX:left y:(float)rowNumber], [[LBZXResultPoint alloc] initWithX:right y:(float)rowNumber]]
                                             format:format];

  int extensionLength = 0;

  LBZXResult *extensionResult = [self.extensionReader decodeRow:rowNumber row:row rowOffset:(int)NSMaxRange(endRange) error:error];
  if (extensionResult) {
    [decodeResult putMetadata:kResultMetadataTypeUPCEANExtension value:extensionResult.text];
    [decodeResult putAllMetadata:[extensionResult resultMetadata]];
    [decodeResult addResultPoints:[extensionResult resultPoints]];
    extensionLength = (int)[extensionResult.text length];
  }

  LBZXIntArray *allowedExtensions = hints == nil ? nil : hints.allowedEANExtensions;
  if (allowedExtensions != nil) {
    BOOL valid = NO;
    for (int i = 0; i < allowedExtensions.length; i++) {
      if (extensionLength == allowedExtensions.array[i]) {
        valid = YES;
        break;
      }
    }
    if (!valid) {
      if (error) *error = LBZXNotFoundErrorInstance();
      return nil;
    }
  }

  if (format == kBarcodeFormatEan13 || format == kBarcodeFormatUPCA) {
    NSString *countryID = [self.eanManSupport lookupCountryIdentifier:resultString];
    if (countryID != nil) {
      [decodeResult putMetadata:kResultMetadataTypePossibleCountry value:countryID];
    }
  }
  return decodeResult;
}

- (BOOL)checkChecksum:(NSString *)s error:(NSError **)error {
  if ([[self class] checkStandardUPCEANChecksum:s]) {
    return YES;
  } else {
    if (error) *error = LBZXFormatErrorInstance();
    return NO;
  }
}

+ (BOOL)checkStandardUPCEANChecksum:(NSString *)s {
  int length = (int)[s length];
  if (length == 0) {
    return NO;
  }
  int sum = 0;

  for (int i = length - 2; i >= 0; i -= 2) {
    int digit = (int)[s characterAtIndex:i] - (int)'0';
    if (digit < 0 || digit > 9) {
      return NO;
    }
    sum += digit;
  }

  sum *= 3;

  for (int i = length - 1; i >= 0; i -= 2) {
    int digit = (int)[s characterAtIndex:i] - (int)'0';
    if (digit < 0 || digit > 9) {
      return NO;
    }
    sum += digit;
  }

  return sum % 10 == 0;
}

- (NSRange)decodeEnd:(LBZXBitArray *)row endStart:(int)endStart error:(NSError **)error {
  return [[self class] findGuardPattern:row
                              rowOffset:endStart
                             whiteFirst:NO
                                pattern:LBZX_UPC_EAN_START_END_PATTERN
                             patternLen:LBZX_UPC_EAN_START_END_PATTERN_LEN
                                  error:error];
}

+ (NSRange)findGuardPattern:(LBZXBitArray *)row rowOffset:(int)rowOffset whiteFirst:(BOOL)whiteFirst pattern:(const int[])pattern patternLen:(int)patternLen error:(NSError **)error {
  LBZXIntArray *counters = [[LBZXIntArray alloc] initWithLength:patternLen];
  return [self findGuardPattern:row rowOffset:rowOffset whiteFirst:whiteFirst pattern:pattern patternLen:patternLen counters:counters error:error];
}

+ (NSRange)findGuardPattern:(LBZXBitArray *)row rowOffset:(int)rowOffset whiteFirst:(BOOL)whiteFirst pattern:(const int[])pattern patternLen:(int)patternLen counters:(LBZXIntArray *)counters error:(NSError **)error {
  int patternLength = patternLen;
  int width = row.size;
  BOOL isWhite = whiteFirst;
  rowOffset = whiteFirst ? [row nextUnset:rowOffset] : [row nextSet:rowOffset];
  int counterPosition = 0;
  int patternStart = rowOffset;
  int32_t *array = counters.array;
  for (int x = rowOffset; x < width; x++) {
    if ([row get:x] ^ isWhite) {
      array[counterPosition]++;
    } else {
      if (counterPosition == patternLength - 1) {
        if ([self patternMatchVariance:counters pattern:pattern maxIndividualVariance:LBZX_UPC_EAN_MAX_INDIVIDUAL_VARIANCE] < LBZX_UPC_EAN_MAX_AVG_VARIANCE) {
          return NSMakeRange(patternStart, x - patternStart);
        }
        patternStart += array[0] + array[1];

        for (int y = 2; y < patternLength; y++) {
          array[y - 2] = array[y];
        }

        array[patternLength - 2] = 0;
        array[patternLength - 1] = 0;
        counterPosition--;
      } else {
        counterPosition++;
      }
      array[counterPosition] = 1;
      isWhite = !isWhite;
    }
  }

  if (error) *error = LBZXNotFoundErrorInstance();
  return NSMakeRange(NSNotFound, 0);
}

/**
 * Attempts to decode a single UPC/EAN-encoded digit.
 */
+ (int)decodeDigit:(LBZXBitArray *)row counters:(LBZXIntArray *)counters rowOffset:(int)rowOffset patternType:(LBZX_UPC_EAN_PATTERNS)patternType error:(NSError **)error {
  if (![self recordPattern:row start:rowOffset counters:counters]) {
    if (error) *error = LBZXNotFoundErrorInstance();
    return -1;
  }
  int bestVariance = LBZX_UPC_EAN_MAX_AVG_VARIANCE;
  int bestMatch = -1;
  int max = 0;
  switch (patternType) {
    case LBZX_UPC_EAN_PATTERNS_L_PATTERNS:
      max = LBZX_UPC_EAN_L_PATTERNS_LEN;
      for (int i = 0; i < max; i++) {
        int pattern[counters.length];
        for(int j = 0; j < counters.length; j++){
          pattern[j] = LBZX_UPC_EAN_L_PATTERNS[i][j];
        }

        int variance = [self patternMatchVariance:counters pattern:pattern maxIndividualVariance:LBZX_UPC_EAN_MAX_INDIVIDUAL_VARIANCE];
        if (variance < bestVariance) {
          bestVariance = variance;
          bestMatch = i;
        }
      }
      break;
    case LBZX_UPC_EAN_PATTERNS_L_AND_G_PATTERNS:
      max = LBZX_UPC_EAN_L_AND_G_PATTERNS_LEN;
      for (int i = 0; i < max; i++) {
        int pattern[counters.length];
        for(int j = 0; j< counters.length; j++){
          pattern[j] = LBZX_UPC_EAN_L_AND_G_PATTERNS[i][j];
        }

        int variance = [self patternMatchVariance:counters pattern:pattern maxIndividualVariance:LBZX_UPC_EAN_MAX_INDIVIDUAL_VARIANCE];
        if (variance < bestVariance) {
          bestVariance = variance;
          bestMatch = i;
        }
      }
      break;
    default:
      break;
  }

  if (bestMatch >= 0) {
    return bestMatch;
  } else {
    if (error) *error = LBZXNotFoundErrorInstance();
    return -1;
  }
}

- (LBZXBarcodeFormat)barcodeFormat {
  @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                 reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                               userInfo:nil];
}

- (int)decodeMiddle:(LBZXBitArray *)row startRange:(NSRange)startRange result:(NSMutableString *)result error:(NSError **)error {
  @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                 reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                               userInfo:nil];
}

@end
