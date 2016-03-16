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
#import "LBZXErrors.h"
#import "LBZXIntArray.h"
#import "LBZXITFReader.h"
#import "LBZXResult.h"
#import "LBZXResultPoint.h"

static int LBZX_ITF_MAX_AVG_VARIANCE;
static int LBZX_ITF_MAX_INDIVIDUAL_VARIANCE;

static const int LBZX_ITF_W = 3; // Pixel width of a wide line
static const int LBZX_ITF_N = 1; // Pixel width of a narrow line

/** Valid ITF lengths. Anything longer than the largest value is also allowed. */
const int LBZX_ITF_DEFAULT_ALLOWED_LENGTHS[] = { 6, 8, 10, 12, 14 };

/**
 * Start/end guard pattern.
 *
 * Note: The end pattern is reversed because the row is reversed before
 * searching for the END_PATTERN
 */
const int LBZX_ITF_ITF_START_PATTERN[] = {LBZX_ITF_N, LBZX_ITF_N, LBZX_ITF_N, LBZX_ITF_N};
const int LBZX_ITF_END_PATTERN_REVERSED[] = {LBZX_ITF_N, LBZX_ITF_N, LBZX_ITF_W};

/**
 * Patterns of Wide / Narrow lines to indicate each digit
 */
const int LBZX_ITF_PATTERNS_LEN = 10;
const int LBZX_ITF_PATTERNS[LBZX_ITF_PATTERNS_LEN][5] = {
  {LBZX_ITF_N, LBZX_ITF_N, LBZX_ITF_W, LBZX_ITF_W, LBZX_ITF_N}, // 0
  {LBZX_ITF_W, LBZX_ITF_N, LBZX_ITF_N, LBZX_ITF_N, LBZX_ITF_W}, // 1
  {LBZX_ITF_N, LBZX_ITF_W, LBZX_ITF_N, LBZX_ITF_N, LBZX_ITF_W}, // 2
  {LBZX_ITF_W, LBZX_ITF_W, LBZX_ITF_N, LBZX_ITF_N, LBZX_ITF_N}, // 3
  {LBZX_ITF_N, LBZX_ITF_N, LBZX_ITF_W, LBZX_ITF_N, LBZX_ITF_W}, // 4
  {LBZX_ITF_W, LBZX_ITF_N, LBZX_ITF_W, LBZX_ITF_N, LBZX_ITF_N}, // 5
  {LBZX_ITF_N, LBZX_ITF_W, LBZX_ITF_W, LBZX_ITF_N, LBZX_ITF_N}, // 6
  {LBZX_ITF_N, LBZX_ITF_N, LBZX_ITF_N, LBZX_ITF_W, LBZX_ITF_W}, // 7
  {LBZX_ITF_W, LBZX_ITF_N, LBZX_ITF_N, LBZX_ITF_W, LBZX_ITF_N}, // 8
  {LBZX_ITF_N, LBZX_ITF_W, LBZX_ITF_N, LBZX_ITF_W, LBZX_ITF_N}  // 9
};

@interface LBZXITFReader ()

@property (nonatomic, assign) int narrowLineWidth;

@end

@implementation LBZXITFReader

+ (void)initialize {
  LBZX_ITF_MAX_AVG_VARIANCE = (int)(LBZX_ONED_PATTERN_MATCH_RESULT_SCALE_FACTOR * 0.42f);
  LBZX_ITF_MAX_INDIVIDUAL_VARIANCE = (int)(LBZX_ONED_PATTERN_MATCH_RESULT_SCALE_FACTOR * 0.78f);
}

- (id)init {
  if (self = [super init]) {
    _narrowLineWidth = -1;
  }

  return self;
}

