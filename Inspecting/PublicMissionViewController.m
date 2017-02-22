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

@interface PublicMissionViewController ()

@end

@implementation PublicMissionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:234/255.0 green:230/255.0 blue:221/255.0 alpha:1.0];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    CGRect rScreen = [[UIScreen mainScreen] bounds];
    
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
    
    CGRect rNav = self.navigationController.navigationBar.frame;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, rNav.origin.y + rNav.size.height, rScreen.size.width, rScreen.size.height - rNav.origin.y - rNav.size.height - self.tabBarController.tabBar.frame.size.height) style:UITableViewStylePlain];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (IBAction)onLocate:(id)sender {
    
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
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IPublicTableViewCell *cell = [IPublicTableViewCell cellWithTableView:tableView];
    [cell.missionView setMissionNO:@"23423434" endTime:@"2017-03-15"];
    [cell.missionView setMission:@"renwumingcheng" store:@"mendianxinxi" business:@"shanghuxinxi" organ:@"lishujigou" description:@"miaoshuxinxi"];
    [cell.missionView setDistance:[NSNumber numberWithFloat:1.2]];
    [cell.missionView setAccepted:(BOOL)(indexPath.row%2)];
    return cell;
}

@end
