//
//  IPubTask.m
//  Inspecting
//
//  Created by liuyuanpeng on 2017/3/18.
//  Copyright © 2017年 default. All rights reserved.
//

#import "IPubTask.h"

@implementation IPubTask

+ (IPubTask *)shareInstance {
    static IPubTask *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[IPubTask alloc] init];
    });
    return instance;
}

- (NSDictionary *)getStepInfoByIndex:(NSInteger)index {
    if (self.stepArray && self.stepArray.count > index) {
        for (NSDictionary *dict in self.stepArray) {
            if ([[dict objectForKey:@"step"] integerValue] == index) {
                return dict;
            }
        }
    }
    return nil;
}
@end
