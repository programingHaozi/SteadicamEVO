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
#import "LBZXDataMatrixBitMatrixParser.h"
#import "LBZXDataMatrixDataBlock.h"
#import "LBZXDataMatrixDecodedBitStreamParser.h"
#import "LBZXDataMatrixDecoder.h"
#import "LBZXDataMatrixVersion.h"
#import "LBZXDecoderResult.h"
#import "LBZXErrors.h"
#import "LBZXGenericGF.h"
#import "LBZXIntArray.h"
#import "LBZXReedSolomonDecoder.h"

@interface LBZXDataMatrixDecoder ()

@property (nonatomic, strong, readonly) LBZXReedSolomonDecoder *rsDecoder;

@end

@implementation LBZXDataMatrixDecoder

- (id)init {
  if (self = [super init]) {
    _rsDecoder = [[LBZXReedSolomonDecoder alloc] initWithField:[LBZXGenericGF DataMatrixField256]];
  }

  return self;
}

- (LBZXDecoderResult *)decode:(NSArray *)image error:(NSError **)error {
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

  return [self decodeMatrix:bits error:error];
}

- (LBZXDecoderResult *)decodeMatrix:(LBZXBitMatrix *)bits error:(NSError **)error {
  LBZXDataMatrixBitMatrixParser *parser = [[LBZXDataMatrixBitMatrixParser alloc] initWithBitMatrix:bits error:error];
  if (!parser) {
    return nil;
  }
  LBZXDataMatrixVersion *version = [parser version];

  LBZXByteArray *codewords = [parser readCodewords];
  NSArray *dataBlocks = [LBZXDataMatrixDataBlock dataBlocks:codewords version:version];

  NSUInteger dataBlocksCount = [dataBlocks count];

  int totalBytes = 0;
  for (int i = 0; i < dataBlocksCount; i++) {
    totalBytes += [dataBlocks[i] numDataCodewords];
  }

  if (totalBytes == 0) {
    return nil;
  }

  LBZXByteArray *resultBytes = [[LBZXByteArray alloc] initWithLength:totalBytes];

  for (int j = 0; j < dataBlocksCount; j++) {
    LBZXDataMatrixDataBlock *dataBlock = dataBlocks[j];
    LBZXByteArray *codewordBytes = dataBlock.codewords;
    int numDataCodewords = [dataBlock numDataCodewords];
    if (![self correctErrors:codewordBytes numDataCodewords:numDataCodewords error:error]) {
      return nil;
    }
    for (int i = 0; i < numDataCodewords; i++) {
      // De-interlace data blocks.
      resultBytes.array[i * dataBlocksCount + j] = codewordBytes.array[i];
    }
  }

  return [LBZXDataMatrixDecodedBitStreamParser decode:resultBytes error:error];
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
  int numCodewords = codewordBytes.length;
  // First read into an array of ints
  LBZXIntArray *codewordsInts = [[LBZXIntArray alloc] initWithLength:numCodewords];
  for (int i = 0; i < numCodewords; i++) {
    codewordsInts.array[i] = codewordBytes.array[i] & 0xFF;
  }
  int numECCodewords = codewordBytes.length - numDataCodewords;

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

  for (int i = 0; i < numDataCodewords; i++) {
    codewordBytes.array[i] = (int8_t) codewordsInts.array[i];
  }
  return YES;
}

@end
