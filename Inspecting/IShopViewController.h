//
//  IShopViewController.h
//  Inspecting
//
//  Created by liuyuanpeng on 2017/3/4.
//  Copyright © 2017年 default. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IShopViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *shopArray;
@property (nonatomic, strong) NSDictionary *merchInfo;
@property (nonatomic, strong) UIImage *loadingImage;
@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) UITextField *keywordText;

@end
