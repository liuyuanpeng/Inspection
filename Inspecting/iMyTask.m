//
//  iMyTask.m
//  Inspecting
//
//  Created by liuyuanpeng on 2017/3/2.
//  Copyright © 2017年 default. All rights reserved.
//

#import "iMyTask.h"

@implementation iMyTask

+ (iMyTask *)getInstance {
    static dispatch_once_t onceToken;
    static iMyTask *myTask;
    dispatch_once(&onceToken, ^{
        myTask = [[iMyTask alloc] init];
    });
    return myTask;
}

@end
