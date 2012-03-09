//
//  PageContent.h
//  GaugesTouch
//
//  Created by Tyler Stromberg on 3/7/12.
//  Copyright (c) 2012 Tyler Stromberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PageContent : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic) long views;
@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) NSString *url;

@end
