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

#import "LBZXBitArray.h"
#import "LBZXErrors.h"
#import "LBZXRSSExpandedBlockParsedResult.h"
#import "LBZXRSSExpandedCurrentParsingState.h"
#import "LBZXRSSExpandedDecodedChar.h"
#import "LBZXRSSExpandedDecodedInformation.h"
#import "LBZXRSSExpandedDecodedNumeric.h"
#import "LBZXRSSExpandedFieldParser.h"
#import "LBZXRSSExpandedGeneralAppIdDecoder.h"

@interface LBZXRSSExpandedGeneralAppIdDecoder ()

@property (nonatomic, strong, readonly) LBZXBitArray *information;
@property (nonatomic, strong, readonly) LBZXRSSExpandedCurrentParsingState *current;
@property (nonatomic, strong, readonly) NSMutableString *buffer;

@end

@implementation LBZXRSSExpandedGeneralAppIdDecoder

- (id)initWithInformation:(LBZXBitArray *)information {
  if (self = [super init]) {
    _current = [[LBZXRSSExpandedCurrentParsingState alloc] init];
    _buffer = [NSMutableString string];
    _information = information;
  }

  return self;
}

- (NSString *)decodeAllCodes:(NSMutableString *)buff initialPosition:(int)initialPosition error:(NSError **)error {
  int currentPosition = initialPosition;
  NSString *remaining = nil;
  do {
    LBZXRSSExpandedDecodedInformation *info = [self decodeGeneralPurposeField:currentPosition remaining:remaining];
    if (!info) {
      if (error) *error = LBZXFormatErrorInstance();
      return nil;
    }
    NSString *parsedFields = [LBZXRSSExpandedFieldParser parseFieldsInGeneralPurpose:[info theNewString] error:error];
    if (!parsedFields) {
      return nil;
    } else if (parsedFields.length > 0) {
      [buff appendString:parsedFields];
    }

    if ([info remaining]) {
      remaining = [@([info remainingValue]) stringValue];
    } else {
      remaining = nil;
    }

    if (currentPosition == [info theNewPosition]) {// No step forward!
      break;
    }
    currentPosition = [info theNewPosition];
  } while (YES);

  return buff;
}

- (BOOL)isStillNumeric:(int)pos {
  // It's numeric if it still has 7 positions
  // and one of the first 4 bits is "1".
  if (pos + 7 > self.information.size) {
    return pos + 4 <= self.information.size;
  }

  for (int i = pos; i < pos + 3; ++i) {
    if ([self.information get:i]) {
      return YES;
    }
  }

  return [self.information get:pos + 3];
}

- (LBZXRSSExpandedDecodedNumeric *)decodeNumeric:(int)pos {
  if (pos + 7 > self.information.size) {
    int numeric = [self extractNumericValueFromBitArray:pos bits:4];
    if (numeric == 0) {
      return [[LBZXRSSExpandedDecodedNumeric alloc] initWithNewPosition:self.information.size
                                                 firstDigit:LBZX_FNC1_INT
                                                secondDigit:LBZX_FNC1_INT];
    }
    return [[LBZXRSSExpandedDecodedNumeric alloc] initWithNewPosition:self.information.size
                                               firstDigit:numeric - 1
                                              secondDigit:LBZX_FNC1_INT];
  }
  int numeric = [self extractNumericValueFromBitArray:pos bits:7];

  int digit1 = (numeric - 8) / 11;
  int digit2 = (numeric - 8) % 11;

  return [[LBZXRSSExpandedDecodedNumeric alloc] initWithNewPosition:pos + 7
                                             firstDigit:digit1
                                            secondDigit:digit2];
}

- (int)extractNumericValueFromBitArray:(int)pos bits:(int)bits {
  return [LBZXRSSExpandedGeneralAppIdDecoder extractNumericValueFromBitArray:self.information pos:pos bits:bits];
}

+ (int)extractNumericValueFromBitArray:(LBZXBitArray *)information pos:(int)pos bits:(int)bits {
  if (bits > 32) {
    [NSException raise:NSInvalidArgumentException format:@"extractNumberValueFromBitArray can't handle more than 32 bits"];
  }

  int value = 0;
  for (int i = 0; i < bits; ++i) {
    if ([information get:pos + i]) {
      value |= 1 << (bits - i - 1);
    }
  }

  return value;
}

