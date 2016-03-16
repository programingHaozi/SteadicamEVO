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

#import "LBZXGenericGF.h"
#import "LBZXGenericGFPoly.h"
#import "LBZXIntArray.h"

@interface LBZXGenericGFPoly ()

@property (nonatomic, strong, readonly) LBZXGenericGF *field;

@end

@implementation LBZXGenericGFPoly

- (id)initWithField:(LBZXGenericGF *)field coefficients:(LBZXIntArray *)coefficients {
  if (self = [super init]) {
    if (coefficients.length == 0) {
      @throw [NSException exceptionWithName:@"IllegalArgumentException"
                                     reason:@"coefficients must have at least one element"
                                   userInfo:nil];
    }
    _field = field;
    int coefficientsLength = coefficients.length;
    if (coefficientsLength > 1 && coefficients.array[0] == 0) {
      // Leading term must be non-zero for anything except the constant polynomial "0"
      int firstNonZero = 1;
      while (firstNonZero < coefficientsLength && coefficients.array[firstNonZero] == 0) {
        firstNonZero++;
      }
      if (firstNonZero == coefficientsLength) {
        _coefficients = field.zero.coefficients;
      } else {
        _coefficients = [[LBZXIntArray alloc] initWithLength:coefficientsLength - firstNonZero];
        for (int i = 0; i < _coefficients.length; i++) {
          _coefficients.array[i] = coefficients.array[firstNonZero + i];
        }
      }
    } else {
      _coefficients = coefficients;
    }
  }

  return self;
}

- (int)degree {
  return self.coefficients.length - 1;
}

- (BOOL)zero {
  return self.coefficients.array[0] == 0;
}

- (int)coefficient:(int)degree {
  return self.coefficients.array[self.coefficients.length - 1 - degree];
}

- (int)evaluateAt:(int)a {
  if (a == 0) {
    return [self coefficient:0];
  }
  int size = self.coefficients.length;
  int32_t *coefficients = self.coefficients.array;
  LBZXGenericGF *field = self.field;
  if (a == 1) {
    // Just the sum of the coefficients
    int result = 0;
    for (int i = 0; i < size; i++) {
      result = [LBZXGenericGF addOrSubtract:result b:coefficients[i]];
    }
    return result;
  }
  int result = coefficients[0];
  for (int i = 1; i < size; i++) {
    result = [LBZXGenericGF addOrSubtract:[field multiply:a b:result] b:coefficients[i]];
  }
  return result;
}

- (LBZXGenericGFPoly *)addOrSubtract:(LBZXGenericGFPoly *)other {
  if (![self.field isEqual:other.field]) {
    [NSException raise:NSInvalidArgumentException format:@"LBZXGenericGFPolys do not have same LBZXGenericGF field"];
  }
  if (self.zero) {
    return other;
  }
  if (other.zero) {
    return self;
  }

  LBZXIntArray *smallerCoefficients = self.coefficients;
  LBZXIntArray *largerCoefficients = other.coefficients;
  if (smallerCoefficients.length > largerCoefficients.length) {
    LBZXIntArray *temp = smallerCoefficients;
    smallerCoefficients = largerCoefficients;
    largerCoefficients = temp;
  }
  LBZXIntArray *sumDiff = [[LBZXIntArray alloc] initWithLength:largerCoefficients.length];
  int lengthDiff = largerCoefficients.length - smallerCoefficients.length;
  // Copy high-order terms only found in higher-degree polynomial's coefficients
  memcpy(sumDiff.array, largerCoefficients.array, lengthDiff * sizeof(int32_t));

  for (int i = lengthDiff; i < largerCoefficients.length; i++) {
    sumDiff.array[i] = [LBZXGenericGF addOrSubtract:smallerCoefficients.array[i - lengthDiff] b:largerCoefficients.array[i]];
  }

  return [[LBZXGenericGFPoly alloc] initWithField:self.field coefficients:sumDiff];
}

