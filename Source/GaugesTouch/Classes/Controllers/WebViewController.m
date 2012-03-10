//
//  WebViewController.m
//  GaugesTouch
//
//  Created by Tyler Stromberg on 3/9/12.
//  Copyright (c) 2012 Tyler Stromberg. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController()

@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *reloadItem;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *stopItem;
@property (nonatomic, weak) IBOutlet UIButton *backButton;
@property (nonatomic, weak) IBOutlet UIButton *forwardButton;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)openInSafariTapped:(id)sender;

@end


#pragma mark -

@implementation WebViewController

@synthesize webView = _webView;
@synthesize reloadItem = _reloadItem;
@synthesize stopItem = _stopItem;
@synthesize backButton = _backButton;
@synthesize forwardButton = _forwardButton;
@synthesize activityIndicator = _activityIndicator;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Remove the stop item from the nav bar - we just set it up that way because it's easiest
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.apple.com"]]];
}

#pragma mark Button Actions

- (IBAction)openInSafariTapped:(id)sender
{
    // TODO: Open the URL in Mobile Safari
}


#pragma mark - UIWebView Delegate Methods

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    // Swap out the reload button for the stop button
    self.navigationItem.rightBarButtonItem = self.stopItem;
    
    [self.activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // Swap out the stop button for the reload button
    self.navigationItem.rightBarButtonItem = self.reloadItem;
    
    [self.activityIndicator stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    // TODO: Anything?
}

@end
