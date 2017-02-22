//
//  IPublicTableViewCell.m
//  Inspecting
//
//  Created by liuyuanpeng on 2017/2/21.
//  Copyright © 2017年 default. All rights reserved.
//

#import "IPublicTableViewCell.h"
#import "IPublicMissionView.h"

@implementation IPublicTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellIdentifier = @"ipubliccell";
    IPublicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[IPublicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // UI code here
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        self.missionView = [[IPublicMissionView alloc] init];
        [self.contentView addSubview:self.missionView];
    }
    return self;
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
