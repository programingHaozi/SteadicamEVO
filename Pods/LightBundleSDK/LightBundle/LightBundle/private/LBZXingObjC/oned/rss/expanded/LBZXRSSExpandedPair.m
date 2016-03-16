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

#import "LBZXRSSDataCharacter.h"
#import "LBZXRSSExpandedPair.h"
#import "LBZXRSSFinderPattern.h"

@implementation LBZXRSSExpandedPair

- (id)initWithLeftChar:(LBZXRSSDataCharacter *)leftChar rightChar:(LBZXRSSDataCharacter *)rightChar
         finderPattern:(LBZXRSSFinderPattern *)finderPattern mayBeLast:(BOOL)mayBeLast {
  if (self = [super init]) {
    _leftChar = leftChar;
    _rightChar = rightChar;
    _finderPattern = finderPattern;
    _mayBeLast = mayBeLast;
  }

  return self;
}

- (BOOL)mustBeLast {
  return self.rightChar == nil;
}

- (NSString *)description {
  return [NSString stringWithFormat:@"[ %@, %@ : %@ ]",
          self.leftChar, self.rightChar,
          self.finderPattern == nil ? @"null" : [NSString stringWithFormat:@"%d", self.finderPattern.value]];
}

- (BOOL)isEqual:(id)object {
  if (![object isKindOfClass:[LBZXRSSExpandedPair class]]) {
    return NO;
  }
  LBZXRSSExpandedPair *that = (LBZXRSSExpandedPair *)object;
  return [LBZXRSSExpandedPair isEqualOrNil:self.leftChar toObject:that.leftChar] &&
    [LBZXRSSExpandedPair isEqualOrNil:self.rightChar toObject:that.rightChar] &&
    [LBZXRSSExpandedPair isEqualOrNil:self.finderPattern toObject:that.finderPattern];
}

+ (BOOL)isEqualOrNil:(id)o1 toObject:(id)o2 {
  return o1 == nil ? o2 == nil : [o1 isEqual:o2];
}

- (NSUInteger)hash {
  return [self hashNotNil:self.leftChar] ^ [self hashNotNil:self.rightChar] ^ [self hashNotNil:self.finderPattern];
}

- (NSUInteger)hashNotNil:(NSObject *)o {
  return o == nil ? 0 : o.hash;
}

@end
