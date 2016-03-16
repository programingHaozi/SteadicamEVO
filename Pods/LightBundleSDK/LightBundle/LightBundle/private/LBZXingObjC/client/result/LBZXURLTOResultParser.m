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

#import "LBZXResult.h"
#import "LBZXURIParsedResult.h"
#import "LBZXURLTOResultParser.h"

@implementation LBZXURLTOResultParser

- (LBZXParsedResult *)parse:(LBZXResult *)result {
  NSString *rawText = [LBZXResultParser massagedText:result];
  if (![rawText hasPrefix:@"urlto:"] && ![rawText hasPrefix:@"URLTO:"]) {
    return nil;
  }
  NSUInteger titleEnd = [rawText rangeOfString:@":" options:NSLiteralSearch range:NSMakeRange(6, [rawText length] - 6)].location;
  if (titleEnd == NSNotFound) {
    return nil;
  }
  NSString *title = titleEnd <= 6 ? nil : [rawText substringWithRange:NSMakeRange(6, titleEnd - 6)];
  NSString *uri = [rawText substringFromIndex:titleEnd + 1];
  return [LBZXURIParsedResult uriParsedResultWithUri:uri title:title];
}

@end
