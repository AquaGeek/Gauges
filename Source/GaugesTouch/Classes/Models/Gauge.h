//
//  Gauge.h
//  GaugesTouch
//
//  Created by Tyler Stromberg on 2/22/12.
//  Copyright (c) 2012 Tyler Stromberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Gauge : NSObject

@property (nonatomic, strong) NSString *gaugeID;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *timeZoneName;
@property (nonatomic, strong, getter = isEnabled) BOOL enabled;

@end
