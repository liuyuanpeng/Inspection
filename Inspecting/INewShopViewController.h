//
//  INewShopViewController.h
//  Inspecting
//
//  Created by liuyuanpeng on 2017/3/5.
//  Copyright © 2017年 default. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ITextView;
@class RadioButton;

@interface INewShopViewController : UIViewController<UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UITextField *shopName;
@property (nonatomic, strong) UITextField *shopAddr;

@property (nonatomic, strong) UITextField *nameText;
@property (nonatomic, strong) UITextField *telText;
@property (nonatomic, strong) UITextField *mailText;

@property (nonatomic, weak) RadioButton *radioButton;
@property (nonatomic, strong) ITextView *desc;
@property (nonatomic, strong) UIButton *instPic;
@property (nonatomic, strong) UIButton *serialPic;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;


@end