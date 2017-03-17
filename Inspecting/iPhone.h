//
//  iPhone.h
//  Inspecting
//  获取设备信息
//  Created by liuyuanpeng on 2017/2/27.
//  Copyright © 2017年 default. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iPhone : NSObject

+ (NSString *)getIMSI;
+ (NSString *)getIMEI;

@end
