//
//  ITermType.m
//  Inspecting
//
//  Created by liuyuanpeng on 2017/3/6.
//  Copyright © 2017年 default. All rights reserved.
//

#import "ITermType.h"
#import "AFNRequestManager.h"

@implementation ITermType

+ (ITermType *)getInstance {
    static dispatch_once_t onceToken;
    static ITermType *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[ITermType alloc] init];
    });
    return instance;
}

- (void) requestTypes {
    [AFNRequestManager requestAFURL:@"getTermType.json" httpMethod:METHOD_POST params:nil succeed:^(NSDictionary *ret) {
        if (0 == [[ret objectForKey:@"status"] integerValue]) {
            // @"remark":name  @"term_type": type code
            self.types = [[NSArray alloc] initWithArray:[ret objectForKey:@"datas"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}
@end
