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

+ (void)initializeCurrentUserWithToken:(NSString *)apiToken;

@end


#pragma mark -

@implementation User

static User *currentUser = nil;

+ (void)initialize
{
    // Try to load an API token from the user defaults
    // TODO: Move this to the keychain
    NSString *apiToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"APIToken"];
    
    if (apiToken != nil)
    {
        [self initializeCurrentUserWithToken:apiToken];
    }
}

+ (User *)currentUser
{
    return currentUser;
}

+ (void)initializeCurrentUserWithToken:(NSString *)apiToken;
{
    currentUser = [[self alloc] init];
    [[GaugesAPIClient sharedClient] setDefaultHeader:@"X-Gauges-Token" value:apiToken];
    
    // Store it in the user defaults
    // TODO: Move this to the keychain
    [[NSUserDefaults standardUserDefaults] setObject:apiToken forKey:@"APIToken"];
}

+ (void)authenticateWithEmail:(NSString *)email password:(NSString *)password handler:(void (^)(NSError *error))handler
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:2];
    [params setObject:email forKey:@"email"];
    [params setObject:password forKey:@"password"];
    
    [[GaugesAPIClient sharedClient] postPath:@"authenticate"
                                  parameters:params
                                     success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         // See if there is already an API client named "Gaug.es for iPhone"
         [[GaugesAPIClient sharedClient] getPath:@"clients"
                                      parameters:nil
                                         success:^(AFHTTPRequestOperation *operation, id responseObject)
          {
              if ([responseObject isKindOfClass:[NSDictionary class]])
              {
                  BOOL tokenExists = NO;
                  
                  for (NSDictionary *clientInfo in [responseObject objectForKey:@"clients"])
                  {
                      if ([[clientInfo objectForKey:@"description"] isEqualToString:@"Gaug.es for iPhone"])
                      {
                          NSString *apiToken = [clientInfo objectForKey:@"key"];
                          [self initializeCurrentUserWithToken:apiToken];
                          
                          tokenExists = YES;
                          break;
                      }
                  }
                  
                  if (!tokenExists)
                  {
                      // TODO: Hit the server and create it
                  }
              }
              
              if (handler != nil)
              {
                  handler(nil);
              }
          }
                                         failure:^(AFHTTPRequestOperation *operation, NSError *error)
          {
              if (handler != nil)
              {
                  handler(error);
              }
          }];
     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         if (handler != nil)
         {
             handler(error);
         }
     }];
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
         // TODO: How to handle authentication errors?
         handler(error);
     }];
}

@end
