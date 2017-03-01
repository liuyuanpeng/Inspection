//
//  Utils.m
//  Inspecting
//
//  Created by liuyuanpeng on 2017/3/1.
//  Copyright © 2017年 default. All rights reserved.
//

#import "Utils.h"
#import <BaiduMapAPI_Utils/BMKGeometry.h>

@implementation Utils

+ (NSString *)getAddrCode {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    return [NSString stringWithFormat:@"%f,%f",[user doubleForKey:@"latitude"], [user doubleForKey:@"longtitude"]];
}

+ (double) getDistance:(NSString *)addrcode {
    NSArray *titudeArray = [addrcode componentsSeparatedByString:@","];
    if (titudeArray.count != 2) {
        return 1.0;
    }
    double latitude = [[titudeArray objectAtIndex:0] doubleValue];
    double longtitude = [[titudeArray objectAtIndex:1] doubleValue];
    BMKMapPoint a, b;
    a.x = latitude;
    a.y = longtitude;
    b.x = [[NSUserDefaults standardUserDefaults] doubleForKey:@"latitude"];
    b.y = [[NSUserDefaults standardUserDefaults] doubleForKey:@"longtitude"];
    return BMKMetersBetweenMapPoints(a, b);
}

@end
