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

#import "LBZXAddressBookAUResultParser.h"
#import "LBZXAddressBookDoCoMoResultParser.h"
#import "LBZXAddressBookParsedResult.h"
#import "LBZXBizcardResultParser.h"
#import "LBZXBookmarkDoCoMoResultParser.h"
#import "LBZXCalendarParsedResult.h"
#import "LBZXEmailAddressParsedResult.h"
#import "LBZXEmailAddressResultParser.h"
#import "LBZXEmailDoCoMoResultParser.h"
#import "LBZXExpandedProductParsedResult.h"
#import "LBZXExpandedProductResultParser.h"
#import "LBZXGeoParsedResult.h"
#import "LBZXGeoResultParser.h"
#import "LBZXISBNParsedResult.h"
#import "LBZXISBNResultParser.h"
#import "LBZXParsedResult.h"
#import "LBZXProductParsedResult.h"
#import "LBZXProductResultParser.h"
#import "LBZXResult.h"
#import "LBZXResultParser.h"
#import "LBZXSMSMMSResultParser.h"
#import "LBZXSMSParsedResult.h"
#import "LBZXSMSTOMMSTOResultParser.h"
#import "LBZXSMTPResultParser.h"
#import "LBZXTelParsedResult.h"
#import "LBZXTelResultParser.h"
#import "LBZXTextParsedResult.h"
#import "LBZXURIParsedResult.h"
#import "LBZXURIResultParser.h"
#import "LBZXURLTOResultParser.h"
#import "LBZXVCardResultParser.h"
#import "LBZXVEventResultParser.h"
#import "LBZXVINResultParser.h"
#import "LBZXWifiParsedResult.h"
#import "LBZXWifiResultParser.h"

static NSArray *LBZX_PARSERS = nil;
static NSRegularExpression *LBZX_DIGITS = nil;
static NSString *LBZX_AMPERSAND = @"&";
static NSString *LBZX_EQUALS = @"=";
static unichar LBZX_BYTE_ORDER_MARK = L'\ufeff';

@implementation LBZXResultParser

+ (void)initialize {
  LBZX_PARSERS = @[[[LBZXBookmarkDoCoMoResultParser alloc] init],
                 [[LBZXAddressBookDoCoMoResultParser alloc] init],
                 [[LBZXEmailDoCoMoResultParser alloc] init],
                 [[LBZXAddressBookAUResultParser alloc] init],
                 [[LBZXVCardResultParser alloc] init],
                 [[LBZXBizcardResultParser alloc] init],
                 [[LBZXVEventResultParser alloc] init],
                 [[LBZXEmailAddressResultParser alloc] init],
                 [[LBZXSMTPResultParser alloc] init],
                 [[LBZXTelResultParser alloc] init],
                 [[LBZXSMSMMSResultParser alloc] init],
                 [[LBZXSMSTOMMSTOResultParser alloc] init],
                 [[LBZXGeoResultParser alloc] init],
                 [[LBZXWifiResultParser alloc] init],
                 [[LBZXURLTOResultParser alloc] init],
                 [[LBZXURIResultParser alloc] init],
                 [[LBZXISBNResultParser alloc] init],
                 [[LBZXProductResultParser alloc] init],
                 [[LBZXExpandedProductResultParser alloc] init],
                 [[LBZXVINResultParser alloc] init]];
  LBZX_DIGITS = [[NSRegularExpression alloc] initWithPattern:@"^\\d+$" options:0 error:nil];
}

- (LBZXParsedResult *)parse:(LBZXResult *)result {
  @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                 reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                               userInfo:nil];
}

+ (NSString *)massagedText:(LBZXResult *)result {
  NSString *text = result.text;
  if (text.length > 0 && [text characterAtIndex:0] == LBZX_BYTE_ORDER_MARK) {
    text = [text substringFromIndex:1];
  }
  return text;
}

+ (LBZXParsedResult *)parseResult:(LBZXResult *)theResult {
  for (LBZXResultParser *parser in LBZX_PARSERS) {
    LBZXParsedResult *result = [parser parse:theResult];
    if (result != nil) {
      return result;
    }
  }
  return [LBZXTextParsedResult textParsedResultWithText:[theResult text] language:nil];
}

- (void)maybeAppend:(NSString *)value result:(NSMutableString *)result {
  if (value != nil) {
    [result appendFormat:@"\n%@", value];
  }
}

- (void)maybeAppendArray:(NSArray *)value result:(NSMutableString *)result {
  if (value != nil) {
    for (NSString *s in value) {
      [result appendFormat:@"\n%@", s];
    }
  }
}

- (NSArray *)maybeWrap:(NSString *)value {
  return value == nil ? nil : @[value];
}

+ (NSString *)unescapeBackslash:(NSString *)escaped {
  NSUInteger backslash = [escaped rangeOfString:@"\\"].location;
  if (backslash == NSNotFound) {
    return escaped;
  }
  NSUInteger max = [escaped length];
  NSMutableString *unescaped = [NSMutableString stringWithCapacity:max - 1];
  [unescaped appendString:[escaped substringToIndex:backslash]];
  BOOL nextIsEscaped = NO;
  for (int i = (int)backslash; i < max; i++) {
    unichar c = [escaped characterAtIndex:i];
    if (nextIsEscaped || c != '\\') {
      [unescaped appendFormat:@"%C", c];
      nextIsEscaped = NO;
    } else {
      nextIsEscaped = YES;
    }
  }
  return unescaped;
}

