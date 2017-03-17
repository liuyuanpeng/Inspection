//
//  HomeViewController.m
//  Inspecting
//
//  Created by liuyuanpeng on 2017/2/16.
//  Copyright © 2017年 default. All rights reserved.
//

#import "HomeViewController.h"
#import "INewestTableViewCell.h"
#import "iUser.h"
#import "AFNRequestManager.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "IMission.h"
#import "MyMissionViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.delegate = self;
    self.view.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0];
    CGRect rScreen = [[UIScreen mainScreen] bounds];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,  rScreen.size.width, 30)];
    titleLabel.text = @"POS终端巡检系统";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLabel;
    
    CGRect rHeader = self.navigationController.navigationBar.frame;
    
    UIImageView *header = [[UIImageView alloc] initWithFrame:CGRectMake(0, rHeader.origin.y + rHeader.size.height, rScreen.size.width, 270/2)];
    
    header.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"b_protrait.png"]] ;
    [self.view addSubview:header];
    
    self.avatar = [[UIImageView alloc] initWithFrame:CGRectMake(10, 27, 80, 80)];
    [self.avatar.layer setCornerRadius:40];
    [self.avatar.layer setMasksToBounds:YES];
    self.avatar.backgroundColor = [UIColor whiteColor];
    [header addSubview:self.avatar];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(112, 38, 150, 30)];
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
    self.organLabel = [[UILabel alloc] initWithFrame:CGRectMake(112, 77, 150, 30)];
    self.organLabel.textColor = [UIColor whiteColor];
    self.organLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
    [header addSubview:self.nameLabel];
    [header addSubview:self.organLabel];
    
    self.organAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(rScreen.size.width - 10 - 90, 27, 80, 80)];
    [self.organAvatar.layer setCornerRadius:40];
    [self.organAvatar.layer setMasksToBounds:YES];
    self.organAvatar.backgroundColor = [UIColor whiteColor];
    [header addSubview:self.organAvatar];
    
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
    self.finishedLabel = [[UILabel alloc] initWithFrame:CGRectMake(105, 50, 30, 30)];
    self.finishedLabel.textColor  = [UIColor colorWithRed:133/255.0 green:198/255.0 blue:103/255.0 alpha:1.0];
    self.finishedLabel.text = @"66";
    self.finishedLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
    [finishedMissionView addSubview:self.finishedLabel];
    
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
    self.unfinishedLabel = [[UILabel alloc] initWithFrame:CGRectMake(105, 50, 30, 30)];
    self.unfinishedLabel.textColor = [UIColor colorWithRed:252/255.0 green:7/255.0 blue:1/255.0 alpha:1.0];
    self.unfinishedLabel.text = @"66";
    self.unfinishedLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
    [unFinishedMissionView addSubview:self.unfinishedLabel];
    
    
    
    UIView *splitLine = [[UIView alloc] initWithFrame:CGRectMake(rScreen.size.width/2, rHeader.origin.y + rHeader.size.height + 270/2, 2, 172/2)];
    splitLine.backgroundColor = [UIColor colorWithRed:226/255.0 green:226/255.0 blue:221/255.0 alpha:1.0];
    [self.view addSubview:splitLine];
    
    
    UILabel *newestLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, finishedMissionView.frame.origin.y + 172/2 + 32/2, rScreen.size.width, 30)];
    newestLabel.text = @"最新任务";
    newestLabel.font = [UIFont systemFontOfSize:15.0f];
    [self.view addSubview:newestLabel];
    
    self.newestTable = [[UITableView alloc] initWithFrame:CGRectMake(0, newestLabel.frame.origin.y + 30, rScreen.size.width, rScreen.size.height - self.tabBarController.tabBar.frame.size.height - newestLabel.frame.origin.y - 30)];
    self.newestTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.newestTable];
    
    self.newestTable.delegate = self;
    self.newestTable.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    iUser *userInst = [iUser getInstance];
    [self setAvartar:userInst.headimg organAvatar:@"i_default_institution.png"];
    [self setUsername:userInst.name organname:userInst.instname];
    
    // get mission info
    NSDictionary *params = @{
                             @"staffcode":[iUser getInstance].staffcode
                             };
    [AFNRequestManager requestAFURL:@"getTaskTotalByStaff.json" httpMethod:METHOD_POST params:params succeed:^(NSDictionary *ret) {
        if (0 == [[ret valueForKey:@"status"] integerValue]) {
            [self setFinished:[[ret valueForKey:@"completed"] integerValue] Unfinished:[[ret valueForKey:@"uncompleted"] integerValue]];
            [[IMission getInstance].missions removeAllObjects];
            [[IMission getInstance].missions addObjectsFromArray:[ret objectForKey:@"detail"]];
            [self.newestTable reloadData];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setAvartar:(NSString *)avatar organAvatar:(NSString *)organAvatar {
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMG_URL, avatar]] placeholderImage:[UIImage imageNamed:@"i_default_inspector.png"]];
    self.organAvatar.image = [UIImage imageNamed:organAvatar];
}

- (void)setUsername:(NSString *)username organname:(NSString *)organname {
    self.nameLabel.text = [NSString stringWithFormat:@"姓名:%@", username];
    self.organLabel.text = [NSString stringWithFormat:@"机构:%@", organname];
}

- (void)setFinished:(NSInteger)finished Unfinished:(NSInteger)unfinished {
    self.finishedLabel.text = [NSString stringWithFormat:@"%ld", (long)finished];
    self.unfinishedLabel.text = [NSString stringWithFormat:@"%ld", (long)unfinished];
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
    return [IMission getInstance].missions.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *missionDict = [[IMission getInstance].missions objectAtIndex:indexPath.row];
    INewestTableViewCell *cell = [INewestTableViewCell cellWithTableView:tableView];
    [cell setName:[missionDict objectForKey:@"taskname"] code:[missionDict objectForKey:@"taskcode"] finished:0 total:[[missionDict objectForKey:@"uncompleted"]integerValue]];
    return cell;
}

#pragma mark - UITalbeViewDelegate implementation


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 63.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [IMission getInstance].curSel = indexPath.row;
    [IMission getInstance].needupdate = YES;
    self.tabBarController.selectedIndex = 1;
}

#pragma mark - UITabBarControllerDelegate Implementation
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if (tabBarController.selectedIndex == 1) {
        [IMission getInstance].curSel = -1;
        [self.myMissionViewController getMission];
    }
}
@end
