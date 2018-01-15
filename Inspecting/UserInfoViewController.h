//
//  UserInfoViewController.h
//  Inspecting
//
//  Created by liuyuanpeng on 2017/2/16.
//  Copyright © 2017年 default. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IPopupView;

@interface UserInfoViewController : UIViewController

@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *organLabel;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *idType;
@property (nonatomic, strong) UILabel *idNO;
@property (nonatomic, strong) UILabel *currentVersion;
@property (nonatomic, strong) IPopupView *changePwdView;
@property (nonatomic, strong) UITextField *oldpwdText;
@property (nonatomic, strong) UITextField *newpwdText;
@property (nonatomic, strong) UITextField *newpwdText2;
@property (nonatomic, strong) UIView *changepwd;


- (void)setAvatar:(NSString *)avatar name:(NSString *)name organ:(NSString *)organ;
- (void)setIdType:(NSString *)type idNo:(NSString *)idNo;

@end
