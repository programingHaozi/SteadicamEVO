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

#import "LBZXAztecReader.h"
#import "LBZXBinaryBitmap.h"
#import "LBZXDataMatrixReader.h"
#import "LBZXDecodeHints.h"
#import "LBZXErrors.h"
#import "LBZXMaxiCodeReader.h"
#import "LBZXMultiFormatOneDReader.h"
#import "LBZXMultiFormatReader.h"
#import "LBZXPDF417Reader.h"
#import "LBZXQRCodeReader.h"
#import "LBZXResult.h"

@interface LBZXMultiFormatReader ()

@property (nonatomic, strong, readonly) NSMutableArray *readers;

@end

@implementation LBZXMultiFormatReader

- (id)init {
  if (self = [super init]) {
    _readers = [NSMutableArray array];
  }

  return self;
}

+ (id)reader {
  return [[LBZXMultiFormatReader alloc] init];
}

/**
 * This version of decode honors the intent of Reader.decode(BinaryBitmap) in that it
 * passes null as a hint to the decoders. However, that makes it inefficient to call repeatedly.
 * Use setHints() followed by decodeWithState() for continuous scan applications.
 *
 * @param image The pixel data to decode
 * @return The contents of the image or nil if any errors occurred
 */
- (LBZXResult *)decode:(LBZXBinaryBitmap *)image error:(NSError **)error {
  self.hints = nil;
  return [self decodeInternal:image error:error];
}

/**
 * Decode an image using the hints provided. Does not honor existing state.
 *
 * @param image The pixel data to decode
 * @param hints The hints to use, clearing the previous state.
 * @return The contents of the image or nil if any errors occurred
 */
- (LBZXResult *)decode:(LBZXBinaryBitmap *)image hints:(LBZXDecodeHints *)hints error:(NSError **)error {
  self.hints = hints;
  return [self decodeInternal:image error:error];
}

- (LBZXResult *)decodeWithState:(LBZXBinaryBitmap *)image error:(NSError **)error {
  if (self.readers == nil) {
    self.hints = nil;
  }
  return [self decodeInternal:image error:error];
}

/**
 * This method adds state to the MultiFormatReader. By setting the hints once, subsequent calls
 * to decodeWithState(image) can reuse the same set of readers without reallocating memory. This
 * is important for performance in continuous scan clients.
 *
 * @param hints The set of hints to use for subsequent calls to decode(image)
 */
- (void)setHints:(LBZXDecodeHints *)hints {
  _hints = hints;

  BOOL tryHarder = hints != nil && hints.tryHarder;
  [self.readers removeAllObjects];
  if (hints != nil) {
    BOOL addLBZXOneDReader = [hints containsFormat:kBarcodeFormatUPCA] ||
      [hints containsFormat:kBarcodeFormatUPCE] ||
      [hints containsFormat:kBarcodeFormatEan13] ||
      [hints containsFormat:kBarcodeFormatEan8] ||
      [hints containsFormat:kBarcodeFormatCodabar] ||
      [hints containsFormat:kBarcodeFormatCode39] ||
      [hints containsFormat:kBarcodeFormatCode93] ||
      [hints containsFormat:kBarcodeFormatCode128] ||
      [hints containsFormat:kBarcodeFormatITF] ||
      [hints containsFormat:kBarcodeFormatRSS14] ||
      [hints containsFormat:kBarcodeFormatRSSExpanded];
    if (addLBZXOneDReader && !tryHarder) {
      [self.readers addObject:[[LBZXMultiFormatOneDReader alloc] initWithHints:hints]];
    }
    if ([hints containsFormat:kBarcodeFormatQRCode]) {
      [self.readers addObject:[[LBZXQRCodeReader alloc] init]];
    }
    if ([hints containsFormat:kBarcodeFormatDataMatrix]) {
      [self.readers addObject:[[LBZXDataMatrixReader alloc] init]];
    }
    if ([hints containsFormat:kBarcodeFormatAztec]) {
      [self.readers addObject:[[LBZXAztecReader alloc] init]];
    }
    if ([hints containsFormat:kBarcodeFormatPDF417]) {
      [self.readers addObject:[[LBZXPDF417Reader alloc] init]];
    }
    if ([hints containsFormat:kBarcodeFormatMaxiCode]) {
      [self.readers addObject:[[LBZXMaxiCodeReader alloc] init]];
    }
    if (addLBZXOneDReader && tryHarder) {
      [self.readers addObject:[[LBZXMultiFormatOneDReader alloc] initWithHints:hints]];
    }
  }
  if ([self.readers count] == 0) {
    if (!tryHarder) {
      [self.readers addObject:[[LBZXMultiFormatOneDReader alloc] initWithHints:hints]];
    }
    [self.readers addObject:[[LBZXQRCodeReader alloc] init]];
    [self.readers addObject:[[LBZXDataMatrixReader alloc] init]];
    [self.readers addObject:[[LBZXAztecReader alloc] init]];
    [self.readers addObject:[[LBZXPDF417Reader alloc] init]];
    [self.readers addObject:[[LBZXMaxiCodeReader alloc] init]];
    if (tryHarder) {
      [self.readers addObject:[[LBZXMultiFormatOneDReader alloc] initWithHints:hints]];
    }
  }
}

- (void)reset {
  if (self.readers != nil) {
    for (id<LBZXReader> reader in self.readers) {
      [reader reset];
    }
  }
}

- (LBZXResult *)decodeInternal:(LBZXBinaryBitmap *)image error:(NSError **)error {
  if (self.readers != nil) {
    for (id<LBZXReader> reader in self.readers) {
      LBZXResult *result = [reader decode:image hints:self.hints error:nil];
      if (result) {
        return result;
      }
    }
  }

  if (error) *error = LBZXNotFoundErrorInstance();
  return nil;
}

@end
