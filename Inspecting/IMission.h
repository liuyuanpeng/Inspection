//
//  IMission.h
//  Inspecting
//
//  Created by liuyuanpeng on 2017/3/8.
//  Copyright © 2017年 default. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMission : NSObject

@property (nonatomic, strong) NSMutableArray *missions;
@property (nonatomic, assign) NSInteger curSel;
@property (nonatomic, assign) BOOL needupdate;

+ (IMission *)getInstance;
- (NSDictionary *)getCurMission;

@end
