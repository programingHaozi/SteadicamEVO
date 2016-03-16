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

#import "LBZXEAN13Writer.h"
#import "LBZXUPCAWriter.h"
#import <Foundation/Foundation.h>
@implementation LBZXUPCAWriter

- (LBZXEAN13Writer *)subWriter {
  static LBZXEAN13Writer *subWriter = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    subWriter = [[LBZXEAN13Writer alloc] init];
  });

  return subWriter;
}

- (LBZXBitMatrix *)encode:(NSString *)contents format:(LBZXBarcodeFormat)format width:(int)width height:(int)height error:(NSError **)error {
  return [self encode:contents format:format width:width height:height hints:nil error:error];
}

- (LBZXBitMatrix *)encode:(NSString *)contents format:(LBZXBarcodeFormat)format width:(int)width height:(int)height hints:(LBZXEncodeHints *)hints error:(NSError **)error {
  if (format != kBarcodeFormatUPCA) {
    @throw [NSException exceptionWithName:NSInvalidArgumentException
                                   reason:[NSString stringWithFormat:@"Can only encode UPC-A, but got %d", format]
                                 userInfo:nil];
  }
  return [self.subWriter encode:[self preencode:contents] format:kBarcodeFormatEan13 width:width height:height hints:hints error:error];
}

/**
 * Transform a UPC-A code into the equivalent EAN-13 code, and add a check digit if it is not
 * already present.
 */
- (NSString *)preencode:(NSString *)contents {
  NSUInteger length = [contents length];
  if (length == 11) {
    int sum = 0;

    for (int i = 0; i < 11; ++i) {
      sum += ([contents characterAtIndex:i] - '0') * (i % 2 == 0 ? 3 : 1);
    }

    contents = [contents stringByAppendingFormat:@"%d", (1000 - sum) % 10];
  } else if (length != 12) {
     @throw [NSException exceptionWithName:NSInvalidArgumentException
                                    reason:[NSString stringWithFormat:@"Requested contents should be 11 or 12 digits long, but got %ld", (unsigned long)[contents length]]
                                  userInfo:nil];
  }
  return [NSString stringWithFormat:@"0%@", contents];
}

@end
