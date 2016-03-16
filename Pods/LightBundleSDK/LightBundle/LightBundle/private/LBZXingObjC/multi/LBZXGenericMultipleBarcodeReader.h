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

#import "LBZXMultipleBarcodeReader.h"

@protocol LBZXReader;

/**
 * Attempts to locate multiple barcodes in an image by repeatedly decoding portion of the image.
 * After one barcode is found, the areas left, above, right and below the barcode's
 * LBZXResultPoints are scanned, recursively.
 *
 * A caller may want to also employ LBZXByQuadrantReader when attempting to find multiple
 * 2D barcodes, like QR Codes, in an image, where the presence of multiple barcodes might prevent
 * detecting any one of them.
 *
 * That is, instead of passing an LBZXReader a caller might pass
 * [[LBZXByQuadrantReader alloc] initWithDelegate:reader]</code>.
 */
@interface LBZXGenericMultipleBarcodeReader : NSObject <LBZXMultipleBarcodeReader>

- (id)initWithDelegate:(id<LBZXReader>)delegate;

@end
