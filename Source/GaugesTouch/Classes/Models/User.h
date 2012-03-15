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
+ (void)authenticateWithEmail:(NSString *)email password:(NSString *)password handler:(void (^)(NSError *error))handler;

- (void)refreshGaugesWithHandler:(void (^)(NSError *error))handler;

@end
