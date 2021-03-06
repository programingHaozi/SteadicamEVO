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

@class LBZXIntArray;

/**
 * PDF417 error correction implementation.
 *
 * This example <http://en.wikipedia.org/wiki/Reed%E2%80%93Solomon_error_correction#Example>
 * is quite useful in understanding the algorithm.
 */
@interface LBZXPDF417ECErrorCorrection : NSObject

/**
 * @return number of errors
 */
- (int)decode:(LBZXIntArray *)received numECCodewords:(int)numECCodewords erasures:(LBZXIntArray *)erasures;

@end
