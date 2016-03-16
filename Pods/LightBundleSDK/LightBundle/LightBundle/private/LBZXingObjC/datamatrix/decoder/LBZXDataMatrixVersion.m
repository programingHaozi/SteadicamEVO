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

#import "LBZXDataMatrixVersion.h"

@implementation LBZXDataMatrixECBlocks

- (id)initWithCodewords:(int)ecCodewords ecBlocks:(LBZXDataMatrixECB *)ecBlocks {
  if (self = [super init]) {
    _ecCodewords = ecCodewords;
    _ecBlocks = @[ecBlocks];
  }

  return self;
}

- (id)initWithCodewords:(int)ecCodewords ecBlocks1:(LBZXDataMatrixECB *)ecBlocks1 ecBlocks2:(LBZXDataMatrixECB *)ecBlocks2 {
  if (self = [super init]) {
    _ecCodewords = ecCodewords;
    _ecBlocks = @[ecBlocks1, ecBlocks2];
  }

  return self;
}

@end


@implementation LBZXDataMatrixECB

- (id)initWithCount:(int)count dataCodewords:(int)dataCodewords {
  if (self = [super init]) {
    _count = count;
    _dataCodewords = dataCodewords;
  }

  return self;
}

@end


static NSArray *VERSIONS = nil;

@implementation LBZXDataMatrixVersion

- (id)initWithVersionNumber:(int)versionNumber symbolSizeRows:(int)symbolSizeRows symbolSizeColumns:(int)symbolSizeColumns
         dataRegionSizeRows:(int)dataRegionSizeRows dataRegionSizeColumns:(int)dataRegionSizeColumns ecBlocks:(LBZXDataMatrixECBlocks *)ecBlocks {
  if (self = [super init]) {
    _versionNumber = versionNumber;
    _symbolSizeRows = symbolSizeRows;
    _symbolSizeColumns = symbolSizeColumns;
    _dataRegionSizeRows = dataRegionSizeRows;
    _dataRegionSizeColumns = dataRegionSizeColumns;
    _ecBlocks = ecBlocks;

    int total = 0;
    int ecCodewords = ecBlocks.ecCodewords;
    NSArray *ecbArray = ecBlocks.ecBlocks;
    for (LBZXDataMatrixECB *ecBlock in ecbArray) {
      total += ecBlock.count * (ecBlock.dataCodewords + ecCodewords);
    }
    _totalCodewords = total;
  }

  return self;
}

+ (LBZXDataMatrixVersion *)versionForDimensions:(int)numRows numColumns:(int)numColumns {
  if ((numRows & 0x01) != 0 || (numColumns & 0x01) != 0) {
    return nil;
  }

  for (LBZXDataMatrixVersion *version in VERSIONS) {
    if (version.symbolSizeRows == numRows && version.symbolSizeColumns == numColumns) {
      return version;
    }
  }

  return nil;
}

- (NSString *)description {
  return [@(self.versionNumber) stringValue];
}

/**
 * See ISO 16022:2006 5.5.1 Table 7
 */
