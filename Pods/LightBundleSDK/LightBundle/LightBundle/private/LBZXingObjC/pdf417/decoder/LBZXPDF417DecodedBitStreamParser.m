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

#import "LBZXDecoderResult.h"
#import "LBZXErrors.h"
#import "LBZXIntArray.h"
#import "LBZXPDF417DecodedBitStreamParser.h"
#import "LBZXPDF417ResultMetadata.h"

typedef enum {
  LBZXPDF417ModeAlpha = 0,
  LBZXPDF417ModeLower,
  LBZXPDF417ModeMixed,
  LBZXPDF417ModePunct,
  LBZXPDF417ModeAlphaShift,
  LBZXPDF417ModePunctShift
} LBZXPDF417Mode;

const int LBZX_PDF417_TEXT_COMPACTION_MODE_LATCH = 900;
const int LBZX_PDF417_BYTE_COMPACTION_MODE_LATCH = 901;
const int LBZX_PDF417_NUMERIC_COMPACTION_MODE_LATCH = 902;
const int LBZX_PDF417_BYTE_COMPACTION_MODE_LATCH_6 = 924;
const int LBZX_PDF417_BEGIN_MACRO_PDF417_CONTROL_BLOCK = 928;
const int LBZX_PDF417_BEGIN_MACRO_PDF417_OPTIONAL_FIELD = 923;
const int LBZX_PDF417_MACRO_PDF417_TERMINATOR = 922;
const int LBZX_PDF417_MODE_SHIFT_TO_BYTE_COMPACTION_MODE = 913;
const int LBZX_PDF417_MAX_NUMERIC_CODEWORDS = 15;

const int LBZX_PDF417_PL = 25;
const int LBZX_PDF417_LL = 27;
const int LBZX_PDF417_AS = 27;
const int LBZX_PDF417_ML = 28;
const int LBZX_PDF417_AL = 28;
const int LBZX_PDF417_PS = 29;
const int LBZX_PDF417_PAL = 29;

const unichar LBZX_PDF417_PUNCT_CHARS[] = {
  ';', '<', '>', '@', '[', '\\', '}', '_', '`', '~', '!',
  '\r', '\t', ',', ':', '\n', '-', '.', '$', '/', '"', '|', '*',
  '(', ')', '?', '{', '}', '\''};

const unichar LBZX_PDF417_MIXED_CHARS[] = {
  '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '&',
  '\r', '\t', ',', ':', '#', '-', '.', '$', '/', '+', '%', '*',
  '=', '^'};

const int LBZX_PDF417_NUMBER_OF_SEQUENCE_CODEWORDS = 2;

/**
 * Table containing values for the exponent of 900.
 * This is used in the numeric compaction decode algorithm.
 */
static NSArray *LBZX_PDF417_EXP900 = nil;

@implementation LBZXPDF417DecodedBitStreamParser

+ (void)initialize {
  NSMutableArray *exponents = [NSMutableArray arrayWithCapacity:16];
  [exponents addObject:[NSDecimalNumber one]];
  NSDecimalNumber *nineHundred = [NSDecimalNumber decimalNumberWithString:@"900"];
  [exponents addObject:nineHundred];
  for (int i = 2; i < 16; i++) {
    [exponents addObject:[exponents[i - 1] decimalNumberByMultiplyingBy:nineHundred]];
  }
  LBZX_PDF417_EXP900 = [[NSArray alloc] initWithArray:exponents];
}

