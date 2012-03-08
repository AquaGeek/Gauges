//
//  TrafficCell.m
//  GaugesTouch
//
//  Created by Tyler Stromberg on 3/7/12.
//  Copyright (c) 2012 Tyler Stromberg. All rights reserved.
//

#import "TrafficCell.h"

#import "DatedViewSummary.h"
#import "NSDateFormatter+Additions.h"

@implementation TrafficCell

@synthesize dateLabel = _dateLabel;
@synthesize viewsLabel = _viewsLabel;
@synthesize peopleLabel = _peopleLabel;
@synthesize traffic = _traffic;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self addObserver:self forKeyPath:@"traffic.date" options:0 context:NULL];
        [self addObserver:self forKeyPath:@"traffic.views" options:0 context:NULL];
        [self addObserver:self forKeyPath:@"traffic.people" options:0 context:NULL];
    }
    
    return self;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"traffic.date"];
    [self removeObserver:self forKeyPath:@"traffic.views"];
    [self removeObserver:self forKeyPath:@"traffic.people"];
}


#pragma mark -

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"traffic.date"])
    {
        self.dateLabel.text = [NSDateFormatter localizedStringFromDate:self.traffic.date withTemplate:@"MMMMd"];
    }
    else if ([keyPath isEqualToString:@"traffic.views"])
    {
        self.viewsLabel.text = [self.traffic formattedViews];
    }
    else if ([keyPath isEqualToString:@"traffic.people"])
    {
        self.peopleLabel.text = [self.traffic formattedPeople];
    }
}

@end
