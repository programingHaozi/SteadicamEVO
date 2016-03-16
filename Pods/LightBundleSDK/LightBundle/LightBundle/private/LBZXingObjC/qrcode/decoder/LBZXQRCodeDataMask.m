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

#import "LBZXBitMatrix.h"
#import "LBZXQRCodeDataMask.h"

/**
 * 000: mask bits for which (x + y) mod 2 == 0
 */
@interface LBZXDataMask000 : LBZXQRCodeDataMask

@end

@implementation LBZXDataMask000

- (BOOL)isMasked:(int)i j:(int)j {
  return ((i + j) & 0x01) == 0;
}

@end


/**
 * 001: mask bits for which x mod 2 == 0
 */
@interface LBZXDataMask001 : LBZXQRCodeDataMask

@end

@implementation LBZXDataMask001

- (BOOL)isMasked:(int)i j:(int)j {
  return (i & 0x01) == 0;
}

@end


/**
 * 010: mask bits for which y mod 3 == 0
 */
@interface LBZXDataMask010 : LBZXQRCodeDataMask

@end

@implementation LBZXDataMask010

- (BOOL)isMasked:(int)i j:(int)j {
  return j % 3 == 0;
}

@end


/**
 * 011: mask bits for which (x + y) mod 3 == 0
 */
@interface LBZXDataMask011 : LBZXQRCodeDataMask

@end

@implementation LBZXDataMask011

- (BOOL)isMasked:(int)i j:(int)j {
  return (i + j) % 3 == 0;
}

@end


/**
 * 100: mask bits for which (x/2 + y/3) mod 2 == 0
 */
@interface LBZXDataMask100 : LBZXQRCodeDataMask

@end

@implementation LBZXDataMask100

- (BOOL)isMasked:(int)i j:(int)j {
  return (((int)((unsigned int)i >> 1) + (j / 3)) & 0x01) == 0;
}

@end


/**
 * 101: mask bits for which xy mod 2 + xy mod 3 == 0
 */
@interface LBZXDataMask101 : LBZXQRCodeDataMask

@end

@implementation LBZXDataMask101

- (BOOL)isMasked:(int)i j:(int)j {
  int temp = i * j;
  return (temp & 0x01) + (temp % 3) == 0;
}

@end


/**
 * 110: mask bits for which (xy mod 2 + xy mod 3) mod 2 == 0
 */
@interface LBZXDataMask110 : LBZXQRCodeDataMask

@end

@implementation LBZXDataMask110

- (BOOL)isMasked:(int)i j:(int)j {
  int temp = i * j;
  return (((temp & 0x01) + (temp % 3)) & 0x01) == 0;
}

@end


/**
 * 111: mask bits for which ((x+y)mod 2 + xy mod 3) mod 2 == 0
 */
@interface LBZXDataMask111 : LBZXQRCodeDataMask

@end

@implementation LBZXDataMask111

- (BOOL)isMasked:(int)i j:(int)j {
  return ((((i + j) & 0x01) + ((i * j) % 3)) & 0x01) == 0;
}

@end


@implementation LBZXQRCodeDataMask

/**
 * See ISO 18004:2006 6.8.1
 */
static NSArray *DATA_MASKS = nil;

/**
 * Implementations of this method reverse the data masking process applied to a QR Code and
 * make its bits ready to read.
 */
- (void)unmaskBitMatrix:(LBZXBitMatrix *)bits dimension:(int)dimension {
  for (int i = 0; i < dimension; i++) {
    for (int j = 0; j < dimension; j++) {
      if ([self isMasked:i j:j]) {
        [bits flipX:j y:i];
      }
    }
  }
}

- (BOOL)isMasked:(int)i j:(int)j {
  @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                 reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                               userInfo:nil];
}


+ (LBZXQRCodeDataMask *)forReference:(int)reference {
  if (!DATA_MASKS) {
    DATA_MASKS = @[[[LBZXDataMask000 alloc] init],
                   [[LBZXDataMask001 alloc] init],
                   [[LBZXDataMask010 alloc] init],
                   [[LBZXDataMask011 alloc] init],
                   [[LBZXDataMask100 alloc] init],
                   [[LBZXDataMask101 alloc] init],
                   [[LBZXDataMask110 alloc] init],
                   [[LBZXDataMask111 alloc] init]];
  }

  if (reference < 0 || reference > 7) {
    [NSException raise:NSInvalidArgumentException format:@"Invalid reference value"];
  }
  return DATA_MASKS[reference];
}

@end
