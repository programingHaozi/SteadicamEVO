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

#import "LBZXEAN13Reader.h"
#import "LBZXErrors.h"
#import "LBZXResult.h"
#import "LBZXUPCAReader.h"

@interface LBZXUPCAReader ()

@property (nonatomic, strong, readonly) LBZXUPCEANReader *ean13Reader;

@end

@implementation LBZXUPCAReader

- (id)init {
  if (self = [super init]) {
    _ean13Reader = [[LBZXEAN13Reader alloc] init];
  }

  return self;
}

- (LBZXResult *)decodeRow:(int)rowNumber row:(LBZXBitArray *)row startGuardRange:(NSRange)startGuardRange hints:(LBZXDecodeHints *)hints error:(NSError **)error {
  LBZXResult *result = [self.ean13Reader decodeRow:rowNumber row:row startGuardRange:startGuardRange hints:hints error:error];
  if (result) {
    result = [self maybeReturnResult:result];
    if (!result) {
      if (error) *error = LBZXFormatErrorInstance();
      return nil;
    }
    return result;
  } else {
    return nil;
  }
}

- (LBZXResult *)decodeRow:(int)rowNumber row:(LBZXBitArray *)row hints:(LBZXDecodeHints *)hints error:(NSError **)error {
  LBZXResult *result = [self.ean13Reader decodeRow:rowNumber row:row hints:hints error:error];
  if (result) {
    result = [self maybeReturnResult:result];
    if (!result) {
      if (error) *error = LBZXFormatErrorInstance();
      return nil;
    }
    return result;
  } else {
    return nil;
  }
}

- (LBZXResult *)decode:(LBZXBinaryBitmap *)image error:(NSError **)error {
  LBZXResult *result = [self.ean13Reader decode:image error:error];
  if (result) {
    result = [self maybeReturnResult:result];
    if (!result) {
      if (error) *error = LBZXFormatErrorInstance();
      return nil;
    }
    return result;
  } else {
    return nil;
  }
}

- (LBZXResult *)decode:(LBZXBinaryBitmap *)image hints:(LBZXDecodeHints *)hints error:(NSError **)error {
  LBZXResult *result = [self.ean13Reader decode:image hints:hints error:error];
  if (result) {
    result = [self maybeReturnResult:result];
    if (!result) {
      if (error) *error = LBZXFormatErrorInstance();
      return nil;
    }
    return result;
  } else {
    return nil;
  }
}

- (LBZXBarcodeFormat)barcodeFormat {
  return kBarcodeFormatUPCA;
}

- (int)decodeMiddle:(LBZXBitArray *)row startRange:(NSRange)startRange result:(NSMutableString *)result error:(NSError **)error {
  return [self.ean13Reader decodeMiddle:row startRange:startRange result:result error:error];
}

- (LBZXResult *)maybeReturnResult:(LBZXResult *)result {
  NSString *text = result.text;
  if ([text characterAtIndex:0] == '0') {
    return [LBZXResult resultWithText:[text substringFromIndex:1]
                           rawBytes:nil
                       resultPoints:result.resultPoints
                             format:kBarcodeFormatUPCA];
  } else {
    return nil;
  }
}

@end
