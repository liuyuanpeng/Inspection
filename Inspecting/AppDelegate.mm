//
//  AppDelegate.m
//  Inspecting
//
//  Created by liuyuanpeng on 2017/2/15.
//  Copyright © 2017年 default. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"

// use for bundle identifier: default.inspecting
// #define BMKKey @"r6olmS6fnA5WRqnO7nSeIDTcULYYN33A"
#define BMKKey @"M65qGxyRTKVXPV0ihcF2VVdBZxXDiTxa"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [self.mapManager start:BMKKey generalDelegate:nil];
    if (!ret) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"locationAccess"];
        NSLog(@"baidu map manager opend failure.");
    }
    else {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"locationAccess"];
        self.locService = [[BMKLocationService alloc] init];
        self.locService.delegate = self;
        
        self.locService.distanceFilter = 20;
        
        self.locService.allowsBackgroundLocationUpdates = NO;
        
        [self.locService startUserLocationService];
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[LoginViewController alloc] init];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self.locService stopUserLocationService];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [self.locService startUserLocationService];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
}

#pragma mark - BMKLocationService Delegate Implementation
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    [[NSUserDefaults standardUserDefaults] setDouble:userLocation.location.coordinate.latitude forKey:@"latitude"];
    [[NSUserDefaults standardUserDefaults] setDouble:userLocation.location.coordinate.longitude forKey:@"longtitude"];
}

@end