+ (int)parseHexDigit:(unichar)c {
  if (c >= '0' && c <= '9') {
    return c - '0';
  }
  if (c >= 'a' && c <= 'f') {
    return 10 + (c - 'a');
  }
  if (c >= 'A' && c <= 'F') {
    return 10 + (c - 'A');
  }
  return -1;
}

+ (BOOL)isStringOfDigits:(NSString *)value length:(unsigned int)length {
  return value != nil && length > 0 && length == value.length && [LBZX_DIGITS numberOfMatchesInString:value options:0 range:NSMakeRange(0, value.length)] > 0;
}

- (NSString *)urlDecode:(NSString *)escaped {
  if (escaped == nil) {
    return nil;
  }

  int first = [self findFirstEscape:escaped];
  if (first == -1) {
    return escaped;
  }

  NSUInteger max = [escaped length];
  NSMutableString *unescaped = [NSMutableString stringWithCapacity:max - 2];
  [unescaped appendString:[escaped substringToIndex:first]];

  for (int i = first; i < max; i++) {
    unichar c = [escaped characterAtIndex:i];
    switch (c) {
      case '+':
        [unescaped appendString:@" "];
        break;
      case '%':
        if (i >= max - 2) {
          [unescaped appendString:@"%"];
        } else {
          int firstDigitValue = [[self class] parseHexDigit:[escaped characterAtIndex:++i]];
          int secondDigitValue = [[self class] parseHexDigit:[escaped characterAtIndex:++i]];
          if (firstDigitValue < 0 || secondDigitValue < 0) {
            [unescaped appendFormat:@"%%%C%C", [escaped characterAtIndex:i - 1], [escaped characterAtIndex:i]];
          }
          [unescaped appendFormat:@"%C", (unichar)((firstDigitValue << 4) + secondDigitValue)];
        }
        break;
      default:
        [unescaped appendFormat:@"%C", c];
        break;
    }
  }

  return unescaped;
}

- (int)findFirstEscape:(NSString *)escaped {
  NSUInteger max = [escaped length];
  for (int i = 0; i < max; i++) {
    unichar c = [escaped characterAtIndex:i];
    if (c == '+' || c == '%') {
      return i;
    }
  }

  return -1;
}

+ (BOOL)isSubstringOfDigits:(NSString *)value offset:(int)offset length:(int)length {
  if (value == nil || length <= 0) {
    return NO;
  }
  int max = offset + length;
  return value.length >= max && [LBZX_DIGITS numberOfMatchesInString:value options:0 range:NSMakeRange(offset, max - offset)] > 0;
}

- (NSMutableDictionary *)parseNameValuePairs:(NSString *)uri {
  NSUInteger paramStart = [uri rangeOfString:@"?"].location;
  if (paramStart == NSNotFound) {
    return nil;
  }
  NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:3];
  for (NSString *keyValue in [[uri substringFromIndex:paramStart + 1] componentsSeparatedByString:LBZX_AMPERSAND]) {
    [self appendKeyValue:keyValue result:result];
  }
  return result;
}

- (void)appendKeyValue:(NSString *)keyValue result:(NSMutableDictionary *)result {
  NSRange equalsRange = [keyValue rangeOfString:LBZX_EQUALS];
  if (equalsRange.location != NSNotFound) {
    NSString *key = [keyValue substringToIndex:equalsRange.location];
    NSString *value = [keyValue substringFromIndex:equalsRange.location + 1];
    value = [self urlDecode:value];
    result[key] = value;
  }
}

+ (NSString *)urlDecode:(NSString *)encoded {
  NSString *result = [encoded stringByReplacingOccurrencesOfString:@"+" withString:@" "];
  result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  return result;
}

+ (NSArray *)matchPrefixedField:(NSString *)prefix rawText:(NSString *)rawText endChar:(unichar)endChar trim:(BOOL)trim {
  NSMutableArray *matches = nil;
  NSUInteger i = 0;
  NSUInteger max = [rawText length];
  while (i < max) {
    i = [rawText rangeOfString:prefix options:NSLiteralSearch range:NSMakeRange(i, [rawText length] - i - 1)].location;
    if (i == NSNotFound) {
      break;
    }
    i += [prefix length]; // Skip past this prefix we found to start
    NSUInteger start = i; // Found the start of a match here
    BOOL more = YES;
    while (more) {
      i = [rawText rangeOfString:[NSString stringWithFormat:@"%C", endChar] options:NSLiteralSearch range:NSMakeRange(i, [rawText length] - i)].location;
      if (i == NSNotFound) {
        // No terminating end character? uh, done. Set i such that loop terminates and break
        i = [rawText length];
        more = NO;
      } else if ([rawText characterAtIndex:i - 1] == '\\') {
        // semicolon was escaped so continue
        i++;
      } else {
        // found a match
        if (matches == nil) {
          matches = [NSMutableArray arrayWithCapacity:3]; // lazy init
        }
        NSString *element = [self unescapeBackslash:[rawText substringWithRange:NSMakeRange(start, i - start)]];
        if (trim) {
          element = [element stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }
        if (element.length > 0) {
          [matches addObject:element];
        }
        i++;
        more = NO;
      }
    }
  }
  if (matches == nil || [matches count] == 0) {
    return nil;
  }
  return matches;
}

+ (NSString *)matchSinglePrefixedField:(NSString *)prefix rawText:(NSString *)rawText endChar:(unichar)endChar trim:(BOOL)trim {
  NSArray *matches = [self matchPrefixedField:prefix rawText:rawText endChar:endChar trim:trim];
  return matches == nil ? nil : matches[0];
}

@end
