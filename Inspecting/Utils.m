//
//  Utils.m
//  Inspecting
//
//  Created by liuyuanpeng on 2017/3/1.
//  Copyright © 2017年 default. All rights reserved.
//

#import "Utils.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import "AppDelegate.h"
#import <DYLocationConverter/DYLocationConverter.h>

@implementation Utils

+ (BOOL)cameraAccess {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
    {
        return NO;
    }
    return YES;
}

+ (BOOL)locationAccess {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return appDelegate.locationEnable;
}

+ (NSString *)getAddrCode {
    CLLocationCoordinate2D gcj02Coordinate = [self getMyCoordinate];
    CLLocationCoordinate2D coordinate = [DYLocationConverter bd09FromGcj02:gcj02Coordinate];
    return [NSString stringWithFormat:@"%.5f,%.5f",coordinate.latitude, coordinate.longitude];
}

+ (CLLocation *) getMyLocation {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return appDelegate.userLocation;
}

+ (CLLocationCoordinate2D) getMyCoordinate {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return appDelegate.userCoordinate;
}

+ (double) getDistance:(NSString *)addrcode {
    NSArray *titudeArray = [addrcode componentsSeparatedByString:@","];
    if (titudeArray.count != 2) {
        return 1.0;
    }
    double latitude = [[titudeArray objectAtIndex:0] doubleValue];
    double longtitude = [[titudeArray objectAtIndex:1] doubleValue];
    CLLocation *a = [[CLLocation alloc] initWithLatitude:latitude longitude:longtitude];
    a = [DYLocationConverter gcj02LocationFromBd09:a];
    CLLocation *b = [self getMyLocation];

    return [a distanceFromLocation:b]/1000;
}

+(BOOL)isAboveIOS11 {
    return [[UIDevice currentDevice].systemVersion integerValue] >= 11;
}

+(void)openLocationSetting:(UIViewController *) viewController{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"打开定位服务" message:@"巡检过程中，需要您允许访问您的位置" preferredStyle:UIAlertControllerStyleAlert];//UIAlertControllerStyleAlert视图在中央
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [viewController  presentViewController:alertController animated:YES completion:nil];
}

+(void)openUpdate:(UIViewController *) viewController{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"更新" message:@"您有新的版本，请前往APP Store更新" preferredStyle:UIAlertControllerStyleAlert];//UIAlertControllerStyleAlert视图在中央
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString  *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/us/app/id%@",@"1221434009"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [viewController  presentViewController:alertController animated:YES completion:nil];
}
@end
