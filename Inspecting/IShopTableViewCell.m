//
//  IShopTableViewCell.m
//  Inspecting
//
//  Created by liuyuanpeng on 2017/3/5.
//  Copyright © 2017年 default. All rights reserved.
//

#import "IShopTableViewCell.h"

@implementation IShopTableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellIdentifier = @"ishopcell";
    IShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[IShopTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        CGRect rScreen = [[UIScreen mainScreen] bounds];
        self.contentView.backgroundColor = [UIColor colorWithWhite:236/255.0 alpha:1.0];
        
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
        
        self.shopImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 30, 70, 70)];
        [self.shopImageView.layer setMasksToBounds:YES];
        self.shopImageView.image = [UIImage imageNamed:@"i_store.png"];
        [self.clickView addSubview:self.shopImageView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 30, rScreen.size.width - 90, fontSize)];
        self.nameLabel.textColor = [UIColor grayColor];
        self.nameLabel.font = [UIFont fontWithName:@"Helvetica" size:fontSize];
        [self.clickView addSubview:self.nameLabel];
        
        self.codeLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 50, rScreen.size.width - 90, fontSize)];
        self.codeLabel.textColor = [UIColor grayColor];
        self.codeLabel.font = [UIFont fontWithName:@"Helvetica" size:fontSize];
        [self.clickView addSubview:self.codeLabel];
        
        self.merchLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 70, rScreen.size.width - 90, fontSize)];
        self.merchLabel.textColor = [UIColor grayColor];
        self.merchLabel.font = [UIFont fontWithName:@"Helvetica" size:fontSize];
        [self.clickView addSubview:self.merchLabel];
        
        self.instLabe = [[UILabel alloc] initWithFrame:CGRectMake(80, 90, rScreen.size.width - 90, fontSize)];
        self.instLabe.textColor = [UIColor grayColor];
        self.instLabe.font = [UIFont fontWithName:@"Helvetica" size:fontSize];
        [self.clickView addSubview:self.instLabe];
        
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

- (void)setMissionNO:(NSString *)missionNO floatNO:(NSString *)floatnumber {
    self.titleLabel.text = [NSString stringWithFormat:@"批次号: %@  流水号: %@", missionNO, floatnumber];
}

- (void)setShop:(NSString *)shop code:(NSString *)code merch:(NSString *)merch inst:(NSString *)inst {
    self.nameLabel.text = [NSString stringWithFormat:@"名称: %@", shop];
    self.codeLabel.text = [NSString stringWithFormat:@"编码: %@", code];
    self.merchLabel.text = [NSString stringWithFormat:@"商户: %@", merch];
    self.instLabe.text = [NSString stringWithFormat:@"机构: %@", inst];
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

- (void)setShopImg:(NSString *)img {
    if (img && ![img isEqualToString:@""]) {
        self.shopImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:img]]];
    }
    else {
        self.shopImageView.image = [UIImage imageNamed:@"i_store.png"];
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
