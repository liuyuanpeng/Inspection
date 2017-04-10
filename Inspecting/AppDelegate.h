//
//  AppDelegate.h
//  Inspecting
//
//  Created by liuyuanpeng on 2017/2/15.
//  Copyright © 2017年 default. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) CLLocation* userLocation;
@property (assign, nonatomic) CLLocationCoordinate2D userCoordinate;
@property (assign, nonatomic) BOOL locationEnable;

@end
