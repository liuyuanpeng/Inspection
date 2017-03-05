//
//  ITermViewController.h
//  Inspecting
//
//  Created by liuyuanpeng on 2017/3/4.
//  Copyright © 2017年 default. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ITermDetailViewController;

@interface ITermViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSDictionary *merchInfo;
@property (nonatomic, strong) NSDictionary *shopInfo;
@property (nonatomic, strong) NSMutableArray *termArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ITermDetailViewController *termDetailViewController;

@end
