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

#import "LBZXResult.h"

@interface LBZXResult ()

@property (nonatomic, strong) NSMutableDictionary *resultMetadata;
@property (nonatomic, strong) NSMutableArray *resultPoints;

@end

@implementation LBZXResult

- (id)initWithText:(NSString *)text rawBytes:(LBZXByteArray *)rawBytes resultPoints:(NSArray *)resultPoints format:(LBZXBarcodeFormat)format {
  return [self initWithText:text rawBytes:rawBytes resultPoints:resultPoints format:format timestamp:CFAbsoluteTimeGetCurrent()];
}

- (id)initWithText:(NSString *)text rawBytes:(LBZXByteArray *)rawBytes resultPoints:(NSArray *)resultPoints format:(LBZXBarcodeFormat)format timestamp:(long)timestamp {
  if (self = [super init]) {
    _text = text;
    _rawBytes = rawBytes;
    _resultPoints = [resultPoints mutableCopy];
    _barcodeFormat = format;
    _resultMetadata = nil;
    _timestamp = timestamp;
  }

  return self;
}

+ (id)resultWithText:(NSString *)text rawBytes:(LBZXByteArray *)rawBytes resultPoints:(NSArray *)resultPoints format:(LBZXBarcodeFormat)format {
  return [[self alloc] initWithText:text rawBytes:rawBytes resultPoints:resultPoints format:format];
}

+ (id)resultWithText:(NSString *)text rawBytes:(LBZXByteArray *)rawBytes resultPoints:(NSArray *)resultPoints format:(LBZXBarcodeFormat)format timestamp:(long)timestamp {
  return [[self alloc] initWithText:text rawBytes:rawBytes resultPoints:resultPoints format:format timestamp:timestamp];
}

- (void)putMetadata:(LBZXResultMetadataType)type value:(id)value {
  if (self.resultMetadata == nil) {
    self.resultMetadata = [NSMutableDictionary dictionary];
  }
  self.resultMetadata[@(type)] = value;
}

- (void)putAllMetadata:(NSMutableDictionary *)metadata {
  if (metadata != nil) {
    if (self.resultMetadata == nil) {
      self.resultMetadata = metadata;
    } else {
      [self.resultMetadata addEntriesFromDictionary:metadata];
    }
  }
}

- (void)addResultPoints:(NSArray *)newPoints {
  if (self.resultPoints == nil) {
    self.resultPoints = [newPoints mutableCopy];
  } else if (newPoints != nil && [newPoints count] > 0) {
    [self.resultPoints addObjectsFromArray:newPoints];
  }
}

- (NSString *)description {
  return self.text;
}

@end
