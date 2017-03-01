//
//  iInst.m
//  Inspecting
//
//  Created by liuyuanpeng on 2017/2/28.
//  Copyright © 2017年 default. All rights reserved.
//

#import "iInst.h"

@implementation iInst

- (iInst *)getInstance {
    static dispatch_once_t oneceToken;
    static iInst *setSharedInstance;
    dispatch_once(&oneceToken, ^{
        setSharedInstance = [[iInst alloc] init];
    });
    return setSharedInstance;
}

@end