- (LBZXGenericGFPoly *)multiply:(LBZXGenericGFPoly *)other {
  LBZXGenericGF *field = self.field;
  if (![self.field isEqual:other.field]) {
    [NSException raise:NSInvalidArgumentException format:@"LBZXGenericGFPolys do not have same GenericGF field"];
  }
  if (self.zero || other.zero) {
    return field.zero;
  }
  LBZXIntArray *aCoefficients = self.coefficients;
  int aLength = aCoefficients.length;
  LBZXIntArray *bCoefficients = other.coefficients;
  int bLength = bCoefficients.length;
  LBZXIntArray *product = [[LBZXIntArray alloc] initWithLength:aLength + bLength - 1];
  for (int i = 0; i < aLength; i++) {
    int aCoeff = aCoefficients.array[i];
    for (int j = 0; j < bLength; j++) {
      product.array[i + j] = [LBZXGenericGF addOrSubtract:product.array[i + j]
                                                      b:[field multiply:aCoeff b:bCoefficients.array[j]]];
    }
  }
  return [[LBZXGenericGFPoly alloc] initWithField:field coefficients:product];
}

- (LBZXGenericGFPoly *)multiplyScalar:(int)scalar {
  if (scalar == 0) {
    return self.field.zero;
  }
  if (scalar == 1) {
    return self;
  }
  int size = self.coefficients.length;
  int32_t *coefficients = self.coefficients.array;
  LBZXIntArray *product = [[LBZXIntArray alloc] initWithLength:size];
  for (int i = 0; i < size; i++) {
    product.array[i] = [self.field multiply:coefficients[i] b:scalar];
  }
  return [[LBZXGenericGFPoly alloc] initWithField:self.field coefficients:product];
}

- (LBZXGenericGFPoly *)multiplyByMonomial:(int)degree coefficient:(int)coefficient {
  if (degree < 0) {
    [NSException raise:NSInvalidArgumentException format:@"Degree must be greater than 0."];
  }
  if (coefficient == 0) {
    return self.field.zero;
  }
  int size = self.coefficients.length;
  int32_t *coefficients = self.coefficients.array;
  LBZXGenericGF *field = self.field;
  LBZXIntArray *product = [[LBZXIntArray alloc] initWithLength:size + degree];
  for (int i = 0; i < size; i++) {
    product.array[i] = [field multiply:coefficients[i] b:coefficient];
  }

  return [[LBZXGenericGFPoly alloc] initWithField:field coefficients:product];
}

- (NSArray *)divide:(LBZXGenericGFPoly *)other {
  if (![self.field isEqual:other.field]) {
    [NSException raise:NSInvalidArgumentException format:@"LBZXGenericGFPolys do not have same LBZXGenericGF field"];
  }
  if (other.zero) {
    [NSException raise:NSInvalidArgumentException format:@"Divide by 0"];
  }

  LBZXGenericGFPoly *quotient = self.field.zero;
  LBZXGenericGFPoly *remainder = self;

  int denominatorLeadingTerm = [other coefficient:other.degree];
  int inverseDenominatorLeadingTerm = [self.field inverse:denominatorLeadingTerm];

  LBZXGenericGF *field = self.field;
  while ([remainder degree] >= other.degree && !remainder.zero) {
    int degreeDifference = remainder.degree - other.degree;
    int scale = [field multiply:[remainder coefficient:remainder.degree] b:inverseDenominatorLeadingTerm];
    LBZXGenericGFPoly *term = [other multiplyByMonomial:degreeDifference coefficient:scale];
    LBZXGenericGFPoly *iterationQuotient = [field buildMonomial:degreeDifference coefficient:scale];
    quotient = [quotient addOrSubtract:iterationQuotient];
    remainder = [remainder addOrSubtract:term];
  }

  return @[quotient, remainder];
}

- (NSString *)description {
  NSMutableString *result = [NSMutableString stringWithCapacity:8 * [self degree]];
  for (int degree = [self degree]; degree >= 0; degree--) {
    int coefficient = [self coefficient:degree];
    if (coefficient != 0) {
      if (coefficient < 0) {
        [result appendString:@" - "];
        coefficient = -coefficient;
      } else {
        if ([result length] > 0) {
          [result appendString:@" + "];
        }
      }
      if (degree == 0 || coefficient != 1) {
        int alphaPower = [self.field log:coefficient];
        if (alphaPower == 0) {
          [result appendString:@"1"];
        } else if (alphaPower == 1) {
          [result appendString:@"a"];
        } else {
          [result appendString:@"a^"];
          [result appendFormat:@"%d", alphaPower];
        }
      }
      if (degree != 0) {
        if (degree == 1) {
          [result appendString:@"x"];
        } else {
          [result appendString:@"x^"];
          [result appendFormat:@"%d", degree];
        }
      }
    }
  }

  return result;
}

@end
