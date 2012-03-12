//
//  User.m
//  GaugesTouch
//
//  Created by Tyler Stromberg on 3/10/12.
//  Copyright (c) 2012 Tyler Stromberg. All rights reserved.
//

#import "User.h"

#import "Gauge.h"
#import "GaugesAPIClient.h"

@interface User()

@property (nonatomic, strong, readwrite) NSArray *gauges;

@end


#pragma mark -

@implementation User

static User *currentUser = nil;

+ (void)initialize
{
    // TODO: Here we should be checking whether or not there is a saved token in the keychain
    currentUser = [[User alloc] init];
}

+ (User *)currentUser
{
    return currentUser;
}

+ (void)setCurrentUser:(User *)user
{
    currentUser = user;
}

@synthesize gauges = _gauges;

- (void)refreshGaugesWithHandler:(void (^)(NSError *error))handler
{
    [[GaugesAPIClient sharedClient] getPath:@"gauges/embedded"
                                 parameters:nil
                                    success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if ([responseObject isKindOfClass:[NSDictionary class]])
         {
             NSArray *rawGauges = [responseObject objectForKey:@"gauges"];
             NSMutableArray *newGauges = [NSMutableArray arrayWithCapacity:rawGauges.count];
             
             for (NSDictionary *gaugeInfo in rawGauges)
             {
                 Gauge *newGauge = [[Gauge alloc] initWithDictionary:gaugeInfo];
                 [newGauges addObject:newGauge];
             }
             
             self.gauges = newGauges;
         }
         
         handler(nil);
     }
                                    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         handler(error);
     }];
}

@end
