//
//  LanguageViewController.m
//  SteadicamEVO
//
//  Created by Chen Hao 陈浩 on 16/3/30.
//  Copyright © 2016年 haozi. All rights reserved.
//

#import "LanguageViewController.h"
#import "LanguageViewCell.h"

@interface LanguageViewController ()

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end

@implementation LanguageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
}

- (void)initViews
{
    [super initViews];
}

-(void)autolayoutViews
{
    [super autolayoutViews];
}

-(void)bindData
{
    [super bindData];
}

#pragma mark - delegate -

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LanguageViewCell *cell = (LanguageViewCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    cell.selectLanguage = self.selectedIndexPath == indexPath;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexPath = indexPath;
    
    [self.tableView reloadData];
}

@end
