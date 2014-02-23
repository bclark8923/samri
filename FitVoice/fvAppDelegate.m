//
//  fvAppDelegate.m
//  FitVoice
//
//  Created by Brian Clark on 11/13/13.
//  Copyright (c) 2013 FitVoice. All rights reserved.
//

#import "fvAppDelegate.h"
#import "fvViewController.h"
#import "fvFacebookLoginViewController.h"
#import "Flurry.h"
#import <Parse/Parse.h>
#import <Appsee/Appsee.h>
#import <AnnoTree/AnnoTree.h>
#import "Heap.h"
#import "Analytics.h"
#import "swizzleAnalytics.h"

@implementation fvAppDelegate

@synthesize window;

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //[[AnnoTree sharedInstance] loadAnnoTree:@"ca8a2aee665e81db47e7a505c68f2764b02ba5fed1bbf6278bf082be5dfe9292"];
    // Override point for customization after application launch.
    
    //self.window = [[myAnalyticsWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //swizzleAnalytics *newAnalytics = [[swizzleAnalytics alloc] init];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [Parse setApplicationId:@"IGAmaQMQbGC1DePnG0aaYqkdIyf1ZKkxLIw7hC4q"
                  clientKey:@"XHOOPDOQL0Vc32bAOzUtWyQZcG3L59j17KFYbF69"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    [PFFacebookUtils initializeFacebook];
    
    //[[Heap sharedInstance] setAppId:@"3465098721"];
    
    //[Flurry setCrashReportingEnabled:NO];
    //note: iOS only allows one crash reporting tool per app; if using another, set to: NO
    //[Flurry startSession:@"4V7MGQFZYMF6D9X6Y9QR"];
    
    //[Appsee start:@"5da342884878429dba1e0f4f552495a1"];
    
    [[Analytics sharedInstance] launch:@"five"];
    
    /*
    fvFacebookLoginViewController *nextViewController = [[fvFacebookLoginViewController alloc] initWithNibName:nil bundle:nil];

    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:nextViewController];
    [window makeKeyAndVisible];
    [window addSubview:navController.view];
    */
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [PFFacebookUtils handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [PFFacebookUtils handleOpenURL:url];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
