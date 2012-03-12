//
//  TrafficTableManager.m
//  GaugesTouch
//
//  Created by Tyler Stromberg on 3/9/12.
//  Copyright (c) 2012 Tyler Stromberg. All rights reserved.
//

#import "TrafficTableManager.h"

#import "Gauge.h"
#import "TrafficBarGraph.h"
#import "TrafficCell.h"

@interface TrafficTableManager()

@property (nonatomic, weak) IBOutlet TrafficBarGraph *trafficBarGraph;

@end


#pragma mark -

@implementation TrafficTableManager

@synthesize trafficBarGraph = _trafficBarGraph;

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.title = NSLocalizedString(@"Recent Traffic", nil);
}

- (void)setTrafficBarGraph:(TrafficBarGraph *)trafficBarGraph
{
    _trafficBarGraph = trafficBarGraph;
    
    // Configure the traffic graph
    self.trafficBarGraph.viewsColor = [UIColor colorWithRed:0xBA/255.0f green:0xDD/255.0f blue:0xCC/255.0f alpha:1.0f];
    self.trafficBarGraph.peopleColor = [UIColor colorWithRed:0x97/255.0f green:0xCC/255.0f blue:0xB1/255.0f alpha:1.0f];
    self.trafficBarGraph.traffic = self.gauge.recentTrafficAscending;
}

- (void)setGauge:(Gauge *)gauge
{
    [super setGauge:gauge];
    
    self.trafficBarGraph.traffic = self.gauge.recentTraffic;
}


#pragma mark - UITableView Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.gauge.recentTraffic.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TrafficHeaderCellIdentifier = @"TrafficHeaderCell";
    static NSString *CellIdentifier = @"TrafficCell";
    
    NSString *identifier = (indexPath.row == 0) ? TrafficHeaderCellIdentifier : CellIdentifier;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    // Configure the cell
    if (indexPath.row > 0)
    {
        DatedViewSummary *traffic = [self.gauge.recentTraffic objectAtIndex:indexPath.row - 1];
        ((TrafficCell *)cell).traffic = traffic;
    }
    
    return cell;
}

#pragma mark Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 24.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = (indexPath.row % 2 == 1) ? [UIColor colorWithWhite:0.5f alpha:0.1f] : [UIColor clearColor];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;  // We don't allow selection
}

@end
