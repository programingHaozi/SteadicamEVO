//
//  OBDDeviceFuncMacro.h
//  TorqueSDK
//
//  Created by zhangjipeng on 2/9/15.
//  Copyright (c) 2015 saike. All rights reserved.
//

#ifndef TorqueSDK_OBDDeviceFuncMacro_h
#define TorqueSDK_OBDDeviceFuncMacro_h

#define FetchDataStreamForType(type,class,param) do { \
                                                     [self.dataProcessor fetchDataStreamForType:type AndParam:param completion:^(OBDDataStream *stream, NSError *error) { \
                                                         if (completion) { \
                                                             completion([[class alloc] initWithDataStream:stream],error); \
                                                         } \
                                                     }]; \
                                                 } while(0)

#define CloseDataStreamForType(type) do { \
                                         [self.dataProcessor closeDataStreamForType:type]; \
                                     } while(0)

#endif