+ (LBZXDecoderResult *)decode:(LBZXIntArray *)codewords ecLevel:(NSString *)ecLevel error:(NSError **)error {
  if (!codewords) {
    if (error) *error = LBZXNotFoundErrorInstance();
    return nil;
  }
  NSMutableString *result = [NSMutableString stringWithCapacity:codewords.length * 2];
  // Get compaction mode
  int codeIndex = 1;
  int code = codewords.array[codeIndex++];
  LBZXPDF417ResultMetadata *resultMetadata = [[LBZXPDF417ResultMetadata alloc] init];
  while (codeIndex < codewords.array[0]) {
    switch (code) {
    case LBZX_PDF417_TEXT_COMPACTION_MODE_LATCH:
      codeIndex = [self textCompaction:codewords codeIndex:codeIndex result:result];
      break;
    case LBZX_PDF417_BYTE_COMPACTION_MODE_LATCH:
    case LBZX_PDF417_BYTE_COMPACTION_MODE_LATCH_6:
    case LBZX_PDF417_MODE_SHIFT_TO_BYTE_COMPACTION_MODE:
      codeIndex = [self byteCompaction:code codewords:codewords codeIndex:codeIndex result:result];
      break;
    case LBZX_PDF417_NUMERIC_COMPACTION_MODE_LATCH:
      codeIndex = [self numericCompaction:codewords codeIndex:codeIndex result:result];
      break;
    case LBZX_PDF417_BEGIN_MACRO_PDF417_CONTROL_BLOCK:
      codeIndex = [self decodeMacroBlock:codewords codeIndex:codeIndex resultMetadata:resultMetadata];
      if (codeIndex < 0) {
        if (error) *error = LBZXNotFoundErrorInstance();
        return nil;
      }
      break;
    case LBZX_PDF417_BEGIN_MACRO_PDF417_OPTIONAL_FIELD:
    case LBZX_PDF417_MACRO_PDF417_TERMINATOR:
      // Should not see these outside a macro block
      if (error) *error = LBZXNotFoundErrorInstance();
      return nil;
    default:
      // Default to text compaction. During testing numerous barcodes
      // appeared to be missing the starting mode. In these cases defaulting
      // to text compaction seems to work.
      codeIndex--;
      codeIndex = [self textCompaction:codewords codeIndex:codeIndex result:result];
      break;
    }
    if (codeIndex < codewords.length) {
      code = codewords.array[codeIndex++];
    } else {
      if (error) *error = LBZXNotFoundErrorInstance();
      return nil;
    }
  }
  if ([result length] == 0) {
    if (error) *error = LBZXNotFoundErrorInstance();
    return nil;
  }
  LBZXDecoderResult *decoderResult = [[LBZXDecoderResult alloc] initWithRawBytes:nil text:result byteSegments:nil ecLevel:ecLevel];
  decoderResult.other = resultMetadata;
  return decoderResult;
}

+ (int)decodeMacroBlock:(LBZXIntArray *)codewords codeIndex:(int)codeIndex resultMetadata:(LBZXPDF417ResultMetadata *)resultMetadata {
  if (codeIndex + LBZX_PDF417_NUMBER_OF_SEQUENCE_CODEWORDS > codewords.array[0]) {
    // we must have at least two bytes left for the segment index
    return -1;
  }
  LBZXIntArray *segmentIndexArray = [[LBZXIntArray alloc] initWithLength:LBZX_PDF417_NUMBER_OF_SEQUENCE_CODEWORDS];
  for (int i = 0; i < LBZX_PDF417_NUMBER_OF_SEQUENCE_CODEWORDS; i++, codeIndex++) {
    segmentIndexArray.array[i] = codewords.array[codeIndex];
  }
  resultMetadata.segmentIndex = [[self decodeBase900toBase10:segmentIndexArray count:LBZX_PDF417_NUMBER_OF_SEQUENCE_CODEWORDS] intValue];

  NSMutableString *fileId = [NSMutableString string];
  codeIndex = [self textCompaction:codewords codeIndex:codeIndex result:fileId];
  resultMetadata.fileId = [NSString stringWithString:fileId];

  if (codewords.array[codeIndex] == LBZX_PDF417_BEGIN_MACRO_PDF417_OPTIONAL_FIELD) {
    codeIndex++;
    NSMutableArray *additionalOptionCodeWords = [NSMutableArray array];

    BOOL end = NO;
    while ((codeIndex < codewords.array[0]) && !end) {
      int code = codewords.array[codeIndex++];
      if (code < LBZX_PDF417_TEXT_COMPACTION_MODE_LATCH) {
        [additionalOptionCodeWords addObject:@(code)];
      } else {
        switch (code) {
          case LBZX_PDF417_MACRO_PDF417_TERMINATOR:
            resultMetadata.lastSegment = YES;
            codeIndex++;
            end = YES;
            break;
          default:
            return -1;
        }
      }
    }

    resultMetadata.optionalData = additionalOptionCodeWords;
  } else if (codewords.array[codeIndex] == LBZX_PDF417_MACRO_PDF417_TERMINATOR) {
    resultMetadata.lastSegment = YES;
    codeIndex++;
  }

  return codeIndex;
}

