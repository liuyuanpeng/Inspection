//
//  ITermTableViewCell.m
//  Inspecting
//
//  Created by liuyuanpeng on 2017/3/5.
//  Copyright © 2017年 default. All rights reserved.
//

#import "ITermTableViewCell.h"

@implementation ITermTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellIdentifier = @"itermcell";
    ITermTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[ITermTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        CGRect rScreen = [[UIScreen mainScreen] bounds];
        self.contentView.backgroundColor = [UIColor colorWithWhite:236/255.0 alpha:1.0];
        
        self.clickView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, rScreen.size.width - 20, 170)];
        self.clickView.backgroundColor = [UIColor whiteColor];
        [self.clickView.layer setCornerRadius:10.0f];
        [self.clickView.layer setMasksToBounds:YES];
        [self.contentView addSubview:self.clickView];
        
        [self.contentView setFrame:CGRectMake(10, 0, rScreen.size.width - 20, 140)];
        
        NSInteger fontSize = 12;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, rScreen.size.width - 50, fontSize)];
        self.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:fontSize];
        [self.clickView addSubview:self.titleLabel];
        
        self.shopName = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, rScreen.size.width - 20, fontSize)];
        self.shopName.textColor = [UIColor grayColor];
        self.shopName.font = [UIFont fontWithName:@"Helvetica" size:fontSize];
        [self.clickView addSubview:self.shopName];
        
        self.termcode = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, rScreen.size.width - 20, fontSize)];
        self.termcode.textColor = [UIColor grayColor];
        self.termcode.font = [UIFont fontWithName:@"Helvetica" size:fontSize];
        [self.clickView addSubview:self.termcode];
        
        self.merchName = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, rScreen.size.width - 20, fontSize)];
        self.merchName.textColor = [UIColor grayColor];
        self.merchName.font = [UIFont fontWithName:@"Helvetica" size:fontSize];
        [self.clickView addSubview:self.merchName];
        
        self.instName = [[UILabel alloc] initWithFrame:CGRectMake(10, 90, rScreen.size.width - 20, fontSize)];
        self.instName.textColor = [UIColor grayColor];
        self.instName.font = [UIFont fontWithName:@"Helvetica" size:fontSize];
        [self.clickView addSubview:self.instName];
        
        UIImageView *toRight = [[UIImageView alloc] initWithFrame:CGRectMake(rScreen.size.width - 50, 80, 8, 14.5)];
        toRight.image = [UIImage imageNamed:@"i_next.png"];
        [self.clickView addSubview:toRight];
        
        self.termName = [[UILabel alloc] initWithFrame:CGRectMake(10, 110, rScreen.size.width - 20, fontSize)];
        self.termName.textColor = [UIColor grayColor];
        self.termName.font = [UIFont fontWithName:@"Helvetica" size:fontSize];
        [self.clickView addSubview:self.termName];
        
        self.termType = [[UILabel alloc] initWithFrame:CGRectMake(10, 130, rScreen.size.width - 20, fontSize)];
        self.termType.textColor = [UIColor grayColor];
        self.termType.font = [UIFont fontWithName:@"Helvetica" size:fontSize];
        [self.clickView addSubview:self.termType];
        
        self.termModel = [[UILabel alloc] initWithFrame:CGRectMake(10, 150, rScreen.size.width - 20, fontSize)];
        self.termModel.textColor = [UIColor grayColor];
        self.termModel.font = [UIFont fontWithName:@"Helvetica" size:fontSize];
        [self.clickView addSubview:self.termModel];
        
        self.markImageView = [[UIImageView alloc] initWithFrame:CGRectMake(rScreen.size.width - 20 -75/2, 0, 75/2, 69/2)];
        [self.clickView addSubview:self.markImageView];
        
    }
    return self;
}

- (void)setBatchcode:(NSString *)batchcode serialnbr:(NSString *)serialnbr {
    self.titleLabel.text = [NSString stringWithFormat:@"批次号: %@  流水号: %@", batchcode, serialnbr];
}

- (void)setShop:(NSString *)shop termcode:(NSString *)termcode merchname:(NSString *)merchname instname:(NSString *)instname termname:(NSString *)termname termtype:(NSString *)termtype termmodel:(NSString *)termmodel {
    self.shopName.text = [NSString stringWithFormat:@"门店名称:%@", shop];
    self.termcode.text = [NSString stringWithFormat:@"编码:%@", termcode];
    self.merchName.text = [NSString stringWithFormat:@"商户:%@", merchname];
    self.instName.text = [NSString stringWithFormat:@"机构:%@", instname];
    self.termName.text = [NSString stringWithFormat:@"终端名称:%@", termname];
    self.termType.text = [NSString stringWithFormat:@"终端类型:%@", termtype];
    self.termModel.text = [NSString stringWithFormat:@"终端型号:%@", termmodel];
}

- (void)setFinished:(BOOL)bFinished {
    if (bFinished) {
        self.markImageView.image = [UIImage imageNamed:@"a_finished.png"];
    }
    else {
        self.markImageView.image = [UIImage imageNamed:@"a_unfinished.png"];
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    CGPoint pt = [self.contentView convertPoint:point toView:self.clickView];
    if ([self.clickView pointInside:pt withEvent:event]) {
        return [super hitTest:point withEvent:event];
    }
    
    return nil;
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
