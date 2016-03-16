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

@class LBZXBitMatrix, LBZXByteArray, LBZXDataMatrixVersion;

@interface LBZXDataMatrixBitMatrixParser : NSObject

@property (nonatomic, strong, readonly) LBZXDataMatrixVersion *version;

/**
 * @param bitMatrix LBZXBitMatrix to parse
 * @return nil if dimension is < 8 or > 144 or not 0 mod 2
 */
- (id)initWithBitMatrix:(LBZXBitMatrix *)bitMatrix error:(NSError **)error;

/**
 * Reads the bits in the LBZXBitMatrix representing the mapping matrix (No alignment patterns)
 * in the correct order in order to reconstitute the codewords bytes contained within the
 * Data Matrix Code.
 *
 * @return bytes encoded within the Data Matrix Code or nil if the exact number of bytes expected is not read
 */
- (LBZXByteArray *)readCodewords;

@end
