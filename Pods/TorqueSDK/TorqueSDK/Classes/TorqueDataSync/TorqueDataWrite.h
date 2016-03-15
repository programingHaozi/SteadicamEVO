#import <Foundation/Foundation.h>

#import "TorqueEquipment.h"

@interface TorqueDataWrite : TorqueEquipment

/**
 *  写入行程数据
 */

- (void)writeTripInfosWithCount:(NSUInteger)count complete:(void(^)(NSError *error))completion;

@end
