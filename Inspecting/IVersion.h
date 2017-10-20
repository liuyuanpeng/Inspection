//
//  IVersion.h
//  Inspecting
//
//  Created by liuyuanpeng on 2017/3/13.
//  Copyright © 2017年 default. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IVersion : NSObject
@property (nonatomic, strong) NSString *lastVersion;
@property (nonatomic, strong) NSString *version;
+ (IVersion *)getInstance;
@end
