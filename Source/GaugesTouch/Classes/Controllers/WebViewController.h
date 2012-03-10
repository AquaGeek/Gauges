//
//  WebViewController.h
//  GaugesTouch
//
//  Created by Tyler Stromberg on 3/9/12.
//  Copyright (c) 2012 Tyler Stromberg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong) NSString *urlString;

@end
