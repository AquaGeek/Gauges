//
//  AppDelegate.m
//  GaugesTouch
//
//  Created by Tyler Stromberg on 2/22/12.
//  Copyright (c) 2012 Tyler Stromberg. All rights reserved.
//

#import "AppDelegate.h"

#import "AFNetworking.h"
#import "User.h"

@implementation AppDelegate

@synthesize window = _window;

- (id)init
{
    if ((self = [super init]))
    {
        // Set up any appearance proxies
        UIImage *bgImage = [UIImage imageNamed:@"nav_bar_bg"]; //([UIScreen mainScreen].scale > 1.0f) ? 
        NSLog(@"Image: %@", NSStringFromCGSize(bgImage.size));
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav_bar_bg"] forBarMetrics:UIBarMetricsDefault];
    }
    
    return self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UINavigationController *navController = [mainStoryboard instantiateInitialViewController];
    
    // Check if logged in or not and adjust the nav stack accordingly
    if ([User currentUser] != nil)
    {
        NSMutableArray *viewControllers = [navController.viewControllers mutableCopy];
        UIViewController *listVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"ListView"];
        [viewControllers addObject:listVC];
        navController.viewControllers = viewControllers;
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain
     types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits
     the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games
     should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application
     state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate:
     when the user quits.
     */
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the
     changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application
     was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
