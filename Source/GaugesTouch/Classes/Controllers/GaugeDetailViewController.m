//
//  GaugeDetailViewController.m
//  GaugesTouch
//
//  Created by Tyler Stromberg on 2/22/12.
//  Copyright (c) 2012 Tyler Stromberg. All rights reserved.
//

#import "GaugeDetailViewController.h"

#import "Gauge.h"

@interface GaugeDetailViewController()

@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;

@end


#pragma mark -

@implementation GaugeDetailViewController

@synthesize gauge = _gauge;
@synthesize descriptionLabel = _descriptionLabel;

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

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (![self isViewLoaded])
    {
        return;
    }
    
    if ([keyPath isEqualToString:@"gauge.title"])
    {
        self.descriptionLabel.text = self.gauge.title;
    }
}

@end
