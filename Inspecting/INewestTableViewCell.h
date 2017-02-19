//
//  INewestTableViewCell.h
//  Inspecting
//
//  Created by liuyuanpeng on 2017/2/19.
//  Copyright © 2017年 default. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface INewestTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)setName:(NSString *)name code:(NSString *)code finished:(NSInteger)finished total:(NSInteger)total;

@property (strong, nonatomic) UILabel *missionNameLabel;
@property (strong, nonatomic) UILabel *missionNOLabel;
@property (strong, nonatomic) UILabel *completePercentLabel;
@end