/**
 * Text Compaction mode (see 5.4.1.5) permits all printable ASCII characters to be
 * encoded, i.e. values 32 - 126 inclusive in accordance with ISO/IEC 646 (IRV), as
 * well as selected control characters.
 *
 * @param codewords The array of codewords (data + error)
 * @param codeIndex The current index into the codeword array.
 * @param result    The decoded data is appended to the result.
 * @return The next index into the codeword array.
 */
+ (int)textCompaction:(LBZXIntArray *)codewords codeIndex:(int)codeIndex result:(NSMutableString *)result {
  // 2 character per codeword
  LBZXIntArray *textCompactionData = [[LBZXIntArray alloc] initWithLength:(codewords.array[0] - codeIndex) << 1];
  // Used to hold the byte compaction value if there is a mode shift
  LBZXIntArray *byteCompactionData = [[LBZXIntArray alloc] initWithLength:(codewords.array[0] - codeIndex) << 1];

  int index = 0;
  BOOL end = NO;
  while ((codeIndex < codewords.array[0]) && !end) {
    int code = codewords.array[codeIndex++];
    if (code < LBZX_PDF417_TEXT_COMPACTION_MODE_LATCH) {
      textCompactionData.array[index] = code / 30;
      textCompactionData.array[index + 1] = code % 30;
      index += 2;
    } else {
      switch (code) {
      case LBZX_PDF417_TEXT_COMPACTION_MODE_LATCH:
        // reinitialize text compaction mode to alpha sub mode
        textCompactionData.array[index++] = LBZX_PDF417_TEXT_COMPACTION_MODE_LATCH;
        break;
      case LBZX_PDF417_BYTE_COMPACTION_MODE_LATCH:
      case LBZX_PDF417_BYTE_COMPACTION_MODE_LATCH_6:
      case LBZX_PDF417_NUMERIC_COMPACTION_MODE_LATCH:
      case LBZX_PDF417_BEGIN_MACRO_PDF417_CONTROL_BLOCK:
      case LBZX_PDF417_BEGIN_MACRO_PDF417_OPTIONAL_FIELD:
      case LBZX_PDF417_MACRO_PDF417_TERMINATOR:
        codeIndex--;
        end = YES;
        break;
      case LBZX_PDF417_MODE_SHIFT_TO_BYTE_COMPACTION_MODE:
        // The Mode Shift codeword 913 shall cause a temporary
        // switch from Text Compaction mode to Byte Compaction mode.
        // This switch shall be in effect for only the next codeword,
        // after which the mode shall revert to the prevailing sub-mode
        // of the Text Compaction mode. Codeword 913 is only available
        // in Text Compaction mode; its use is described in 5.4.2.4.
        textCompactionData.array[index] = LBZX_PDF417_MODE_SHIFT_TO_BYTE_COMPACTION_MODE;
        code = codewords.array[codeIndex++];
        byteCompactionData.array[index] = code;
        index++;
        break;
      }
    }
  }

  [self decodeTextCompaction:textCompactionData byteCompactionData:byteCompactionData length:index result:result];
  return codeIndex;
}

