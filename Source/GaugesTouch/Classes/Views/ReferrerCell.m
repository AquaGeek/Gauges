//
//  ReferrerCell.m
//  GaugesTouch
//
//  Created by Tyler Stromberg on 3/9/12.
//  Copyright (c) 2012 Tyler Stromberg. All rights reserved.
//

#import "ReferrerCell.h"

#import "Referrer.h"

@interface ReferrerCell()

@property (nonatomic, weak) IBOutlet UILabel *hostLabel;
@property (nonatomic, weak) IBOutlet UILabel *viewsLabel;
@property (nonatomic, weak) IBOutlet UILabel *pathLabel;

- (void)updateLabelShadows;

@end


#pragma mark -

@implementation ReferrerCell

@synthesize referrer = _referrer;

@synthesize hostLabel = _hostLabel;
@synthesize viewsLabel = _viewsLabel;
@synthesize pathLabel = _pathLabel;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self addObserver:self forKeyPath:@"referrer.host" options:0 context:NULL];
        [self addObserver:self forKeyPath:@"referrer.views" options:0 context:NULL];
        [self addObserver:self forKeyPath:@"referrer.path" options:0 context:NULL];
    }
    
    return self;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"referrer.host"];
    [self removeObserver:self forKeyPath:@"referrer.views"];
    [self removeObserver:self forKeyPath:@"referrer.path"];
}


#pragma mark -

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    [self updateLabelShadows];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    [self updateLabelShadows];
}

- (void)updateLabelShadows
{
    UIColor *shadowColor = (self.highlighted || self.selected) ? nil : [UIColor whiteColor];
    self.hostLabel.shadowColor = shadowColor;
    self.viewsLabel.shadowColor = shadowColor;
    self.pathLabel.shadowColor = shadowColor;
}


#pragma mark -

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"referrer.host"])
    {
        self.hostLabel.text = self.referrer.host;
    }
    else if ([keyPath isEqualToString:@"referrer.views"])
    {
        self.viewsLabel.text = [self.referrer formattedViews];
    }
    else if ([keyPath isEqualToString:@"referrer.path"])
    {
        self.pathLabel.text = self.referrer.path;
    }
}

@end
