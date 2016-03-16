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

#import "LBZXByteArray.h"
#import "LBZXDecoderResult.h"
#import "LBZXErrors.h"
#import "LBZXMaxiCodeDecodedBitStreamParser.h"

const unichar LBSHIFTA = 0xFFF0;
const unichar LBSHIFTB = 0xFFF1;
const unichar LBSHIFTC = 0xFFF2;
const unichar LBSHIFTD = 0xFFF3;
const unichar LBSHIFTE = 0xFFF4;
const unichar LBTWOSHIFTA = 0xFFF5;
const unichar LBTHREESHIFTA = 0xFFF6;
const unichar LBLATCHA = 0xFFF7;
const unichar LBLATCHB = 0xFFF8;
const unichar LBLOCK = 0xFFF9;
const unichar LBECI = 0xFFFA;
const unichar LBNS = 0xFFFB;
const unichar LBPAD = 0xFFFC;
const unichar LBFS = 0x001C;
const unichar LBGS = 0x001D;
const unichar LBRS = 0x001E;

const unichar LBSETS[1][383] = {
  '\n', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W',
  'X', 'Y', 'Z', LBECI, LBFS, LBGS, LBRS, LBNS, ' ', LBPAD, '"', '#', '$', '%', '&', '\'', '(', ')', '*', '+', ',', '-', '.', '/', '0',
  '1', '2', '3', '4', '5', '6', '7', '8', '9', ':', LBSHIFTB, LBSHIFTC, LBSHIFTD, LBSHIFTE, LBLATCHB,
  '`', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p' , 'q', 'r', 's', 't', 'u', 'v', 'w',
  'x', 'y', 'z', LBECI, LBFS, LBGS, LBRS, LBNS, '{', LBPAD, '}', '~', 0x007F, ';', '<', '=', '>', '?', '[', '\\', ']', '^', '_', ' ',
  ',', '.', '/', ':', '@', '!', '|', LBPAD, LBTWOSHIFTA, LBTHREESHIFTA, LBPAD, LBSHIFTA, LBSHIFTC, LBSHIFTD, LBSHIFTE, LBLATCHA,
  0x00C0, 0x00C1, 0x00C2, 0x00C3, 0x00C4, 0x00C5, 0x00C6, 0x00C7, 0x00C8, 0x00C9, 0x00CA, 0x00CB, 0x00CC, 0x00CD, 0x00CE,
  0x00CF, 0x00D0, 0x00D1, 0x00D2, 0x00D3, 0x00D4, 0x00D5, 0x00D6, 0x00D7, 0x00D8, 0x00D9, 0x00DA, LBECI, LBFS, LBGS, LBRS, 0x00DB,
  0x00DC, 0x00DD, 0x00DE, 0x00DF, 0x00AA, 0x00AC, 0x00B1, 0x00B2, 0x00B3, 0x00B5, 0x00B9, 0x00BA, 0x00BC, 0x00BD, 0x00BE,
  0x0080, 0x0081, 0x0082, 0x0083, 0x0084, 0x0085, 0x0086, 0x0087, 0x0088, 0x0089, LBLATCHA, ' ', LBLOCK, LBSHIFTD, LBSHIFTE, LBLATCHB,
  0x00E0, 0x00E1, 0x00E2, 0x00E3, 0x00E4, 0x00E5, 0x00E6, 0x00E7, 0x00E8, 0x00E9, 0x00EA, 0x00EB, 0x00EC, 0x00ED, 0x00EE,
  0x00EF, 0x00F0, 0x00F1, 0x00F2, 0x00F3, 0x00F4, 0x00F5, 0x00F6, 0x00F7, 0x00F8, 0x00F9, 0x00FA, LBECI, LBFS, LBGS, LBRS, LBNS,
  0x00FB, 0x00FC, 0x00FD, 0x00FE, 0x00FF, 0x00A1, 0x00A8, 0x00AB, 0x00AF, 0x00B0, 0x00B4, 0x00B7, 0x00B8, 0x00BB, 0x00BF,
  0x008A, 0x008B, 0x008C, 0x008D, 0x008E, 0x008F, 0x0090, 0x0091, 0x0092, 0x0093, 0x0094, LBLATCHA, ' ', LBSHIFTC, LBLOCK, LBSHIFTE,
  LBLATCHB, 0x0000, 0x0001, 0x0002, 0x0003, 0x0004, 0x0005, 0x0006, 0x0007, 0x0008, 0x0009, '\n', 0x000B, 0x000C, '\r',
  0x000E, 0x000F, 0x0010, 0x0011, 0x0012, 0x0013, 0x0014, 0x0015, 0x0016, 0x0017, 0x0018, 0x0019, 0x001A, LBECI, LBPAD, LBPAD,
  0x001B, LBNS, LBFS, LBGS, LBRS, 0x001F, 0x009F, 0x00A0, 0x00A2, 0x00A3, 0x00A4, 0x00A5, 0x00A6, 0x00A7, 0x00A9, 0x00AD, 0x00AE,
  0x00B6, 0x0095, 0x0096, 0x0097, 0x0098, 0x0099, 0x009A, 0x009B, 0x009C, 0x009D, 0x009E, LBLATCHA, ' ', LBSHIFTC, LBSHIFTD, LBLOCK,
  LBLATCHB, 0x0000, 0x0001, 0x0002, 0x0003, 0x0004, 0x0005, 0x0006, 0x0007, 0x0008, 0x0009, '\n', 0x000B, 0x000C, '\r',
  0x000E, 0x000F, 0x0010, 0x0011, 0x0012, 0x0013, 0x0014, 0x0015, 0x0016, 0x0017, 0x0018, 0x0019, 0x001A, 0x001B, 0x001C,
  0x001D, 0x001E, 0x001F, 0x0020, 0x0021, '"', 0x0023, 0x0024, 0x0025, 0x0026, 0x0027, 0x0028, 0x0029, 0x002A, 0x002B,
  0x002C, 0x002D, 0x002E, 0x002F, 0x0030, 0x0031, 0x0032, 0x0033, 0x0034, 0x0035, 0x0036, 0x0037, 0x0038, 0x0039, 0x003A,
  0x003B, 0x003C, 0x003D, 0x003E, 0x003F
};