+ (void)initialize {
  VERSIONS = @[[[LBZXDataMatrixVersion alloc] initWithVersionNumber:1
                                                   symbolSizeRows:10
                                                symbolSizeColumns:10
                                               dataRegionSizeRows:8
                                            dataRegionSizeColumns:8
                                                         ecBlocks:[[LBZXDataMatrixECBlocks alloc] initWithCodewords:5
                                                                                                         ecBlocks:[[LBZXDataMatrixECB alloc] initWithCount:1 dataCodewords:3]]],

               [[LBZXDataMatrixVersion alloc] initWithVersionNumber:2
                                                   symbolSizeRows:12
                                                symbolSizeColumns:12
                                               dataRegionSizeRows:10
                                            dataRegionSizeColumns:10
                                                         ecBlocks:[[LBZXDataMatrixECBlocks alloc] initWithCodewords:7
                                                                                                         ecBlocks:[[LBZXDataMatrixECB alloc] initWithCount:1 dataCodewords:5]]],

               [[LBZXDataMatrixVersion alloc] initWithVersionNumber:3
                                                   symbolSizeRows:14
                                                symbolSizeColumns:14
                                               dataRegionSizeRows:12
                                            dataRegionSizeColumns:12
                                                         ecBlocks:[[LBZXDataMatrixECBlocks alloc] initWithCodewords:10
                                                                                                         ecBlocks:[[LBZXDataMatrixECB alloc] initWithCount:1 dataCodewords:8]]],

               [[LBZXDataMatrixVersion alloc] initWithVersionNumber:4
                                                   symbolSizeRows:16
                                                symbolSizeColumns:16
                                               dataRegionSizeRows:14
                                            dataRegionSizeColumns:14
                                                         ecBlocks:[[LBZXDataMatrixECBlocks alloc] initWithCodewords:12
                                                                                                         ecBlocks:[[LBZXDataMatrixECB alloc] initWithCount:1 dataCodewords:12]]],

               [[LBZXDataMatrixVersion alloc] initWithVersionNumber:5
                                                   symbolSizeRows:18
                                                symbolSizeColumns:18
                                               dataRegionSizeRows:16
                                            dataRegionSizeColumns:16
                                                         ecBlocks:[[LBZXDataMatrixECBlocks alloc] initWithCodewords:14
                                                                                                         ecBlocks:[[LBZXDataMatrixECB alloc] initWithCount:1 dataCodewords:18]]],

               [[LBZXDataMatrixVersion alloc] initWithVersionNumber:6
                                                   symbolSizeRows:20
                                                symbolSizeColumns:20
                                               dataRegionSizeRows:18
                                            dataRegionSizeColumns:18
                                                         ecBlocks:[[LBZXDataMatrixECBlocks alloc] initWithCodewords:18
                                                                                                         ecBlocks:[[LBZXDataMatrixECB alloc] initWithCount:1 dataCodewords:22]]],

               [[LBZXDataMatrixVersion alloc] initWithVersionNumber:7
                                                   symbolSizeRows:22
                                                symbolSizeColumns:22
                                               dataRegionSizeRows:20
                                            dataRegionSizeColumns:20
                                                         ecBlocks:[[LBZXDataMatrixECBlocks alloc] initWithCodewords:20
                                                                                                         ecBlocks:[[LBZXDataMatrixECB alloc] initWithCount:1 dataCodewords:30]]],

               [[LBZXDataMatrixVersion alloc] initWithVersionNumber:8
                                                   symbolSizeRows:24
                                                symbolSizeColumns:24
                                               dataRegionSizeRows:22
                                            dataRegionSizeColumns:22
                                                         ecBlocks:[[LBZXDataMatrixECBlocks alloc] initWithCodewords:24
                                                                                                         ecBlocks:[[LBZXDataMatrixECB alloc] initWithCount:1 dataCodewords:36]]],

               [[LBZXDataMatrixVersion alloc] initWithVersionNumber:9
                                                   symbolSizeRows:26
                                                symbolSizeColumns:26
                                               dataRegionSizeRows:24
                                            dataRegionSizeColumns:24
                                                         ecBlocks:[[LBZXDataMatrixECBlocks alloc] initWithCodewords:28
                                                                                                         ecBlocks:[[LBZXDataMatrixECB alloc] initWithCount:1 dataCodewords:44]]],

               [[LBZXDataMatrixVersion alloc] initWithVersionNumber:10
                                                   symbolSizeRows:32
                                                symbolSizeColumns:32
                                               dataRegionSizeRows:14
                                            dataRegionSizeColumns:14
                                                         ecBlocks:[[LBZXDataMatrixECBlocks alloc] initWithCodewords:36
                                                                                                         ecBlocks:[[LBZXDataMatrixECB alloc] initWithCount:1 dataCodewords:62]]],

               [[LBZXDataMatrixVersion alloc] initWithVersionNumber:11
                                                   symbolSizeRows:36
                                                symbolSizeColumns:36
                                               dataRegionSizeRows:16
                                            dataRegionSizeColumns:16
                                                         ecBlocks:[[LBZXDataMatrixECBlocks alloc] initWithCodewords:42
                                                                                                         ecBlocks:[[LBZXDataMatrixECB alloc] initWithCount:1 dataCodewords:86]]],

               [[LBZXDataMatrixVersion alloc] initWithVersionNumber:12
                                                   symbolSizeRows:40
                                                symbolSizeColumns:40
                                               dataRegionSizeRows:18
                                            dataRegionSizeColumns:18
                                                         ecBlocks:[[LBZXDataMatrixECBlocks alloc] initWithCodewords:48
                                                                                                         ecBlocks:[[LBZXDataMatrixECB alloc] initWithCount:1 dataCodewords:114]]],

               [[LBZXDataMatrixVersion alloc] initWithVersionNumber:13
                                                   symbolSizeRows:44
                                                symbolSizeColumns:44
                                               dataRegionSizeRows:20
                                            dataRegionSizeColumns:20
                                                         ecBlocks:[[LBZXDataMatrixECBlocks alloc] initWithCodewords:56
                                                                                                         ecBlocks:[[LBZXDataMatrixECB alloc] initWithCount:1 dataCodewords:144]]],

               [[LBZXDataMatrixVersion alloc] initWithVersionNumber:14
                                                   symbolSizeRows:48
                                                symbolSizeColumns:48
                                               dataRegionSizeRows:22
                                            dataRegionSizeColumns:22
                                                         ecBlocks:[[LBZXDataMatrixECBlocks alloc] initWithCodewords:68
                                                                                                         ecBlocks:[[LBZXDataMatrixECB alloc] initWithCount:1 dataCodewords:174]]],

               [[LBZXDataMatrixVersion alloc] initWithVersionNumber:15
                                                   symbolSizeRows:52
                                                symbolSizeColumns:52
                                               dataRegionSizeRows:24
                                            dataRegionSizeColumns:24
                                                         ecBlocks:[[LBZXDataMatrixECBlocks alloc] initWithCodewords:42
                                                                                                         ecBlocks:[[LBZXDataMatrixECB alloc] initWithCount:2 dataCodewords:102]]],

               [[LBZXDataMatrixVersion alloc] initWithVersionNumber:16
                                                   symbolSizeRows:64
                                                symbolSizeColumns:64
                                               dataRegionSizeRows:14
                                            dataRegionSizeColumns:14
                                                         ecBlocks:[[LBZXDataMatrixECBlocks alloc] initWithCodewords:56
                                                                                                         ecBlocks:[[LBZXDataMatrixECB alloc] initWithCount:2 dataCodewords:140]]],

               [[LBZXDataMatrixVersion alloc] initWithVersionNumber:17
                                                   symbolSizeRows:72
                                                symbolSizeColumns:72
                                               dataRegionSizeRows:16
                                            dataRegionSizeColumns:16
                                                         ecBlocks:[[LBZXDataMatrixECBlocks alloc] initWithCodewords:36
                                                                                                         ecBlocks:[[LBZXDataMatrixECB alloc] initWithCount:4 dataCodewords:92]]],

               [[LBZXDataMatrixVersion alloc] initWithVersionNumber:18
                                                   symbolSizeRows:80
                                                symbolSizeColumns:80
                                               dataRegionSizeRows:18
                                            dataRegionSizeColumns:18
                                                         ecBlocks:[[LBZXDataMatrixECBlocks alloc] initWithCodewords:48
                                                                                                         ecBlocks:[[LBZXDataMatrixECB alloc] initWithCount:4 dataCodewords:114]]],

               [[LBZXDataMatrixVersion alloc] initWithVersionNumber:19
                                                   symbolSizeRows:88
                                                symbolSizeColumns:88
                                               dataRegionSizeRows:20
                                            dataRegionSizeColumns:20
                                                         ecBlocks:[[LBZXDataMatrixECBlocks alloc] initWithCodewords:56
                                                                                                         ecBlocks:[[LBZXDataMatrixECB alloc] initWithCount:4 dataCodewords:144]]],

               [[LBZXDataMatrixVersion alloc] initWithVersionNumber:20
                                                   symbolSizeRows:96
                                                symbolSizeColumns:96
                                               dataRegionSizeRows:22
                                            dataRegionSizeColumns:22
                                                         ecBlocks:[[LBZXDataMatrixECBlocks alloc] initWithCodewords:68
                                                                                                         ecBlocks:[[LBZXDataMatrixECB alloc] initWithCount:4 dataCodewords:174]]],

               [[LBZXDataMatrixVersion alloc] initWithVersionNumber:21
                                                   symbolSizeRows:104
                                                symbolSizeColumns:104
                                               dataRegionSizeRows:24
                                            dataRegionSizeColumns:24
                                                         ecBlocks:[[LBZXDataMatrixECBlocks alloc] initWithCodewords:56
                                                                                                         ecBlocks:[[LBZXDataMatrixECB alloc] initWithCount:6 dataCodewords:136]]],

               [[LBZXDataMatrixVersion alloc] initWithVersionNumber:22
                                                   symbolSizeRows:120
                                                symbolSizeColumns:120
                                               dataRegionSizeRows:18
                                            dataRegionSizeColumns:18
                                                         ecBlocks:[[LBZXDataMatrixECBlocks alloc] initWithCodewords:68
                                                                                                         ecBlocks:[[LBZXDataMatrixECB alloc] initWithCount:6 dataCodewords:175]]],

               [[LBZXDataMatrixVersion alloc] initWithVersionNumber:23
                                                   symbolSizeRows:132
                                                symbolSizeColumns:132
                                               dataRegionSizeRows:20
                                            dataRegionSizeColumns:20
                                                         ecBlocks:[[LBZXDataMatrixECBlocks alloc] initWithCodewords:62
                                                                                                         ecBlocks:[[LBZXDataMatrixECB alloc] initWithCount:8 dataCodewords:163]]],

               [[LBZXDataMatrixVersion alloc] initWithVersionNumber:24
                                                   symbolSizeRows:144
                                                symbolSizeColumns:144
                                               dataRegionSizeRows:22
                                            dataRegionSizeColumns:22
                                                         ecBlocks:[[LBZXDataMatrixECBlocks alloc] initWithCodewords:62
                                                                                                        ecBlocks1:[[LBZXDataMatrixECB alloc] initWithCount:8 dataCodewords:156]
                                                                                                        ecBlocks2:[[LBZXDataMatrixECB alloc] initWithCount:2 dataCodewords:155]]],

               [[LBZXDataMatrixVersion alloc] initWithVersionNumber:25
                                                   symbolSizeRows:8
                                                symbolSizeColumns:18
                                               dataRegionSizeRows:6
                                            dataRegionSizeColumns:16
                                                         ecBlocks:[[LBZXDataMatrixECBlocks alloc] initWithCodewords:7
                                                                                                         ecBlocks:[[LBZXDataMatrixECB alloc] initWithCount:1 dataCodewords:5]]],

               [[LBZXDataMatrixVersion alloc] initWithVersionNumber:26
                                                   symbolSizeRows:8
                                                symbolSizeColumns:32
                                               dataRegionSizeRows:6
                                            dataRegionSizeColumns:14
                                                         ecBlocks:[[LBZXDataMatrixECBlocks alloc] initWithCodewords:11
                                                                                                         ecBlocks:[[LBZXDataMatrixECB alloc] initWithCount:1 dataCodewords:10]]],

               [[LBZXDataMatrixVersion alloc] initWithVersionNumber:27
                                                   symbolSizeRows:12
                                                symbolSizeColumns:26
                                               dataRegionSizeRows:10
                                            dataRegionSizeColumns:24
                                                         ecBlocks:[[LBZXDataMatrixECBlocks alloc] initWithCodewords:14
                                                                                                         ecBlocks:[[LBZXDataMatrixECB alloc] initWithCount:1 dataCodewords:16]]],

               [[LBZXDataMatrixVersion alloc] initWithVersionNumber:28
                                                   symbolSizeRows:12
                                                symbolSizeColumns:36
                                               dataRegionSizeRows:10
                                            dataRegionSizeColumns:16
                                                         ecBlocks:[[LBZXDataMatrixECBlocks alloc] initWithCodewords:18
                                                                                                         ecBlocks:[[LBZXDataMatrixECB alloc] initWithCount:1 dataCodewords:22]]],

               [[LBZXDataMatrixVersion alloc] initWithVersionNumber:29
                                                   symbolSizeRows:16
                                                symbolSizeColumns:36
                                               dataRegionSizeRows:14
                                            dataRegionSizeColumns:16
                                                         ecBlocks:[[LBZXDataMatrixECBlocks alloc] initWithCodewords:24
                                                                                                         ecBlocks:[[LBZXDataMatrixECB alloc] initWithCount:1 dataCodewords:32]]],

               [[LBZXDataMatrixVersion alloc] initWithVersionNumber:30
                                                   symbolSizeRows:16
                                                symbolSizeColumns:48
                                               dataRegionSizeRows:14
                                            dataRegionSizeColumns:22
                                                         ecBlocks:[[LBZXDataMatrixECBlocks alloc] initWithCodewords:28
                                                                                                         ecBlocks:[[LBZXDataMatrixECB alloc] initWithCount:1 dataCodewords:49]]]];
}

@end
