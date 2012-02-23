//
//  MasterViewController.m
//  GaugesTouch
//
//  Created by Tyler Stromberg on 2/22/12.
//  Copyright (c) 2012 Tyler Stromberg. All rights reserved.
//

#import "GaugesListViewController.h"

#import "Gauge.h"
#import "GaugeDetailViewController.h"

@interface GaugesListViewController()

@property (nonatomic, strong, readwrite) NSArray *gauges;

@end


#pragma mark -

@implementation GaugesListViewController

@synthesize gauges = _gauges;

#pragma mark Object Lifecycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        NSDictionary *gaugeDict = [NSDictionary dictionaryWithObjectsAndKeys:@"Gauge 1", @"title", nil];
        NSDictionary *gaugeDict2 = [NSDictionary dictionaryWithObjectsAndKeys:@"Test Gauge", @"title", nil];
        _gauges = [NSArray arrayWithObjects:[[Gauge alloc] initWithDictionary:gaugeDict],
                   [[Gauge alloc] initWithDictionary:gaugeDict2], nil];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
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
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor viewFlipsideBackgroundColor];
    bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.backgroundView = bgView;
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"GaugeDetailSegue"])
    {
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        Gauge *gauge = [self.gauges objectAtIndex:selectedIndexPath.row];
        ((GaugeDetailViewController *)segue.destinationViewController).gauge = gauge;
    }
}


#pragma mark - UITableView Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.gauges.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GaugeCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // TODO: Pass on the gauge
    Gauge *gauge = [self.gauges objectAtIndex:indexPath.row];
//    cell.textLabel.text = gauge.title;
    
    return cell;
}

@end
