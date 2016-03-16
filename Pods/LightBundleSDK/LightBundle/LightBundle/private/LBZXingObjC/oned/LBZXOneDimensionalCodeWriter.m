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
#import "LBZXBoolArray.h"
#import "LBZXEncodeHints.h"
#import "LBZXOneDimensionalCodeWriter.h"

@implementation LBZXOneDimensionalCodeWriter

- (LBZXBitMatrix *)encode:(NSString *)contents format:(LBZXBarcodeFormat)format width:(int)width height:(int)height error:(NSError **)error {
  return [self encode:contents format:format width:width height:height hints:nil error:error];
}

/**
 * Encode the contents following specified format.
 * width and height are required size. This method may return bigger size
 * LBZXBitMatrix when specified size is too small. The user can set both {width and
 * height to zero to get minimum size barcode. If negative value is set to width
 * or height, IllegalArgumentException is thrown.
 */
- (LBZXBitMatrix *)encode:(NSString *)contents format:(LBZXBarcodeFormat)format width:(int)width height:(int)height
                 hints:(LBZXEncodeHints *)hints error:(NSError **)error {
  if (contents.length == 0) {
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Found empty contents" userInfo:nil];
  }

  if (width < 0 || height < 0) {
    @throw [NSException exceptionWithName:NSInvalidArgumentException
                                   reason:[NSString stringWithFormat:@"Negative size is not allowed. Input: %dx%d", width, height]
                                 userInfo:nil];
  }

  int sidesMargin = [self defaultMargin];
  if (hints && hints.margin) {
    sidesMargin = hints.margin.intValue;
  }

  LBZXBoolArray *code = [self encode:contents];
  return [self renderResult:code width:width height:height sidesMargin:sidesMargin];
}

/**
 * @return a byte array of horizontal pixels (0 = white, 1 = black)
 */
- (LBZXBitMatrix *)renderResult:(LBZXBoolArray *)code width:(int)width height:(int)height sidesMargin:(int)sidesMargin {
  int inputWidth = code.length;
  // Add quiet zone on both sides.
  int fullWidth = inputWidth + sidesMargin;
  int outputWidth = MAX(width, fullWidth);
  int outputHeight = MAX(1, height);

  int multiple = outputWidth / fullWidth;
  int leftPadding = (outputWidth - (inputWidth * multiple)) / 2;

  LBZXBitMatrix *output = [LBZXBitMatrix bitMatrixWithWidth:outputWidth height:outputHeight];
  for (int inputX = 0, outputX = leftPadding; inputX < inputWidth; inputX++, outputX += multiple) {
    if (code.array[inputX]) {
      [output setRegionAtLeft:outputX top:0 width:multiple height:outputHeight];
    }
  }
  return output;
}

/**
 * Appends the given pattern to the target array starting at pos.
 *
 * @param startColor starting color - false for white, true for black
 * @return the number of elements added to target.
 */
- (int)appendPattern:(LBZXBoolArray *)target pos:(int)pos pattern:(const int[])pattern patternLen:(int)patternLen startColor:(BOOL)startColor {
  BOOL color = startColor;
  int numAdded = 0;
  for (int i = 0; i < patternLen; i++) {
    for (int j = 0; j < pattern[i]; j++) {
      target.array[pos++] = color;
    }
    numAdded += pattern[i];
    color = !color; // flip color after each segment
  }
  return numAdded;
}

- (int)defaultMargin {
  // CodaBar spec requires a side margin to be more than ten times wider than narrow space.
  // This seems like a decent idea for a default for all formats.
  return 10;
}

/**
 * Encode the contents to boolean array expression of one-dimensional barcode.
 * Start code and end code should be included in result, and side margins should not be included.
 *
 * @return a LBZXBoolArray of horizontal pixels (false = white, true = black)
 */
- (LBZXBoolArray *)encode:(NSString *)contents {
  @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                 reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                               userInfo:nil];
}

@end
