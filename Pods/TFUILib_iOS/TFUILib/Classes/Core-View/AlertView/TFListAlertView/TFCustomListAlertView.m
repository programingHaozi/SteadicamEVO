//
//  TFCustomListAlertView.m
//  Orange
//
//  Created by Chen Yiliang on 3/30/15.
//  Copyright (c) 2015 Chexiang. All rights reserved.
//

#import "TFCustomListAlertView.h"
#import <TFBaseLib.h>

@implementation TFCustomListAlertView

- (instancetype)initWithTitle:(NSString *)title
                    dataArray:(NSArray *)dataArray
                     delegate:(id)delegate
{
    return [self initWithTitle:title
                     dataArray:dataArray
                      delegate:delegate
                 selectedIndex:NSNotFound];
}

- (instancetype)initWithTitle:(NSString *)title
                    dataArray:(NSArray *)dataArray
                     delegate:(id)delegate
                selectedIndex:(NSUInteger)selectedIndex
{
    TFCustomListAlertContentView *contentView = [TFCustomListAlertContentView contentViewWithTitle:title dataArray:dataArray dataSource:delegate selectedIndex:selectedIndex];
    
    self = [super initWithContentView:contentView
                             position: TFCustomAlertViewPositionMiddle];
    
    if (self != nil)
    {
        self.delegate = delegate;
        self.showCloseButton = NO;
        
        contentView.tableView.delegate = self;
        [contentView.closeButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (void)setAllowsSelection:(BOOL)allowsSelection
{
    TFCustomListAlertContentView *contentView = (TFCustomListAlertContentView *)self.contentView;
    
    contentView.tableView.allowsSelection = allowsSelection;
}

- (BOOL)allowsSelection
{
    TFCustomListAlertContentView *contentView = (TFCustomListAlertContentView *)self.contentView;
    
    return contentView.tableView.allowsSelection;
}

- (void)setShowCloseButton:(BOOL)showCloseButton
{
    TFCustomListAlertContentView *contentView = (TFCustomListAlertContentView *)self.contentView;
    
    contentView.buttonContainerView.hidden = !showCloseButton;
}

- (BOOL)showCloseButton
{
    TFCustomListAlertContentView *contentView = (TFCustomListAlertContentView *)self.contentView;
    
    return contentView.buttonContainerView.hidden == NO;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_delegate respondsToSelector:@selector(listAlertView:didSelectedItem:atIndex:)])
    {
        id<TFCustomListAlertViewProtocol> item = ((TFCustomListAlertContentView *)self.contentView).dataArray[indexPath.row];
        
        [_delegate listAlertView:self didSelectedItem:item atIndex:indexPath.row];
    }

    TFCustomListAlertContentView *contentView = (TFCustomListAlertContentView *)self.contentView;
    
    contentView.selectedIndex = indexPath.row;
    
    [self hide];
}

@end

@implementation TFCustomListAlertContentView

+ (instancetype)contentViewWithTitle:(NSString *)title
                           dataArray:(NSArray *)dataArray
                          dataSource:(id)dataSource
                       selectedIndex:(NSUInteger)selectedIndex
{
    TFCustomListAlertContentView *contentView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([TFCustomListAlertView class]) owner:nil options:nil][0];
    
    contentView.titleLabel.text     = title;
    contentView.dataArray           = dataArray;
    contentView.dataSource          = dataSource;
    contentView.selectedIndex       = selectedIndex;
    contentView.tableView.rowHeight = 44.0;
    
    if (dataArray.count * contentView.tableView.rowHeight < contentView.tableView.frame.size.height)
    {
        CGRect frame = contentView.frame;
        
        frame.size.height -= contentView.tableView.frame.size.height - (dataArray.count * contentView.tableView.rowHeight);
        
        contentView.frame = frame;
    }
    
    [contentView.tableView reloadData];
    
    if (selectedIndex < dataArray.count)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
        
        [contentView.tableView selectRowAtIndexPath:indexPath
                                           animated:NO
                                     scrollPosition:UITableViewScrollPositionMiddle];
    }
    
    return contentView;
}

- (void)awakeFromNib
{
    self.cornerRadius = 5.0;
    
    CGRect frame             = self.seperatorView.frame;
    frame.size.height        = frame.size.height / [UIScreen mainScreen].scale;
    frame.origin.y           += self.seperatorView.frame.size.height - frame.size.height;
    self.seperatorView.frame = frame;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if ([_dataSource respondsToSelector:@selector(listAlertTableView:cellAtIndexPath:)])
    {
        cell = [_dataSource listAlertTableView:tableView cellAtIndexPath:indexPath];
    }
    else
    {
        static NSString *cellIdentifier = @"TFCustomListAlertCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            
            cell.textLabel.font = FONT(16);
            cell.textLabel.textColor = [UIColor colorWithRed:73.0/255 green:73.0/255 blue:73.0/255 alpha:1.0];
            
            CGFloat height = 1.0 / [UIScreen mainScreen].scale;
            
            TFView *seperatorView = [[TFView alloc] initWithFrame:CGRectMake(0.0, cell.frame.size.height - height, cell.frame.size.width, height)];
            seperatorView.backgroundColor = [UIColor colorWithRed:200.0/255 green:198.0/255 blue:204.0/255 alpha:1.0];
            seperatorView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            [cell addSubview:seperatorView];
        }
        
        id<TFCustomListAlertViewProtocol> item = _dataArray[indexPath.row];
        cell.textLabel.text = item.cellText;
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
    }
    
    return cell;
}

@end
