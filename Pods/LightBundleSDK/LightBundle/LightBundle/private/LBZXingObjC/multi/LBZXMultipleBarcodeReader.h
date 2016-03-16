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

#import "LBZXBinaryBitmap.h"
#import "LBZXResult.h"

@class LBZXDecodeHints;

/**
 * Implementation of this interface attempt to read several barcodes from one image.
 */
@protocol LBZXMultipleBarcodeReader <NSObject>

- (NSArray *)decodeMultiple:(LBZXBinaryBitmap *)image error:(NSError **)error;
- (NSArray *)decodeMultiple:(LBZXBinaryBitmap *)image hints:(LBZXDecodeHints *)hints error:(NSError **)error;

@end
