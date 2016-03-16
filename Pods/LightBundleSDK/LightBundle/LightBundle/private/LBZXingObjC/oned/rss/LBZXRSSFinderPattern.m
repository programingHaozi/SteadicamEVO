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

#import "LBZXRSSFinderPattern.h"

@implementation LBZXRSSFinderPattern

- (id)initWithValue:(int)value startEnd:(LBZXIntArray *)startEnd start:(int)start end:(int)end rowNumber:(int)rowNumber {
  if (self = [super init]) {
    _value = value;
    _startEnd = startEnd;
    _resultPoints = [@[[[LBZXResultPoint alloc] initWithX:(float)start y:(float)rowNumber],
                       [[LBZXResultPoint alloc] initWithX:(float)end y:(float)rowNumber]] mutableCopy];
  }

  return self;
}

- (BOOL)isEqual:(id)object {
  if (![object isKindOfClass:[LBZXRSSFinderPattern class]]) {
    return NO;
  }

  LBZXRSSFinderPattern *that = (LBZXRSSFinderPattern *)object;
  return self.value == that.value;
}

- (NSUInteger)hash {
  return self.value;
}

@end
