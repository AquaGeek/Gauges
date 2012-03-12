//
//  Referrer.h
//  GaugesTouch
//
//  Created by Tyler Stromberg on 3/9/12.
//  Copyright (c) 2012 Tyler Stromberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Referrer : NSObject

@property (nonatomic, strong) NSString *host;
@property (nonatomic) long views;
@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) NSString *url;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)formattedViews;

@end
