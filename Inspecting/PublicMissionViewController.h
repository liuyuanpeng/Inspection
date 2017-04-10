//
//  PublicMissionViewController.h
//  Inspecting
//
//  Created by liuyuanpeng on 2017/2/16.
//  Copyright © 2017年 default. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class NoneImageView;
@class IPopupView;

@interface PublicMissionViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate>

//公共任务列表
@property (nonatomic, strong) UITableView *tableView;

// 百度地图
@property (nonatomic, strong) MKMapView *mapView;

// 公共任务
@property (nonatomic, strong) UIView *missionView;

// 放大按钮
@property (nonatomic, strong) NoneImageView *noneZoomin;
@property (nonatomic, strong) UIButton *zoomIn;

// 缩小按钮
@property (nonatomic, strong) NoneImageView *noneZoomout;
@property (nonatomic, strong) UIButton *zoomOut;

// 地图泡泡标识
@property (nonatomic, strong) NSMutableArray *annotations;

// 地图内的弹出框
@property (nonatomic, strong) IPopupView *popupView;

@end
