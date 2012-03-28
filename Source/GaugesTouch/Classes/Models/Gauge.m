//
//  Gauge.m
//  GaugesTouch
//
//  Created by Tyler Stromberg on 2/22/12.
//  Copyright (c) 2012 Tyler Stromberg. All rights reserved.
//

#import "Gauge.h"

#import "PTPusher.h"
#import "PTPusherEvent.h"

#import "DatedViewSummary.h"
#import "GaugesAPIClient.h"
#import "PageContent.h"
#import "Referrer.h"

@interface Gauge() <PTPusherDelegate>

@property (nonatomic, strong, readwrite) DatedViewSummary *todayTraffic;
@property (nonatomic, strong, readwrite) NSArray *recentTraffic;
@property (nonatomic, strong, readwrite) NSArray *topContent;
@property (nonatomic, strong, readwrite) NSArray *referrers;

@property (nonatomic, strong) PTPusherPrivateChannel *privateGaugeChannel;

@end

static PTPusher *pusherClient = nil;


#pragma mark -

@implementation Gauge

@synthesize gaugeID = _gaugeID;
@synthesize title = _title;
@synthesize timeZoneName = _timeZoneName;
@synthesize enabled = _enabled;
@synthesize todayTraffic = _todayTraffic;

@synthesize privateGaugeChannel = _privateGaugeChannel;


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
        
        // Set up the Pusher client and private channel
        // TODO: Move the pusher client to the GaugesAPIClient class (it should be shared across all gauges)
        if (pusherClient == nil)
        {
            pusherClient = [PTPusher pusherWithKey:@"887bd32ce6b7c2049e0b" connectAutomatically:NO encrypted:NO];
            pusherClient.delegate = self;
            pusherClient.authorizationURL = [NSURL URLWithString:@"https://secure.gaug.es/pusher/auth"];
            [pusherClient connect];
        }
        
        _privateGaugeChannel = [pusherClient subscribeToPrivateChannelNamed:self.gaugeID];
        
        // Listen for events
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveChannelEventNotification:)
                                                     name:PTPusherEventReceivedNotification
                                                   object:_privateGaugeChannel];
    }
    
    return self;
}

- (void)dealloc
{
    // Cleanup
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:PTPusherEventReceivedNotification
                                                  object:_privateGaugeChannel];
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


#pragma mark - Pusher

- (void)pusher:(PTPusher *)pusher willAuthorizeChannelWithRequest:(NSMutableURLRequest *)request
{
    // Tack on the X-Gauges-Token
    NSString *apiToken = [[GaugesAPIClient sharedClient] defaultValueForHeader:@"X-Gauges-Token"];
    [request setValue:apiToken forHTTPHeaderField:@"X-Gauges-Token"];
}

- (void)pusher:(PTPusher *)pusher connectionDidConnect:(PTPusherConnection *)connection
{
    NSLog(@"We're in!");
}

- (void)pusher:(PTPusher *)pusher connection:(PTPusherConnection *)connection failedWithError:(NSError *)error
{
    NSLog(@"uh oh...");
}

- (void)pusher:(PTPusher *)pusher didSubscribeToChannel:(PTPusherChannel *)channel
{
    NSLog(@"We subscribed??");
}

- (void)pusher:(PTPusher *)pusher didFailToSubscribeToChannel:(PTPusherChannel *)channel withError:(NSError *)error
{
    NSLog(@"Argh... something went wrong...");
}

- (void)didReceiveChannelEventNotification:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    PTPusherEvent *event = (PTPusherEvent *)[userInfo objectForKey:PTPusherEventUserInfoKey];
    
    if ([event.name isEqualToString:@"hit"])
    {
        // Increment any counters as necessary
        // TODO: These objects should be shared across everything
        DatedViewSummary *weeklyToday = [self.weekTraffic lastObject];
        DatedViewSummary *monthlyToday = [self.recentTraffic lastObject];
        
        NSDictionary *uniques = [event.data objectForKey:@"u"];
        CFBooleanRef dailyUnique = (__bridge CFBooleanRef)[uniques objectForKey:@"day"];
        
        if (CFBooleanGetValue(dailyUnique) == true)
        {
            self.todayTraffic.people++;
            weeklyToday.people++;
            monthlyToday.people++;
        }
        
        self.todayTraffic.views++;
        weeklyToday.views++;
        monthlyToday.views++;
        
        // TODO: Update our graph
    }
}

- (void)pusher:(PTPusher *)pusher didReceiveErrorEvent:(PTPusherErrorEvent *)errorEvent
{
    NSLog(@"An error occurred...");
}

@end
