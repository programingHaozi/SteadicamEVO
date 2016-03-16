/*
 * Copyright 2014 LBZXing authors
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

@class LBZXAztecToken, LBZXBitArray, LBZXByteArray;

/**
 * State represents all information about a sequence necessary to generate the current output.
 * Note that a state is immutable.
 */
@interface LBZXAztecState : NSObject

// The current mode of the encoding (or the mode to which we'll return if
// we're in Binary Shift mode.
@property (nonatomic, assign, readonly) int mode;

// The list of tokens that we output.  If we are in Binary Shift mode, this
// token list does *not* yet included the token for those bytes
@property (nonatomic, strong, readonly) LBZXAztecToken *token;

// If non-zero, the number of most recent bytes that should be output
// in Binary Shift mode.
@property (nonatomic, assign, readonly) int binaryShiftByteCount;

// The total number of bits generated (including Binary Shift).
@property (nonatomic, assign, readonly) int bitCount;

- (id)initWithToken:(LBZXAztecToken *)token mode:(int)mode binaryBytes:(int)binaryBytes bitCount:(int)bitCount;
+ (LBZXAztecState *)initialState;
- (LBZXAztecState *)latchAndAppend:(int)mode value:(int)value;
- (LBZXAztecState *)shiftAndAppend:(int)mode value:(int)value;
- (LBZXAztecState *)addBinaryShiftChar:(int)index;
- (LBZXAztecState *)endBinaryShift:(int)index;
- (BOOL)isBetterThanOrEqualTo:(LBZXAztecState *)other;
- (LBZXBitArray *)toBitArray:(LBZXByteArray *)text;

@end
