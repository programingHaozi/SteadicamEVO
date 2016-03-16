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

#import "LBZXBitMatrix.h"
#import "LBZXPDF417BoundingBox.h"
#import "LBZXResultPoint.h"

@interface LBZXPDF417BoundingBox ()

@property (nonatomic, strong, readonly) LBZXBitMatrix *image;
@property (nonatomic, assign) int minX;
@property (nonatomic, assign) int maxX;
@property (nonatomic, assign) int minY;
@property (nonatomic, assign) int maxY;

@end

@implementation LBZXPDF417BoundingBox

- (id)initWithImage:(LBZXBitMatrix *)image topLeft:(LBZXResultPoint *)topLeft bottomLeft:(LBZXResultPoint *)bottomLeft
           topRight:(LBZXResultPoint *)topRight bottomRight:(LBZXResultPoint *)bottomRight {
  if ((!topLeft && !topRight) || (!bottomLeft && !bottomRight) ||
      (topLeft && !bottomLeft) || (topRight && !bottomRight)) {
    return nil;
  }

  self = [super init];
  if (self) {
    _image = image;
    _topLeft = topLeft;
    _bottomLeft = bottomLeft;
    _topRight = topRight;
    _bottomRight = bottomRight;
    [self calculateMinMaxValues];
  }

  return self;
}

- (id)initWithBoundingBox:(LBZXPDF417BoundingBox *)boundingBox {
  return [self initWithImage:boundingBox.image topLeft:boundingBox.topLeft bottomLeft:boundingBox.bottomLeft
                    topRight:boundingBox.topRight bottomRight:boundingBox.bottomRight];
}

+ (LBZXPDF417BoundingBox *)mergeLeftBox:(LBZXPDF417BoundingBox *)leftBox rightBox:(LBZXPDF417BoundingBox *)rightBox {
  if (!leftBox) {
    return rightBox;
  }
  if (!rightBox) {
    return leftBox;
  }
  return [[self alloc] initWithImage:leftBox.image topLeft:leftBox.topLeft bottomLeft:leftBox.bottomLeft
                            topRight:rightBox.topRight bottomRight:rightBox.bottomRight];
}

- (LBZXPDF417BoundingBox *)addMissingRows:(int)missingStartRows missingEndRows:(int)missingEndRows isLeft:(BOOL)isLeft {
  LBZXResultPoint *newTopLeft = self.topLeft;
  LBZXResultPoint *newBottomLeft = self.bottomLeft;
  LBZXResultPoint *newTopRight = self.topRight;
  LBZXResultPoint *newBottomRight = self.bottomRight;

  if (missingStartRows > 0) {
    LBZXResultPoint *top = isLeft ? self.topLeft : self.topRight;
    int newMinY = (int) top.y - missingStartRows;
    if (newMinY < 0) {
      newMinY = 0;
    }
    // TODO use existing points to better interpolate the new x positions
    LBZXResultPoint *newTop = [[LBZXResultPoint alloc] initWithX:top.x y:newMinY];
    if (isLeft) {
      newTopLeft = newTop;
    } else {
      newTopRight = newTop;
    }
  }

  if (missingEndRows > 0) {
    LBZXResultPoint *bottom = isLeft ? self.bottomLeft : self.bottomRight;
    int newMaxY = (int) bottom.y + missingEndRows;
    if (newMaxY >= self.image.height) {
      newMaxY = self.image.height - 1;
    }
    // TODO use existing points to better interpolate the new x positions
    LBZXResultPoint *newBottom = [[LBZXResultPoint alloc] initWithX:bottom.x y:newMaxY];
    if (isLeft) {
      newBottomLeft = newBottom;
    } else {
      newBottomRight = newBottom;
    }
  }
  [self calculateMinMaxValues];
  return [[LBZXPDF417BoundingBox alloc] initWithImage:self.image topLeft:newTopLeft bottomLeft:newBottomLeft topRight:newTopRight bottomRight:newBottomRight];
}

- (void)calculateMinMaxValues {
  if (!self.topLeft) {
    _topLeft = [[LBZXResultPoint alloc] initWithX:0 y:self.topRight.y];
    _bottomLeft = [[LBZXResultPoint alloc] initWithX:0 y:self.bottomRight.y];
  } else if (!self.topRight) {
    _topRight = [[LBZXResultPoint alloc] initWithX:self.image.width - 1 y:self.topLeft.y];
    _bottomRight = [[LBZXResultPoint alloc] initWithX:self.image.width - 1 y:self.bottomLeft.y];
  }

  self.minX = (int) MIN(self.topLeft.x, self.bottomLeft.x);
  self.maxX = (int) MAX(self.topRight.x, self.bottomRight.x);
  self.minY = (int) MIN(self.topLeft.y, self.topRight.y);
  self.maxY = (int) MAX(self.bottomLeft.y, self.bottomRight.y);
}

/*
- (void)setTopRight:(LBZXResultPoint *)topRight {
  _topRight = topRight;
  [self calculateMinMaxValues];
}

- (void)setBottomRight:(LBZXResultPoint *)bottomRight {
  _bottomRight = bottomRight;
  [self calculateMinMaxValues];
}
*/

@end
