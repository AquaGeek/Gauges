//
//  DatedViewSummary.h
//  GaugesTouch
//
//  Created by Tyler Stromberg on 2/22/12.
//  Copyright (c) 2012 Tyler Stromberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DatedViewSummary : NSObject

@property (nonatomic, strong) NSDate *date;
@property (nonatomic) uint64_t views;
@property (nonatomic) uint64_t people;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
