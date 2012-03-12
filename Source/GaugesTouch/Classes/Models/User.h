//
//  User.h
//  GaugesTouch
//
//  Created by Tyler Stromberg on 3/10/12.
//  Copyright (c) 2012 Tyler Stromberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, strong, readonly) NSArray *gauges;

+ (User *)currentUser;
+ (void)setCurrentUser:(User *)user;

- (void)refreshGaugesWithHandler:(void (^)(NSError *error))handler;

@end
