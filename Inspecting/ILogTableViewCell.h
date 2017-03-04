//
//  ILogTableViewCell.h
//  Inspecting
//
//  Created by liuyuanpeng on 2017/3/4.
//  Copyright © 2017年 default. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ILogTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *logType;
@property (nonatomic, strong) UILabel *logOld;
@property (nonatomic, strong) UILabel *logCur;

+ (ILogTableViewCell *)cellWithTableView:(UITableView *)tableView;

- (void)setLogType:(NSString *)logtype logOld:(NSString *)logold logCur:(NSString *)logcur;

@end
