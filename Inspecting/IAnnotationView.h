//
//  IAnnotationView.h
//  Inspecting
//
//  Created by liuyuanpeng on 2017/4/8.
//  Copyright © 2017年 default. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface IAnnotationView : MKAnnotationView
@property (strong, nonatomic) UIImageView *imageView;
@end
