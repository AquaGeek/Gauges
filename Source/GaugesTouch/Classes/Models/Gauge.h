//
//  Gauge.h
//  GaugesTouch
//
//  Created by Tyler Stromberg on 2/22/12.
//  Copyright (c) 2012 Tyler Stromberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DatedViewSummary;

@interface Gauge : NSObject

@property (nonatomic, strong) NSString *gaugeID;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *timeZoneName;
@property (nonatomic, getter = isEnabled) BOOL enabled;
@property (nonatomic, strong, readonly) DatedViewSummary *todayTraffic;
@property (nonatomic, strong, readonly) NSArray *weekTraffic;
@property (nonatomic, strong, readonly) NSArray *recentTraffic;
@property (nonatomic, strong, readonly) NSArray *recentTrafficDescending;
@property (nonatomic, strong, readonly) NSArray *topContent;
@property (nonatomic, strong, readonly) NSArray *referrers;

// Designated initializer
- (id)initWithDictionary:(NSDictionary *)dictionary;

- (void)refreshTrafficWithHandler:(void (^)(NSError *error))completionHandler;
- (void)refreshContentWithHandler:(void (^)(NSError *error))completionHandler;
- (void)refreshReferrersWithHandler:(void (^)(NSError *error))completionHandler;

@end
