//
//  TFViewModel.m
//  TFUILib
//
//  Created by xiayiyong on 16/1/5.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFViewModel.h"

#define TWO_DIMISION 2  //二维数组
#define ONE_DIMISION 1  //一维数组

@implementation TFViewModel

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.title=@"";
    }
    
    return self;
}

-(NSInteger)numberOfSections
{
    return self.dataArray.count;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    id obj=self.dataArray[section];
    if ([obj isKindOfClass:[TFTableSectionModel class]])
    {
        return ((TFTableSectionModel*)obj).dataArray.count;
    }
    else
    {
        return 0;
    }
}

- (TFModel*)dataAtIndexPath:(NSIndexPath *)indexPath
{
    id obj=self.dataArray[indexPath.section];
    if ([obj isKindOfClass:[TFTableSectionModel class]])
    {
        return ((TFTableSectionModel*)obj).dataArray[indexPath.row];
    }
    else
    {
        return nil;
    }
}

- (NSString*)titleAtSection:(NSInteger)section
{
    id obj=self.dataArray[section];
    if ([obj isKindOfClass:[TFTableSectionModel class]])
    {
        return ((TFTableSectionModel*)obj).title;
    }
    else
    {
        return nil;
    }
}


@end
