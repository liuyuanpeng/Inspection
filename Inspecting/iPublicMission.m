//
//  iPublicMission.m
//  Inspecting
//
//  Created by liuyuanpeng on 2017/3/1.
//  Copyright © 2017年 default. All rights reserved.
//

#import "iPublicMission.h"

@implementation iPublicMission

+ (iPublicMission *)getInstance {
    static dispatch_once_t onceToken;
    static iPublicMission *publicMission;
    dispatch_once(&onceToken, ^{
        publicMission = [[iPublicMission alloc] init];
    });
    return publicMission;
}

- (void)setData:(NSArray *)data {
    self.missionArray = [NSArray arrayWithArray:data];
}

@end
