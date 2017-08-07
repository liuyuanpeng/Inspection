//
//  PublicMissionViewController.m
//  Inspecting
//
//  Created by liuyuanpeng on 2017/2/16.
//  Copyright © 2017年 default. All rights reserved.
//

#import "PublicMissionViewController.h"
#import "IPublicTableViewCell.h"
#import "IPublicMissionView.h"
#import "iUser.h"
#import "AFNRequestManager.h"
#import "Utils.h"
#import "iPublicMission.h"
#import "NoneImageView.h"
#import <Toast/UIView+Toast.h>
#import "AppDelegate.h"
#import "IAnnotation.h"
#import "IAnnotationView.h"
#import "IPopupView.h"
#import "MKMapView+ZoomLevel.h"
#import <DYLocationConverter/DYLocationConverter.h>

#define MAX_ZOOM_LEVEL 18
#define MIN_ZOOM_LEVEL 10

@interface PublicMissionViewController ()

@end

@implementation PublicMissionViewController

- (void)viewDidLoad {
    [super viewDidLoad];    self.view.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    CGRect rNav = self.navigationController.navigationBar.frame;
    CGRect rScreen = [[UIScreen mainScreen] bounds];
    CGRect rView =CGRectMake(0, rNav.origin.y + rNav.size.height, rScreen.size.width, rScreen.size.height - rNav.origin.y - rNav.size.height - self.tabBarController.tabBar.frame.size.height);
    
    self.mapView = [[MKMapView alloc] initWithFrame:rView];
    self.mapView.delegate = self;
    self.mapView.zoomEnabled = YES;
    self.mapView.rotateEnabled = NO;
    self.mapView.pitchEnabled = NO;
    if ([[UIDevice currentDevice] systemVersion].floatValue >= 9.0) {
        self.mapView.showsScale = YES;
    }
    [self.mapView setShowsUserLocation:YES];
    self.mapView.showsPointsOfInterest = YES;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.mapView = self.mapView;
    [self.mapView setCenterCoordinate:appDelegate.userCoordinate zoomLevel:16 animated:NO];
    
    self.missionView = [[UIView alloc] initWithFrame:rView];
    self.missionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.mapView];
    [self.mapView setHidden:YES];
    [self.view addSubview:self.missionView];
    [self.missionView setHidden:NO];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,  rScreen.size.width, 30)];
    titleLabel.text = @"公共任务";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLabel;
    
    UIButton *buttonLocation = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonLocation.frame = CGRectMake(0, 0, 24, 24);
    [buttonLocation setBackgroundImage:[UIImage imageNamed:@"i_location.png"] forState:UIControlStateNormal];
    [buttonLocation addTarget:self action:@selector(onLocate:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:buttonLocation];
    self.navigationItem.rightBarButtonItem = barItem;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, rScreen.size.width, rScreen.size.height - rNav.origin.y - rNav.size.height - self.tabBarController.tabBar.frame.size.height) style:UITableViewStylePlain];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.missionView addSubview:self.tableView];
    
    self.zoomIn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.zoomOut = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.zoomOut setBackgroundImage:[UIImage imageNamed:@"main_bottombtn_up.9.png"] forState:UIControlStateNormal];
    [self.zoomOut setBackgroundImage:[UIImage imageNamed:@"main_bottombtn_down.9.png"] forState:UIControlStateSelected];
    [self.zoomIn setBackgroundImage:[UIImage imageNamed:@"main_topbtn_up.9.png"] forState:UIControlStateNormal];
    [self.zoomIn setBackgroundImage:[UIImage imageNamed:@"main_topbtn_down.9.png"] forState:UIControlStateDisabled];
    
    CGRect rMap = self.mapView.frame;
    self.zoomOut.frame = CGRectMake(rMap.size.width - 60, rMap.size.height - 60, 40, 40);
    self.zoomIn.frame = CGRectMake(rMap.size.width - 60, rMap.size.height - 100, 40, 40);
    [self.zoomIn addTarget:self action:@selector(onZoomIn:) forControlEvents:UIControlEventTouchUpInside];
    [self.zoomOut addTarget:self action:@selector(onZoomOut:) forControlEvents:UIControlEventTouchUpInside];
    [self.mapView addSubview:self.zoomIn];
    [self.mapView addSubview:self.zoomOut];
    
    self.noneZoomin = [[NoneImageView alloc] init];
    self.noneZoomout = [[NoneImageView alloc] init];
    self.noneZoomout.frame = CGRectMake(rMap.size.width - 55, rMap.size.height - 55, 30, 30);
    self.noneZoomin.frame = CGRectMake(rMap.size.width - 55, rMap.size.height - 95, 30, 30);
    self.noneZoomin.image = [UIImage imageNamed:@"main_icon_zoomin.png"];
    self.noneZoomout.image = [UIImage imageNamed:@"main_icon_zoomout.png"];
    [self.mapView addSubview:self.noneZoomout];
    [self.mapView addSubview:self.noneZoomin];
    
    UIButton *myLocationBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    myLocationBtn.frame = CGRectMake(rMap.size.width - 55, rMap.size.height - 140, 30, 30);
    [myLocationBtn setBackgroundImage:[UIImage imageNamed:@"my_location.png"] forState:UIControlStateNormal];
    [myLocationBtn addTarget:self action:@selector(onLocate) forControlEvents:UIControlEventTouchUpInside];
    [self.mapView addSubview:myLocationBtn];
    
    self.annotations = [[NSMutableArray alloc] init];
    
    self.popupView = [[IPopupView alloc] init];
    IPublicMissionView *publicMissionView = [[IPublicMissionView alloc] init];
    publicMissionView.frame = CGRectMake(10, rScreen.size.height/2 - 70, rScreen.size.width - 20, 140);
    self.popupView.contentView = publicMissionView;
    [publicMissionView.statusButton addTarget:self action:@selector(onLockTask:) forControlEvents:UIControlEventTouchUpInside];
}

