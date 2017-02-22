//
//  IPublicTableViewCell.h
//  Inspecting
//
//  Created by liuyuanpeng on 2017/2/21.
//  Copyright © 2017年 default. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IPublicMissionView;
@interface IPublicTableViewCell : UITableViewCell

@property (nonatomic, strong) IPublicMissionView *missionView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
