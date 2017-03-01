//
//  iPhone.m
//  Inspecting
//
//  Created by liuyuanpeng on 2017/2/27.
//  Copyright © 2017年 default. All rights reserved.
//

#import "iPhone.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <UIKit/UIKit.h>

@implementation iPhone

+ (NSString *)getIMSI {
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = networkInfo.subscriberCellularProvider;
    if (carrier) {
        return carrier.mobileNetworkCode;
    }
    return @"12345678";
    
}

+ (NSString *)getIMEI {
    return [NSString stringWithFormat:@"%@", [[[UIDevice currentDevice] identifierForVendor] UUIDString]];
}

@end
