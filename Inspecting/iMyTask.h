//
//  iMyTask.h
//  Inspecting
//
//  Created by liuyuanpeng on 2017/3/2.
//  Copyright © 2017年 default. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iMyTask : NSObject

@property (nonatomic, strong) NSString *taskcode;
@property (nonatomic, strong) NSString *taskname;

+ (iMyTask *)getInstance;

@end