- (LBZXRSSExpandedDecodedInformation *)decodeGeneralPurposeField:(int)pos remaining:(NSString *)remaining {
  [self.buffer setString:@""];

  if (remaining != nil) {
    [self.buffer appendString:remaining];
  }

  self.current.position = pos;

  NSError *error;
  LBZXRSSExpandedDecodedInformation *lastDecoded = [self parseBlocksWithError:&error];
  if (error) {
    return nil;
  }

  if (lastDecoded != nil && [lastDecoded remaining]) {
    return [[LBZXRSSExpandedDecodedInformation alloc] initWithNewPosition:self.current.position
                                                    newString:self.buffer
                                               remainingValue:lastDecoded.remainingValue];
  }
  return [[LBZXRSSExpandedDecodedInformation alloc] initWithNewPosition:self.current.position newString:self.buffer];
}

- (LBZXRSSExpandedDecodedInformation *)parseBlocksWithError:(NSError **)error {
  BOOL isFinished;
  LBZXRSSExpandedBlockParsedResult *result;
  do {
    int initialPosition = self.current.position;

    NSError *localError;
    if (self.current.alpha) {
      result = [self parseAlphaBlock];
      isFinished = result.finished;
    } else if (self.current.isoIec646) {
      result = [self parseIsoIec646BlockWithError:&localError];
      isFinished = result.finished;
    } else {
      result = [self parseNumericBlockWithError:&localError];
      isFinished = result.finished;
    }

    if (localError) {
      if (error) *error = localError;
      return nil;
    }

    BOOL positionChanged = initialPosition != self.current.position;
    if (!positionChanged && !isFinished) {
      break;
    }
  } while (!isFinished);
  return result.decodedInformation;
}

- (LBZXRSSExpandedBlockParsedResult *)parseNumericBlockWithError:(NSError **)error {
  while ([self isStillNumeric:self.current.position]) {
    LBZXRSSExpandedDecodedNumeric *numeric = [self decodeNumeric:self.current.position];
    if (!numeric) {
      if (error) *error = LBZXFormatErrorInstance();
      return nil;
    }
    self.current.position = numeric.theNewPosition;

    if ([numeric firstDigitFNC1]) {
      LBZXRSSExpandedDecodedInformation *information;
      if ([numeric secondDigitFNC1]) {
        information = [[LBZXRSSExpandedDecodedInformation alloc] initWithNewPosition:self.current.position
                                                              newString:self.buffer];
      } else {
        information = [[LBZXRSSExpandedDecodedInformation alloc] initWithNewPosition:self.current.position
                                                              newString:self.buffer
                                                         remainingValue:numeric.secondDigit];
      }
      return [[LBZXRSSExpandedBlockParsedResult alloc] initWithInformation:information finished:YES];
    }
    [self.buffer appendFormat:@"%d", numeric.firstDigit];

    if (numeric.secondDigitFNC1) {
      LBZXRSSExpandedDecodedInformation *information = [[LBZXRSSExpandedDecodedInformation alloc] initWithNewPosition:self.current.position
                                                                                  newString:self.buffer];
      return [[LBZXRSSExpandedBlockParsedResult alloc] initWithInformation:information finished:YES];
    }
    [self.buffer appendFormat:@"%d", numeric.secondDigit];
  }

  if ([self isNumericToAlphaNumericLatch:self.current.position]) {
    [self.current setAlpha];
    self.current.position += 4;
  }
  return [[LBZXRSSExpandedBlockParsedResult alloc] initWithFinished:NO];
}

