//
//  MasterViewController.m
//  GaugesTouch
//
//  Created by Tyler Stromberg on 2/22/12.
//  Copyright (c) 2012 Tyler Stromberg. All rights reserved.
//

#import "GaugesListViewController.h"

#import "Gauge.h"
#import "GaugeCell.h"
#import "GaugeDetailViewController.h"
#import "User.h"

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
    bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"black_linen_v2"]];
    bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.backgroundView = bgView;
    
    // Get rid of the additional cell dividers
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    footerView.opaque = NO;
    self.tableView.tableFooterView = footerView;
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
    
    // Update our data if necessary
    if ([User currentUser].gauges == nil)
    {
        [[User currentUser] refreshGaugesWithHandler:^(NSError *error) {
            self.gauges = [User currentUser].gauges;
            [self.tableView reloadData];
        }];
    }
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
    
    GaugeCell *cell = (GaugeCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell
    Gauge *gauge = [self.gauges objectAtIndex:indexPath.row];
    cell.gauge = gauge;
    
    return cell;
}

@end