/**
 * The Text Compaction mode includes all the printable ASCII characters
 * (i.e. values from 32 to 126) and three ASCII control characters: HT or tab
 * (ASCII value 9), LF or line feed (ASCII value 10), and CR or carriage
 * return (ASCII value 13). The Text Compaction mode also includes various latch
 * and shift characters which are used exclusively within the mode. The Text
 * Compaction mode encodes up to 2 characters per codeword. The compaction rules
 * for converting data into PDF417 codewords are defined in 5.4.2.2. The sub-mode
 * switches are defined in 5.4.2.3.
 *
 * @param textCompactionData The text compaction data.
 * @param byteCompactionData The byte compaction data if there
 *                           was a mode shift.
 * @param length             The size of the text compaction and byte compaction data.
 * @param result             The decoded data is appended to the result.
 */
+ (void)decodeTextCompaction:(LBZXIntArray *)textCompactionData byteCompactionData:(LBZXIntArray *)byteCompactionData length:(unsigned int)length result:(NSMutableString *)result {
  // Beginning from an initial state of the Alpha sub-mode
  // The default compaction mode for PDF417 in effect at the start of each symbol shall always be Text
  // Compaction mode Alpha sub-mode (uppercase alphabetic). A latch codeword from another mode to the Text
  // Compaction mode shall always switch to the Text Compaction Alpha sub-mode.
  LBZXPDF417Mode subMode = LBZXPDF417ModeAlpha;
  LBZXPDF417Mode priorToShiftMode = LBZXPDF417ModeAlpha;
  int i = 0;
  while (i < length) {
    int subModeCh = textCompactionData.array[i];
    unichar ch = 0;
    switch (subMode) {
      case LBZXPDF417ModeAlpha:
        // Alpha (uppercase alphabetic)
        if (subModeCh < 26) {
        // Upper case Alpha Character
          ch = (unichar)('A' + subModeCh);
        } else {
          if (subModeCh == 26) {
            ch = ' ';
          } else if (subModeCh == LBZX_PDF417_LL) {
            subMode = LBZXPDF417ModeLower;
          } else if (subModeCh == LBZX_PDF417_ML) {
            subMode = LBZXPDF417ModeMixed;
          } else if (subModeCh == LBZX_PDF417_PS) {
            // Shift to punctuation
            priorToShiftMode = subMode;
            subMode = LBZXPDF417ModePunctShift;
          } else if (subModeCh == LBZX_PDF417_MODE_SHIFT_TO_BYTE_COMPACTION_MODE) {
            [result appendFormat:@"%C", (unichar)byteCompactionData.array[i]];
          } else if (subModeCh == LBZX_PDF417_TEXT_COMPACTION_MODE_LATCH) {
            subMode = LBZXPDF417ModeAlpha;
          }
        }
        break;

      case LBZXPDF417ModeLower:
        // Lower (lowercase alphabetic)
        if (subModeCh < 26) {
          ch = (unichar)('a' + subModeCh);
        } else {
          if (subModeCh == 26) {
            ch = ' ';
          } else if (subModeCh == LBZX_PDF417_AS) {
            // Shift to alpha
            priorToShiftMode = subMode;
            subMode = LBZXPDF417ModeAlphaShift;
          } else if (subModeCh == LBZX_PDF417_ML) {
            subMode = LBZXPDF417ModeMixed;
          } else if (subModeCh == LBZX_PDF417_PS) {
            // Shift to punctuation
            priorToShiftMode = subMode;
            subMode = LBZXPDF417ModePunctShift;
          } else if (subModeCh == LBZX_PDF417_MODE_SHIFT_TO_BYTE_COMPACTION_MODE) {
            [result appendFormat:@"%C", (unichar)byteCompactionData.array[i]];
          } else if (subModeCh == LBZX_PDF417_TEXT_COMPACTION_MODE_LATCH) {
            subMode = LBZXPDF417ModeAlpha;
          }
        }
        break;

      case LBZXPDF417ModeMixed:
        // Mixed (numeric and some punctuation)
        if (subModeCh < LBZX_PDF417_PL) {
          ch = LBZX_PDF417_MIXED_CHARS[subModeCh];
        } else {
          if (subModeCh == LBZX_PDF417_PL) {
            subMode = LBZXPDF417ModePunct;
          } else if (subModeCh == 26) {
            ch = ' ';
          } else if (subModeCh == LBZX_PDF417_LL) {
            subMode = LBZXPDF417ModeLower;
          } else if (subModeCh == LBZX_PDF417_AL) {
            subMode = LBZXPDF417ModeAlpha;
          } else if (subModeCh == LBZX_PDF417_PS) {
            // Shift to punctuation
            priorToShiftMode = subMode;
            subMode = LBZXPDF417ModePunctShift;
          } else if (subModeCh == LBZX_PDF417_MODE_SHIFT_TO_BYTE_COMPACTION_MODE) {
            [result appendFormat:@"%C", (unichar)byteCompactionData.array[i]];
          } else if (subModeCh == LBZX_PDF417_TEXT_COMPACTION_MODE_LATCH) {
            subMode = LBZXPDF417ModeAlpha;
          }
        }
        break;

      case LBZXPDF417ModePunct:
        // Punctuation
        if (subModeCh < LBZX_PDF417_PAL) {
          ch = LBZX_PDF417_PUNCT_CHARS[subModeCh];
        } else {
          if (subModeCh == LBZX_PDF417_PAL) {
            subMode = LBZXPDF417ModeAlpha;
          } else if (subModeCh == LBZX_PDF417_MODE_SHIFT_TO_BYTE_COMPACTION_MODE) {
            [result appendFormat:@"%C", (unichar)byteCompactionData.array[i]];
          } else if (LBZX_PDF417_TEXT_COMPACTION_MODE_LATCH) {
            subMode = LBZXPDF417ModeAlpha;
          }
        }
        break;

      case LBZXPDF417ModeAlphaShift:
        // Restore sub-mode
        subMode = priorToShiftMode;
        if (subModeCh < 26) {
          ch = (unichar)('A' + subModeCh);
        } else {
          if (subModeCh == 26) {
            ch = ' ';
          } else if (subModeCh == LBZX_PDF417_TEXT_COMPACTION_MODE_LATCH) {
            subMode = LBZXPDF417ModeAlpha;
          }
        }
        break;

      case LBZXPDF417ModePunctShift:
        // Restore sub-mode
        subMode = priorToShiftMode;
        if (subModeCh < LBZX_PDF417_PAL) {
          ch = LBZX_PDF417_PUNCT_CHARS[subModeCh];
        } else {
          if (subModeCh == LBZX_PDF417_PAL) {
            subMode = LBZXPDF417ModeAlpha;
          } else if (subModeCh == LBZX_PDF417_MODE_SHIFT_TO_BYTE_COMPACTION_MODE) {
            // PS before Shift-to-Byte is used as a padding character,
            // see 5.4.2.4 of the specification
            [result appendFormat:@"%C", (unichar)byteCompactionData.array[i]];
          } else if (subModeCh == LBZX_PDF417_TEXT_COMPACTION_MODE_LATCH) {
            subMode = LBZXPDF417ModeAlpha;
          }
        }
        break;
    }
    if (ch != 0) {
      // Append decoded character to result
      [result appendFormat:@"%C", ch];
    }
    i++;
  }
}

