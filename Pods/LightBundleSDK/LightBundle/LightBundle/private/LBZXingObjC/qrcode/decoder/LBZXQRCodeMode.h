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
#import <Foundation/Foundation.h>
@class LBZXQRCodeVersion;

/**
 * See ISO 18004:2006, 6.4.1, Tables 2 and 3. This enum encapsulates the various modes in which
 * data can be encoded to bits in the QR code standard.
 */
@interface LBZXQRCodeMode : NSObject

@property (nonatomic, assign, readonly) int bits;
@property (nonatomic, copy, readonly) NSString *name;

- (id)initWithCharacterCountBitsForVersions:(NSArray *)characterCountBitsForVersions bits:(int)bits name:(NSString *)name;

/**
 * @param bits four bits encoding a QR Code data mode
 * @return Mode encoded by these bits or nil if bits do not correspond to a known mode
 */
+ (LBZXQRCodeMode *)forBits:(int)bits;

- (int)characterCountBits:(LBZXQRCodeVersion *)version;

/**
 * @param version version in question
 * @return number of bits used, in this QR Code symbol {@link Version}, to encode the
 *         count of characters that will follow encoded in this Mode
 */
+ (LBZXQRCodeMode *)terminatorMode; // Not really a mode...
+ (LBZXQRCodeMode *)numericMode;
+ (LBZXQRCodeMode *)alphanumericMode;
+ (LBZXQRCodeMode *)structuredAppendMode; // Not supported
+ (LBZXQRCodeMode *)byteMode;
+ (LBZXQRCodeMode *)eciMode; // character counts don't apply
+ (LBZXQRCodeMode *)kanjiMode;
+ (LBZXQRCodeMode *)fnc1FirstPositionMode;
+ (LBZXQRCodeMode *)fnc1SecondPositionMode;

/** See GBT 18284-2000; "Hanzi" is a transliteration of this mode name. */
+ (LBZXQRCodeMode *)hanziMode;

@end