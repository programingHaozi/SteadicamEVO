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

#import "LBZXReader.h"

extern const int LBZX_ONED_INTEGER_MATH_SHIFT;
extern const int LBZX_ONED_PATTERN_MATCH_RESULT_SCALE_FACTOR;

@class LBZXBitArray, LBZXDecodeHints, LBZXIntArray, LBZXResult;

/**
 * Encapsulates functionality and implementation that is common to all families
 * of one-dimensional barcodes.
 */
@interface LBZXOneDReader : NSObject <LBZXReader>

+ (BOOL)recordPattern:(LBZXBitArray *)row start:(int)start counters:(LBZXIntArray *)counters;
+ (BOOL)recordPatternInReverse:(LBZXBitArray *)row start:(int)start counters:(LBZXIntArray *)counters;
+ (int)patternMatchVariance:(LBZXIntArray *)counters pattern:(const int[])pattern maxIndividualVariance:(int)maxIndividualVariance;
- (LBZXResult *)decodeRow:(int)rowNumber row:(LBZXBitArray *)row hints:(LBZXDecodeHints *)hints error:(NSError **)error;

@end
