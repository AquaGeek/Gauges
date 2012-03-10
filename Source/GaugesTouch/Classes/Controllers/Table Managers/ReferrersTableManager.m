//
//  ReferrersTableManager.m
//  GaugesTouch
//
//  Created by Tyler Stromberg on 3/9/12.
//  Copyright (c) 2012 Tyler Stromberg. All rights reserved.
//

#import "ReferrersTableManager.h"

#import "Gauge.h"
#import "Referrer.h"
#import "ReferrerCell.h"

@implementation ReferrersTableManager

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.title = NSLocalizedString(@"Top Referrers", nil);
}


#pragma mark - UITableView Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.gauge.referrers.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ReferrerHeaderCellIdentifier = @"ReferrerHeaderCell";
    static NSString *CellIdentifier = @"ReferrerCell";
    
    NSString *identifier = (indexPath.row == 0) ? ReferrerHeaderCellIdentifier : CellIdentifier;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    // Configure the cell
    if (indexPath.row > 0)
    {
        Referrer *referrer = [self.gauge.referrers objectAtIndex:indexPath.row - 1];
        ((ReferrerCell *)cell).referrer = referrer;
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

@end