- (IBAction) onLocate {
    [self.mapView setCenterCoordinate:[Utils getMyCoordinate] zoomLevel:16 animated:YES];
}


/**
 获取随机数
 
 @return 随机经纬度
 */
- (double)getRandom {
    return (arc4random()%1000)/10000.0 - 0.05;
}


/**
 更新地图泡泡
 */
- (void)recreateAnnotation {
    if (self.annotations.count > 0) {
        // 移除原来的所有泡泡
        [self.mapView removeAnnotations:self.annotations];
        [self.annotations removeAllObjects];
    }
    
    // 获取公共任务列表数据
    NSArray *missionArray = [iPublicMission getInstance].missionArray;
    
    // 逐一添加到地图
    for (NSInteger i = 0; i < missionArray.count; i++) {
        NSDictionary *dict = [missionArray objectAtIndex:i];
        IAnnotation *annotation=[[IAnnotation alloc]init];
        annotation.tag = i;
        NSArray *array = [[dict objectForKey:@"addrcode"] componentsSeparatedByString:@","];
        if (array.count != 2) {
            array = [[Utils getAddrCode] componentsSeparatedByString:@","];
            annotation.coordinate = CLLocationCoordinate2DMake([[array objectAtIndex:0] doubleValue] + [self getRandom], [[array objectAtIndex:1] doubleValue] + [self getRandom]);
        }
        else {
            annotation.coordinate = [DYLocationConverter gcj02FromBd09: CLLocationCoordinate2DMake([[array objectAtIndex:0] doubleValue], [[array objectAtIndex:1] doubleValue])];
        }
        
        [self.annotations addObject:annotation];
    }
    [self.mapView addAnnotations:self.annotations];
}


/**
 切换地图和公共任务列表
 
 @param sender 按钮对象
 */
- (IBAction)onLocate:(id)sender {
    if ([Utils locationAccess]) {
        [self.missionView setHidden:!self.missionView.isHidden];
        [self.mapView setHidden:!self.mapView.isHidden];
    }
    else {
        [self.view makeToast:@"请先开启定位服务!" duration:2 position:CSToastPositionCenter];
    }
}


/**
 放大地图
 
 @param sender 放大按钮
 */
