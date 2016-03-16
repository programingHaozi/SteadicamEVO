/*
 * Copyright 2013 LBZXing authors
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

#import "LBZXAztecCode.h"
#import "LBZXAztecEncoder.h"
#import "LBZXAztecWriter.h"
#import "LBZXBitMatrix.h"
#import "LBZXByteArray.h"
#import "LBZXEncodeHints.h"

const NSStringEncoding LBZX_AZTEC_DEFAULT_ENCODING = NSISOLatin1StringEncoding;

@implementation LBZXAztecWriter

- (LBZXBitMatrix *)encode:(NSString *)contents format:(LBZXBarcodeFormat)format width:(int)width height:(int)height error:(NSError **)error {
  return [self encode:contents format:format width:width height:height hints:nil error:error];
}

- (LBZXBitMatrix *)encode:(NSString *)contents format:(LBZXBarcodeFormat)format width:(int)width height:(int)height hints:(LBZXEncodeHints *)hints error:(NSError **)error {
  NSStringEncoding encoding = hints.encoding;
  NSNumber *eccPercent = hints.errorCorrectionPercent;
  NSNumber *layers = hints.aztecLayers;

  return [self encode:contents
               format:format
                width:width
               height:height
             encoding:encoding == 0 ? LBZX_AZTEC_DEFAULT_ENCODING : encoding
           eccPercent:eccPercent == nil ? LBZX_AZTEC_DEFAULT_EC_PERCENT : [eccPercent intValue]
               layers:layers == nil ? LBZX_AZTEC_DEFAULT_LAYERS : [layers intValue]];
}

- (LBZXBitMatrix *)encode:(NSString *)contents format:(LBZXBarcodeFormat)format width:(int)width
                 height:(int)height encoding:(NSStringEncoding)encoding eccPercent:(int)eccPercent layers:(int)layers {
  if (format != kBarcodeFormatAztec) {
    @throw [NSException exceptionWithName:NSInvalidArgumentException
                                   reason:[NSString stringWithFormat:@"Can only encode kBarcodeFormatAztec (%d), but got %d", kBarcodeFormatAztec, format]
                                 userInfo:nil];
  }

  NSData *data = [contents dataUsingEncoding:encoding];
  LBZXByteArray *bytes = [[LBZXByteArray alloc] initWithLength:(unsigned int)[data length]];
  memcpy(bytes.array, [data bytes], bytes.length * sizeof(int8_t));
  LBZXAztecCode *aztec = [LBZXAztecEncoder encode:bytes minECCPercent:eccPercent userSpecifiedLayers:layers];
  return [self renderResult:aztec width:width height:height];
}

- (LBZXBitMatrix *)renderResult:(LBZXAztecCode *)aztec width:(int)width height:(int)height {
  LBZXBitMatrix *input = aztec.matrix;
  if (!input) {
    return nil;
  }

  int inputWidth = input.width;
  int inputHeight = input.height;
  int outputWidth = MAX(width, inputWidth);
  int outputHeight = MAX(height, inputHeight);

  int multiple = MIN(outputWidth / inputWidth, outputHeight / inputHeight);
  int leftPadding = (outputWidth - (inputWidth * multiple)) / 2;
  int topPadding = (outputHeight - (inputHeight * multiple)) / 2;

  LBZXBitMatrix *output = [[LBZXBitMatrix alloc] initWithWidth:outputWidth height:outputHeight];

  for (int inputY = 0, outputY = topPadding; inputY < inputHeight; inputY++, outputY += multiple) {
    // Write the contents of this row of the barcode
    for (int inputX = 0, outputX = leftPadding; inputX < inputWidth; inputX++, outputX += multiple) {
      if ([input getX:inputX y:inputY]) {
        [output setRegionAtLeft:outputX top:outputY width:multiple height:multiple];
      }
    }
  }
  return output;
}

@end
