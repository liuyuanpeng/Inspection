//
//  ILogTableViewCell.m
//  Inspecting
//
//  Created by liuyuanpeng on 2017/3/4.
//  Copyright © 2017年 default. All rights reserved.
//

#import "ILogTableViewCell.h"

@implementation ILogTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellIdentifier = @"ilogCell";
    ILogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[ILogTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // UI code here
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        CGRect rScreen = [[UIScreen mainScreen] bounds];
        
        self.logType = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, rScreen.size.width, 15)];
        self.logOld = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, rScreen.size.width - 20, 15)];
        self.logCur = [[UILabel alloc] initWithFrame:CGRectMake(10, 45, rScreen.size.width - 20, 15)];
        
        [self.logType setTextAlignment:NSTextAlignmentCenter];
        self.logType.font = [UIFont systemFontOfSize:12.0f];
        self.logOld.font = [UIFont systemFontOfSize:12.0f];
        self.logCur.font = [UIFont systemFontOfSize:12.0f];
        
        [self addSubview:self.logType];
        [self addSubview:self.logOld];
        [self addSubview:self.logCur];
    }
    return self;
}

- (void)setLogType:(NSString *)logtype logOld:(NSString *)logold logCur:(NSString *)logcur {
    self.logType.text = [NSString stringWithString:logtype];
    self.logOld.text = [NSString stringWithFormat:@"巡检前:%@", logold];
    self.logCur.text = [NSString stringWithFormat:@"巡检后:%@", logcur];
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
