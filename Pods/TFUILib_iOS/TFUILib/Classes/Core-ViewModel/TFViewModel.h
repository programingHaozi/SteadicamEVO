//
//  TFViewModel.h
//  TFUILib
//
//  Created by xiayiyong on 16/1/5.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "TFTableSectionModel.h"
#import "TFModel.h"

#pragma mark -
#pragma mark - TFModel
@protocol TFViewModel <NSObject>
@end

@interface TFViewModel : NSObject

/**
 *  导航栏标题
 */
@property (nonatomic,strong) NSString *title;

/**
 *  
 */
@property (nonatomic,strong) NSArray *dataArray;


/**
 *  获取indexPath所在行数据
 *
 *  @param indexPath
 *
 *  @return
 */
- (TFModel*)dataAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  获取section段title
 *
 *  @param section
 *
 *  @return
 */
- (NSString*)titleAtSection:(NSInteger)section;

/**
 *  有多少行
 *
 *  @return
 */
-(NSInteger)numberOfSections;

/**
 *  所在行有多少列
 *
 *  @param section
 *
 *  @return
 */
- (NSInteger)numberOfRowsInSection:(NSInteger)section;

@end
