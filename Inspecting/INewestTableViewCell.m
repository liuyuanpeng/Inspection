//
//  INewestTableViewCell.m
//  Inspecting
//
//  Created by liuyuanpeng on 2017/2/19.
//  Copyright © 2017年 default. All rights reserved.
//

#import "INewestTableViewCell.h"

@implementation INewestTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    INewestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newestCell"];
    if (cell == nil) {
        cell = [[INewestTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"newestCell"];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.missionNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, 16, 200, 20)];
        self.missionNameLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
        self.missionNameLabel.textColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1.0];
        [self.contentView addSubview:self.missionNameLabel];
        
        self.missionNOLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, 36, 200, 20)];
        self.missionNOLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
        self.missionNOLabel.textColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1.0];
        [self.contentView addSubview:self.missionNOLabel];
        
        CGRect rScreen = [[UIScreen mainScreen]bounds];
        
        UILabel *finishedLabel = [[UILabel alloc] initWithFrame:CGRectMake(rScreen.size.width - 100, 25, 50, 14)];
        finishedLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
        finishedLabel.text = @"完成度:";
        [self.contentView addSubview:finishedLabel];
        
        self.completePercentLabel = [[UILabel alloc] initWithFrame:CGRectMake(rScreen.size.width - 50, 25, 40, 14)];
        self.completePercentLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
        [self.contentView addSubview:self.completePercentLabel];
    }
    return self;
}

- (void)setName:(NSString *)name code:(NSString *)code finished:(NSInteger)finished total:(NSInteger)total {
    self.missionNameLabel.text = [NSString stringWithFormat:@"任务名称: %@", name];
    self.missionNOLabel.text = [NSString stringWithFormat:@"任务批次: %@", code];
    self.completePercentLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)finished, (long)total];
    if (finished == total) {
        self.completePercentLabel.textColor = [UIColor colorWithRed:133/255.0 green:198/255.0 blue:103/255.0 alpha:1.0];
    }
    else {
        self. completePercentLabel.textColor = [UIColor colorWithRed:252/255.0 green:7/255.0 blue:1/255.0 alpha:1.0];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
