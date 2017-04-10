//
//  MKMapView+ZoomLevel.h
//  Inspecting
//
//  Created by liuyuanpeng on 2017/4/8.
//  Copyright © 2017年 default. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView (ZoomLevel)
- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;

- (MKCoordinateRegion)coordinateRegionWithMapView:(MKMapView *)mapView
                                 centerCoordinate:(CLLocationCoordinate2D)centerCoordinate
                                     andZoomLevel:(NSUInteger)zoomLevel;
- (NSUInteger)zoomLevel;

// Helper
+ (double)originXForLongitude:(double)longitude;
+ (double)originYForLatitude:(double)latitude;
+ (double)longitudeForOriginX:(double)originX;
+ (double)latitudeForOriginY:(double)originY;

+ (double)realWorldDistanceOfMapView:(MKMapView *)mapView;


@end
