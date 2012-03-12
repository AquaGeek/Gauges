//
//  PageContent.m
//  GaugesTouch
//
//  Created by Tyler Stromberg on 3/7/12.
//  Copyright (c) 2012 Tyler Stromberg. All rights reserved.
//

#import "PageContent.h"

@interface PageContent()

@property (nonatomic, strong, readonly) NSNumberFormatter *numberFormatter;

@end


#pragma mark -

@implementation PageContent

@synthesize title = _title;
@synthesize views = _views;
@synthesize path = _path;
@synthesize url = _url;

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if ((self = [super init]))
    {
        _title = [dictionary objectForKey:@"title"];
        _views = [[dictionary objectForKey:@"views"] longValue];
        _path = [dictionary objectForKey:@"path"];
        _url = [dictionary objectForKey:@"url"];
    }
    
    return self;
}

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
