//
//  HomeViewController.m
//  Inspecting
//
//  Created by liuyuanpeng on 2017/2/16.
//  Copyright © 2017年 default. All rights reserved.
//

#import "HomeViewController.h"
#import "INewestTableViewCell.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:234/255.0 green:230/255.0 blue:221/255.0 alpha:1.0];
    
    CGRect rScreen = [[UIScreen mainScreen] bounds];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,  rScreen.size.width, 30)];
    titleLabel.text = @"中国人民银行POS终端巡检系统";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLabel;
    
    CGRect rHeader = self.navigationController.navigationBar.frame;
    
    UIImageView *header = [[UIImageView alloc] initWithFrame:CGRectMake(0, rHeader.origin.y + rHeader.size.height, rScreen.size.width, 270/2)];
    
    
    
//    header.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"b_protrait.png"]] ;
    header.backgroundColor = [UIColor grayColor];
    [self.view addSubview:header];
    
    UIImageView *avatar = [[UIImageView alloc] initWithFrame:CGRectMake(10, 22, 90, 90)];
    [avatar.layer setCornerRadius:45.0];
    avatar.backgroundColor = [UIColor whiteColor];
    [header addSubview:avatar];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(112, 38, 120, 30)];
    nameLabel.text = @"姓名：xxx";
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    UILabel *organLabel = [[UILabel alloc] initWithFrame:CGRectMake(112, 77, 120, 30)];
    organLabel.text = @"隶属机构：xxxxxxxx";
    organLabel.textColor = [UIColor whiteColor];
    organLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    [header addSubview:nameLabel];
    [header addSubview:organLabel];
    
    UIImageView *organAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(rScreen.size.width - 10 - 90, 22, 90, 90)];
    [organAvatar.layer setCornerRadius:45.0];
    organAvatar.backgroundColor = [UIColor whiteColor];
    [header addSubview:organAvatar];
    
    UIView *finishedMissionView = [[UIView alloc] initWithFrame:CGRectMake(0, rHeader.origin.y + rHeader.size.height + 270/2, rScreen.size.width/2, 172/2)];
    finishedMissionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:finishedMissionView];
    UIImageView *finishedIcon = [[UIImageView alloc] initWithFrame:CGRectMake(134/2, 30/2, 86/2, 68/2)];
    finishedIcon.image = [UIImage imageNamed:@"i_finished.png"];
    [finishedMissionView addSubview:finishedIcon];
    UILabel *finishedLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 50, 75, 30)];
    finishedLabel.text = @"已完成任务：";
    finishedLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
    [finishedMissionView addSubview:finishedLabel];
    UILabel *finishedNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(105, 50, 30, 30)];
    finishedNumLabel.textColor  = [UIColor colorWithRed:133/255.0 green:198/255.0 blue:103/255.0 alpha:1.0];
    finishedNumLabel.text = @"66";
    finishedNumLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
    [finishedMissionView addSubview:finishedNumLabel];
    
    UIView *splitLine = [[UIView alloc] initWithFrame:CGRectMake(rScreen.size.width/2, rHeader.origin.y + rHeader.size.height + 270/2, 1, 172/2)];
    splitLine.backgroundColor = [UIColor colorWithRed:226/255.0 green:226/255.0 blue:221/255.0 alpha:1.0];
    [header addSubview:splitLine];
    
    UIView *unFinishedMissionView = [[UIView alloc] initWithFrame:CGRectMake(rScreen.size.width/2 + 1, rHeader.origin.y + rHeader.size.height + 270/2, rScreen.size.width/2 - 1, 172/2)];
    unFinishedMissionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:unFinishedMissionView];
    UIImageView *unfinishedIcon = [[UIImageView alloc] initWithFrame:CGRectMake(134/2, 30/2, 86/2, 68/2)];
    unfinishedIcon.image = [UIImage imageNamed:@"i_unfinished.png"];
    [unFinishedMissionView addSubview:unfinishedIcon];
    UILabel *unfinishedLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 50, 75, 30)];
    unfinishedLabel.text = @"未完成任务：";
    unfinishedLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
    [unFinishedMissionView addSubview:unfinishedLabel];
    UILabel *unfinishedNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(105, 50, 30, 30)];
    unfinishedNumLabel.textColor = [UIColor colorWithRed:252/255.0 green:7/255.0 blue:1/255.0 alpha:1.0];
    unfinishedNumLabel.text = @"66";
    unfinishedNumLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
    [unFinishedMissionView addSubview:unfinishedNumLabel];
    
    UILabel *newestLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, finishedMissionView.frame.origin.y + 172/2 + 32/2, rScreen.size.width, 30)];
    newestLabel.text = @"最新任务";
    [self.view addSubview:newestLabel];
    
    UITableView *newestTable = [[UITableView alloc] initWithFrame:CGRectMake(0, newestLabel.frame.origin.y + 30, rScreen.size.width, rScreen.size.height - self.tabBarController.tabBar.frame.size.height - newestLabel.frame.origin.y - 30)];
    [self.view addSubview:newestTable];
    
    newestTable.delegate = self;
    newestTable.dataSource = self;
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

#pragma mark - UITableViewDataSource implementation


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    INewestTableViewCell *cell = [INewestTableViewCell cellWithTableView:tableView];
    [cell setName:@"有点意思" code:@"007" finished:16 total:18];
    return cell;
}

#pragma mark - UITalbeViewDelegate implementation


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 63.0;
}

@end