- (LBZXResult *)decodeRow:(int)rowNumber row:(LBZXBitArray *)row hints:(LBZXDecodeHints *)hints error:(NSError **)error {
  // Find out where the Middle section (payload) starts & ends
  LBZXIntArray *startRange = [self decodeStart:row];
  LBZXIntArray *endRange = [self decodeEnd:row];
  if (!startRange || !endRange) {
    if (error) *error = LBZXNotFoundErrorInstance();
    return nil;
  }

  NSMutableString *resultString = [NSMutableString stringWithCapacity:20];
  if (![self decodeMiddle:row payloadStart:startRange.array[1] payloadEnd:endRange.array[0] resultString:resultString]) {
    if (error) *error = LBZXNotFoundErrorInstance();
    return nil;
  }

  NSArray *allowedLengths = nil;
  if (hints != nil) {
    allowedLengths = hints.allowedLengths;
  }
  if (allowedLengths == nil) {
    NSMutableArray *temp = [NSMutableArray array];
    for (int i = 0; i < sizeof(LBZX_ITF_DEFAULT_ALLOWED_LENGTHS) / sizeof(int); i++) {
      [temp addObject:@(LBZX_ITF_DEFAULT_ALLOWED_LENGTHS[i])];
    }
    allowedLengths = [NSArray arrayWithArray:temp];
  }

  // To avoid false positives with 2D barcodes (and other patterns), make
  // an assumption that the decoded string must be a 'standard' length if it's short
  NSUInteger length = [resultString length];
  BOOL lengthOK = NO;
  int maxAllowedLength = 0;
  for (NSNumber *i in allowedLengths) {
    int allowedLength = [i intValue];
    if (length == allowedLength) {
      lengthOK = YES;
      break;
    }
    if (allowedLength > maxAllowedLength) {
      maxAllowedLength = allowedLength;
    }
  }
  if (!lengthOK && length > maxAllowedLength) {
    lengthOK = YES;
  }
  if (!lengthOK) {
    if (error) *error = LBZXFormatErrorInstance();
    return nil;
  }

  return [LBZXResult resultWithText:resultString
                         rawBytes:nil
                     resultPoints:@[[[LBZXResultPoint alloc] initWithX:startRange.array[1] y:(float)rowNumber],
                                    [[LBZXResultPoint alloc] initWithX:endRange.array[0] y:(float)rowNumber]]
                           format:kBarcodeFormatITF];
}

/**
 * @param row          row of black/white values to search
 * @param payloadStart offset of start pattern
 * @param resultString NSMutableString to append decoded chars to
 * @return NO if decoding could not complete successfully
 */
- (BOOL)decodeMiddle:(LBZXBitArray *)row payloadStart:(int)payloadStart payloadEnd:(int)payloadEnd resultString:(NSMutableString *)resultString {
  // Digits are interleaved in pairs - 5 black lines for one digit, and the
  // 5
  // interleaved white lines for the second digit.
  // Therefore, need to scan 10 lines and then
  // split these into two arrays
  LBZXIntArray *counterDigitPair = [[LBZXIntArray alloc] initWithLength:10];
  LBZXIntArray *counterBlack = [[LBZXIntArray alloc] initWithLength:5];
  LBZXIntArray *counterWhite = [[LBZXIntArray alloc] initWithLength:5];

  while (payloadStart < payloadEnd) {
    // Get 10 runs of black/white.
    if (![LBZXOneDReader recordPattern:row start:payloadStart counters:counterDigitPair]) {
      return NO;
    }
    // Split them into each array
    for (int k = 0; k < 5; k++) {
      int twoK = k << 1;
      counterBlack.array[k] = counterDigitPair.array[twoK];
      counterWhite.array[k] = counterDigitPair.array[twoK + 1];
    }

    int bestMatch = [self decodeDigit:counterBlack];
    if (bestMatch == -1) {
      return NO;
    }
    [resultString appendFormat:@"%C", (unichar)('0' + bestMatch)];
    bestMatch = [self decodeDigit:counterWhite];
    if (bestMatch == -1) {
      return NO;
    }
    [resultString appendFormat:@"%C", (unichar)('0' + bestMatch)];

    for (int i = 0; i < counterDigitPair.length; i++) {
      payloadStart += counterDigitPair.array[i];
    }
  }
  return YES;
}

/**
 * Identify where the start of the middle / payload section starts.
 *
 * @param row row of black/white values to search
 * @return Array, containing index of start of 'start block' and end of
 *         'start block'
 */
- (LBZXIntArray *)decodeStart:(LBZXBitArray *)row {
  int endStart = [self skipWhiteSpace:row];
  if (endStart == -1) {
    return nil;
  }
  LBZXIntArray *startPattern = [self findGuardPattern:row rowOffset:endStart pattern:LBZX_ITF_ITF_START_PATTERN patternLen:sizeof(LBZX_ITF_ITF_START_PATTERN)/sizeof(int)];
  if (!startPattern) {
    return nil;
  }

  self.narrowLineWidth = (startPattern.array[1] - startPattern.array[0]) >> 2;

  if (![self validateQuietZone:row startPattern:startPattern.array[0]]) {
    return nil;
  }

  return startPattern;
}

/**
 * The start & end patterns must be pre/post fixed by a quiet zone. This
 * zone must be at least 10 times the width of a narrow line.  Scan back until
 * we either get to the start of the barcode or match the necessary number of
 * quiet zone pixels.
 *
 * Note: Its assumed the row is reversed when using this method to find
 * quiet zone after the end pattern.
 *
 * ref: http://www.barcode-1.net/i25code.html
 *
 * @param row bit array representing the scanned barcode.
 * @param startPattern index into row of the start or end pattern.
 * @return NO if the quiet zone cannot be found, a ReaderException is thrown.
 */
