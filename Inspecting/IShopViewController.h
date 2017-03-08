//
//  IShopViewController.h
//  Inspecting
//
//  Created by liuyuanpeng on 2017/3/4.
//  Copyright © 2017年 default. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IShopDetailViewController;
@class INewShopViewController;

@interface IShopViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) IShopDetailViewController *shopDetailViewController;
@property (nonatomic, strong) INewShopViewController *addShopViewController;
@property (nonatomic, strong) NSMutableArray *shopArray;
@property (nonatomic, strong) NSDictionary *merchInfo;
@property (nonatomic, strong) UIImage *loadingImage;

@end
