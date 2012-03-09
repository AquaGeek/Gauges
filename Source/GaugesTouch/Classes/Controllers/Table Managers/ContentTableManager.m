//
//  ContentTableManager.m
//  GaugesTouch
//
//  Created by Tyler Stromberg on 3/9/12.
//  Copyright (c) 2012 Tyler Stromberg. All rights reserved.
//

#import "ContentTableManager.h"

#import "Gauge.h"
#import "PageContent.h"
#import "PageContentCell.h"

@implementation ContentTableManager

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.title = NSLocalizedString(@"Top Content", nil);
}


#pragma mark - UITableView Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.gauge.topContent.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ContentHeaderCellIdentifier = @"ContentHeaderCell";
    static NSString *CellIdentifier = @"ContentCell";
    
    NSString *identifier = (indexPath.row == 0) ? ContentHeaderCellIdentifier : CellIdentifier;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    // Configure the cell
    if (indexPath.row > 0)
    {
        PageContent *content = [self.gauge.topContent objectAtIndex:indexPath.row - 1];
        ((PageContentCell *)cell).pageContent = content;
    }
    
    return cell;
}

#pragma mark Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.row == 0) ? 24.0f : 38.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = (indexPath.row % 2 == 1) ? [UIColor colorWithWhite:0.5f alpha:0.1f] : [UIColor clearColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Open the selected URL
}

@end