- (BOOL)validateQuietZone:(LBZXBitArray *)row startPattern:(int)startPattern {
  int quietCount = self.narrowLineWidth * 10;

  // if there are not so many pixel at all let's try as many as possible
  quietCount = quietCount < startPattern ? quietCount : startPattern;

  for (int i = startPattern - 1; quietCount > 0 && i >= 0; i--) {
    if ([row get:i]) {
      break;
    }
    quietCount--;
  }
  if (quietCount != 0) {
    return NO;
  }
  return YES;
}

/**
 * Skip all whitespace until we get to the first black line.
 *
 * @param row row of black/white values to search
 * @return index of the first black line or -1 if no black lines are found in the row
 */
- (int)skipWhiteSpace:(LBZXBitArray *)row {
  int width = [row size];
  int endStart = [row nextSet:0];
  if (endStart == width) {
    return -1;
  }
  return endStart;
}

/**
 * Identify where the end of the middle / payload section ends.
 *
 * @param row row of black/white values to search
 * @return Array, containing index of start of 'end block' and end of 'end
 *         block'
 */
- (LBZXIntArray *)decodeEnd:(LBZXBitArray *)row {
  [row reverse];

  int endStart = [self skipWhiteSpace:row];
  if (endStart == -1) {
    [row reverse];
    return nil;
  }
  LBZXIntArray *endPattern = [self findGuardPattern:row rowOffset:endStart pattern:LBZX_ITF_END_PATTERN_REVERSED patternLen:sizeof(LBZX_ITF_END_PATTERN_REVERSED)/sizeof(int)];
  if (!endPattern) {
    [row reverse];
    return nil;
  }
  if (![self validateQuietZone:row startPattern:endPattern.array[0]]) {
    [row reverse];
    return nil;
  }
  int temp = endPattern.array[0];
  endPattern.array[0] = [row size] - endPattern.array[1];
  endPattern.array[1] = [row size] - temp;
  [row reverse];
  return endPattern;
}

/**
 * @param row       row of black/white values to search
 * @param rowOffset position to start search
 * @param pattern   pattern of counts of number of black and white pixels that are
 *                  being searched for as a pattern
 * @return start/end horizontal offset of guard pattern, as an array of two
 *         ints or nil if pattern is not found
 */
- (LBZXIntArray *)findGuardPattern:(LBZXBitArray *)row rowOffset:(int)rowOffset pattern:(const int[])pattern patternLen:(int)patternLen {
  int patternLength = patternLen;
  LBZXIntArray *counters = [[LBZXIntArray alloc] initWithLength:patternLength];
  int32_t *array = counters.array;
  int width = row.size;
  BOOL isWhite = NO;

  int counterPosition = 0;
  int patternStart = rowOffset;
  for (int x = rowOffset; x < width; x++) {
    if ([row get:x] ^ isWhite) {
      array[counterPosition]++;
    } else {
      if (counterPosition == patternLength - 1) {
        if ([LBZXOneDReader patternMatchVariance:counters pattern:pattern maxIndividualVariance:LBZX_ITF_MAX_INDIVIDUAL_VARIANCE] < LBZX_ITF_MAX_AVG_VARIANCE) {
          return [[LBZXIntArray alloc] initWithInts:patternStart, x, -1];
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

  return nil;
}

/**
 * Attempts to decode a sequence of ITF black/white lines into single
 * digit.
 *
 * @param counters the counts of runs of observed black/white/black/... values
 * @return The decoded digit or -1 if digit cannot be decoded
 */
- (int)decodeDigit:(LBZXIntArray *)counters {
  int bestVariance = LBZX_ITF_MAX_AVG_VARIANCE; // worst variance we'll accept
  int bestMatch = -1;
  int max = LBZX_ITF_PATTERNS_LEN;
  for (int i = 0; i < max; i++) {
    int pattern[counters.length];
    for(int ind = 0; ind < counters.length; ind++){
      pattern[ind] = LBZX_ITF_PATTERNS[i][ind];
    }
    int variance = [LBZXOneDReader patternMatchVariance:counters pattern:pattern maxIndividualVariance:LBZX_ITF_MAX_INDIVIDUAL_VARIANCE];
    if (variance < bestVariance) {
      bestVariance = variance;
      bestMatch = i;
    }
  }
  if (bestMatch >= 0) {
    return bestMatch;
  } else {
    return -1;
  }
}

@end
