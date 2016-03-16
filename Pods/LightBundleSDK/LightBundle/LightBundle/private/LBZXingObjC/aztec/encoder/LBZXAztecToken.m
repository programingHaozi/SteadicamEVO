/*
 * Copyright 2014 LBZXing authors
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

#import "LBZXAztecBinaryShiftToken.h"
#import "LBZXAztecSimpleToken.h"
#import "LBZXAztecToken.h"
#import "LBZXBitArray.h"

@implementation LBZXAztecToken

- (id)initWithPrevious:(LBZXAztecToken *)previous {
  if (self = [super init]) {
    _previous = previous;
  }

  return self;
}

+ (LBZXAztecToken *)empty {
  return [[LBZXAztecSimpleToken alloc] initWithPrevious:nil value:0 bitCount:0];
}

- (LBZXAztecToken *)add:(int)value bitCount:(int)bitCount {
  return [[LBZXAztecSimpleToken alloc] initWithPrevious:self value:value bitCount:bitCount];
}

- (LBZXAztecToken *)addBinaryShift:(int)start byteCount:(int)byteCount {
//  int bitCount = (byteCount * 8) + (byteCount <= 31 ? 10 : byteCount <= 62 ? 20 : 21);
  return [[LBZXAztecBinaryShiftToken alloc] initWithPrevious:self binaryShiftStart:start binaryShiftByteCount:byteCount];
}

- (void)appendTo:(LBZXBitArray *)bitArray text:(LBZXByteArray *)text {
  @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                 reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                               userInfo:nil];
}

@end
