//
//  Utils.h
//  Inspecting
//
//  Created by liuyuanpeng on 2017/3/1.
//  Copyright © 2017年 default. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Utils/BMKGeometry.h>

@interface Utils : NSObject

+ (NSString *)getAddrCode;
+ (double) getDistance:(NSString *)addrcode;
+ (CLLocationCoordinate2D) getMyLocation;
+ (BOOL)cameraAccess;
+ (BOOL)locationAccess;

@end
