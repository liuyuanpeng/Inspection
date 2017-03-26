//
//  IShopDetailViewController.h
//  Inspecting
//
//  Created by liuyuanpeng on 2017/3/5.
//  Copyright © 2017年 default. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>

@class ITextView;
@class RadioButton;
@class ILogViewController;
@class ITermDetailViewController;
@class INewTermViewController;

@interface IShopDetailViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate, BMKGeoCodeSearchDelegate>

@property (nonatomic, strong) NSDictionary *merchInfo;
@property (nonatomic, strong) NSDictionary *shopInfo;
@property (nonatomic, strong) NSDictionary *shopDetail;

@property (nonatomic, strong) UIImageView *shopImg;
@property (nonatomic, strong) UITextField *shopName;
@property (nonatomic, strong) UILabel *shopCode;
@property (nonatomic, strong) UILabel *merchName;
@property (nonatomic, strong) UILabel *instName;
@property (nonatomic, strong) UITextField *addr;

@property (nonatomic, strong) UITextField *nameTextView;
@property (nonatomic, strong) UITextField *telTextView;
@property (nonatomic, strong) UITextField *mailTextView;


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

@property (nonatomic, assign) NSInteger inspcntid;

@property (nonatomic, strong) NSMutableArray *inspresultArray;
@property (nonatomic, strong) NSMutableDictionary *userImgDict;
@property (nonatomic, weak) UIImageView *curSelPic;

@property (nonatomic, strong) UIImage *loadingImage;
@property (nonatomic, assign) BOOL needupdate;
@end