/**
 * Byte Compaction mode (see 5.4.3) permits all 256 possible 8-bit byte values to be encoded.
 * This includes all ASCII characters value 0 to 127 inclusive and provides for international
 * character set support.
 *
 * @param mode      The byte compaction mode i.e. 901 or 924
 * @param codewords The array of codewords (data + error)
 * @param codeIndex The current index into the codeword array.
 * @param result    The decoded data is appended to the result.
 * @return The next index into the codeword array.
 */
+ (int)byteCompaction:(int)mode codewords:(LBZXIntArray *)codewords codeIndex:(int)codeIndex result:(NSMutableString *)result {
  if (mode == LBZX_PDF417_BYTE_COMPACTION_MODE_LATCH) {
    // Total number of Byte Compaction characters to be encoded
    // is not a multiple of 6
    int count = 0;
    long long value = 0;
    unichar decodedData[6] = {0, 0, 0, 0, 0, 0};
    LBZXIntArray *byteCompactedCodewords = [[LBZXIntArray alloc] initWithLength:6];
    BOOL end = NO;
    int nextCode = codewords.array[codeIndex++];
    while ((codeIndex < codewords.array[0]) && !end) {
      byteCompactedCodewords.array[count++] = nextCode;
      // Base 900
      value = 900 * value + nextCode;
      nextCode = codewords.array[codeIndex++];
      // perhaps it should be ok to check only nextCode >= TEXT_COMPACTION_MODE_LATCH
      if (nextCode == LBZX_PDF417_TEXT_COMPACTION_MODE_LATCH ||
          nextCode == LBZX_PDF417_BYTE_COMPACTION_MODE_LATCH ||
          nextCode == LBZX_PDF417_NUMERIC_COMPACTION_MODE_LATCH ||
          nextCode == LBZX_PDF417_BYTE_COMPACTION_MODE_LATCH_6 ||
          nextCode == LBZX_PDF417_BEGIN_MACRO_PDF417_CONTROL_BLOCK ||
          nextCode == LBZX_PDF417_BEGIN_MACRO_PDF417_OPTIONAL_FIELD ||
          nextCode == LBZX_PDF417_MACRO_PDF417_TERMINATOR) {
        codeIndex--;
        end = YES;
      } else {
        if ((count % 5 == 0) && (count > 0)) {
          // Decode every 5 codewords
          // Convert to Base 256
          for (int j = 0; j < 6; ++j) {
            decodedData[5 - j] = (unichar) (value % 256);
            value >>= 8;
          }
          [result appendString:[[NSString alloc] initWithCharacters:decodedData length:6]];
          count = 0;
        }
      }
    }

    // if the end of all codewords is reached the last codeword needs to be added
    if (codeIndex == codewords.array[0] && nextCode < LBZX_PDF417_TEXT_COMPACTION_MODE_LATCH) {
      byteCompactedCodewords.array[count++] = nextCode;
    }

    // If Byte Compaction mode is invoked with codeword 901,
    // the last group of codewords is interpreted directly
    // as one byte per codeword, without compaction.
    for (int i = 0; i < count; i++) {
      [result appendFormat:@"%C", (unichar)byteCompactedCodewords.array[i]];
    }
  } else if (mode == LBZX_PDF417_BYTE_COMPACTION_MODE_LATCH_6) {
    // Total number of Byte Compaction characters to be encoded
    // is an integer multiple of 6
    int count = 0;
    long long value = 0;
    BOOL end = NO;
    while (codeIndex < codewords.array[0] && !end) {
      int code = codewords.array[codeIndex++];
      if (code < LBZX_PDF417_TEXT_COMPACTION_MODE_LATCH) {
        count++;
        // Base 900
        value = 900 * value + code;
      } else {
        if (code == LBZX_PDF417_TEXT_COMPACTION_MODE_LATCH ||
            code == LBZX_PDF417_BYTE_COMPACTION_MODE_LATCH ||
            code == LBZX_PDF417_NUMERIC_COMPACTION_MODE_LATCH ||
            code == LBZX_PDF417_BYTE_COMPACTION_MODE_LATCH_6 ||
            code == LBZX_PDF417_BEGIN_MACRO_PDF417_CONTROL_BLOCK ||
            code == LBZX_PDF417_BEGIN_MACRO_PDF417_OPTIONAL_FIELD ||
            code == LBZX_PDF417_MACRO_PDF417_TERMINATOR) {
          codeIndex--;
          end = YES;
        }
      }
      if ((count % 5 == 0) && (count > 0)) {
        // Decode every 5 codewords
        // Convert to Base 256
        unichar decodedData[6];
        for (int j = 0; j < 6; ++j) {
          decodedData[5 - j] = (unichar)(value & 0xFF);
          value >>= 8;
        }
        [result appendString:[NSString stringWithCharacters:decodedData length:6]];
        count = 0;
      }
    }
  }
  return codeIndex;
}

