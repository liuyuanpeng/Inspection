//
//  MerchInfoViewController.h
//  Inspecting
//
//  Created by liuyuanpeng on 2017/3/2.
//  Copyright © 2017年 default. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RadioButton;
@class ITextView;
@class ILogViewController;
@class IShopViewController;
@class ITermViewController;

@interface MerchInfoViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIImageView *merchimg;
@property (nonatomic, strong) UILabel *merchname;
@property (nonatomic, strong) UILabel *merchtype;
@property (nonatomic, strong) UILabel *merchcode;
@property (nonatomic, strong) UILabel *merchinst;
@property (nonatomic, strong) UITextField *merchAddr;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, weak) RadioButton *radioButton;
@property (nonatomic, strong) ITextView *desc;
@property (nonatomic, strong) UIButton *licencePic;
@property (nonatomic, strong) UIButton *FacadePic;
@property (nonatomic, strong) UIButton *signPic;
@property (nonatomic, strong) UIButton *sitePic;

@property (nonatomic, assign) BOOL bEdit;

@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@property (nonatomic, strong) NSDictionary *taskInfo;
@property (nonatomic, strong) NSDictionary *merchInfo;

@property (nonatomic, strong) ILogViewController *logViewController;
@property (nonatomic, strong) IShopViewController *shopViewController;
@property (nonatomic, strong) ITermViewController *termViewController;

@end
