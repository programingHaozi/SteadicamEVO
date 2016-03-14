//
//  TFMacro+GCD.h
//  Treasure
//
//  Created by xiayiyong on 15/9/14.
//  Copyright (c) 2015年 上海赛可电子商务有限公司. All rights reserved.
//

/**
 *  获取主线程
 */
#define MAIN_THREAD(block) dispatch_async(dispatch_get_main_queue(),block)

/**
 *  异步线程
 */
#define BACK_THREAD(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)

