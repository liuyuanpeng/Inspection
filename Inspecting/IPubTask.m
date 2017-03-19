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
        instance.inspPubArray = [[NSMutableArray alloc] init];
    });
    return instance;
}

- (void)generate {
    if (self.inspPubArray.count > 0) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        NSMutableArray *contentArray = [[NSMutableArray alloc] initWithCapacity:self.inspPubArray.count];
        for (NSDictionary *dict in self.inspPubArray) {
            NSArray *picInfos = (NSArray *)[dict objectForKey:@"pics"];
            [contentArray addObject:@{
                                     @"content": [dict objectForKey:@"content"],
                                     @"step": [dict objectForKey:@"step"],
                                     @"flag":@1
                                     }];
            if (picInfos) {
                for (NSDictionary *picDict in picInfos) {
                    NSMutableDictionary *picInfo = [[NSMutableDictionary alloc] initWithCapacity:3];
                    [picInfo setObject:[dict objectForKey:@"step"] forKey:@"step"];
                    [picInfo setObject:[picDict objectForKey:@"oldfile"] forKey:@"oldfile"];
                    if ([picDict objectForKey:@"file"]) {
                        [picInfo setObject:[picDict objectForKey:@"file"] forKey:@"file"];
                    }
                    [array addObject:picInfo];
                }
            }
        }
        self.generatePics = [[NSArray alloc] initWithArray:array];
        self.generateContents = [[NSArray alloc] initWithArray:contentArray];
    }
}

- (NSDictionary *)getStepInfoByStep:(NSInteger)step {
    if (self.stepArray && self.stepArray.count >= step) {
        for (NSDictionary *dict in self.stepArray) {
            if ([[dict objectForKey:@"step"] integerValue] == step) {
                return dict;
            }
        }
    }
    return nil;
}
@end
