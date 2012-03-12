//
//  GaugesAPIClient.h
//  GaugesTouch
//
//  Created by Tyler Stromberg on 3/10/12.
//  Copyright (c) 2012 Tyler Stromberg. All rights reserved.
//

#import "AFHTTPClient.h"

@interface GaugesAPIClient : AFHTTPClient

+ (GaugesAPIClient *)sharedClient;

@end
