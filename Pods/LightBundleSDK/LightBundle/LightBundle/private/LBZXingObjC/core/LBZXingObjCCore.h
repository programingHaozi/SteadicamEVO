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

#ifndef _LBZXINGOBJC_CORE_

#define _LBZXINGOBJC_CORE_

// Client
#import "LBZXCapture.h"
#import "LBZXCaptureDelegate.h"
#import "LBZXCGImageLuminanceSource.h"
#import "LBZXImage.h"

// Common
#import "LBZXBitArray.h"
#import "LBZXBitMatrix.h"
#import "LBZXBitSource.h"
#import "LBZXBoolArray.h"
#import "LBZXByteArray.h"
#import "LBZXCharacterSetECI.h"
#import "LBZXDecoderResult.h"
#import "LBZXDefaultGridSampler.h"
#import "LBZXDetectorResult.h"
#import "LBZXGenericGF.h"
#import "LBZXGlobalHistogramBinarizer.h"
#import "LBZXGridSampler.h"
#import "LBZXHybridBinarizer.h"
#import "LBZXIntArray.h"
#import "LBZXMathUtils.h"
#import "LBZXMonochromeRectangleDetector.h"
#import "LBZXPerspectiveTransform.h"
#import "LBZXReedSolomonDecoder.h"
#import "LBZXReedSolomonEncoder.h"
#import "LBZXStringUtils.h"
#import "LBZXWhiteRectangleDetector.h"

// Core
#import "LBZXBarcodeFormat.h"
#import "LBZXBinarizer.h"
#import "LBZXBinaryBitmap.h"
#import "LBZXByteMatrix.h"
#import "LBZXDecodeHints.h"
#import "LBZXDimension.h"
#import "LBZXEncodeHints.h"
#import "LBZXErrors.h"
#import "LBZXInvertedLuminanceSource.h"
#import "LBZXLuminanceSource.h"
#import "LBZXPlanarYUVLuminanceSource.h"
#import "LBZXReader.h"
#import "LBZXResult.h"
#import "LBZXResultMetadataType.h"
#import "LBZXResultPoint.h"
#import "LBZXResultPointCallback.h"
#import "LBZXRGBLuminanceSource.h"
#import "LBZXWriter.h"

// Multi
#import "LBZXByQuadrantReader.h"
#import "LBZXGenericMultipleBarcodeReader.h"
#import "LBZXMultiDetector.h"
#import "LBZXMultipleBarcodeReader.h"
#import "LBZXQRCodeMultiReader.h"

#endif
