//
//  TFViewModel.m
//  TFUILib
//
//  Created by xiayiyong on 16/1/5.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFViewModel.h"
#import "TFBaseLib.h"

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

-(NSArray *)dataArray
{
    if(_dataArray==nil)
    {
        NSString *className=NSStringFromClass([self class]);
        NSString *fileName=[NSString stringWithFormat:@"%@.json",className];
        NSDictionary *data = [NSString jsonDataFromFileName:fileName];
        _dataArray=[TFTableSectionModel mj_objectArrayWithKeyValuesArray:data];
    }
    return _dataArray;
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
