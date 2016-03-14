//
//  TFMacro+Path.h
//  Treasure
//
//  Created by xiayiyong on 15/9/14.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

/**
 *  沙盒home地址
 */
#define APP_HOME_PATH        NSHomeDirectory()

/**
 *  沙盒CACH地址
 */
#define APP_CACHE_PATH      [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"]

/**
 *  沙盒DOCUMENT地址
 */
#define APP_DOCUMENT_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
/**
 *  沙盒DOCUMENT地址
 */
#define APP_DOCUMENT_PATH2 [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
/**
 *  沙盒LIBRARY地址
 */
#define APP_LIBRARY_PATH [NSHomeDirectory() stringByAppendingPathComponent:@"Library"]

/**
 *  沙盒TMP地址
 */
#define APP_TMP_PATH    NSTemporaryDirectory()

/**
 *  main bundle地址
 */
#define APP_MAIN_BUNDLE [[NSBundle mainBundle] bundlePath]

/**
 *  main bundle resource地址
 */
#define APP_MAIN_BUNDLE_RESOURCE  [[NSBundle mainBundle] resourcePath]

/**
 *  main bundle executable地址
 */
#define APP_MAIN_BUNDLE_EXECUTABLE [[NSBundle mainBundle] executablePath]

