//
//  NSDateFormatter+Additions.m
//  GaugesTouch
//
//  Created by Tyler Stromberg on 3/7/12.
//  Copyright (c) 2012 Tyler Stromberg. All rights reserved.
//

#import "NSDateFormatter+Additions.h"

@implementation NSDateFormatter (Additions)

+ (NSString *)localizedStringFromDate:(NSDate *)date withTemplate:(NSString *)formatTemplate
{
    static NSDateFormatter *formatter = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
    });
    
    NSString *format = [self dateFormatFromTemplate:formatTemplate options:0 locale:[NSLocale autoupdatingCurrentLocale]];
    [formatter setDateFormat:format];
    
    return [formatter stringFromDate:date];
}

@end
