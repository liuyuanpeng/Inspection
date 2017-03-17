//
//  HomeViewController.h
//  Inspecting
//  首页
//  Created by liuyuanpeng on 2017/2/16.
//  Copyright © 2017年 default. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyMissionViewController;

@interface HomeViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITabBarControllerDelegate>
// 用户头像
@property (nonatomic, strong) UIImageView *avatar;
// 机构图像
@property (nonatomic, strong) UIImageView *organAvatar;
// 用户名字
@property (nonatomic, strong) UILabel *nameLabel;
// 机构名称
@property (nonatomic, strong) UILabel *organLabel;
// 已完成
@property (nonatomic, strong) UILabel *finishedLabel;
// 未完成
@property (nonatomic, strong) UILabel *unfinishedLabel;
// 我的任务Controller
@property (nonatomic, weak) MyMissionViewController *myMissionViewController;

@property (nonatomic, strong) UITableView *newestTable;
- (void)setAvartar:(NSString *)avatar organAvatar:(NSString *)organAvatar;
- (void)setUsername:(NSString *)username organname:(NSString *)organname;
- (void)setFinished:(NSInteger)finished Unfinished:(NSInteger)unfinished;

@end
