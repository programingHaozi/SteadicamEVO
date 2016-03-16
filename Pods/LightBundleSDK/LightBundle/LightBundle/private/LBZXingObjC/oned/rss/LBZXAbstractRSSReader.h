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

#import "LBZXOneDReader.h"

@class LBZXIntArray;

typedef enum {
	LBZX_RSS_PATTERNS_RSS14_PATTERNS = 0,
	LBZX_RSS_PATTERNS_RSS_EXPANDED_PATTERNS
} LBZX_RSS_PATTERNS;

@interface LBZXAbstractRSSReader : LBZXOneDReader

@property (nonatomic, strong, readonly) LBZXIntArray *decodeFinderCounters;
@property (nonatomic, strong, readonly) LBZXIntArray *dataCharacterCounters;
@property (nonatomic, assign, readonly) float *oddRoundingErrors;
@property (nonatomic, assign, readonly) unsigned int oddRoundingErrorsLen;
@property (nonatomic, assign, readonly) float *evenRoundingErrors;
@property (nonatomic, assign, readonly) unsigned int evenRoundingErrorsLen;
@property (nonatomic, strong, readonly) LBZXIntArray *oddCounts;
@property (nonatomic, strong, readonly) LBZXIntArray *evenCounts;

+ (int)parseFinderValue:(LBZXIntArray *)counters finderPatternType:(LBZX_RSS_PATTERNS)finderPatternType;
+ (int)count:(LBZXIntArray *)array;
+ (void)increment:(LBZXIntArray *)array errors:(float *)errors;
+ (void)decrement:(LBZXIntArray *)array errors:(float *)errors;
+ (BOOL)isFinderPattern:(LBZXIntArray *)counters;

@end
