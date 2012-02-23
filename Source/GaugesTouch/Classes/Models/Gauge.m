//
//  Gauge.m
//  GaugesTouch
//
//  Created by Tyler Stromberg on 2/22/12.
//  Copyright (c) 2012 Tyler Stromberg. All rights reserved.
//

#import "Gauge.h"

#import "Traffic.h"

@interface Gauge()

@property (nonatomic, strong, readwrite) NSArray *traffic;

@end


#pragma mark -

@implementation Gauge

@synthesize gaugeID = _gaugeID;
@synthesize title = _title;
@synthesize timeZoneName = _timeZoneName;
@synthesize enabled = _enabled;
@synthesize traffic = _traffic;


#pragma mark - Object Lifecycle

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if ((self = [super init]))
    {
        _gaugeID = [dictionary valueForKey:@"id"];
        _title = [dictionary valueForKey:@"title"];
        _timeZoneName = [dictionary valueForKey:@"tz"];
        _enabled = [[dictionary valueForKey:@"enabled"] boolValue];
    }
    
    return self;
}


#pragma mark - Traffic

- (void)refreshTrafficWithHandler:(void (^)(NSError *error))completionHandler
{
    //!!! TEMP: Fake some traffic
    NSMutableArray *newTraffic = [NSMutableArray arrayWithCapacity:30];
    
    for (NSInteger i = 1; i < 24; i++)
    {
        NSString *dateString = [NSString stringWithFormat:@"2012-02-%02d", i];
        NSDictionary *trafficDict = [NSDictionary dictionaryWithObjectsAndKeys:dateString, @"date",
                                     [NSNumber numberWithInt:1234], @"views",
                                     [NSNumber numberWithInt:321], @"people", nil];
        
        Traffic *traffic = [[Traffic alloc] initWithDictionary:trafficDict];
        [newTraffic addObject:traffic];
    }
    
    self.traffic = newTraffic;
}

@end
