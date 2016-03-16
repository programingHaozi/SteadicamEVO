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

@class LBZXGenericGF, LBZXIntArray;

/**
 * Implements Reed-Solomon enbcoding, as the name implies.
 */
@interface LBZXReedSolomonEncoder : NSObject

- (id)initWithField:(LBZXGenericGF *)field;
- (void)encode:(LBZXIntArray *)toEncode ecBytes:(int)ecBytes;

@end
