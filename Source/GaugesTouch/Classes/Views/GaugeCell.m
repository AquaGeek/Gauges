//
//  GaugeCell.m
//  GaugesTouch
//
//  Created by Tyler Stromberg on 2/23/12.
//  Copyright (c) 2012 Tyler Stromberg. All rights reserved.
//

#import "GaugeCell.h"

#import "DatedViewSummary.h"
#import "Gauge.h"
#import "TrafficBarGraph.h"

@interface GaugeCell()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *viewsCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *peopleCountLabel;
@property (nonatomic, weak) IBOutlet TrafficBarGraph *trafficBarGraph;

@end


#pragma mark -

@implementation GaugeCell

@synthesize gauge = _gauge;

@synthesize titleLabel = _titleLabel;
@synthesize viewsCountLabel = _viewsCountLabel;
@synthesize peopleCountLabel = _peopleCountLabel;
@synthesize trafficBarGraph = _trafficBarGraph;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self addObserver:self forKeyPath:@"gauge.title" options:0 context:NULL];
        [self addObserver:self forKeyPath:@"gauge.todayTraffic.views" options:0 context:NULL];
        [self addObserver:self forKeyPath:@"gauge.todayTraffic.people" options:0 context:NULL];
        [self addObserver:self forKeyPath:@"gauge.recentTraffic" options:0 context:NULL];
        
        // TODO: Listen for changes to the individual days as well
    }
    
    return self;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"gauge.title"];
    [self removeObserver:self forKeyPath:@"gauge.todayTraffic.views"];
    [self removeObserver:self forKeyPath:@"gauge.todayTraffic.people"];
    [self removeObserver:self forKeyPath:@"gauge.recentTraffic"];
}


#pragma mark -

- (void)setGaugess:(Gauge *)gauge
{
    if (![_gauge isEqual:gauge])
    {
        _gauge = gauge;
        self.trafficBarGraph.traffic = gauge.recentTraffic;
    }
}

- (void)setTrafficBarGraph:(TrafficBarGraph *)trafficBarGraph
{
    _trafficBarGraph = trafficBarGraph;
    _trafficBarGraph.viewsColor = [UIColor colorWithRed:0x53/255.0f green:0x68/255.0f blue:0x5E/255.0f alpha:1.0f];
    _trafficBarGraph.peopleColor = [UIColor colorWithRed:0x6E/255.0f green:0x91/255.0f blue:0x80/255.0f alpha:1.0f];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"gauge.title"])
    {
        self.titleLabel.text = self.gauge.title;
    }
    else if ([keyPath isEqualToString:@"gauge.todayTraffic.views"])
    {
        NSString *views = [self.gauge.todayTraffic formattedViews];
        self.viewsCountLabel.text = (views == nil) ? @"0" : views;
    }
    else if ([keyPath isEqualToString:@"gauge.todayTraffic.people"])
    {
        NSString *people = [self.gauge.todayTraffic formattedPeople];
        self.peopleCountLabel.text = (people == nil) ? @"0" : people;
    }
    else if ([keyPath isEqualToString:@"gauge.recentTraffic"])
    {
        self.trafficBarGraph.traffic = self.gauge.weekTraffic;
    }
}

@end
