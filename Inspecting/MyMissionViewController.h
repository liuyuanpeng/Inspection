//
//  MyMissionViewController.h
//  Inspecting
//
//  Created by liuyuanpeng on 2017/2/16.
//  Copyright © 2017年 default. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RadioButton;
@class MerchInfoViewController;

@interface MyMissionViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) UITextField *keywordText;
@property (nonatomic, weak) RadioButton *radioButtons;
@property (nonatomic, strong) MerchInfoViewController *merchInfoViewController;

@property (nonatomic, strong) NSArray *myTaskArray;

@end