- (LBZXRSSExpandedBlockParsedResult *)parseIsoIec646BlockWithError:(NSError **)error {
  while ([self isStillIsoIec646:self.current.position]) {
    LBZXRSSExpandedDecodedChar *iso = [self decodeIsoIec646:self.current.position];
    if (!iso) {
      if (error) *error = LBZXFormatErrorInstance();
      return nil;
    }
    self.current.position = iso.theNewPosition;

    if (iso.fnc1) {
      LBZXRSSExpandedDecodedInformation *information = [[LBZXRSSExpandedDecodedInformation alloc] initWithNewPosition:self.current.position
                                                                                  newString:self.buffer];
      return [[LBZXRSSExpandedBlockParsedResult alloc] initWithInformation:information finished:YES];
    }
    [self.buffer appendFormat:@"%C", iso.value];
  }

  if ([self isAlphaOr646ToNumericLatch:self.current.position]) {
    self.current.position += 3;
    [self.current setNumeric];
  } else if ([self isAlphaTo646ToAlphaLatch:self.current.position]) {
    if (self.current.position + 5 < self.information.size) {
      self.current.position += 5;
    } else {
      self.current.position = self.information.size;
    }

    [self.current setAlpha];
  }
  return [[LBZXRSSExpandedBlockParsedResult alloc] initWithFinished:NO];
}

- (LBZXRSSExpandedBlockParsedResult *)parseAlphaBlock {
  while ([self isStillAlpha:self.current.position]) {
    LBZXRSSExpandedDecodedChar *alpha = [self decodeAlphanumeric:self.current.position];
    self.current.position = alpha.theNewPosition;

    if (alpha.fnc1) {
      LBZXRSSExpandedDecodedInformation *information = [[LBZXRSSExpandedDecodedInformation alloc] initWithNewPosition:self.current.position
                                                                                  newString:self.buffer];
      return [[LBZXRSSExpandedBlockParsedResult alloc] initWithInformation:information finished:YES];
    }

    [self.buffer appendFormat:@"%C", alpha.value];
  }

  if ([self isAlphaOr646ToNumericLatch:self.current.position]) {
    self.current.position += 3;
    [self.current setNumeric];
  } else if ([self isAlphaTo646ToAlphaLatch:self.current.position]) {
    if (self.current.position + 5 < self.information.size) {
      self.current.position += 5;
    } else {
      self.current.position = self.information.size;
    }

    [self.current setIsoIec646];
  }
  return [[LBZXRSSExpandedBlockParsedResult alloc] initWithFinished:NO];
}

- (BOOL)isStillIsoIec646:(int)pos {
  if (pos + 5 > self.information.size) {
    return NO;
  }

  int fiveBitValue = [self extractNumericValueFromBitArray:pos bits:5];
  if (fiveBitValue >= 5 && fiveBitValue < 16) {
    return YES;
  }

  if (pos + 7 > self.information.size) {
    return NO;
  }

  int sevenBitValue = [self extractNumericValueFromBitArray:pos bits:7];
  if (sevenBitValue >= 64 && sevenBitValue < 116) {
    return YES;
  }

  if (pos + 8 > self.information.size) {
    return NO;
  }

  int eightBitValue = [self extractNumericValueFromBitArray:pos bits:8];
  return eightBitValue >= 232 && eightBitValue < 253;
}

- (LBZXRSSExpandedDecodedChar *)decodeIsoIec646:(int)pos {
  int fiveBitValue = [self extractNumericValueFromBitArray:pos bits:5];
  if (fiveBitValue == 15) {
    return [[LBZXRSSExpandedDecodedChar alloc] initWithNewPosition:pos + 5 value:LBZX_FNC1_CHAR];
  }

  if (fiveBitValue >= 5 && fiveBitValue < 15) {
    return [[LBZXRSSExpandedDecodedChar alloc] initWithNewPosition:pos + 5 value:(unichar)('0' + fiveBitValue - 5)];
  }

  int sevenBitValue = [self extractNumericValueFromBitArray:pos bits:7];

  if (sevenBitValue >= 64 && sevenBitValue < 90) {
    return [[LBZXRSSExpandedDecodedChar alloc] initWithNewPosition:pos + 7 value:(unichar)(sevenBitValue + 1)];
  }

  if (sevenBitValue >= 90 && sevenBitValue < 116) {
    return [[LBZXRSSExpandedDecodedChar alloc] initWithNewPosition:pos + 7 value:(unichar)(sevenBitValue + 7)];
  }

  int eightBitValue = [self extractNumericValueFromBitArray:pos bits:8];
  unichar c;
  switch (eightBitValue) {
    case 232:
      c = '!';
      break;
    case 233:
      c = '"';
      break;
    case 234:
      c ='%';
      break;
    case 235:
      c = '&';
      break;
    case 236:
      c = '\'';
      break;
    case 237:
      c = '(';
      break;
    case 238:
      c = ')';
      break;
    case 239:
      c = '*';
      break;
    case 240:
      c = '+';
      break;
    case 241:
      c = ',';
      break;
    case 242:
      c = '-';
      break;
    case 243:
      c = '.';
      break;
    case 244:
      c = '/';
      break;
    case 245:
      c = ':';
      break;
    case 246:
      c = ';';
      break;
    case 247:
      c = '<';
      break;
    case 248:
      c = '=';
      break;
    case 249:
      c = '>';
      break;
    case 250:
      c = '?';
      break;
    case 251:
      c = '_';
      break;
    case 252:
      c = ' ';
      break;
    default:
      return nil;
  }
  return [[LBZXRSSExpandedDecodedChar alloc] initWithNewPosition:pos + 8 value:c];
}

