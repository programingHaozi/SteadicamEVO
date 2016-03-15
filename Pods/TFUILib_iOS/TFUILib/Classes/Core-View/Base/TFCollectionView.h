//
//  TFCollectionView.h
//  TFUILib
//
//  Created by xiayiyong on 16/1/12.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TFCollectionView : UICollectionView

/**
 *  注册cell
 *
 *  @param cellClass
 */
-(void)registerCell:(Class)cellClass;

/**
 *  注册headview
 *
 *  @param viewClass
 */
-(void)registerHeaderClass:(Class)viewClass;

/**
 *  注册footview
 *
 *  @param cellClass
 */
-(void)registerFooterClass:(Class)cellClass;

@end
