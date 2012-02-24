//
//  TrafficBarGraph.m
//  GaugesTouch
//
//  Created by Tyler Stromberg on 2/23/12.
//  Copyright (c) 2012 Tyler Stromberg. All rights reserved.
//

#import "TrafficBarGraph.h"

#import "DatedViewSummary.h"

const CGFloat kMinHeight = 4.0f;
const CGFloat kXSpacing = 1.0f;

@interface TrafficBarGraph() {
@private
    long _max;
}

@end


#pragma mark -

@implementation TrafficBarGraph

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
    
    if (self.traffic.count > 0)
    {
        barFrame.size.width = ceilf((bounds.size.width / self.traffic.count) - kXSpacing);
    }
    
    for (DatedViewSummary *dailyTraffic in self.traffic)
    {
        // Draw the traffic
        CGFloat percentage = floorf((CGFloat)dailyTraffic.views / _max * 100) / 100.0f;
        barFrame.size.height = MAX(kMinHeight, percentage * bounds.size.height);
        barFrame.origin.y = bounds.size.height - barFrame.size.height;
        
        // Set the color
        [[UIColor colorWithRed:0x53/255.0f green:0x68/255.0f blue:0x5E/255.0f alpha:1.0f] set];
        CGContextFillRect(context, barFrame);
        
        // Draw the people
        percentage = floorf((CGFloat)dailyTraffic.people / _max * 100) / 100.0f;
        barFrame.size.height = MAX(kMinHeight, percentage * bounds.size.height);
        barFrame.origin.y = bounds.size.height - barFrame.size.height;
        
        // Set the color
        [[UIColor colorWithRed:0x6E/255.0f green:0x91/255.0f blue:0x80/255.0f alpha:1.0f] set];
        CGContextFillRect(context, barFrame);
        
        barFrame.origin.x += barFrame.size.width + kXSpacing;
    }
}


#pragma mark -

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