/**
 * Numeric Compaction mode (see 5.4.4) permits efficient encoding of numeric data strings.
 *
 * @param codewords The array of codewords (data + error)
 * @param codeIndex The current index into the codeword array.
 * @param result    The decoded data is appended to the result.
 * @return The next index into the codeword array.
 */
+ (int)numericCompaction:(LBZXIntArray *)codewords codeIndex:(int)codeIndex result:(NSMutableString *)result {
  int count = 0;
  BOOL end = NO;

  LBZXIntArray *numericCodewords = [[LBZXIntArray alloc] initWithLength:LBZX_PDF417_MAX_NUMERIC_CODEWORDS];

  while (codeIndex < codewords.array[0] && !end) {
    int code = codewords.array[codeIndex++];
    if (codeIndex == codewords.array[0]) {
      end = YES;
    }
    if (code < LBZX_PDF417_TEXT_COMPACTION_MODE_LATCH) {
      numericCodewords.array[count] = code;
      count++;
    } else {
      if (code == LBZX_PDF417_TEXT_COMPACTION_MODE_LATCH ||
          code == LBZX_PDF417_BYTE_COMPACTION_MODE_LATCH ||
          code == LBZX_PDF417_BYTE_COMPACTION_MODE_LATCH_6 ||
          code == LBZX_PDF417_BEGIN_MACRO_PDF417_CONTROL_BLOCK ||
          code == LBZX_PDF417_BEGIN_MACRO_PDF417_OPTIONAL_FIELD ||
          code == LBZX_PDF417_MACRO_PDF417_TERMINATOR) {
        codeIndex--;
        end = YES;
      }
    }
    if (count % LBZX_PDF417_MAX_NUMERIC_CODEWORDS == 0 || code == LBZX_PDF417_NUMERIC_COMPACTION_MODE_LATCH || end) {
      NSString *s = [self decodeBase900toBase10:numericCodewords count:count];
      if (s == nil) {
        return INT_MAX;
      }
      [result appendString:s];
      count = 0;
    }
  }
  return codeIndex;
}

