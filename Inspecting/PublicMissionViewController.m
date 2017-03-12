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
#import "IPopupView.h"

#define MAX_ZOOM_LEVEL 18
#define MIN_ZOOM_LEVEL 3

@interface PublicMissionViewController ()

@end

@implementation PublicMissionViewController

- (void)viewDidLoad {
    [super viewDidLoad];    self.view.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    CGRect rNav = self.navigationController.navigationBar.frame;
    CGRect rScreen = [[UIScreen mainScreen] bounds];
    CGRect rView =CGRectMake(0, rNav.origin.y + rNav.size.height, rScreen.size.width, rScreen.size.height - rNav.origin.y - rNav.size.height - self.tabBarController.tabBar.frame.size.height);
    
    self.mapView = [[BMKMapView alloc] initWithFrame:rView];
    self.mapView.delegate = self;
    self.mapView.zoomEnabled = YES;
    self.mapView.showMapScaleBar = YES;
    [self.mapView setShowsUserLocation:YES];
    self.mapView.showMapPoi = YES;
    [self.mapView setCenterCoordinate: [Utils getMyLocation]];
    self.mapView.zoomLevel = 16.0f;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.mapView = self.mapView;
    [self.mapView updateLocationData:appDelegate.userLocation];
    
    
    BMKLocationViewDisplayParam *param =  [[BMKLocationViewDisplayParam alloc] init];
    param.isRotateAngleValid = NO;
    param.isAccuracyCircleShow = NO;
    param.locationViewOffsetX = 0;
    param.locationViewOffsetY = 0;
    [self.mapView updateLocationViewWithParam:param];

    
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
    self.annotations = [[NSMutableArray alloc] init];
    
    self.popupView = [[IPopupView alloc] init];
    IPublicMissionView *publicMissionView = [[IPublicMissionView alloc] init];
    publicMissionView.frame = CGRectMake(10, rScreen.size.height/2 - 70, rScreen.size.width - 20, 140);
    self.popupView.contentView = publicMissionView;
    [publicMissionView.statusButton addTarget:self action:@selector(onLockTask:) forControlEvents:UIControlEventTouchUpInside];
}

- (double)getRandom {
    return (arc4random()%10)/100.0 - 0.05;
}

- (void)recreateAnnotation {
    if (self.annotations.count > 0) {
        [self.mapView removeAnnotations:self.annotations];
    }
    
    NSArray *missionArray = [iPublicMission getInstance].missionArray;
    for (NSInteger i = 0; i < missionArray.count; i++) {
        NSDictionary *dict = [missionArray objectAtIndex:i];
        IAnnotation *annotation=[[IAnnotation alloc]init];
        annotation.tag = i;
        NSArray *array = [[dict objectForKey:@"addrcode"] componentsSeparatedByString:@","];
        if (array.count != 2) {
            array = [[Utils getAddrCode] componentsSeparatedByString:@","];
        }
        annotation.coordinate = CLLocationCoordinate2DMake([[array objectAtIndex:0] doubleValue] + [self getRandom], [[array objectAtIndex:1] doubleValue] + [self getRandom]);
        [self.annotations addObject:annotation];
        [self.mapView addAnnotation:annotation];

    }
}

- (IBAction)onLocate:(id)sender {
    if ([Utils locationAccess]) {
        [self.missionView setHidden:!self.missionView.isHidden];
        [self.mapView setHidden:!self.mapView.isHidden];
    }
    else {
        [self.view makeToast:@"请先开启定位服务!" duration:2 position:CSToastPositionCenter];
    }
}

- (IBAction)onZoomIn:(id)sender {
    float currentZoomLevel  = [self.mapView getMapStatus].fLevel;
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
    [self.mapView setZoomLevel:currentZoomLevel];
    
}

- (IBAction)onZoomOut:(id)sender {
    float currentZoomLevel = [self.mapView getMapStatus].fLevel;
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
    [self.mapView setZoomLevel:currentZoomLevel];
}

- (void) updateMissions {
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

- (void)createAnnotation {
    
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
- (IBAction)onLockTask:(UIButton *)sender {
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
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark - BMKMapViewDelegate
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation {
    if ([annotation isKindOfClass:[BMKUserLocation class]]) {
        // 我的位置
        return nil;
    }
    BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"iannotation_view"];
    newAnnotationView.paopaoView = nil;
    newAnnotationView.annotation = annotation;
    IAnnotation *iAnnotation = annotation;
    NSDictionary *missionDict = [[iPublicMission getInstance].missionArray objectAtIndex:iAnnotation.tag];
    if ([@"" isEqualToString:[missionDict objectForKey:@"opstaff"]]) {
        newAnnotationView.image = [UIImage imageNamed:@"i_map_unlock.png"];
    }
    else {
        newAnnotationView.image = [UIImage imageNamed:@"i_map_locked.png"];
    }
    newAnnotationView.userInteractionEnabled = YES;
    newAnnotationView.tag = iAnnotation.tag;
    [newAnnotationView addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onAnnotationClick:)]];
    return newAnnotationView;
    
}

#pragma mark - Annotation Clicked
- (IBAction)onAnnotationClick:(UIGestureRecognizer *)sender {
    BMKPinAnnotationView *annotation = (BMKPinAnnotationView *)sender.view;
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
