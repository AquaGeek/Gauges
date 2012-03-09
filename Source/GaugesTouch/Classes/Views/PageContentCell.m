//
//  PageContentCell.m
//  GaugesTouch
//
//  Created by Tyler Stromberg on 3/9/12.
//  Copyright (c) 2012 Tyler Stromberg. All rights reserved.
//

#import "PageContentCell.h"

#import "PageContent.h"

@interface PageContentCell()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *viewsLabel;
@property (nonatomic, weak) IBOutlet UILabel *pathLabel;

@end


#pragma mark -

@implementation PageContentCell

@synthesize pageContent = _pageContent;

@synthesize titleLabel = _titleLabel;
@synthesize viewsLabel = _viewsLabel;
@synthesize pathLabel = _pathLabel;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self addObserver:self forKeyPath:@"pageContent.title" options:0 context:NULL];
        [self addObserver:self forKeyPath:@"pageContent.views" options:0 context:NULL];
        [self addObserver:self forKeyPath:@"pageContent.path" options:0 context:NULL];
    }
    
    return self;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"pageContent.title"];
    [self removeObserver:self forKeyPath:@"pageContent.views"];
    [self removeObserver:self forKeyPath:@"pageContent.path"];
}


#pragma mark -

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"pageContent.title"])
    {
        self.titleLabel.text = self.pageContent.title;
    }
    else if ([keyPath isEqualToString:@"pageContent.views"])
    {
        self.viewsLabel.text = [self.pageContent formattedViews];
    }
    else if ([keyPath isEqualToString:@"pageContent.path"])
    {
        self.pathLabel.text = self.pageContent.path;
    }
}

@end
