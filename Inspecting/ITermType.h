//
//  ITermType.h
//  Inspecting
//
//  Created by liuyuanpeng on 2017/3/6.
//  Copyright © 2017年 default. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ITermType : NSObject

@property (nonatomic, strong) NSArray *types;

+ (ITermType *)getInstance;

- (void) requestTypes;

@end