- (IBAction)onZoomIn:(id)sender {
    float currentZoomLevel  =  self.mapView.zoomLevel;
    if (currentZoomLevel == MAX_ZOOM_LEVEL) {
        return;
    }
    if (currentZoomLevel == MIN_ZOOM_LEVEL) {
        self.noneZoomout.image = [UIImage imageNamed:@"main_icon_zoomout.png"];
        [self.zoomOut setEnabled:YES];
    }
    currentZoomLevel += 1;
    if (currentZoomLevel >= MAX_ZOOM_LEVEL) {
        self.noneZoomin.image = [UIImage imageNamed:@"main_icon_zoomin_dis.png"];
        [self.zoomIn setEnabled:NO];
        currentZoomLevel = MAX_ZOOM_LEVEL;
    }
    [self.mapView setCenterCoordinate:self.mapView.centerCoordinate zoomLevel:currentZoomLevel animated:YES];
}


/**
 缩小地图
 
 @param sender 缩小按钮
 */
- (IBAction)onZoomOut:(id)sender {
    float currentZoomLevel = self.mapView.zoomLevel;
    if (currentZoomLevel == MIN_ZOOM_LEVEL) {
        return;
    }
    if (currentZoomLevel == MAX_ZOOM_LEVEL) {
        self.noneZoomin.image = [UIImage imageNamed:@"main_icon_zoomin.png"];
        [self.zoomIn setEnabled:YES];
    }
    currentZoomLevel -= 1;
    if (currentZoomLevel < MIN_ZOOM_LEVEL) {
        self.noneZoomout.image = [UIImage imageNamed:@"main_icon_zoomout_dis.png"];
        [self.zoomOut setEnabled:NO];
        currentZoomLevel = MIN_ZOOM_LEVEL;
    }
    [self.mapView setCenterCoordinate:self.mapView.centerCoordinate zoomLevel:currentZoomLevel animated:YES];
    
}


/**
 更新公共任务列表
 */