/**
 * Convert a list of Numeric Compacted codewords from Base 900 to Base 10.
 *
 * @param codewords The array of codewords
 * @param count     The number of codewords
 * @return The decoded string representing the Numeric data.
 */
/*
   EXAMPLE
   Encode the fifteen digit numeric string 000213298174000
   Prefix the numeric string with a 1 and set the initial value of
   t = 1 000 213 298 174 000
   Calculate codeword 0
   d0 = 1 000 213 298 174 000 mod 900 = 200

   t = 1 000 213 298 174 000 div 900 = 1 111 348 109 082
   Calculate codeword 1
   d1 = 1 111 348 109 082 mod 900 = 282

   t = 1 111 348 109 082 div 900 = 1 234 831 232
   Calculate codeword 2
   d2 = 1 234 831 232 mod 900 = 632

   t = 1 234 831 232 div 900 = 1 372 034
   Calculate codeword 3
   d3 = 1 372 034 mod 900 = 434

   t = 1 372 034 div 900 = 1 524
   Calculate codeword 4u
   d4 = 1 524 mod 900 = 624

   t = 1 524 div 900 = 1
   Calculate codeword 5
   d5 = 1 mod 900 = 1
   t = 1 div 900 = 0
   Codeword sequence is: 1, 624, 434, 632, 282, 200

   Decode the above codewords involves
   1 x 900 power of 5 + 624 x 900 power of 4 + 434 x 900 power of 3 +
   632 x 900 power of 2 + 282 x 900 power of 1 + 200 x 900 power of 0 = 1000213298174000

   Remove leading 1 =>  Result is 000213298174000
 */
+ (NSString *)decodeBase900toBase10:(LBZXIntArray *)codewords count:(int)count {
  NSDecimalNumber *result = [NSDecimalNumber zero];
  for (int i = 0; i < count; i++) {
    result = [result decimalNumberByAdding:[LBZX_PDF417_EXP900[count - i - 1] decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithDecimal:[@(codewords.array[i]) decimalValue]]]];
  }
  NSString *resultString = [result stringValue];
  if (![resultString hasPrefix:@"1"]) {
    return nil;
  }
  return [resultString substringFromIndex:1];
}

@end
