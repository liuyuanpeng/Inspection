//
//  IVersion.m
//  Inspecting
//
//  Created by liuyuanpeng on 2017/3/13.
//  Copyright © 2017年 default. All rights reserved.
//

#import "IVersion.h"
#import "AFNRequestManager.h"
@implementation IVersion

+ (IVersion *)getInstance {
    static dispatch_once_t onceToken;
    static IVersion *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[IVersion alloc] init];
//        [AFNRequestManager requestAFURL:@"getVersion.json" httpMethod:METHOD_POST params:nil succeed:^(NSDictionary *ret) {
//            if (0 ==  [[ret objectForKey:@"status"] integerValue]) {
//                instance.version = [NSString stringWithString:[ret objectForKey:@""]];
//            }
//        } failure:^(NSError *error) {
//            NSLog(@"%@", error);
//        }];
    });
    return instance;
}

@end
