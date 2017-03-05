//
//  PickerView.h
//  Inspecting
//
//  Created by liuyuanpeng on 2017/3/5.
//  Copyright © 2017年 default. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^complete)(NSString *type);

@interface PickerView : UIView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *types;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) complete block;
@property (nonatomic, assign) NSInteger btnTag;

- (void)setComplete:(complete)block;

@end
