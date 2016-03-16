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

#import "LBZXAztecWriter.h"
#import "LBZXBitMatrix.h"
#import "LBZXCodaBarWriter.h"
#import "LBZXCode39Writer.h"
#import "LBZXCode128Writer.h"
#import "LBZXDataMatrixWriter.h"
#import "LBZXEAN8Writer.h"
#import "LBZXEAN13Writer.h"
#import "LBZXErrors.h"
#import "LBZXITFWriter.h"
#import "LBZXMultiFormatWriter.h"
#import "LBZXPDF417Writer.h"
#import "LBZXQRCodeWriter.h"
#import "LBZXUPCAWriter.h"

@implementation LBZXMultiFormatWriter

+ (id)writer {
  return [[LBZXMultiFormatWriter alloc] init];
}

- (LBZXBitMatrix *)encode:(NSString *)contents format:(LBZXBarcodeFormat)format width:(int)width height:(int)height error:(NSError **)error {
  return [self encode:contents format:format width:width height:height hints:nil error:error];
}

- (LBZXBitMatrix *)encode:(NSString *)contents format:(LBZXBarcodeFormat)format width:(int)width height:(int)height hints:(LBZXEncodeHints *)hints error:(NSError **)error {
  id<LBZXWriter> writer;
  switch (format) {
    case kBarcodeFormatEan8:
      writer = [[LBZXEAN8Writer alloc] init];
      break;

    case kBarcodeFormatEan13:
      writer = [[LBZXEAN13Writer alloc] init];
      break;

    case kBarcodeFormatUPCA:
      writer = [[LBZXUPCAWriter alloc] init];
      break;

    case kBarcodeFormatQRCode:
      writer = [[LBZXQRCodeWriter alloc] init];
      break;

    case kBarcodeFormatCode39:
      writer = [[LBZXCode39Writer alloc] init];
      break;

    case kBarcodeFormatCode128:
      writer = [[LBZXCode128Writer alloc] init];
      break;

    case kBarcodeFormatITF:
      writer = [[LBZXITFWriter alloc] init];
      break;

    case kBarcodeFormatPDF417:
      writer = [[LBZXPDF417Writer alloc] init];
      break;

    case kBarcodeFormatCodabar:
      writer = [[LBZXCodaBarWriter alloc] init];
      break;

    case kBarcodeFormatDataMatrix:
      writer = [[LBZXDataMatrixWriter alloc] init];
      break;

    case kBarcodeFormatAztec:
      writer = [[LBZXAztecWriter alloc] init];
      break;

    default:
      if (error) *error = [NSError errorWithDomain:LBZXErrorDomain code:LBZXWriterError userInfo:@{NSLocalizedDescriptionKey: @"No encoder available for format"}];
      return nil;
  }
  return [writer encode:contents format:format width:width height:height hints:hints error:error];
}

@end
