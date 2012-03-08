//
//  NSDateFormatter+Additions.h
//  GaugesTouch
//
//  Created by Tyler Stromberg on 3/7/12.
//  Copyright (c) 2012 Tyler Stromberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (Additions)

+ (NSString *)localizedStringFromDate:(NSDate *)date withTemplate:(NSString *)formatTemplate;

@end
