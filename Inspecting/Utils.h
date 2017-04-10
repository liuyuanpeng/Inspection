//
//  Utils.h
//  Inspecting
//
//  Created by liuyuanpeng on 2017/3/1.
//  Copyright © 2017年 default. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Utils : NSObject

/**
 获取当前位置经纬度编码

 @return 格式：@"经度,纬度"
 */
+ (NSString *)getAddrCode;


/**
 获取经纬度编码到当前位置的距离

 @param addrcode 经纬度编码
 @return 距离
 */
+ (double) getDistance:(NSString *)addrcode;


/**
 获取我的位置

 @return 结构体
 */
+ (CLLocation *) getMyLocation;

+ (CLLocationCoordinate2D)getMyCoordinate;


/**
 获取相机使用权限

 @return YES: 已经授权， NO: 未授权
 */
+ (BOOL)cameraAccess;


/**
 获取位置信息使用权限

 @return YES: 已授权 NO: 未授权
 */
+ (BOOL)locationAccess;

@end
