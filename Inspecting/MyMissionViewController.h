//
//  MyMissionViewController.h
//  Inspecting
//  我的任务
//  Created by liuyuanpeng on 2017/2/16.
//  Copyright © 2017年 default. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RadioButton;

@interface MyMissionViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
// 我的任务列表
@property (atomic, strong) UITableView *tableview;

// 搜索按钮
@property (nonatomic, strong) UIView *searchView;

// 搜索关键字
@property (nonatomic, strong) UITextField *keywordText;

// 单选按钮
@property (nonatomic, weak) RadioButton *radioButtons;

// 我的任务列表
@property (nonatomic, strong) NSMutableArray *myTaskArray;

- (void)getMission;

@end
