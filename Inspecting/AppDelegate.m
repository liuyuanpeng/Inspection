//
//  AppDelegate.m
//  Inspecting
//
//  Created by liuyuanpeng on 2017/2/15.
//  Copyright © 2017年 default. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import <DYLocationConverter/DYLocationConverter.h>
#import "MKMapView+ZoomLevel.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 50.0f;
    SEL selector = NSSelectorFromString(@"requestWhenInUseAuthorization");
    if ([self.locationManager respondsToSelector:selector]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
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
    [self.locationManager stopUpdatingLocation];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [self.locationManager startUpdatingLocation];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
}

#pragma mark - CLLocationManagerDelegate Implement
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    CLLocation* location = [locations firstObject];
    
    self.userLocation = [DYLocationConverter gcj02LocationFromWgs84:location];
    
    CLLocationCoordinate2D theCoordinate;
    theCoordinate.latitude = self.userLocation.coordinate.latitude;
    theCoordinate.longitude = self.userLocation.coordinate.longitude;
    NSLog(@"latitude:%fr, longtitude:%f", theCoordinate.latitude, theCoordinate.longitude);
    self.userCoordinate = theCoordinate;
    if (self.mapView) {
        [self.mapView setCenterCoordinate:theCoordinate zoomLevel:self.mapView.zoomLevel animated:YES];
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
            case kCLAuthorizationStatusDenied:
            case kCLAuthorizationStatusRestricted:
            self.locationEnable = false;
            break;
            case kCLAuthorizationStatusNotDetermined:
            self.locationEnable = false;
            [self.locationManager requestWhenInUseAuthorization];
            break;
        default:
            self.locationEnable = true;
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"error:%@", error);
}

@end
