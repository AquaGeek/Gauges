//
//  TableManager.m
//  GaugesTouch
//
//  Created by Tyler Stromberg on 3/9/12.
//  Copyright (c) 2012 Tyler Stromberg. All rights reserved.
//

#import "TableManager.h"

@implementation TableManager

@synthesize title = _title;
@synthesize gauge = _gauge;
@synthesize tableHeaderView = _tableHeaderView;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    // Subclasses should override
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Subclasses should override
    return nil;
}

@end
