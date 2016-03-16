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

#import "LBZXEncodeHints.h"

@class LBZXDataMatrixSymbolInfo, LBZXDimension;

@interface LBZXDataMatrixEncoderContext : NSObject

@property (nonatomic, copy, readonly) NSMutableString *codewords;
@property (nonatomic, copy, readonly) NSString *message;
@property (nonatomic, assign) int newEncoding;
@property (nonatomic, assign) int pos;
@property (nonatomic, assign) int skipAtEnd;
@property (nonatomic, assign) LBZXDataMatrixSymbolShapeHint symbolShape;
@property (nonatomic, strong) LBZXDataMatrixSymbolInfo *symbolInfo;

- (id)initWithMessage:(NSString *)msg;
- (void)setSizeConstraints:(LBZXDimension *)minSize maxSize:(LBZXDimension *)maxSize;
- (void)setSkipAtEnd:(int)count;
- (unichar)currentChar;
- (unichar)current;
- (void)writeCodewords:(NSString *)codewords;
- (void)writeCodeword:(unichar)codeword;
- (int)codewordCount;
- (void)signalEncoderChange:(int)encoding;
- (void)resetEncoderSignal;
- (BOOL)hasMoreCharacters;
- (int)totalMessageCharCount;
- (int)remainingCharacters;
- (void)updateSymbolInfo;
- (void)updateSymbolInfoWithLength:(int)len;
- (void)resetSymbolInfo;

@end
