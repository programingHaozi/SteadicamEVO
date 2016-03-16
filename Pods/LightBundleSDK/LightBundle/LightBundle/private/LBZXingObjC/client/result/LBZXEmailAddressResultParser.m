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
#import "LBZXEmailAddressResultParser.h"
#import "LBZXEmailDoCoMoResultParser.h"
#import "LBZXResult.h"

@implementation LBZXEmailAddressResultParser

- (LBZXParsedResult *)parse:(LBZXResult *)result {
  NSString *rawText = [LBZXResultParser massagedText:result];
  NSString *emailAddress;
  if ([rawText hasPrefix:@"mailto:"] || [rawText hasPrefix:@"MAILTO:"]) {
    // If it starts with mailto:, assume it is definitely trying to be an email address
    emailAddress = [rawText substringFromIndex:7];
    NSUInteger queryStart = [emailAddress rangeOfString:@"?"].location;
    if (queryStart != NSNotFound) {
      emailAddress = [emailAddress substringToIndex:queryStart];
    }
    emailAddress = [[self class] urlDecode:emailAddress];
    NSMutableDictionary *nameValues = [self parseNameValuePairs:rawText];
    NSString *subject = nil;
    NSString *body = nil;
    if (nameValues != nil) {
      if ([emailAddress length] == 0) {
        emailAddress = nameValues[@"to"];
      }
      subject = nameValues[@"subject"];
      body = nameValues[@"body"];
    }
    return [LBZXEmailAddressParsedResult emailAddressParsedResultWithEmailAddress:emailAddress
                                                                        subject:subject
                                                                           body:body
                                                                      mailtoURI:rawText];
  } else {
    if (![LBZXEmailDoCoMoResultParser isBasicallyValidEmailAddress:rawText]) {
      return nil;
    }
    emailAddress = rawText;
    return [LBZXEmailAddressParsedResult emailAddressParsedResultWithEmailAddress:emailAddress
                                                                        subject:nil
                                                                           body:nil
                                                                      mailtoURI:[@"mailto:" stringByAppendingString:emailAddress]];
  }
}

@end
