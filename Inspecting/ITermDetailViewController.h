//
//  ITermDetailViewController.h
//  Inspecting
//
//  Created by liuyuanpeng on 2017/3/5.
//  Copyright © 2017年 default. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RadioButton;
@class ITextView;
@class ILogViewController;

@interface ITermDetailViewController : UIViewController<UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UITextField *termSerialnbr;
@property (nonatomic, strong) UILabel *termCode;
@property (nonatomic, strong) UITextField *termBrand;
@property (nonatomic, strong) UITextField *termModel;
@property (nonatomic, strong) UIButton *termType;
@property (nonatomic, strong) UILabel *shopName;
@property (nonatomic, strong) UILabel *merchName;
@property (nonatomic, strong) UILabel *instName;

@property (nonatomic, weak) RadioButton *radioButton;
@property (nonatomic, strong) ITextView *desc;
@property (nonatomic, strong) UIButton *instPic;
@property (nonatomic, strong) UIButton *serialPic;

@property (nonatomic, assign) BOOL bEdit;

@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@property (nonatomic, strong) NSDictionary *merchInfo;
@property (nonatomic, strong) NSDictionary *termInfo;

@property (nonatomic, strong) ILogViewController *logViewController;

@end
