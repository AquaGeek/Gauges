//
//  TableManager.h
//  GaugesTouch
//
//  Created by Tyler Stromberg on 3/9/12.
//  Copyright (c) 2012 Tyler Stromberg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Gauge;

@interface TableManager : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) Gauge *gauge;

@end
