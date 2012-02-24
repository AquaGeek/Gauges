//
//  Gauge.m
//  GaugesTouch
//
//  Created by Tyler Stromberg on 2/22/12.
//  Copyright (c) 2012 Tyler Stromberg. All rights reserved.
//

#import "Gauge.h"

#import "DatedViewSummary.h"

@interface Gauge()

@property (nonatomic, strong, readwrite) DatedViewSummary *todayTraffic;
@property (nonatomic, strong, readwrite) NSArray *recentTraffic;

@end


#pragma mark -

@implementation Gauge

@synthesize gaugeID = _gaugeID;
@synthesize title = _title;
@synthesize timeZoneName = _timeZoneName;
@synthesize enabled = _enabled;
@synthesize todayTraffic = _todayTraffic;
@synthesize recentTraffic = _recentTraffic;


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
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //!!! TEMP: Fake some traffic
        NSDictionary *todaysTrafficDict = [NSDictionary dictionaryWithObjectsAndKeys:@"2012-02-23", @"date",
                                           [NSNumber numberWithUnsignedLongLong:654321], @"views",
                                           [NSNumber numberWithUnsignedLongLong:123456], @"people", nil];
        self.todayTraffic = [[DatedViewSummary alloc] initWithDictionary:todaysTrafficDict];
        
        NSMutableArray *newTraffic = [NSMutableArray arrayWithCapacity:30];
        
        for (NSInteger i = 1; i < 24; i++)
        {
            NSString *dateString = [NSString stringWithFormat:@"2012-02-%02d", i];
            NSDictionary *trafficDict = [NSDictionary dictionaryWithObjectsAndKeys:dateString, @"date",
                                         [NSNumber numberWithInt:1234], @"views",
                                         [NSNumber numberWithInt:321], @"people", nil];
            
            DatedViewSummary *traffic = [[DatedViewSummary alloc] initWithDictionary:trafficDict];
            [newTraffic addObject:traffic];
        }
        
        self.recentTraffic = newTraffic;
        
        if (completionHandler != nil)
        {
            completionHandler(nil);
        }
    });
}

@end
