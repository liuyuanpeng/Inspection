//
//  iPublicMission.h
//  Inspecting
//
//  Created by liuyuanpeng on 2017/3/1.
//  Copyright © 2017年 default. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iPublicMission : NSObject

@property (nonatomic, strong) NSArray *missionArray;

+ (iPublicMission *)getInstance;
- (void)setData:(NSArray *)data;

@end