@implementation LBZXMaxiCodeDecodedBitStreamParser

+ (LBZXDecoderResult *)decode:(LBZXByteArray *)bytes mode:(int)mode {
  NSMutableString *result = [NSMutableString stringWithCapacity:144];
  switch (mode) {
    case 2:
    case 3: {
      NSString *postcode;
      if (mode == 2) {
        int pc = [self postCode2:bytes];
        postcode = [NSString stringWithFormat:@"%9d", pc];
      } else {
        postcode = [self postCode3:bytes];
      }
      NSString *country = [NSString stringWithFormat:@"%3d", [self country:bytes]];
      NSString *service = [NSString stringWithFormat:@"%3d", [self serviceClass:bytes]];
      [result appendString:[self message:bytes start:10 len:84]];
      if ([result hasPrefix:[NSString stringWithFormat:@"[)>%C01%C", LBRS, LBGS]]) {
        [result insertString:[NSString stringWithFormat:@"%@%C%@%C%@%C", postcode, LBGS, country, LBGS, service, LBGS] atIndex:9];
      } else {
        [result insertString:[NSString stringWithFormat:@"%@%C%@%C%@%C", postcode, LBGS, country, LBGS, service, LBGS] atIndex:0];
      }
      break;
    }
    case 4:
      [result appendString:[self message:bytes start:1 len:93]];
      break;
    case 5:
      [result appendString:[self message:bytes start:1 len:77]];
      break;
  }
  return [[LBZXDecoderResult alloc] initWithRawBytes:bytes
                                              text:result
                                      byteSegments:nil
                                           ecLevel:[NSString stringWithFormat:@"%d", mode]];
}

+ (int)bit:(int)bit bytes:(LBZXByteArray *)bytes {
  bit--;
  return (bytes.array[bit / 6] & (1 << (5 - (bit % 6)))) == 0 ? 0 : 1;
}

+ (int)integer:(LBZXByteArray *)bytes x:(LBZXByteArray *)x {
  int val = 0;
  for (int i = 0; i < x.length; i++) {
    val += [self bit:x.array[i] bytes:bytes] << (x.length - i - 1);
  }
  return val;
}

