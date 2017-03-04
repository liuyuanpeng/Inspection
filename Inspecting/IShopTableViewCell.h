//
//  IShopTableViewCell.h
//  Inspecting
//
//  Created by liuyuanpeng on 2017/3/5.
//  Copyright © 2017年 default. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IShopTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *shopImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *codeLabel;
@property (nonatomic, strong) UILabel *merchLabel;
@property (nonatomic, strong) UILabel *instLabe;
@property (nonatomic, strong) UILabel *addrLabel;
@property (nonatomic, strong) UIImageView *markImageView;
@property (nonatomic, strong) UIView *clickView;

- (void)setMissionNO:(NSString *)missionNO floatNO:(NSString *)floatnumber;
- (void)setShop:(NSString *)shop code:(NSString *)code merch:(NSString *)merch inst:(NSString *)inst;
- (void)setAddr:(NSString *)addr;
- (void)setFinished:(BOOL)bFinished;
- (void)setShopImg:(NSString *)img;

@end
