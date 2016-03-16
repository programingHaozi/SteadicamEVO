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

#import "LBZXPDF417BoundingBox.h"
#import "LBZXPDF417Codeword.h"
#import "LBZXPDF417DetectionResultColumn.h"

const int LBZX_PDF417_MAX_NEARBY_DISTANCE = 5;

@implementation LBZXPDF417DetectionResultColumn

- (id)initWithBoundingBox:(LBZXPDF417BoundingBox *)boundingBox {
  self = [super init];
  if (self) {
    _boundingBox = [[LBZXPDF417BoundingBox alloc] initWithBoundingBox:boundingBox];
    _codewords = [NSMutableArray array];
    for (int i = 0; i < boundingBox.maxY - boundingBox.minY + 1; i++) {
      [_codewords addObject:[NSNull null]];
    }
  }

  return self;
}

- (LBZXPDF417Codeword *)codewordNearby:(int)imageRow {
  LBZXPDF417Codeword *codeword = [self codeword:imageRow];
  if (codeword) {
    return codeword;
  }
  for (int i = 1; i < LBZX_PDF417_MAX_NEARBY_DISTANCE; i++) {
    int nearImageRow = [self imageRowToCodewordIndex:imageRow] - i;
    if (nearImageRow >= 0) {
      codeword = self.codewords[nearImageRow];
      if ((id)codeword != [NSNull null]) {
        return codeword;
      }
    }
    nearImageRow = [self imageRowToCodewordIndex:imageRow] + i;
    if (nearImageRow < [self.codewords count]) {
      codeword = self.codewords[nearImageRow];
      if ((id)codeword != [NSNull null]) {
        return codeword;
      }
    }
  }
  return nil;
}

- (int)imageRowToCodewordIndex:(int)imageRow {
  return imageRow - self.boundingBox.minY;
}

- (void)setCodeword:(int)imageRow codeword:(LBZXPDF417Codeword *)codeword {
  _codewords[[self imageRowToCodewordIndex:imageRow]] = codeword;
}

- (LBZXPDF417Codeword *)codeword:(int)imageRow {
  NSUInteger index = [self imageRowToCodewordIndex:imageRow];
  if (_codewords[index] == [NSNull null]) {
    return nil;
  }
  return _codewords[index];
}

- (NSString *)description {
  NSMutableString *result = [NSMutableString string];
  int row = 0;
  for (LBZXPDF417Codeword *codeword in self.codewords) {
    if ((id)codeword == [NSNull null]) {
      [result appendFormat:@"%3d:    |   \n", row++];
      continue;
    }
    [result appendFormat:@"%3d: %3d|%3d\n", row++, codeword.rowNumber, codeword.value];
  }
  return [NSString stringWithString:result];
}

@end
