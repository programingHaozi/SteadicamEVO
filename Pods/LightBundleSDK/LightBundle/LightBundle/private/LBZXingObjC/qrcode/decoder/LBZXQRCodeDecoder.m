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
#import "LBZXByteArray.h"
#import "LBZXDecoderResult.h"
#import "LBZXErrors.h"
#import "LBZXGenericGF.h"
#import "LBZXIntArray.h"
#import "LBZXQRCodeBitMatrixParser.h"
#import "LBZXQRCodeDataBlock.h"
#import "LBZXQRCodeDecodedBitStreamParser.h"
#import "LBZXQRCodeDecoder.h"
#import "LBZXQRCodeDecoderMetaData.h"
#import "LBZXQRCodeErrorCorrectionLevel.h"
#import "LBZXQRCodeFormatInformation.h"
#import "LBZXQRCodeVersion.h"
#import "LBZXReedSolomonDecoder.h"

@interface LBZXQRCodeDecoder ()

@property (nonatomic, strong, readonly) LBZXReedSolomonDecoder *rsDecoder;

@end

@implementation LBZXQRCodeDecoder

- (id)init {
  if (self = [super init]) {
    _rsDecoder = [[LBZXReedSolomonDecoder alloc] initWithField:[LBZXGenericGF QrCodeField256]];
  }

  return self;
}

- (LBZXDecoderResult *)decode:(NSArray *)image error:(NSError **)error {
  return [self decode:image hints:nil error:error];
}

- (LBZXDecoderResult *)decode:(NSArray *)image hints:(LBZXDecodeHints *)hints error:(NSError **)error {
  int dimension = (int)[image count];
  LBZXBitMatrix *bits = [[LBZXBitMatrix alloc] initWithDimension:dimension];
  for (int i = 0; i < dimension; i++) {
    LBZXBoolArray *b = image[i];
    for (int j = 0; j < dimension; j++) {
      if (b.array[j]) {
        [bits setX:j y:i];
      }
    }
  }

  return [self decodeMatrix:bits hints:hints error:error];
}

- (LBZXDecoderResult *)decodeMatrix:(LBZXBitMatrix *)bits error:(NSError **)error {
  return [self decodeMatrix:bits hints:nil error:error];
}

- (LBZXDecoderResult *)decodeMatrix:(LBZXBitMatrix *)bits hints:(LBZXDecodeHints *)hints error:(NSError **)error {
  LBZXQRCodeBitMatrixParser *parser = [[LBZXQRCodeBitMatrixParser alloc] initWithBitMatrix:bits error:error];
  if (!parser) {
    return nil;
  }
  LBZXDecoderResult *result = [self decodeParser:parser hints:hints error:error];
  if (result) {
    return result;
  }

  // Revert the bit matrix
  [parser remask];

  // Will be attempting a mirrored reading of the version and format info.
  [parser setMirror:YES];

  // Preemptively read the version.
  if (![parser readVersionWithError:error]) {
    return nil;
  }

  /*
   * Since we're here, this means we have successfully detected some kind
   * of version and format information when mirrored. This is a good sign,
   * that the QR code may be mirrored, and we should try once more with a
   * mirrored content.
   */
  // Prepare for a mirrored reading.
  [parser mirror];

  result = [self decodeParser:parser hints:hints error:error];
  if (!result) {
    return nil;
  }

  // Success! Notify the caller that the code was mirrored.
  result.other = [[LBZXQRCodeDecoderMetaData alloc] initWithMirrored:YES];

  return result;
}

- (LBZXDecoderResult *)decodeParser:(LBZXQRCodeBitMatrixParser *)parser hints:(LBZXDecodeHints *)hints error:(NSError **)error {
  LBZXQRCodeVersion *version = [parser readVersionWithError:error];
  if (!version) {
    return nil;
  }
  LBZXQRCodeFormatInformation *formatInfo = [parser readFormatInformationWithError:error];
  if (!formatInfo) {
    return nil;
  }
  LBZXQRCodeErrorCorrectionLevel *ecLevel = formatInfo.errorCorrectionLevel;

  LBZXByteArray *codewords = [parser readCodewordsWithError:error];
  if (!codewords) {
    return nil;
  }
  NSArray *dataBlocks = [LBZXQRCodeDataBlock dataBlocks:codewords version:version ecLevel:ecLevel];

  int totalBytes = 0;
  for (LBZXQRCodeDataBlock *dataBlock in dataBlocks) {
    totalBytes += dataBlock.numDataCodewords;
  }

  if (totalBytes == 0) {
    return nil;
  }

  LBZXByteArray *resultBytes = [[LBZXByteArray alloc] initWithLength:totalBytes];
  int resultOffset = 0;

  for (LBZXQRCodeDataBlock *dataBlock in dataBlocks) {
    LBZXByteArray *codewordBytes = dataBlock.codewords;
    int numDataCodewords = [dataBlock numDataCodewords];
    if (![self correctErrors:codewordBytes numDataCodewords:numDataCodewords error:error]) {
      return nil;
    }
    for (int i = 0; i < numDataCodewords; i++) {
      resultBytes.array[resultOffset++] = codewordBytes.array[i];
    }
  }

  return [LBZXQRCodeDecodedBitStreamParser decode:resultBytes version:version ecLevel:ecLevel hints:hints error:error];
}

/**
 * Given data and error-correction codewords received, possibly corrupted by errors, attempts to
 * correct the errors in-place using Reed-Solomon error correction.
 *
 * @param codewordBytes data and error correction codewords
 * @param numDataCodewords number of codewords that are data bytes
 * @return NO if error correction fails
 */
- (BOOL)correctErrors:(LBZXByteArray *)codewordBytes numDataCodewords:(int)numDataCodewords error:(NSError **)error {
  int numCodewords = (int)codewordBytes.length;
  // First read into an array of ints
  LBZXIntArray *codewordsInts = [[LBZXIntArray alloc] initWithLength:numCodewords];
  for (int i = 0; i < numCodewords; i++) {
    codewordsInts.array[i] = codewordBytes.array[i] & 0xFF;
  }
  int numECCodewords = (int)codewordBytes.length - numDataCodewords;
  NSError *decodeError = nil;
  if (![self.rsDecoder decode:codewordsInts twoS:numECCodewords error:&decodeError]) {
    if (decodeError.code == LBZXReedSolomonError) {
      if (error) *error = LBZXChecksumErrorInstance();
      return NO;
    } else {
      if (error) *error = decodeError;
      return NO;
    }
  }
  // Copy back into array of bytes -- only need to worry about the bytes that were data
  // We don't care about errors in the error-correction codewords
  for (int i = 0; i < numDataCodewords; i++) {
    codewordBytes.array[i] = (int8_t) codewordsInts.array[i];
  }
  return YES;
}

@end
