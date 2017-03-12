//
//  PublicMissionViewController.h
//  Inspecting
//
//  Created by liuyuanpeng on 2017/2/16.
//  Copyright © 2017年 default. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapView.h>

@class NoneImageView;
@class IPopupView;

@interface PublicMissionViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, BMKMapViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic, strong) UIView *missionView;
@property (nonatomic, strong) NoneImageView *noneZoomin;
@property (nonatomic, strong) NoneImageView *noneZoomout;
@property (nonatomic, strong) UIButton *zoomIn;
@property (nonatomic, strong) UIButton *zoomOut;
@property (nonatomic, strong) NSMutableArray *annotations;
@property (nonatomic, strong) IPopupView *popupView;

@end
