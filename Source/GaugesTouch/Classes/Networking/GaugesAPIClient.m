//
//  GaugesAPIClient.m
//  GaugesTouch
//
//  Created by Tyler Stromberg on 3/10/12.
//  Copyright (c) 2012 Tyler Stromberg. All rights reserved.
//

#import "GaugesAPIClient.h"

#import "AFJSONRequestOperation.h"

@implementation GaugesAPIClient

+ (GaugesAPIClient *)sharedClient
{
    static GaugesAPIClient *sharedClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[GaugesAPIClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://secure.gaug.es"]];
        [sharedClient setDefaultHeader:@"Accept" value:@"application/json"];
        [sharedClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    });
    
    return sharedClient;
}

@end
