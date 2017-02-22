//
//  IMyTableViewCell.m
//  Inspecting
//
//  Created by liuyuanpeng on 2017/2/21.
//  Copyright © 2017年 default. All rights reserved.
//

#import "IMyTableViewCell.h"

@implementation IMyTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellIdentifier = @"imycell";
    IMyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[IMyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        CGRect rScreen = [[UIScreen mainScreen] bounds];
        self.contentView.backgroundColor = [UIColor colorWithRed:234/255.0 green:230/255.0 blue:221/255.0 alpha:1.0];
        
        self.clickView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, rScreen.size.width - 20, 140)];
        self.clickView.backgroundColor = [UIColor whiteColor];
        [self.clickView.layer setCornerRadius:10.0f];
        [self.clickView.layer setMasksToBounds:YES];
        [self.contentView addSubview:self.clickView];
        
        [self.contentView setFrame:CGRectMake(10, 0, rScreen.size.width - 20, 140)];
        
        NSInteger fontSize = 12;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, rScreen.size.width - 50, fontSize)];
        self.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:fontSize];
        [self.clickView addSubview:self.titleLabel];
        
        self.organImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 30, 70, 70)];
        [self.clickView addSubview:self.organImageView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 30, rScreen.size.width - 90, fontSize)];
        self.nameLabel.textColor = [UIColor grayColor];
        self.nameLabel.font = [UIFont fontWithName:@"Helvetica" size:fontSize];
        [self.clickView addSubview:self.nameLabel];
        
        self.typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 60, rScreen.size.width - 90, fontSize)];
        self.typeLabel.textColor = [UIColor grayColor];
        self.typeLabel.font = [UIFont fontWithName:@"Helvetica" size:fontSize];
        [self.clickView addSubview:self.typeLabel];
        
        self.organLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 90, rScreen.size.width - 90, fontSize)];
        self.organLabel.textColor = [UIColor grayColor];
        self.organLabel.font = [UIFont fontWithName:@"Helvetica" size:fontSize];
        [self.clickView addSubview:self.organLabel];
        
        UIImageView *locateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 110, 24, 24)];
        locateImageView.image = [UIImage imageNamed:@"i_location.png"];
        [self.clickView addSubview:locateImageView];
        
        self.addrLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 120, rScreen.size.width - 75, fontSize)];
        self.addrLabel.font = [UIFont fontWithName:@"Helvetica" size:fontSize];
        [self.clickView addSubview:self.addrLabel];
        
        self.markImageView = [[UIImageView alloc] initWithFrame:CGRectMake(rScreen.size.width - 20 -75/2, 0, 75/2, 69/2)];
        [self.clickView addSubview:self.markImageView];
        
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    CGPoint pt = [self.contentView convertPoint:point toView:self.clickView];
    if ([self.clickView pointInside:pt withEvent:event]) {
        return [super hitTest:point withEvent:event];
    }
    
    return nil;
}

- (void)setMissionNO:(NSString *)missionNO endtime:(NSString *)time {
    self.titleLabel.text = [NSString stringWithFormat:@"批次号: %@  到期: %@", missionNO, time];
}

- (void)setName:(NSString *)name typy:(NSString *)type organ:(NSString *)organ {
    self.nameLabel.text = [NSString stringWithFormat:@"名称: %@", name];
    self.typeLabel.text = [NSString stringWithFormat:@"类型: %@", type];
    self.organLabel.text = [NSString stringWithFormat:@"隶属: %@", organ];
}

- (void)setAddr:(NSString *)addr {
    self.addrLabel.text = [NSString stringWithString:addr];
}

- (void)setFinished:(BOOL)bFinished {
    if (bFinished) {
        self.markImageView.image = [UIImage imageNamed:@"a_finished.png"];
    }
    else {
        self.markImageView.image = [UIImage imageNamed:@"a_unfinished.png"];
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