- (BOOL)isStillAlpha:(int)pos {
  if (pos + 5 > self.information.size) {
    return NO;
  }

  // We now check if it's a valid 5-bit value (0..9 and FNC1)
  int fiveBitValue = [self extractNumericValueFromBitArray:pos bits:5];
  if (fiveBitValue >= 5 && fiveBitValue < 16) {
    return YES;
  }

  if (pos + 6 > self.information.size) {
    return NO;
  }

  int sixBitValue = [self extractNumericValueFromBitArray:pos bits:6];
  return sixBitValue >= 16 && sixBitValue < 63; // 63 not included
}

- (LBZXRSSExpandedDecodedChar *)decodeAlphanumeric:(int)pos {
  int fiveBitValue = [self extractNumericValueFromBitArray:pos bits:5];
  if (fiveBitValue == 15) {
    return [[LBZXRSSExpandedDecodedChar alloc] initWithNewPosition:pos + 5 value:LBZX_FNC1_CHAR];
  }

  if (fiveBitValue >= 5 && fiveBitValue < 15) {
    return [[LBZXRSSExpandedDecodedChar alloc] initWithNewPosition:pos + 5 value:(unichar)('0' + fiveBitValue - 5)];
  }

  int sixBitValue = [self extractNumericValueFromBitArray:pos bits:6];

  if (sixBitValue >= 32 && sixBitValue < 58) {
    return [[LBZXRSSExpandedDecodedChar alloc] initWithNewPosition:pos + 6 value:(unichar)(sixBitValue + 33)];
  }

  unichar c;
  switch (sixBitValue){
    case 58:
      c = '*';
      break;
    case 59:
      c = ',';
      break;
    case 60:
      c = '-';
      break;
    case 61:
      c = '.';
      break;
    case 62:
      c = '/';
      break;
    default:
      @throw [NSException exceptionWithName:@"RuntimeException"
                                     reason:[NSString stringWithFormat:@"Decoding invalid alphanumeric value: %d", sixBitValue]
                                   userInfo:nil];
  }

  return [[LBZXRSSExpandedDecodedChar alloc] initWithNewPosition:pos + 6 value:c];
}

- (BOOL)isAlphaTo646ToAlphaLatch:(int)pos {
  if (pos + 1 > self.information.size) {
    return NO;
  }

  for (int i = 0; i < 5 && i + pos < self.information.size; ++i) {
    if (i == 2) {
      if (![self.information get:pos + 2]) {
        return NO;
      }
    } else if ([self.information get:pos + i]) {
      return NO;
    }
  }

  return YES;
}

- (BOOL)isAlphaOr646ToNumericLatch:(int)pos {
  // Next is alphanumeric if there are 3 positions and they are all zeros
  if (pos + 3 > self.information.size) {
    return NO;
  }

  for (int i = pos; i < pos + 3; ++i) {
    if ([self.information get:i]) {
      return NO;
    }
  }

  return YES;
}

- (BOOL)isNumericToAlphaNumericLatch:(int)pos {
  // Next is alphanumeric if there are 4 positions and they are all zeros, or
  // if there is a subset of this just before the end of the symbol
  if (pos + 1 > self.information.size) {
    return NO;
  }

  for (int i = 0; i < 4 && i + pos < self.information.size; ++i) {
    if ([self.information get:pos + i]) {
      return NO;
    }
  }

  return YES;
}

@end