+ (int)country:(LBZXByteArray *)bytes {
  return [self integer:bytes x:[[LBZXByteArray alloc] initWithBytes:53, 54, 43, 44, 45, 46, 47, 48, 37, 38, -1]];
}

+ (int)serviceClass:(LBZXByteArray *)bytes {
  return [self integer:bytes x:[[LBZXByteArray alloc] initWithBytes:55, 56, 57, 58, 59, 60, 49, 50, 51, 52, -1]];
}

+ (int)postCode2Length:(LBZXByteArray *)bytes {
  return [self integer:bytes x:[[LBZXByteArray alloc] initWithBytes:39, 40, 41, 42, 31, 32, -1]];
}

+ (int)postCode2:(LBZXByteArray *)bytes {
  return [self integer:bytes x:[[LBZXByteArray alloc] initWithBytes:33, 34, 35, 36, 25, 26, 27, 28, 29, 30, 19,
                                20, 21, 22, 23, 24, 13, 14, 15, 16, 17, 18, 7, 8, 9, 10, 11, 12, 1, 2, -1]];
}

+ (NSString *)postCode3:(LBZXByteArray *)bytes {
  return [NSString stringWithFormat:@"%C%C%C%C%C%C",
          LBSETS[0][[self integer:bytes x:[[LBZXByteArray alloc] initWithBytes:39, 40, 41, 42, 31, 32, -1]]],
          LBSETS[0][[self integer:bytes x:[[LBZXByteArray alloc] initWithBytes:33, 34, 35, 36, 25, 26, -1]]],
          LBSETS[0][[self integer:bytes x:[[LBZXByteArray alloc] initWithBytes:27, 28, 29, 30, 19, 20, -1]]],
          LBSETS[0][[self integer:bytes x:[[LBZXByteArray alloc] initWithBytes:21, 22, 23, 24, 13, 14, -1]]],
          LBSETS[0][[self integer:bytes x:[[LBZXByteArray alloc] initWithBytes:15, 16, 17, 18,  7,  8, -1]]],
          LBSETS[0][[self integer:bytes x:[[LBZXByteArray alloc] initWithBytes: 9, 10, 11, 12,  1,  2, -1]]]];
}

+ (NSString *)message:(LBZXByteArray *)bytes start:(int)start len:(int)len {
  NSMutableString *sb = [NSMutableString string];
  int shift = -1;
  int set = 0;
  int lastset = 0;
  for (int i = start; i < start + len; i++) {
    unichar c = LBSETS[set][bytes.array[i]];
    switch (c) {
      case LBLATCHA:
        set = 0;
        shift = -1;
        break;
      case LBLATCHB:
        set = 1;
        shift = -1;
        break;
      case LBSHIFTA:
      case LBSHIFTB:
      case LBSHIFTC:
      case LBSHIFTD:
      case LBSHIFTE:
        lastset = set;
        set = c - LBSHIFTA;
        shift = 1;
        break;
      case LBTWOSHIFTA:
        lastset = set;
        set = 0;
        shift = 2;
        break;
      case LBTHREESHIFTA:
        lastset = set;
        set = 0;
        shift = 3;
        break;
      case LBNS: {
        int nsval1 = bytes.array[++i] << 24;
        int nsval2 = bytes.array[++i] << 18;
        int nsval3 = bytes.array[++i] << 12;
        int nsval4 = bytes.array[++i] << 6;
        int nsval5 = bytes.array[++i];
        int nsval = nsval1 + nsval2 + nsval3 + nsval4 + nsval5;
        [sb appendFormat:@"%9d", nsval];
        break;
      }
      case LBLOCK:
        shift = -1;
        break;
      default:
        [sb appendFormat:@"%C", c];
    }
    if (shift-- == 0) {
      set = lastset;
    }
  }
  while (sb.length > 0 && [sb characterAtIndex:sb.length - 1] == LBPAD) {
    [sb deleteCharactersInRange:NSMakeRange(sb.length - 1, 1)];
  }
  return sb;
}

@end
