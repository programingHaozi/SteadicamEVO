//
//  TFMacro+Log.h
//  Treasure
//
//  Created by xiayiyong on 15/9/14.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

//调试模式下输入NSLog，发布后不再输入。

#ifndef __OPTIMIZE__

//#define NSLog(fmt, ...) NSLog((@"[文件名:%s]\n" "[函数名:%s]\n" "[行号:%d] \n" fmt"\n\n"), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__)

#else

//#define NSLog(...) {}

#endif

