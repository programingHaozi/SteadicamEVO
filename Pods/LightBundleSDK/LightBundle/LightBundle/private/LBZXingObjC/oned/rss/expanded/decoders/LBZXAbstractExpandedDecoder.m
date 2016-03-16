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

#import "LBZXAbstractExpandedDecoder.h"
#import "LBZXAI013103decoder.h"
#import "LBZXAI01320xDecoder.h"
#import "LBZXAI01392xDecoder.h"
#import "LBZXAI01393xDecoder.h"
#import "LBZXAI013x0x1xDecoder.h"
#import "LBZXAI01AndOtherAIs.h"
#import "LBZXAnyAIDecoder.h"
#import "LBZXBitArray.h"
#import "LBZXRSSExpandedGeneralAppIdDecoder.h"

@implementation LBZXAbstractExpandedDecoder

- (id)initWithInformation:(LBZXBitArray *)information {
  if (self = [super init]) {
    _information = information;
    _generalDecoder = [[LBZXRSSExpandedGeneralAppIdDecoder alloc] initWithInformation:information];
  }

  return self;
}

- (NSString *)parseInformationWithError:(NSError **)error {
  @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                 reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                               userInfo:nil];
}

+ (LBZXAbstractExpandedDecoder *)createDecoder:(LBZXBitArray *)information {
  if ([information get:1]) {
    return [[LBZXAI01AndOtherAIs alloc] initWithInformation:information];
  }
  if (![information get:2]) {
    return [[LBZXAnyAIDecoder alloc] initWithInformation:information];
  }

  int fourBitEncodationMethod = [LBZXRSSExpandedGeneralAppIdDecoder extractNumericValueFromBitArray:information pos:1 bits:4];

  switch (fourBitEncodationMethod) {
  case 4:
    return [[LBZXAI013103decoder alloc] initWithInformation:information];
  case 5:
    return [[LBZXAI01320xDecoder alloc] initWithInformation:information];
  }

  int fiveBitEncodationMethod = [LBZXRSSExpandedGeneralAppIdDecoder extractNumericValueFromBitArray:information pos:1 bits:5];
  switch (fiveBitEncodationMethod) {
  case 12:
    return [[LBZXAI01392xDecoder alloc] initWithInformation:information];
  case 13:
    return [[LBZXAI01393xDecoder alloc] initWithInformation:information];
  }

  int sevenBitEncodationMethod = [LBZXRSSExpandedGeneralAppIdDecoder extractNumericValueFromBitArray:information pos:1 bits:7];
  switch (sevenBitEncodationMethod) {
  case 56:
    return [[LBZXAI013x0x1xDecoder alloc] initWithInformation:information firstAIdigits:@"310" dateCode:@"11"];
  case 57:
    return [[LBZXAI013x0x1xDecoder alloc] initWithInformation:information firstAIdigits:@"320" dateCode:@"11"];
  case 58:
    return [[LBZXAI013x0x1xDecoder alloc] initWithInformation:information firstAIdigits:@"310" dateCode:@"13"];
  case 59:
    return [[LBZXAI013x0x1xDecoder alloc] initWithInformation:information firstAIdigits:@"320" dateCode:@"13"];
  case 60:
    return [[LBZXAI013x0x1xDecoder alloc] initWithInformation:information firstAIdigits:@"310" dateCode:@"15"];
  case 61:
    return [[LBZXAI013x0x1xDecoder alloc] initWithInformation:information firstAIdigits:@"320" dateCode:@"15"];
  case 62:
    return [[LBZXAI013x0x1xDecoder alloc] initWithInformation:information firstAIdigits:@"310" dateCode:@"17"];
  case 63:
    return [[LBZXAI013x0x1xDecoder alloc] initWithInformation:information firstAIdigits:@"320" dateCode:@"17"];
  }

  @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                 reason:[NSString stringWithFormat:@"unknown decoder: %@", information]
                               userInfo:nil];
}

@end
