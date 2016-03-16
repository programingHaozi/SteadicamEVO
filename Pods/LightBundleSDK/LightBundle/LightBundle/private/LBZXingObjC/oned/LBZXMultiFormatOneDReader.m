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

#import "LBZXCodaBarReader.h"
#import "LBZXCode128Reader.h"
#import "LBZXCode39Reader.h"
#import "LBZXCode93Reader.h"
#import "LBZXDecodeHints.h"
#import "LBZXErrors.h"
#import "LBZXITFReader.h"
#import "LBZXMultiFormatOneDReader.h"
#import "LBZXMultiFormatUPCEANReader.h"
#import "LBZXRSS14Reader.h"
#import "LBZXRSSExpandedReader.h"

@interface LBZXMultiFormatOneDReader ()

@property (nonatomic, strong, readonly) NSMutableArray *readers;

@end

@implementation LBZXMultiFormatOneDReader

- (id)initWithHints:(LBZXDecodeHints *)hints {
  if (self = [super init]) {
    BOOL useCode39CheckDigit = hints != nil && hints.assumeCode39CheckDigit;
    _readers = [NSMutableArray array];
    if (hints != nil) {
      if ([hints containsFormat:kBarcodeFormatEan13] ||
          [hints containsFormat:kBarcodeFormatUPCA] ||
          [hints containsFormat:kBarcodeFormatEan8] ||
          [hints containsFormat:kBarcodeFormatUPCE]) {
        [_readers addObject:[[LBZXMultiFormatUPCEANReader alloc] initWithHints:hints]];
      }

      if ([hints containsFormat:kBarcodeFormatCode39]) {
        [_readers addObject:[[LBZXCode39Reader alloc] initUsingCheckDigit:useCode39CheckDigit]];
      }

      if ([hints containsFormat:kBarcodeFormatCode93]) {
        [_readers addObject:[[LBZXCode93Reader alloc] init]];
      }

      if ([hints containsFormat:kBarcodeFormatCode128]) {
        [_readers addObject:[[LBZXCode128Reader alloc] init]];
      }

      if ([hints containsFormat:kBarcodeFormatITF]) {
        [_readers addObject:[[LBZXITFReader alloc] init]];
      }

      if ([hints containsFormat:kBarcodeFormatCodabar]) {
        [_readers addObject:[[LBZXCodaBarReader alloc] init]];
      }

      if ([hints containsFormat:kBarcodeFormatRSS14]) {
        [_readers addObject:[[LBZXRSS14Reader alloc] init]];
      }

      if ([hints containsFormat:kBarcodeFormatRSSExpanded]) {
        [_readers addObject:[[LBZXRSSExpandedReader alloc] init]];
      }
    }

    if ([_readers count] == 0) {
      [_readers addObject:[[LBZXMultiFormatUPCEANReader alloc] initWithHints:hints]];
      [_readers addObject:[[LBZXCode39Reader alloc] init]];
      [_readers addObject:[[LBZXCodaBarReader alloc] init]];
      [_readers addObject:[[LBZXCode93Reader alloc] init]];
      [_readers addObject:[[LBZXCode128Reader alloc] init]];
      [_readers addObject:[[LBZXITFReader alloc] init]];
      [_readers addObject:[[LBZXRSS14Reader alloc] init]];
      [_readers addObject:[[LBZXRSSExpandedReader alloc] init]];
    }
  }

  return self;
}

- (LBZXResult *)decodeRow:(int)rowNumber row:(LBZXBitArray *)row hints:(LBZXDecodeHints *)hints error:(NSError **)error {
  for (LBZXOneDReader *reader in self.readers) {
    LBZXResult *result = [reader decodeRow:rowNumber row:row hints:hints error:error];
    if (result) {
      return result;
    }
  }

  if (error) *error = LBZXNotFoundErrorInstance();
  return nil;
}

- (void)reset {
  for (id<LBZXReader> reader in self.readers) {
    [reader reset];
  }
}

@end
