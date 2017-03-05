//
//  IShopDetailViewController.h
//  Inspecting
//
//  Created by liuyuanpeng on 2017/3/5.
//  Copyright © 2017年 default. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ITextView;
@class RadioButton;
@class ILogViewController;
@class ITermDetailViewController;
@class INewTermViewController;

@interface IShopDetailViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate>

@property (nonatomic, strong) NSDictionary *merchInfo;
@property (nonatomic, strong) NSDictionary *shopInfo;
@property (nonatomic, strong) NSDictionary *shopDetail;

@property (nonatomic, strong) UIImageView *shopImg;
@property (nonatomic, strong) UITextField *shopName;
@property (nonatomic, strong) UILabel *shopCode;
@property (nonatomic, strong) UILabel *merchName;
@property (nonatomic, strong) UILabel *instName;
@property (nonatomic, strong) UITextField *addr;

@property (nonatomic, strong) ITextView *nameTextView;
@property (nonatomic, strong) ITextView *telTextView;
@property (nonatomic, strong) ITextView *mailTextView;


@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, weak) RadioButton *radioButton;
@property (nonatomic, strong) ITextView *desc;
@property (nonatomic, strong) UIImageView *licencePic;
@property (nonatomic, strong) UIImageView *facadePic;
@property (nonatomic, strong) UIImageView *signPic;
@property (nonatomic, strong) UIImageView *sitePic;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign) BOOL bEdit;

@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@property (nonatomic, strong) ILogViewController *logViewController;
@property (nonatomic, strong) ITermDetailViewController *termDetailViewController;
@property (nonatomic, strong) INewTermViewController *addTermViewController;

@property (nonatomic, strong) UILabel *resultLabel;
@property (nonatomic, strong) UIView *resultView;
@property (nonatomic, strong) UIButton *commitBtn;

@end
