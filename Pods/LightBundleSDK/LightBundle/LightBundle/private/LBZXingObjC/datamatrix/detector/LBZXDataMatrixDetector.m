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

#import "LBZXDataMatrixDetector.h"
#import "LBZXDetectorResult.h"
#import "LBZXErrors.h"
#import "LBZXGridSampler.h"
#import "LBZXMathUtils.h"
#import "LBZXResultPoint.h"
#import "LBZXWhiteRectangleDetector.h"

/**
 * Simply encapsulates two points and a number of transitions between them.
 */
@interface LBZXResultPointsAndTransitions : NSObject

@property (nonatomic, strong, readonly) LBZXResultPoint *from;
@property (nonatomic, strong, readonly) LBZXResultPoint *to;
@property (nonatomic, assign, readonly) int transitions;

@end

@implementation LBZXResultPointsAndTransitions

- (id)initWithFrom:(LBZXResultPoint *)from to:(LBZXResultPoint *)to transitions:(int)transitions {
  if (self = [super init]) {
    _from = from;
    _to = to;
    _transitions = transitions;
  }

  return self;
}

- (NSString *)description {
  return [NSString stringWithFormat:@"%@/%@/%d", self.from, self.to, self.transitions];
}

- (NSComparisonResult)compare:(LBZXResultPointsAndTransitions *)otherObject {
  return [@(self.transitions) compare:@(otherObject.transitions)];
}

@end


@interface LBZXDataMatrixDetector ()

@property (nonatomic, strong, readonly) LBZXBitMatrix *image;
@property (nonatomic, strong, readonly) LBZXWhiteRectangleDetector *rectangleDetector;

@end

@implementation LBZXDataMatrixDetector

- (id)initWithImage:(LBZXBitMatrix *)image error:(NSError **)error {
  if (self = [super init]) {
    _image = image;
    _rectangleDetector = [[LBZXWhiteRectangleDetector alloc] initWithImage:_image error:error];
    if (!_rectangleDetector) {
      return nil;
    }
  }

  return self;
}

- (LBZXDetectorResult *)detectWithError:(NSError **)error {
  NSArray *cornerPoints = [self.rectangleDetector detectWithError:error];
  if (!cornerPoints) {
    return nil;
  }
  LBZXResultPoint *pointA = cornerPoints[0];
  LBZXResultPoint *pointB = cornerPoints[1];
  LBZXResultPoint *pointC = cornerPoints[2];
  LBZXResultPoint *pointD = cornerPoints[3];

  NSMutableArray *transitions = [NSMutableArray arrayWithCapacity:4];
  [transitions addObject:[self transitionsBetween:pointA to:pointB]];
  [transitions addObject:[self transitionsBetween:pointA to:pointC]];
  [transitions addObject:[self transitionsBetween:pointB to:pointD]];
  [transitions addObject:[self transitionsBetween:pointC to:pointD]];
  [transitions sortUsingSelector:@selector(compare:)];

  LBZXResultPointsAndTransitions *lSideOne = (LBZXResultPointsAndTransitions *)transitions[0];
  LBZXResultPointsAndTransitions *lSideTwo = (LBZXResultPointsAndTransitions *)transitions[1];

  NSMutableDictionary *pointCount = [NSMutableDictionary dictionary];
  [self increment:pointCount key:[lSideOne from]];
  [self increment:pointCount key:[lSideOne to]];
  [self increment:pointCount key:[lSideTwo from]];
  [self increment:pointCount key:[lSideTwo to]];

  LBZXResultPoint *maybeTopLeft = nil;
  LBZXResultPoint *bottomLeft = nil;
  LBZXResultPoint *maybeBottomRight = nil;
  for (LBZXResultPoint *point in [pointCount allKeys]) {
    NSNumber *value = pointCount[point];
    if ([value intValue] == 2) {
      bottomLeft = point;
    } else {
      if (maybeTopLeft == nil) {
        maybeTopLeft = point;
      } else {
        maybeBottomRight = point;
      }
    }
  }

  if (maybeTopLeft == nil || bottomLeft == nil || maybeBottomRight == nil) {
    if (error) *error = LBZXNotFoundErrorInstance();
    return nil;
  }

  NSMutableArray *corners = [NSMutableArray arrayWithObjects:maybeTopLeft, bottomLeft, maybeBottomRight, nil];
  [LBZXResultPoint orderBestPatterns:corners];

  LBZXResultPoint *bottomRight = corners[0];
  bottomLeft = corners[1];
  LBZXResultPoint *topLeft = corners[2];

  LBZXResultPoint *topRight;
  if (!pointCount[pointA]) {
    topRight = pointA;
  } else if (!pointCount[pointB]) {
    topRight = pointB;
  } else if (!pointCount[pointC]) {
    topRight = pointC;
  } else {
    topRight = pointD;
  }

  int dimensionTop = [[self transitionsBetween:topLeft to:topRight] transitions];
  int dimensionRight = [[self transitionsBetween:bottomRight to:topRight] transitions];

  if ((dimensionTop & 0x01) == 1) {
    dimensionTop++;
  }
  dimensionTop += 2;

  if ((dimensionRight & 0x01) == 1) {
    dimensionRight++;
  }
  dimensionRight += 2;

  LBZXBitMatrix *bits;
  LBZXResultPoint *correctedTopRight;

  if (4 * dimensionTop >= 7 * dimensionRight || 4 * dimensionRight >= 7 * dimensionTop) {
    correctedTopRight = [self correctTopRightRectangular:bottomLeft bottomRight:bottomRight topLeft:topLeft topRight:topRight dimensionTop:dimensionTop dimensionRight:dimensionRight];
    if (correctedTopRight == nil) {
      correctedTopRight = topRight;
    }

    dimensionTop = [[self transitionsBetween:topLeft to:correctedTopRight] transitions];
    dimensionRight = [[self transitionsBetween:bottomRight to:correctedTopRight] transitions];

    if ((dimensionTop & 0x01) == 1) {
      dimensionTop++;
    }

    if ((dimensionRight & 0x01) == 1) {
      dimensionRight++;
    }

    bits = [self sampleGrid:self.image topLeft:topLeft bottomLeft:bottomLeft bottomRight:bottomRight topRight:correctedTopRight dimensionX:dimensionTop dimensionY:dimensionRight error:error];
    if (!bits) {
      return nil;
    }
  } else {
    int dimension = MIN(dimensionRight, dimensionTop);
    correctedTopRight = [self correctTopRight:bottomLeft bottomRight:bottomRight topLeft:topLeft topRight:topRight dimension:dimension];
    if (correctedTopRight == nil) {
      correctedTopRight = topRight;
    }

    int dimensionCorrected = MAX([[self transitionsBetween:topLeft to:correctedTopRight] transitions], [[self transitionsBetween:bottomRight to:correctedTopRight] transitions]);
    dimensionCorrected++;
    if ((dimensionCorrected & 0x01) == 1) {
      dimensionCorrected++;
    }

    bits = [self sampleGrid:self.image topLeft:topLeft bottomLeft:bottomLeft bottomRight:bottomRight topRight:correctedTopRight dimensionX:dimensionCorrected dimensionY:dimensionCorrected error:error];
    if (!bits) {
      return nil;
    }
  }
  return [[LBZXDetectorResult alloc] initWithBits:bits points:@[topLeft, bottomLeft, bottomRight, correctedTopRight]];
}

