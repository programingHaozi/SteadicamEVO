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
#import "LBZXBarcodeFormat.h"
#import "LBZXResultMetadataType.h"

@class LBZXByteArray;

/**
 * Encapsulates the result of decoding a barcode within an image.
 */
@interface LBZXResult : NSObject

/**
 * @return raw text encoded by the barcode
 */
@property (nonatomic, copy, readonly) NSString *text;

/**
 * @return raw bytes encoded by the barcode, if applicable, otherwise nil
 */
@property (nonatomic, strong, readonly) LBZXByteArray *rawBytes;

/**
 * @return points related to the barcode in the image. These are typically points
 *         identifying finder patterns or the corners of the barcode. The exact meaning is
 *         specific to the type of barcode that was decoded.
 */
@property (nonatomic, strong, readonly) NSMutableArray *resultPoints;

/**
 * @return LBZXBarcodeFormat representing the format of the barcode that was decoded
 */
@property (nonatomic, assign, readonly) LBZXBarcodeFormat barcodeFormat;

/**
 * @return NSDictionary mapping LBZXResultMetadataType keys to values. May be
 *   nil. This contains optional metadata about what was detected about the barcode,
 *   like orientation.
 */
@property (nonatomic, strong, readonly) NSMutableDictionary *resultMetadata;

@property (nonatomic, assign, readonly) long timestamp;

- (id)initWithText:(NSString *)text rawBytes:(LBZXByteArray *)rawBytes resultPoints:(NSArray *)resultPoints format:(LBZXBarcodeFormat)format;
- (id)initWithText:(NSString *)text rawBytes:(LBZXByteArray *)rawBytes resultPoints:(NSArray *)resultPoints format:(LBZXBarcodeFormat)format timestamp:(long)timestamp;
+ (id)resultWithText:(NSString *)text rawBytes:(LBZXByteArray *)rawBytes resultPoints:(NSArray *)resultPoints format:(LBZXBarcodeFormat)format;
+ (id)resultWithText:(NSString *)text rawBytes:(LBZXByteArray *)rawBytes resultPoints:(NSArray *)resultPoints format:(LBZXBarcodeFormat)format timestamp:(long)timestamp;
- (void)putMetadata:(LBZXResultMetadataType)type value:(id)value;
- (void)putAllMetadata:(NSMutableDictionary *)metadata;
- (void)addResultPoints:(NSArray *)newPoints;

@end
