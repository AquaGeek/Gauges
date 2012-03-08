//
//  GaugeDetailViewController.m
//  GaugesTouch
//
//  Created by Tyler Stromberg on 2/22/12.
//  Copyright (c) 2012 Tyler Stromberg. All rights reserved.
//

#import "GaugeDetailViewController.h"

#import "DatedViewSummary.h"
#import "Gauge.h"
#import "TrafficBarGraph.h"
#import "TrafficCell.h"

@interface GaugeDetailViewController()

@property (nonatomic, weak) IBOutlet UILabel *currentTabTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *gaugeTitleLabel;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet TrafficBarGraph *trafficBarGraph;

@end


#pragma mark -

@implementation GaugeDetailViewController

@synthesize gauge = _gauge;
@synthesize currentTabTitleLabel = _currentTabTitleLabel;
@synthesize gaugeTitleLabel = _gaugeTitleLabel;
@synthesize tableView = _tableView;
@synthesize trafficBarGraph = _trafficBarGraph;

#pragma mark - Object Lifecycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self addObserver:self forKeyPath:@"gauge.title" options:0 context:NULL];
    }
    
    return self;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"gauge.title"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"white"]];
    
    // Configure the traffic graph
    self.trafficBarGraph.viewsColor = [UIColor colorWithRed:0xBA/255.0f green:0xDD/255.0f blue:0xCC/255.0f alpha:1.0f];
    self.trafficBarGraph.peopleColor = [UIColor colorWithRed:0x97/255.0f green:0xCC/255.0f blue:0xB1/255.0f alpha:1.0f];
    self.trafficBarGraph.traffic = self.gauge.recentTraffic;
    
    // Force the KVO to fire
    self.gauge = self.gauge;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -

- (void)setGauge:(Gauge *)gauge
{
    if (![_gauge isEqual:gauge])
    {
        _gauge = gauge;
        
        if ([self isViewLoaded])
        {
            self.trafficBarGraph.traffic = gauge.recentTraffic;
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (![self isViewLoaded])
    {
        return;
    }
    
    if ([keyPath isEqualToString:@"gauge.title"])
    {
        self.gaugeTitleLabel.text = self.gauge.title;
    }
}


#pragma mark - UITableView Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.gauge.recentTrafficDescending.count + 1;
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
        DatedViewSummary *traffic = [self.gauge.recentTrafficDescending objectAtIndex:indexPath.row - 1];
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
