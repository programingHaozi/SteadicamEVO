
#import "TorqueDataWrite.h"

#import "OBDDevice.h"
#import "OBDDevice+Trip.h"

static TorqueDataWrite *instance = nil;
@implementation TorqueDataWrite

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [TorqueDataWrite new];
        
        [instance obdDevice];
    });
    return instance;
}

/**
 *  写入行程数据
 */

- (void)writeTripInfosWithCount:(NSUInteger)count complete:(void(^)(NSError *error))completion
{
    [[OBDDevice sharedInstance] writeHistoryTripRecordWithCount:count completion:^(NSError *error){
        if (error) {
            return ;
        }
        DDLogInfo(@"Has write History Trip Record!");
        completion(nil);
    }];
}

@end

