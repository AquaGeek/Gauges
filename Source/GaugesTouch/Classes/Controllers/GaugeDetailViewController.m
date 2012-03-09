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
#import "TrafficTableManager.h"

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
@property (nonatomic, weak) IBOutlet TrafficBarGraph *trafficBarGraph;

@property (nonatomic) Tab currentTab;
@property (nonatomic, weak) IBOutlet UIButton *trafficButton;
@property (nonatomic, weak) IBOutlet UIButton *contentButton;
@property (nonatomic, weak) IBOutlet UIButton *referrersButton;
@property (nonatomic, weak) IBOutlet UIImageView *activeTabIndicatorView;

- (IBAction)tabButtonTapped:(id)sender;
- (UIButton *)tabButtonAtIndex:(Tab)index;

@end


#pragma mark -

@implementation GaugeDetailViewController

@synthesize gauge = _gauge;
@synthesize currentTabTitleLabel = _currentTabTitleLabel;
@synthesize gaugeTitleLabel = _gaugeTitleLabel;
@synthesize tableView = _tableView;
@synthesize trafficTableManager = _trafficTableManager;
@synthesize trafficBarGraph = _trafficBarGraph;

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
        
        // Pass the gauge down to the table managers
        self.trafficTableManager.gauge = gauge;
        
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
        
        // TODO: Change out the table data source(/delegate?) and refresh the table
        self.tableView.dataSource = self.trafficTableManager;
        self.tableView.delegate = self.trafficTableManager;
        [self.tableView reloadData];
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

@end
