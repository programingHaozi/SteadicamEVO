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

#import "LBZXDecodeHints.h"
#import "LBZXErrors.h"
#import "LBZXMultiDetector.h"
#import "LBZXMultiFinderPatternFinder.h"
#import "LBZXResultPointCallback.h"

@implementation LBZXMultiDetector

- (NSArray *)detectMulti:(LBZXDecodeHints *)hints error:(NSError **)error {
  id<LBZXResultPointCallback> resultPointCallback = hints == nil ? nil : hints.resultPointCallback;
  LBZXMultiFinderPatternFinder *finder = [[LBZXMultiFinderPatternFinder alloc] initWithImage:self.image resultPointCallback:resultPointCallback];
  NSArray *info = [finder findMulti:hints error:error];
  if ([info count] == 0) {
    if (error) *error = LBZXNotFoundErrorInstance();
    return nil;
  }

  NSMutableArray *result = [NSMutableArray array];
  for (int i = 0; i < [info count]; i++) {
    LBZXDetectorResult *patternInfo = [self processFinderPatternInfo:info[i] error:nil];
    if (patternInfo) {
      [result addObject:patternInfo];
    }
  }

  return result;
}

@end
