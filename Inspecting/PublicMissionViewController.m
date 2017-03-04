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

#define MAX_ZOOM_LEVEL 18
#define MIN_ZOOM_LEVEL 3

@interface PublicMissionViewController ()

@end

@implementation PublicMissionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    CGRect rNav = self.navigationController.navigationBar.frame;
    CGRect rScreen = [[UIScreen mainScreen] bounds];
    CGRect rView =CGRectMake(0, rNav.origin.y + rNav.size.height, rScreen.size.width, rScreen.size.height - rNav.origin.y - rNav.size.height - self.tabBarController.tabBar.frame.size.height);
    
    self.mapView = [[BMKMapView alloc] initWithFrame:rView];
    self.mapView.delegate = nil;
    self.mapView.zoomEnabled = YES;
    
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
    
    self.noneZoomin = [[NoneImageView alloc] initWithFrame:self.zoomIn.frame];
    self.noneZoomout = [[NoneImageView alloc] initWithFrame:self.zoomOut.frame];
    self.noneZoomin.image = [UIImage imageNamed:@"main_icon_zoomin.png"];
    self.noneZoomout.image = [UIImage imageNamed:@"main_icon_zoomout.png"];
    [self.mapView addSubview:self.noneZoomout];
    [self.mapView addSubview:self.noneZoomin];
}

- (IBAction)onLocate:(id)sender {
    [self.missionView setHidden:!self.missionView.isHidden];
    [self.mapView setHidden:!self.mapView.isHidden];
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

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // get all missions
    NSDictionary *params = @{
                             @"staffcode": [iUser getInstance].staffcode,
                             @"addrcode": [Utils getAddrCode],
                             @"state": @"",
                             @"keyword": @""
                             };
    
    [AFNRequestManager requestAFURL:@"getPubTaskList.json" httpMethod:METHOD_POST params:params succeed:^(NSDictionary *ret) {
        if (0 == [[ret valueForKey:@"status"] integerValue]) {
            [[iPublicMission getInstance] setData:[ret valueForKey:@"detail"]];
            [self.tableView reloadData];
        }
        NSLog(@"%@", ret);
    }failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
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
    [cell.missionView setAccepted:[(NSString *)[missionDict objectForKey:@"state"]isEqualToString:@"001"]?NO:YES];
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
                             @"flag":[(NSString *)[missionDict objectForKey:@"state"]isEqualToString:@"001"]?@1:@2
                                 };
    [AFNRequestManager requestAFURL:@"lockPubTask.json" httpMethod:METHOD_POST params:params succeed:^(NSDictionary *ret) {
        if (0 == [[ret objectForKey:@"status"] integerValue]) {
            [missionDict setValue:[[params objectForKey:@"flag"] integerValue] == 1 ? @"001": @"002" forKey:@"state"];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

@end
