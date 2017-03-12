//
//  IAnnotation.h
//  Inspecting
//
//  Created by liuyuanpeng on 2017/3/12.
//  Copyright © 2017年 default. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKPointAnnotation.h>

@interface IAnnotation : BMKPointAnnotation
@property (nonatomic, assign) NSInteger tag;
@end
