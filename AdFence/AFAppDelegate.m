//
//  AFAppDelegate.m
//  AdFence
//
//  Created by Michael Scaria on 1/4/14.
//  Copyright (c) 2014 MichaelScaria. All rights reserved.
//

#import "AFAppDelegate.h"
#import <FYX/FYX.h>

#import "TGAccessoryManager.h"
#import "M2x.h"

#import "AFViewController.h"

#define APP_ID @"ca120314eab2ae1462f41b5d39a54258b61528ed8514e3715e9666c3004f8b6c"
#define SECRET @"c2224d0eb70b4839701b3540b9d97b4a3ce908fc8e8f72771947e17ce5524fe1"
#define CALLBACK @"adfence://test"

@implementation AFAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
//    TGAccessoryType accessoryType = (TGAccessoryType)[[NSUserDefaults standardUserDefaults] integerForKey:@"accessory_type_preference"];
    
    // setup the TGAccessoryManager to dispatch dataReceived notifications every 0.05s (20 times per second)
    [[TGAccessoryManager sharedTGAccessoryManager] setupManagerWithInterval:0.05 forAccessoryType:TGAccessoryTypeDongle];

    // set the root UIViewController as the delegate object.
    [[TGAccessoryManager sharedTGAccessoryManager] setDelegate:(AFViewController *)self.window.rootViewController];
    [[TGAccessoryManager sharedTGAccessoryManager] setRawEnabled:YES];
    
    [FYX setAppId:APP_ID appSecret:SECRET callbackUrl:CALLBACK];
    
    M2x* m2x = [M2x shared];
    //set the Master Api Key
    m2x.api_key = @"e25333763bac942da7c38635c3581478";
    //set the api url
//    m2x.api_url = @"http://api-m2x.att.com/v1/feeds/695945db9bf748a9abb9cf8d6a1bfb6c";
    m2x.api_url = @"695945db9bf748a9abb9cf8d6a1bfb6c";
    return YES;
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
    [[TGAccessoryManager sharedTGAccessoryManager] teardownManager];
}

@end
