//
//  PidCommand.h
//  TorqueSDK
//
//  Created by sunxiaofei on 5/28/15.
//  Copyright (c) 2015 saike. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  PID命令模型对象
 */
@interface PidCommand : NSObject

/**
 *  PID
 */
@property (nonatomic, strong) NSString *pid;
/**
 *  具体的PID指令
 */
@property (nonatomic, strong) NSString *name;
/**
 *  相关描述
 */
@property (nonatomic, strong) NSString *descriptionContent;
/**
 *  相关解释或建议
 */
@property (nonatomic, strong) NSString *explain;


@end
/**
 *  PID模型对象
 */
@interface PidModel : NSObject

/**
 *  PID指令集合
 */
@property (nonatomic, strong) NSString *pid;
/**
 *  命令集合
 */
@property (nonatomic, strong) NSArray *commands;

@end
