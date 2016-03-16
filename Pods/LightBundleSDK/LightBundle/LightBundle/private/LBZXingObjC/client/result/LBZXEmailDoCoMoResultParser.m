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

#import "LBZXEmailAddressParsedResult.h"
#import "LBZXEmailDoCoMoResultParser.h"
#import "LBZXResult.h"

static NSRegularExpression *LBZX_ATEXT_ALPHANUMERIC = nil;

@implementation LBZXEmailDoCoMoResultParser

+ (void)initialize {
  LBZX_ATEXT_ALPHANUMERIC = [[NSRegularExpression alloc] initWithPattern:@"^[a-zA-Z0-9@.!#$%&'*+\\-/=?^_`{|}~]+$"
                                                               options:0 error:nil];
}

- (LBZXParsedResult *)parse:(LBZXResult *)result {
  NSString *rawText = [LBZXResultParser massagedText:result];
  if (![rawText hasPrefix:@"MATMSG:"]) {
    return nil;
  }
  NSArray *rawTo = [[self class] matchDoCoMoPrefixedField:@"TO:" rawText:rawText trim:YES];
  if (rawTo == nil) {
    return nil;
  }
  NSString *to = rawTo[0];
  if (![[self class] isBasicallyValidEmailAddress:to]) {
    return nil;
  }
  NSString *subject = [[self class] matchSingleDoCoMoPrefixedField:@"SUB:" rawText:rawText trim:NO];
  NSString *body = [[self class] matchSingleDoCoMoPrefixedField:@"BODY:" rawText:rawText trim:NO];

  return [LBZXEmailAddressParsedResult emailAddressParsedResultWithEmailAddress:to
                                                                      subject:subject
                                                                         body:body
                                                                    mailtoURI:[@"mailto:" stringByAppendingString:to]];
}

+ (BOOL)isBasicallyValidEmailAddress:(NSString *)email {
  return email != nil && [LBZX_ATEXT_ALPHANUMERIC numberOfMatchesInString:email options:0 range:NSMakeRange(0, email.length)] > 0 && [email rangeOfString:@"@"].location != NSNotFound;
}

@end
