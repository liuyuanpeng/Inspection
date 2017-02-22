//
//  IPublicMissionView.h
//  Inspecting
//
//  Created by liuyuanpeng on 2017/2/22.
//  Copyright © 2017年 default. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPublicMissionView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *missionLabel;
@property (nonatomic, strong) UILabel *storeLabel;
@property (nonatomic, strong) UILabel *businessLabel;
@property (nonatomic, strong) UILabel *organLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UILabel *distanceLabe;
@property (nonatomic, strong) UIButton *statusButton;

- (void)setMissionNO:(NSString *)missionNO endTime:(NSString *)time;
- (void)setMission:(NSString *)mission store:(NSString *)store business:(NSString *)business organ:(NSString *)organ description:(NSString *)desc;
- (void)setDistance:(NSNumber *)distance;
- (void)setAccepted:(BOOL)bAccepted;

@end
