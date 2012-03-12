//
//  TrafficBarGraph.m
//  GaugesTouch
//
//  Created by Tyler Stromberg on 2/23/12.
//  Copyright (c) 2012 Tyler Stromberg. All rights reserved.
//

#import "TrafficBarGraph.h"

#import "DatedViewSummary.h"

const CGFloat kMinHeight = 1.0f;
const CGFloat kXSpacing = 1.0f;

@interface TrafficBarGraph() {
@private
    long _max;
}

@end


#pragma mark -

@implementation TrafficBarGraph

@synthesize viewsColor = _viewsColor;
@synthesize peopleColor = _peopleColor;
@synthesize traffic = _traffic;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        _max = 1;
        
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGRect bounds = self.bounds;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect barFrame = CGRectZero;
    
    NSUInteger trafficCount = self.traffic.count;
    if (trafficCount > 0)
    {
        barFrame.size.width = bounds.size.width / trafficCount - kXSpacing;
    }
    
    for (DatedViewSummary *dailyTraffic in self.traffic)
    {
        // Draw the traffic
        CGFloat percentage = floorf((CGFloat)dailyTraffic.views / _max * 100) / 100.0f;
        barFrame.size.height = MAX(kMinHeight, percentage * bounds.size.height);
        barFrame.origin.y = bounds.size.height - barFrame.size.height;
        
        [self.viewsColor set];
        CGContextFillRect(context, barFrame);
        
        // Draw the people
        percentage = floorf((CGFloat)dailyTraffic.people / _max * 100) / 100.0f;
        barFrame.size.height = MAX(kMinHeight, percentage * bounds.size.height);
        barFrame.origin.y = bounds.size.height - barFrame.size.height;
        
        [self.peopleColor set];
        CGContextFillRect(context, barFrame);
        
        barFrame.origin.x += barFrame.size.width + kXSpacing;
    }
}


#pragma mark -

- (void)setViewsColor:(UIColor *)viewsColor
{
    if (![_viewsColor isEqual:viewsColor])
    {
        _viewsColor = viewsColor;
        [self setNeedsDisplay];
    }
}

- (void)setPeopleColor:(UIColor *)peopleColor
{
    if (![_peopleColor isEqual:peopleColor])
    {
        _peopleColor = peopleColor;
        [self setNeedsDisplay];
    }
}

- (void)setTraffic:(NSArray *)traffic
{
    if (![_traffic isEqualToArray:traffic])
    {
        _traffic = traffic;
        
        // Calculate the max
        for (DatedViewSummary *dailyTraffic in traffic)
        {
            _max = MAX(_max, MAX(dailyTraffic.views, dailyTraffic.people));
        }
        
        [self setNeedsDisplay];
    }
}

@end
