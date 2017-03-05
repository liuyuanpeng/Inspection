//
//  INewTermViewController.h
//  Inspecting
//
//  Created by liuyuanpeng on 2017/3/5.
//  Copyright © 2017年 default. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ITextView;
@class RadioButton;

@interface INewTermViewController : UIViewController <UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UITextField *termSerialnbr;
@property (nonatomic, strong) UITextField *termBrand;
@property (nonatomic, strong) UITextField *termModel;
@property (nonatomic, strong) UITextField *termType;


@property (nonatomic, weak) RadioButton *radioButton;
@property (nonatomic, strong) ITextView *desc;
@property (nonatomic, strong) UIButton *instPic;
@property (nonatomic, strong) UIButton *serialPic;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@end
