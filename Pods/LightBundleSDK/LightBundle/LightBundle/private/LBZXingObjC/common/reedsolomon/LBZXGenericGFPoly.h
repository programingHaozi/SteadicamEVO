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

@class LBZXGenericGF, LBZXIntArray;

/**
 * Represents a polynomial whose coefficients are elements of a GF.
 * Instances of this class are immutable.
 *
 * Much credit is due to William Rucklidge since portions of this code are an indirect
 * port of his C++ Reed-Solomon implementation.
 */
@interface LBZXGenericGFPoly : NSObject

@property (nonatomic, strong, readonly) LBZXIntArray *coefficients;

/**
 * @param field the {@link GenericGF} instance representing the field to use
 * to perform computations
 * @param coefficients coefficients as ints representing elements of GF(size), arranged
 * from most significant (highest-power term) coefficient to least significant
 */
- (id)initWithField:(LBZXGenericGF *)field coefficients:(LBZXIntArray *)coefficients;

/**
 * @return degree of this polynomial
 */
- (int)degree;

/**
 * @return true iff this polynomial is the monomial "0"
 */
- (BOOL)zero;

/**
 * @return coefficient of x^degree term in this polynomial
 */
- (int)coefficient:(int)degree;

/**
 * @return evaluation of this polynomial at a given point
 */
- (int)evaluateAt:(int)a;

- (LBZXGenericGFPoly *)addOrSubtract:(LBZXGenericGFPoly *)other;
- (LBZXGenericGFPoly *)multiply:(LBZXGenericGFPoly *)other;
- (LBZXGenericGFPoly *)multiplyScalar:(int)scalar;
- (LBZXGenericGFPoly *)multiplyByMonomial:(int)degree coefficient:(int)coefficient;
- (NSArray *)divide:(LBZXGenericGFPoly *)other;

@end
