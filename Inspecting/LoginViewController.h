//
//  LoginViewController.h
//  Inspecting
//
//  Created by liuyuanpeng on 2017/2/16.
//  Copyright © 2017年 default. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate>
// 用户名
@property (nonatomic, strong) UITextField *username;
// 密码
@property (nonatomic, strong) UITextField *password;

@end