- (void) updateMissions {
    if (![Utils locationAccess]) {
        [self.view makeToast:@"定位功能不可用!"];
        return;
    }
    NSDictionary *params = @{
                             @"staffcode": [iUser getInstance].staffcode,
                             @"addrcode": [Utils getAddrCode],
                             @"state": @"",
                             @"keyword": @""
                             };
    
    [AFNRequestManager requestAFURL:@"getPubTaskList.json" httpMethod:METHOD_POST params:params succeed:^(NSDictionary *ret) {
        if (0 == [[ret valueForKey:@"status"] integerValue]) {
            [[iPublicMission getInstance] setData:[ret valueForKey:@"detail"]];
            [self recreateAnnotation];
            [self.tableView reloadData];
        }
        NSLog(@"%@", ret);
    }failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // get all missions
    [self updateMissions];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - UITableView Delegate Implementation
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UITableView Datasource Impletation

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [iPublicMission getInstance].missionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *missionDict = [[iPublicMission getInstance].missionArray objectAtIndex:indexPath.row];
    IPublicTableViewCell *cell = [IPublicTableViewCell cellWithTableView:tableView];
    [cell.missionView setMissionNO:[missionDict valueForKey:@"batchcode"]  endTime:[missionDict valueForKey:@"enddate"]];
    [cell.missionView setMission:[missionDict valueForKey:@"taskname"] store:[missionDict valueForKey:@"shopname"] business:[missionDict valueForKey:@"merchname"] organ:[missionDict valueForKey:@"instname"] description:[missionDict valueForKey:@"taskdesc"]];
    [cell.missionView setDistance:[NSNumber numberWithFloat:[Utils getDistance:[missionDict valueForKey:@"addrcode"]]]];
    [cell.missionView.statusButton setHidden:NO];
    if ([@"" isEqualToString:[missionDict objectForKey:@"opstaff"]]) {
        [cell.missionView setAccepted:NO];
    }
    else if ([(NSString *)[missionDict objectForKey:@"opstaff"]isEqualToString:[iUser getInstance].staffcode]) {
        [cell.missionView setAccepted:YES];
    }
    else {
        [cell.missionView.statusButton setHidden:YES];
    }
    cell.missionView.statusButton.tag = indexPath.row;
    [cell.missionView.statusButton addTarget:self action:@selector(onLockTask:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

#pragma mark - lock task

/**
 锁定公共任务
 
 @param sender IBAction
 */
- (IBAction)onLockTask:(UIButton *)sender {
    if (![Utils locationAccess]) {
        [self.view makeToast:@"定位功能不可用!"];
        return;
    }
    NSDictionary *missionDict = [[iPublicMission getInstance].missionArray objectAtIndex:sender.tag];
    NSDictionary *params = @{
                             @"staffcode": [iUser getInstance].staffcode,
                             @"addrcode": [Utils getAddrCode],
                             @"batchcode": [missionDict objectForKey:@"batchcode"],
                             @"serialnbr": [missionDict objectForKey:@"serialnbr"],
                             @"flag": [@"" isEqualToString: [missionDict objectForKey:@"opstaff"]] ? @"1" : @"2"
                             };
    [AFNRequestManager requestAFURL:@"lockPubTask.json" httpMethod:METHOD_POST params:params succeed:^(NSDictionary *ret) {
        if (0 == [[ret objectForKey:@"status"] integerValue]) {
            [self updateMissions];
            [self.popupView hide];
            [self.view makeToast:@"请求处理成功!" duration:2 position:CSToastPositionCenter];
        }
        else {
            [self.view makeToast: [ret objectForKey:@"desc"] duration:2 position:CSToastPositionCenter];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark - BMKMapViewDelegate
// 自定义泡泡图标
- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        // 我的位置
        return nil;
    }
    static NSString *pin = @"iannotation_view";
    MKAnnotationView *newAnnotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:pin];
    if (!newAnnotationView) {
        newAnnotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pin];
    }
    IAnnotation *iAnnotation = annotation;
    NSDictionary *missionDict = [[iPublicMission getInstance].missionArray objectAtIndex:iAnnotation.tag];
    if ([@"" isEqualToString:[missionDict objectForKey:@"opstaff"]]) {
        newAnnotationView.image = [UIImage imageNamed:@"i_map_unlock.png"];
    }
    else {
        newAnnotationView.image = [UIImage imageNamed:@"i_map_locked.png"];
    }
    newAnnotationView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    newAnnotationView.userInteractionEnabled = YES;
    newAnnotationView.tag = iAnnotation.tag;
    [newAnnotationView addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onAnnotationClick:)]];
    return newAnnotationView;
    
    
}

#pragma mark - Annotation Clicked
// 点击泡泡事件
- (IBAction)onAnnotationClick:(UIGestureRecognizer *)sender {
    MKPinAnnotationView *annotation = (MKPinAnnotationView *)sender.view;
    IPublicMissionView *missionView = (IPublicMissionView *)self.popupView.contentView;
    missionView.statusButton.tag = annotation.tag;
    
    NSDictionary *missionDict = [[iPublicMission getInstance].missionArray objectAtIndex:annotation.tag];
    [missionView setMissionNO:[missionDict valueForKey:@"batchcode"]  endTime:[missionDict valueForKey:@"enddate"]];
    [missionView setMission:[missionDict valueForKey:@"taskname"] store:[missionDict valueForKey:@"shopname"] business:[missionDict valueForKey:@"merchname"] organ:[missionDict valueForKey:@"instname"] description:[missionDict valueForKey:@"taskdesc"]];
    [missionView setDistance:[NSNumber numberWithFloat:[Utils getDistance:[missionDict valueForKey:@"addrcode"]]]];
    [missionView.statusButton setHidden:NO];
    if ([@"" isEqualToString:[missionDict objectForKey:@"opstaff"]]) {
        [missionView setAccepted:NO];
    }
    else if ([(NSString *)[missionDict objectForKey:@"opstaff"]isEqualToString:[iUser getInstance].staffcode]) {
        [missionView setAccepted:YES];
    }
    else {
        [missionView.statusButton setHidden:YES];
    }
    
    [self.popupView show];
}

@end
