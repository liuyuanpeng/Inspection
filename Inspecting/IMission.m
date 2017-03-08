//
//  IMission.m
//  Inspecting
//
//  Created by liuyuanpeng on 2017/3/8.
//  Copyright © 2017年 default. All rights reserved.
//

#import "IMission.h"

@implementation IMission

- (id)init {
    self = [super init];
    if (self) {
        self.missions = [[NSMutableArray alloc]init];
    }
    return self;
}

+ (IMission *)getInstance {
    static dispatch_once_t onceToken;
    static IMission *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[IMission alloc] init];
    });
    return instance;
}

- (NSDictionary *)getCurMission {
    if (self.curSel == -1) {
        return nil;
    }
    return [self.missions objectAtIndex:self.curSel];
}

@end
