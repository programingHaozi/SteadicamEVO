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

#import <Foundation/Foundation.h>

@class LBZXBitArray, LBZXIntArray;

/**
 * Represents a 2D matrix of bits. In function arguments below, and throughout the common
 * module, x is the column position, and y is the row position. The ordering is always x, y.
 * The origin is at the top-left.
 *
 * Internally the bits are represented in a 1-D array of 32-bit ints. However, each row begins
 * with a new NSInteger. This is done intentionally so that we can copy out a row into a BitArray very
 * efficiently.
 *
 * The ordering of bits is row-major. Within each NSInteger, the least significant bits are used first,
 * meaning they represent lower x values. This is compatible with BitArray's implementation.
 */
@interface LBZXBitMatrix : NSObject <NSCopying>

/**
 * @return The width of the matrix
 */
@property (nonatomic, assign, readonly) int width;

/**
 * @return The height of the matrix
 */
@property (nonatomic, assign, readonly) int height;

@property (nonatomic, assign, readonly) int32_t *bits;

// A helper to construct a square matrix.
+ (LBZXBitMatrix *)bitMatrixWithDimension:(int)dimension;

+ (LBZXBitMatrix *)bitMatrixWithWidth:(int)width height:(int)height;

- (id)initWithDimension:(int)dimension;

- (id)initWithWidth:(int)width height:(int)height;

/**
 * Gets the requested bit, where true means black.
 *
 * @param x The horizontal component (i.e. which column)
 * @param y The vertical component (i.e. which row)
 * @return value of given bit in matrix
 */
- (BOOL)getX:(int)x y:(int)y;

/**
 * Sets the given bit to true.
 *
 * @param x The horizontal component (i.e. which column)
 * @param y The vertical component (i.e. which row)
 */
- (void)setX:(int)x y:(int)y;

/**
 * Flips the given bit.
 *
 * @param x The horizontal component (i.e. which column)
 * @param y The vertical component (i.e. which row)
 */
- (void)flipX:(int)x y:(int)y;

/**
 * Clears all bits (sets to false).
 */
- (void)clear;

/**
 * Sets a square region of the bit matrix to true.
 *
 * @param left The horizontal position to begin at (inclusive)
 * @param top The vertical position to begin at (inclusive)
 * @param width The width of the region
 * @param height The height of the region
 */
- (void)setRegionAtLeft:(int)left top:(int)top width:(int)width height:(int)height;

/**
 * A fast method to retrieve one row of data from the matrix as a LBZXBitArray.
 *
 * @param y The row to retrieve
 * @param row An optional caller-allocated BitArray, will be allocated if null or too small
 * @return The resulting BitArray - this reference should always be used even when passing
 *         your own row
 */
- (LBZXBitArray *)rowAtY:(int)y row:(LBZXBitArray *)row;

/**
 * @param y row to set
 * @param row LBZXBitArray to copy from
 */
- (void)setRowAtY:(int)y row:(LBZXBitArray *)row;

/**
 * Modifies this LBZXBitMatrix to represent the same but rotated 180 degrees
 */
- (void)rotate180;

/**
 * This is useful in detecting the enclosing rectangle of a 'pure' barcode.
 *
 * @return {left,top,width,height} enclosing rectangle of all 1 bits, or null if it is all white
 */
- (LBZXIntArray *)enclosingRectangle;

/**
 * This is useful in detecting a corner of a 'pure' barcode.
 *
 * @return {x,y} coordinate of top-left-most 1 bit, or null if it is all white
 */
- (LBZXIntArray *)topLeftOnBit;

- (LBZXIntArray *)bottomRightOnBit;

@end
