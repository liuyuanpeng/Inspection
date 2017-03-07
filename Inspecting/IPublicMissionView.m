//
//  IPublicMissionView.m
//  Inspecting
//
//  Created by liuyuanpeng on 2017/2/22.
//  Copyright © 2017年 default. All rights reserved.
//

#import "IPublicMissionView.h"

@implementation IPublicMissionView

- (instancetype) init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        CGRect rScreen = [[UIScreen mainScreen] bounds];
        self.frame = CGRectMake(10, 0, rScreen.size.width - 20, 140);
        [self.layer setCornerRadius:10.0f];
        [self.layer setMasksToBounds:YES];
        
        NSInteger fontSize = 12;
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, rScreen.size.width - 40, fontSize)];
        self.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:fontSize];
        [self addSubview:self.titleLabel];
        
        UIImageView *locationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(rScreen.size.width - 100, 20, 24, 24)];
        locationImageView.image = [UIImage imageNamed:@"i_location.png"];
        [self addSubview:locationImageView];
        
        self.distanceLabe = [[UILabel alloc] initWithFrame:CGRectMake(rScreen.size.width - 70, 25, 40, fontSize)];
        self.distanceLabe.font = [UIFont fontWithName:@"Helvetica" size:fontSize];
        [self.distanceLabe setTextAlignment:NSTextAlignmentRight];
        [self addSubview:self.distanceLabe];
        
        self.statusButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.statusButton.frame = CGRectMake(rScreen.size.width - 100, 50, 115/2, 55/2);
        [self addSubview:self.statusButton];
        
        self.missionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, rScreen.size.width - 130, fontSize)];
        self.missionLabel.textColor = [UIColor grayColor];
        self.missionLabel.font = [UIFont fontWithName:@"Helvetica" size:fontSize];
        [self addSubview:self.missionLabel];
        
        self.storeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 60, rScreen.size.width - 130, fontSize)];
        self.storeLabel.textColor = [UIColor grayColor];
        self.storeLabel.font = [UIFont fontWithName:@"Helvetica" size:fontSize];
        [self addSubview:self.storeLabel];

        self.businessLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, rScreen.size.width - 130, fontSize)];
        self.businessLabel.textColor = [UIColor grayColor];
        self.businessLabel.font = [UIFont fontWithName:@"Helvetica" size:fontSize];
        [self addSubview:self.businessLabel];

        self.organLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, rScreen.size.width - 130, fontSize)];
        self.organLabel.textColor = [UIColor grayColor];
        self.organLabel.font = [UIFont fontWithName:@"Helvetica" size:fontSize];
        [self addSubview:self.organLabel];

        self.descLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 120, rScreen.size.width - 130, fontSize)];
        self.descLabel.textColor = [UIColor grayColor];
        self.descLabel.font = [UIFont fontWithName:@"Helvetica" size:fontSize];
        [self addSubview:self.descLabel];
    }
    return self;
}

- (void)setMissionNO:(NSString *)missionNO endTime:(NSString *)time {
    self.titleLabel.text = [NSString stringWithFormat:@"批次号: %@ 到期: %@", missionNO, time];
}

- (void)setMission:(NSString *)mission store:(NSString *)store business:(NSString *)business organ:(NSString *)organ description:(NSString *)desc {
    self.missionLabel.text = [NSString stringWithFormat:@"任务名称: %@", mission];
    self.storeLabel.text = [NSString stringWithFormat:@"门店名称: %@", store];
    self.businessLabel.text = [NSString stringWithFormat:@"隶属商户: %@", business];
    self.organLabel.text = [NSString stringWithFormat:@"隶属机构: %@", organ];
    self.descLabel.text = [NSString stringWithFormat:@"任务描述: %@", desc];
}

- (void)setDistance:(NSNumber *)distance {
    self.distanceLabe.text = [NSString stringWithFormat:@"%@KM", distance];
}

- (void)setAccepted:(BOOL)bAccepted {
    if (bAccepted) {
        [self.statusButton setBackgroundImage:[UIImage imageNamed:@"i_botton_picked.png"] forState:UIControlStateNormal];
        self.statusButton.tag = 1;
    }
    else {
        [self.statusButton setBackgroundImage:[UIImage imageNamed:@"i_botton_pick.png"] forState:UIControlStateNormal];
        self.statusButton.tag = 2;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
