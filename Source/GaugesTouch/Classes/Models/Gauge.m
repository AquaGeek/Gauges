//
//  Gauge.m
//  GaugesTouch
//
//  Created by Tyler Stromberg on 2/22/12.
//  Copyright (c) 2012 Tyler Stromberg. All rights reserved.
//

#import "Gauge.h"

#import "DatedViewSummary.h"
#import "GaugesAPIClient.h"
#import "PageContent.h"
#import "Referrer.h"

@interface Gauge()

@property (nonatomic, strong, readwrite) DatedViewSummary *todayTraffic;
@property (nonatomic, strong, readwrite) NSArray *recentTraffic;
@property (nonatomic, strong, readwrite) NSArray *topContent;
@property (nonatomic, strong, readwrite) NSArray *referrers;

@end


#pragma mark -

@implementation Gauge

@synthesize gaugeID = _gaugeID;
@synthesize title = _title;
@synthesize timeZoneName = _timeZoneName;
@synthesize enabled = _enabled;
@synthesize todayTraffic = _todayTraffic;


#pragma mark - Object Lifecycle

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if ((self = [super init]))
    {
        _gaugeID = [dictionary valueForKey:@"id"];
        _title = [dictionary valueForKey:@"title"];
        _timeZoneName = [dictionary valueForKey:@"tz"];
        _enabled = [[dictionary valueForKey:@"enabled"] boolValue];
        
        NSDictionary *todaysTraffic = [dictionary objectForKey:@"today"];
        _todayTraffic = [[DatedViewSummary alloc] initWithDictionary:todaysTraffic];
        
        NSArray *rawTraffic = [dictionary objectForKey:@"recent_days"];
        NSMutableArray *newTraffic = [NSMutableArray arrayWithCapacity:rawTraffic.count];
        
        for (NSDictionary *trafficInfo in rawTraffic)
        {
            DatedViewSummary *traffic = [[DatedViewSummary alloc] initWithDictionary:trafficInfo];
            [newTraffic addObject:traffic];
        }
        
        self.recentTraffic = newTraffic;
    }
    
    return self;
}


#pragma mark - Traffic

@synthesize recentTraffic = _recentTraffic;

- (NSArray *)weekTraffic
{
    NSArray *traffic = self.recentTrafficAscending;
    NSRange weekRange;
    
    if (traffic.count > 7)
    {
        weekRange.location = traffic.count - 7;
    }
    
    weekRange.length = MIN(7, traffic.count);
    
    return [traffic subarrayWithRange:weekRange];
}

- (NSArray *)recentTrafficAscending
{
    NSSortDescriptor *ascendingDate = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    return [self.recentTraffic sortedArrayUsingDescriptors:[NSArray arrayWithObject:ascendingDate]];
}

- (void)refreshTrafficWithHandler:(void (^)(NSError *error))completionHandler
{
    [[GaugesAPIClient sharedClient] getPath:[NSString stringWithFormat:@"gauges/%@", self.gaugeID]
                                 parameters:nil
                                    success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if ([responseObject isKindOfClass:[NSDictionary class]])
         {
             responseObject = [responseObject objectForKey:@"gauge"];
             
             NSDictionary *todaysTraffic = [responseObject objectForKey:@"today"];
             _todayTraffic = [[DatedViewSummary alloc] initWithDictionary:todaysTraffic];
             
             NSArray *rawTraffic = [responseObject objectForKey:@"recent_days"];
             NSMutableArray *newTraffic = [NSMutableArray arrayWithCapacity:rawTraffic.count];
             
             for (NSDictionary *trafficInfo in rawTraffic)
             {
                 DatedViewSummary *traffic = [[DatedViewSummary alloc] initWithDictionary:trafficInfo];
                 [newTraffic addObject:traffic];
             }
             
             self.recentTraffic = newTraffic;
         }
         
         if (completionHandler != nil)
         {
             completionHandler(nil);
         }
     }
                                    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         if (completionHandler != nil)
         {
             completionHandler(error);
         }
     }];
}


#pragma mark - Content

@synthesize topContent = _topContent;

- (void)refreshContentWithHandler:(void (^)(NSError *))completionHandler
{
    [[GaugesAPIClient sharedClient] getPath:[NSString stringWithFormat:@"gauges/%@/content", self.gaugeID]
                                 parameters:nil
                                    success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if ([responseObject isKindOfClass:[NSDictionary class]])
         {
             NSArray *rawContent = [responseObject objectForKey:@"content"];
             NSMutableArray *newContent = [NSMutableArray arrayWithCapacity:rawContent.count];
             
             for (NSDictionary *contentInfo in rawContent)
             {
                 PageContent *content = [[PageContent alloc] initWithDictionary:contentInfo];
                 [newContent addObject:content];
             }
             
             NSSortDescriptor *byViews = [NSSortDescriptor sortDescriptorWithKey:@"views" ascending:NO];
             self.topContent = [newContent sortedArrayUsingDescriptors:[NSArray arrayWithObject:byViews]];
         }
         
         if (completionHandler != nil)
         {
             completionHandler(nil);
         }
     }
                                    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         if (completionHandler != nil)
         {
             completionHandler(error);
         }
     }];
}


#pragma mark - Referrers

@synthesize referrers = _referrers;

- (void)refreshReferrersWithHandler:(void (^)(NSError *error))completionHandler
{
    [[GaugesAPIClient sharedClient] getPath:[NSString stringWithFormat:@"gauges/%@/referrers", self.gaugeID]
                                 parameters:nil
                                    success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if ([responseObject isKindOfClass:[NSDictionary class]])
         {
             NSArray *rawReferrers = [responseObject objectForKey:@"referrers"];
             NSMutableArray *newReferrers = [NSMutableArray arrayWithCapacity:rawReferrers.count];
             
             for (NSDictionary *referrerInfo in rawReferrers)
             {
                 Referrer *referrer = [[Referrer alloc] initWithDictionary:referrerInfo];
                 [newReferrers addObject:referrer];
             }
             
             NSSortDescriptor *byViews = [NSSortDescriptor sortDescriptorWithKey:@"views" ascending:NO];
             self.referrers = [newReferrers sortedArrayUsingDescriptors:[NSArray arrayWithObject:byViews]];
         }
         
         if (completionHandler != nil)
         {
             completionHandler(nil);
         }
     }
                                    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         if (completionHandler != nil)
         {
             completionHandler(error);
         }
     }];
}

@end
