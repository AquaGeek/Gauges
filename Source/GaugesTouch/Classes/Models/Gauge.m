//
//  Gauge.m
//  GaugesTouch
//
//  Created by Tyler Stromberg on 2/22/12.
//  Copyright (c) 2012 Tyler Stromberg. All rights reserved.
//

#import "Gauge.h"

#import "DatedViewSummary.h"
#import "PageContent.h"

@interface Gauge()

@property (nonatomic, strong, readwrite) DatedViewSummary *todayTraffic;
@property (nonatomic, strong, readwrite) NSArray *recentTraffic;
@property (nonatomic, strong, readwrite) NSArray *topContent;

@end


#pragma mark -

@implementation Gauge

@synthesize gaugeID = _gaugeID;
@synthesize title = _title;
@synthesize timeZoneName = _timeZoneName;
@synthesize enabled = _enabled;


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

@synthesize todayTraffic = _todayTraffic;
@synthesize recentTraffic = _recentTraffic;

- (NSArray *)weekTraffic
{
    NSArray *traffic = self.recentTraffic;
    NSRange weekRange;
    
    if (traffic.count > 7)
    {
        weekRange.location = traffic.count - 7;
    }
    
    weekRange.length = MIN(7, traffic.count);
    
    return [traffic subarrayWithRange:weekRange];
}

- (NSArray *)recentTrafficDescending
{
    NSSortDescriptor *descendingDate = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    return [self.recentTraffic sortedArrayUsingDescriptors:[NSArray arrayWithObject:descendingDate]];
}

- (void)refreshTrafficWithHandler:(void (^)(NSError *error))completionHandler
{
    srand(time(NULL));
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //!!! TEMP: Fake some traffic
        NSDictionary *todaysTrafficDict = [NSDictionary dictionaryWithObjectsAndKeys:@"2012-01-30", @"date",
                                           [NSNumber numberWithLong:rand() % 1000 + 1000], @"views",
                                           [NSNumber numberWithLong:rand() % 1000], @"people", nil];
        self.todayTraffic = [[DatedViewSummary alloc] initWithDictionary:todaysTrafficDict];
        
        NSMutableArray *newTraffic = [NSMutableArray arrayWithCapacity:30];
        
        for (NSInteger i = 1; i < 30; i++)
        {
            NSString *dateString = [NSString stringWithFormat:@"2012-01-%02d", i];
            NSDictionary *trafficDict = [NSDictionary dictionaryWithObjectsAndKeys:dateString, @"date",
                                         [NSNumber numberWithLong:rand() % 1000 + 1000], @"views",
                                         [NSNumber numberWithLong:rand() % 1000], @"people", nil];
            
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


#pragma mark - Content

@synthesize topContent = _topContent;

- (void)refreshContentWithHandler:(void (^)(NSError *))completionHandler
{
    srand(time(NULL));
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //!!! TEMP: Fake some content data
        NSMutableArray *newContent = [NSMutableArray arrayWithCapacity:15];
        
        for (NSInteger i = 0; i < 15; i++)
        {
            PageContent *content = [[PageContent alloc] init];
            content.views = rand() % 1000;
            content.url = @"http://get.gaug.es";
            content.path = @"/";
            content.title = @"Gaug.es";
            
            [newContent addObject:content];
        }
        
        NSSortDescriptor *byViews = [NSSortDescriptor sortDescriptorWithKey:@"views" ascending:NO];
        self.topContent = [newContent sortedArrayUsingDescriptors:[NSArray arrayWithObject:byViews]];
        
        if (completionHandler != nil)
        {
            completionHandler(nil);
        }
    });
}

@end
