//
//  GaugeCell.m
//  GaugesTouch
//
//  Created by Tyler Stromberg on 2/23/12.
//  Copyright (c) 2012 Tyler Stromberg. All rights reserved.
//

#import "GaugeCell.h"

#import "Gauge.h"

@interface GaugeCell()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *viewsCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *peopleCountLabel;

@end


#pragma mark -

@implementation GaugeCell

@synthesize gauge = _gauge;

@synthesize titleLabel = _titleLabel;
@synthesize viewsCountLabel = _viewsCountLabel;
@synthesize peopleCountLabel = _peopleCountLabel;

- (void)setGauge:(Gauge *)gauge
{
    if (![_gauge isEqual:gauge])
    {
        _gauge = gauge;
        
        // Update the various labels
        self.titleLabel.text = gauge.title;
        self.viewsCountLabel.text = @"12,891";  // TODO: Use real values
        self.peopleCountLabel.text = @"4,029";  // TODO: Use real values
    }
}

@end
