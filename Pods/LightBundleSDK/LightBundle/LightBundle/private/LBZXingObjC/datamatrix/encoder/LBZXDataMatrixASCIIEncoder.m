/*
 * Copyright 2013 LBZXing authors
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

#import "LBZXDataMatrixASCIIEncoder.h"
#import "LBZXDataMatrixEncoderContext.h"
#import "LBZXDataMatrixHighLevelEncoder.h"

@implementation LBZXDataMatrixASCIIEncoder

- (int)encodingMode {
  return [LBZXDataMatrixHighLevelEncoder asciiEncodation];
}

- (void)encode:(LBZXDataMatrixEncoderContext *)context {
  //step B
  int n = [LBZXDataMatrixHighLevelEncoder determineConsecutiveDigitCount:context.message startpos:context.pos];
  if (n >= 2) {
    [context writeCodeword:[self encodeASCIIDigits:[context.message characterAtIndex:context.pos]
                                            digit2:[context.message characterAtIndex:context.pos + 1]]];
    context.pos += 2;
  } else {
    unichar c = [context currentChar];
    int newMode = [LBZXDataMatrixHighLevelEncoder lookAheadTest:context.message startpos:context.pos currentMode:[self encodingMode]];
    if (newMode != [self encodingMode]) {
      if (newMode == [LBZXDataMatrixHighLevelEncoder base256Encodation]) {
        [context writeCodeword:[LBZXDataMatrixHighLevelEncoder latchToBase256]];
        [context signalEncoderChange:[LBZXDataMatrixHighLevelEncoder base256Encodation]];
        return;
      } else if (newMode == [LBZXDataMatrixHighLevelEncoder c40Encodation]) {
        [context writeCodeword:[LBZXDataMatrixHighLevelEncoder latchToC40]];
        [context signalEncoderChange:[LBZXDataMatrixHighLevelEncoder c40Encodation]];
        return;
      } else if (newMode == [LBZXDataMatrixHighLevelEncoder x12Encodation]) {
        [context writeCodeword:[LBZXDataMatrixHighLevelEncoder latchToAnsiX12]];
        [context signalEncoderChange:[LBZXDataMatrixHighLevelEncoder x12Encodation]];
      } else if (newMode == [LBZXDataMatrixHighLevelEncoder textEncodation]) {
        [context writeCodeword:[LBZXDataMatrixHighLevelEncoder latchToText]];
        [context signalEncoderChange:[LBZXDataMatrixHighLevelEncoder textEncodation]];
      } else if (newMode == [LBZXDataMatrixHighLevelEncoder edifactEncodation]) {
        [context writeCodeword:[LBZXDataMatrixHighLevelEncoder latchToEdifact]];
        [context signalEncoderChange:[LBZXDataMatrixHighLevelEncoder edifactEncodation]];
      } else {
        @throw [NSException exceptionWithName:@"IllegalStateException" reason:@"Illegal mode" userInfo:nil];
      }
    } else if ([LBZXDataMatrixHighLevelEncoder isExtendedASCII:c]) {
      [context writeCodeword:[LBZXDataMatrixHighLevelEncoder upperShift]];
      [context writeCodeword:(unichar)(c - 128 + 1)];
      context.pos++;
    } else {
      [context writeCodeword:(unichar)(c + 1)];
      context.pos++;
    }
  }
}

- (unichar)encodeASCIIDigits:(unichar)digit1 digit2:(unichar)digit2 {
  if ([LBZXDataMatrixHighLevelEncoder isDigit:digit1] && [LBZXDataMatrixHighLevelEncoder isDigit:digit2]) {
    int num = (digit1 - 48) * 10 + (digit2 - 48);
    return (unichar) (num + 130);
  }
  @throw [NSException exceptionWithName:NSInvalidArgumentException
                                 reason:[NSString stringWithFormat:@"not digits: %C %C", digit1, digit2]
                               userInfo:nil];
}

@end
