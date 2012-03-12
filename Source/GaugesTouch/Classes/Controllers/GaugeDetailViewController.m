//
//  GaugeDetailViewController.m
//  GaugesTouch
//
//  Created by Tyler Stromberg on 2/22/12.
//  Copyright (c) 2012 Tyler Stromberg. All rights reserved.
//

#import "GaugeDetailViewController.h"

#import "ContentTableManager.h"
#import "DatedViewSummary.h"
#import "Gauge.h"
#import "PageContent.h"
#import "Referrer.h"
#import "ReferrersTableManager.h"
#import "TrafficTableManager.h"
#import "WebViewController.h"

typedef enum {
    kTrafficTab = 0,
    kContentTab,
    kReferrersTab
} Tab;

@interface GaugeDetailViewController()

@property (nonatomic, weak) IBOutlet UILabel *currentTabTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *gaugeTitleLabel;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet TrafficTableManager *trafficTableManager;
@property (nonatomic, strong) IBOutlet ContentTableManager *contentTableManager;
@property (nonatomic, strong) IBOutlet ReferrersTableManager *referrersTableManager;

@property (nonatomic) Tab currentTab;
@property (nonatomic, weak) IBOutlet UIButton *trafficButton;
@property (nonatomic, weak) IBOutlet UIButton *contentButton;
@property (nonatomic, weak) IBOutlet UIButton *referrersButton;
@property (nonatomic, weak) IBOutlet UIImageView *activeTabIndicatorView;

- (IBAction)tabButtonTapped:(id)sender;
- (UIButton *)tabButtonAtIndex:(Tab)index;
- (TableManager *)activeTableManager;

@end


#pragma mark -

@implementation GaugeDetailViewController

@synthesize gauge = _gauge;
@synthesize currentTabTitleLabel = _currentTabTitleLabel;
@synthesize gaugeTitleLabel = _gaugeTitleLabel;
@synthesize tableView = _tableView;
@synthesize trafficTableManager = _trafficTableManager;
@synthesize contentTableManager = _contentTableManager;
@synthesize referrersTableManager = _referrersTableManager;

@synthesize currentTab = _currentTab;
@synthesize trafficButton = _trafficButton;
@synthesize contentButton = _contentButton;
@synthesize referrersButton = _referrersButton;
@synthesize activeTabIndicatorView = _activeTabIndicatorView;

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
    
    // Set/restore the tab selection
    self.currentTab = _currentTab;
    
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
    
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:animated];
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
    NSIndexPath *selectedPath = self.tableView.indexPathForSelectedRow;
    
    if ([segue.identifier isEqualToString:@"ContentSegue"])
    {
        PageContent *selectedContent = [self.gauge.topContent objectAtIndex:selectedPath.row - 1];
        ((WebViewController *)segue.destinationViewController).urlString = selectedContent.url;
    }
    else if ([segue.identifier isEqualToString:@"ReferrerSegue"])
    {
        Referrer *selectedReferrer = [self.gauge.referrers objectAtIndex:selectedPath.row - 1];
        ((WebViewController *)segue.destinationViewController).urlString = selectedReferrer.url;
    }
}


#pragma mark -

- (void)setGauge:(Gauge *)gauge
{
    if (![_gauge isEqual:gauge])
    {
        _gauge = gauge;
        
        // Pass the gauge down to the table managers
        self.trafficTableManager.gauge = gauge;
        self.contentTableManager.gauge = gauge;
        self.referrersTableManager.gauge = gauge;
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


#pragma mark - Button Actions

- (void)setCurrentTab:(Tab)currentTab
{
    if (_currentTab >= kTrafficTab && currentTab <= kReferrersTab)
    {
        Tab oldTab = _currentTab;
        _currentTab = currentTab;
        
        UIButton *oldButton = [self tabButtonAtIndex:oldTab];
        UIButton *newButton = [self tabButtonAtIndex:currentTab];
        
        // Re-enable the old tab and update its appearance
        oldButton.userInteractionEnabled = YES;
        oldButton.selected = NO;
        
        // Disable the new tab and update its appearance
        newButton.userInteractionEnabled = NO;
        newButton.selected = YES;
        
        // Move the indicator
        CGRect indicatorFrame = self.activeTabIndicatorView.frame;
        indicatorFrame.origin.x = floorf(CGRectGetMidX(newButton.frame) - indicatorFrame.size.width / 2);
        self.activeTabIndicatorView.frame = indicatorFrame;
        
        // Swap out the table data source/delegate and refresh the table
        TableManager *activeManager = self.activeTableManager;
        self.tableView.dataSource = activeManager;
        self.tableView.delegate = activeManager;
        self.tableView.tableHeaderView = activeManager.tableHeaderView;
        self.currentTabTitleLabel.text = activeManager.title;
        [self.tableView reloadData];
        
        // Refresh the tab content, as appropriate
        if (currentTab == kContentTab && self.gauge.topContent == nil)
        {
            [self.gauge refreshContentWithHandler:^(NSError *error) {
                [self.tableView reloadData];
            }];
        }
        else if (currentTab == kReferrersTab && self.gauge.referrers == nil)
        {
            [self.gauge refreshReferrersWithHandler:^(NSError *error) {
                [self.tableView reloadData];
            }];
        }
    }
}

- (IBAction)tabButtonTapped:(id)sender
{
    if ([sender isKindOfClass:[UIButton class]])
    {
        self.currentTab = ((UIButton *)sender).tag - 1000;
    }
}

- (UIButton *)tabButtonAtIndex:(Tab)index
{
    switch (index)
    {
        case kTrafficTab:
            return self.trafficButton;
        case kContentTab:
            return self.contentButton;
        case kReferrersTab:
            return self.referrersButton;
        default:
            return nil;
    }
}

- (TableManager *)activeTableManager
{
    switch (self.currentTab)
    {
        case kTrafficTab:
            return self.trafficTableManager;
        case kContentTab:
            return self.contentTableManager;
        case kReferrersTab:
            return self.referrersTableManager;
        default:
            return nil;
    }
}

@end
