//
//  IPubTask.h
//  Inspecting
//  自定义任务Model
//  Created by liuyuanpeng on 2017/3/18.
//  Copyright © 2017年 default. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^complete)(BOOL status);

@interface IPubTask : NSObject
// 详细步骤
@property(nonatomic, strong) NSArray *stepArray;

#pragma mark - Instance Method
- (NSDictionary *)getStepInfoByIndex:(NSInteger)index;

#pragma mark - Class Method
+ (IPubTask *)shareInstance;
@end
