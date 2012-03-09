//
//  Referrer.m
//  GaugesTouch
//
//  Created by Tyler Stromberg on 3/9/12.
//  Copyright (c) 2012 Tyler Stromberg. All rights reserved.
//

#import "Referrer.h"

@interface Referrer()

@property (nonatomic, strong, readonly) NSNumberFormatter *numberFormatter;

@end


#pragma mark -

@implementation Referrer

@synthesize host = _host;
@synthesize views = _views;
@synthesize path = _path;
@synthesize url = _url;

- (NSNumberFormatter *)numberFormatter
{
    static NSNumberFormatter *numberFormatter = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    });
    
    return numberFormatter;
}

- (NSString *)formattedViews
{
    return [self.numberFormatter stringFromNumber:[NSNumber numberWithLong:self.views]];
}

@end