/**
 * Calculates the position of the white top right module using the output of the rectangle detector
 * for a rectangular matrix
 */
- (LBZXResultPoint *)correctTopRightRectangular:(LBZXResultPoint *)bottomLeft bottomRight:(LBZXResultPoint *)bottomRight
                                      topLeft:(LBZXResultPoint *)topLeft topRight:(LBZXResultPoint *)topRight
                                 dimensionTop:(int)dimensionTop dimensionRight:(int)dimensionRight {
  float corr = [self distance:bottomLeft b:bottomRight] / (float)dimensionTop;
  int norm = [self distance:topLeft b:topRight];
  float cos = ([topRight x] - [topLeft x]) / norm;
  float sin = ([topRight y] - [topLeft y]) / norm;

  LBZXResultPoint *c1 = [[LBZXResultPoint alloc] initWithX:[topRight x] + corr * cos y:[topRight y] + corr * sin];

  corr = [self distance:bottomLeft b:topLeft] / (float)dimensionRight;
  norm = [self distance:bottomRight b:topRight];
  cos = ([topRight x] - [bottomRight x]) / norm;
  sin = ([topRight y] - [bottomRight y]) / norm;

  LBZXResultPoint *c2 = [[LBZXResultPoint alloc] initWithX:[topRight x] + corr * cos y:[topRight y] + corr * sin];

  if (![self isValid:c1]) {
    if ([self isValid:c2]) {
      return c2;
    }
    return nil;
  } else if (![self isValid:c2]) {
    return c1;
  }

  int l1 = abs(dimensionTop - [[self transitionsBetween:topLeft to:c1] transitions]) + abs(dimensionRight - [[self transitionsBetween:bottomRight to:c1] transitions]);
  int l2 = abs(dimensionTop - [[self transitionsBetween:topLeft to:c2] transitions]) + abs(dimensionRight - [[self transitionsBetween:bottomRight to:c2] transitions]);

  if (l1 <= l2) {
    return c1;
  }

  return c2;
}

/**
 * Calculates the position of the white top right module using the output of the rectangle detector
 * for a square matrix
 */
