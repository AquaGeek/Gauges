//
//  TrafficCell.h
//  GaugesTouch
//
//  Created by Tyler Stromberg on 3/7/12.
//  Copyright (c) 2012 Tyler Stromberg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DatedViewSummary;

@interface TrafficCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UILabel *viewsLabel;
@property (nonatomic, weak) IBOutlet UILabel *peopleLabel;

@property (nonatomic, strong) DatedViewSummary *traffic;

@end
