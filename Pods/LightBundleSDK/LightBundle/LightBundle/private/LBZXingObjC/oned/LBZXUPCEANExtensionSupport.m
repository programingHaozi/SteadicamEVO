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

#import "LBZXUPCEANExtensionSupport.h"
#import "LBZXUPCEANExtension2Support.h"
#import "LBZXUPCEANExtension5Support.h"
#import "LBZXUPCEANReader.h"

const int LBZX_UPCEAN_EXTENSION_START_PATTERN[] = {1,1,2};

@interface LBZXUPCEANExtensionSupport ()

@property (nonatomic, strong, readonly) LBZXUPCEANExtension2Support *twoSupport;
@property (nonatomic, strong, readonly) LBZXUPCEANExtension5Support *fiveSupport;

@end

@implementation LBZXUPCEANExtensionSupport

- (id)init {
  if (self = [super init]) {
    _twoSupport = [[LBZXUPCEANExtension2Support alloc] init];
    _fiveSupport = [[LBZXUPCEANExtension5Support alloc] init];
  }

  return self;
}

- (LBZXResult *)decodeRow:(int)rowNumber row:(LBZXBitArray *)row rowOffset:(int)rowOffset error:(NSError **)error {
  NSRange extensionStartRange = [LBZXUPCEANReader findGuardPattern:row
                                                       rowOffset:rowOffset
                                                      whiteFirst:NO
                                                         pattern:LBZX_UPCEAN_EXTENSION_START_PATTERN
                                                      patternLen:sizeof(LBZX_UPCEAN_EXTENSION_START_PATTERN)/sizeof(int)
                                                           error:error];

  if (extensionStartRange.location == NSNotFound) {
    return nil;
  }

  LBZXResult *result = [self.fiveSupport decodeRow:rowNumber row:row extensionStartRange:extensionStartRange error:error];
  if (!result) {
    result = [self.twoSupport decodeRow:rowNumber row:row extensionStartRange:extensionStartRange error:error];
  }

  return result;
}

@end