- (LBZXResultPoint *)correctTopRight:(LBZXResultPoint *)bottomLeft bottomRight:(LBZXResultPoint *)bottomRight
                           topLeft:(LBZXResultPoint *)topLeft topRight:(LBZXResultPoint *)topRight dimension:(int)dimension {
  float corr = [self distance:bottomLeft b:bottomRight] / (float)dimension;
  int norm = [self distance:topLeft b:topRight];
  float cos = ([topRight x] - [topLeft x]) / norm;
  float sin = ([topRight y] - [topLeft y]) / norm;

  LBZXResultPoint *c1 = [[LBZXResultPoint alloc] initWithX:[topRight x] + corr * cos y:[topRight y] + corr * sin];

  corr = [self distance:bottomLeft b:topLeft] / (float)dimension;
  norm = [self distance:bottomRight b:topRight];
  cos = ([topRight x] - [bottomRight x]) / norm;
  sin = ([topRight y] - [bottomRight y]) / norm;

  LBZXResultPoint *c2 = [[LBZXResultPoint alloc] initWithX:[topRight x] + corr * cos y:[topRight y] + corr * sin];

  if (![self isValid:c1]) {
    if ([self isValid:c2]) {
      return c2;
    }
    return nil;
  } else if (![self isValid:c2]) {
    return c1;
  }

  int l1 = abs([[self transitionsBetween:topLeft to:c1] transitions] - [[self transitionsBetween:bottomRight to:c1] transitions]);
  int l2 = abs([[self transitionsBetween:topLeft to:c2] transitions] - [[self transitionsBetween:bottomRight to:c2] transitions]);

  return l1 <= l2 ? c1 : c2;
}

- (BOOL) isValid:(LBZXResultPoint *)p {
  return [p x] >= 0 && [p x] < self.image.width && [p y] > 0 && [p y] < self.image.height;
}

- (int)distance:(LBZXResultPoint *)a b:(LBZXResultPoint *)b {
  return [LBZXMathUtils round:[LBZXResultPoint distance:a pattern2:b]];
}

/**
 * Increments the Integer associated with a key by one.
 */
- (void)increment:(NSMutableDictionary *)table key:(LBZXResultPoint *)key {
  NSNumber *value = table[key];
  table[key] = value == nil ? @1 : @([value intValue] + 1);
}

- (LBZXBitMatrix *)sampleGrid:(LBZXBitMatrix *)image
                    topLeft:(LBZXResultPoint *)topLeft
                 bottomLeft:(LBZXResultPoint *)bottomLeft
                bottomRight:(LBZXResultPoint *)bottomRight
                   topRight:(LBZXResultPoint *)topRight
                 dimensionX:(int)dimensionX
                 dimensionY:(int)dimensionY
                      error:(NSError **)error {
  LBZXGridSampler *sampler = [LBZXGridSampler instance];
  return [sampler sampleGrid:image
                  dimensionX:dimensionX dimensionY:dimensionY
                       p1ToX:0.5f p1ToY:0.5f
                       p2ToX:dimensionX - 0.5f p2ToY:0.5f
                       p3ToX:dimensionX - 0.5f p3ToY:dimensionY - 0.5f
                       p4ToX:0.5f p4ToY:dimensionY - 0.5f
                     p1FromX:[topLeft x] p1FromY:[topLeft y]
                     p2FromX:[topRight x] p2FromY:[topRight y]
                     p3FromX:[bottomRight x] p3FromY:[bottomRight y]
                     p4FromX:[bottomLeft x] p4FromY:[bottomLeft y]
                       error:error];
}

/**
 * Counts the number of black/white transitions between two points, using something like Bresenham's algorithm.
 */
- (LBZXResultPointsAndTransitions *)transitionsBetween:(LBZXResultPoint *)from to:(LBZXResultPoint *)to {
  int fromX = (int)[from x];
  int fromY = (int)[from y];
  int toX = (int)[to x];
  int toY = (int)[to y];
  BOOL steep = abs(toY - fromY) > abs(toX - fromX);
  if (steep) {
    int temp = fromX;
    fromX = fromY;
    fromY = temp;
    temp = toX;
    toX = toY;
    toY = temp;
  }

  int dx = abs(toX - fromX);
  int dy = abs(toY - fromY);
  int error = -dx >> 1;
  int ystep = fromY < toY ? 1 : -1;
  int xstep = fromX < toX ? 1 : -1;
  int transitions = 0;
  BOOL inBlack = [self.image getX:steep ? fromY : fromX y:steep ? fromX : fromY];
  for (int x = fromX, y = fromY; x != toX; x += xstep) {
    BOOL isBlack = [self.image getX:steep ? y : x y:steep ? x : y];
    if (isBlack != inBlack) {
      transitions++;
      inBlack = isBlack;
    }
    error += dy;
    if (error > 0) {
      if (y == toY) {
        break;
      }
      y += ystep;
      error -= dx;
    }
  }
  return [[LBZXResultPointsAndTransitions alloc] initWithFrom:from to:to transitions:transitions];
}

@end
