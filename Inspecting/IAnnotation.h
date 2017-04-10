//
//  IAnnotation.h
//  Inspecting
//
//  Created by liuyuanpeng on 2017/3/12.
//  Copyright © 2017年 default. All rights reserved.
//
#import <MapKit/MapKit.h>
@interface IAnnotation : MKPointAnnotation
@property (nonatomic, assign) NSInteger tag;
@end
