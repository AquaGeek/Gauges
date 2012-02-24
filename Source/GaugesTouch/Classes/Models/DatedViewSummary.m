//
//  DatedViewSummary.m
//  GaugesTouch
//
//  Created by Tyler Stromberg on 2/22/12.
//  Copyright (c) 2012 Tyler Stromberg. All rights reserved.
//

#import "DatedViewSummary.h"

@interface DatedViewSummary()

@property (nonatomic, strong, readonly) NSDateFormatter *dateFormatter;

@end


#pragma mark -

@implementation DatedViewSummary

@synthesize date = _date;
@synthesize views = _views;
@synthesize people = _people;

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if ((self = [super init]))
    {
        _date = [self.dateFormatter dateFromString:[dictionary valueForKey:@"date"]];
        _views = [[dictionary valueForKey:@"views"] unsignedLongLongValue];
        _people = [[dictionary valueForKey:@"people"] unsignedLongLongValue];
    }
    
    return self;
}


#pragma mark -

- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    });
    
    return dateFormatter;
}

@end
