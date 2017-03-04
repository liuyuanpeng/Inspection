//
//  IMyTableViewCell.h
//  Inspecting
//
//  Created by liuyuanpeng on 2017/2/21.
//  Copyright © 2017年 default. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMyTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *organImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *organLabel;
@property (nonatomic, strong) UILabel *addrLabel;
@property (nonatomic, strong) UIImageView *markImageView;
@property (nonatomic, strong) UIView *clickView;

- (void)setMissionNO:(NSString *)missionNO endtime:(NSString *)time;
- (void)setName:(NSString *)name typy:(NSString *)type organ:(NSString *)organ;
- (void)setAddr:(NSString *)addr;
- (void)setFinished:(BOOL)bFinished;
- (void)setOrganImg:(NSString *)img;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
