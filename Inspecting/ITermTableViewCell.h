//
//  ITermTableViewCell.h
//  Inspecting
//
//  Created by liuyuanpeng on 2017/3/5.
//  Copyright © 2017年 default. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ITermTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *shopName;
@property (nonatomic, strong) UILabel *termcode;
@property (nonatomic, strong) UILabel *merchName;
@property (nonatomic, strong) UILabel *instName;
@property (nonatomic, strong) UILabel *termName;
@property (nonatomic, strong) UILabel *termType;
@property (nonatomic, strong) UILabel *termModel;

@property (nonatomic, strong) UIImageView *markImageView;
@property (nonatomic, strong) UIView *clickView;

+ (instancetype)cellWithTableView:(UITableView *)table;
- (void)setBatchcode:(NSString *)batchcode serialnbr:(NSString *)serialnbr;
- (void)setShop:(NSString *)shop termcode:(NSString *)termcode merchname:(NSString *)merchname instname:(NSString *)instname termname:(NSString *)termname termtype:(NSString *)termtype termmodel:(NSString *)termmodel;
- (void)setFinished:(BOOL)bFinished;
@end
