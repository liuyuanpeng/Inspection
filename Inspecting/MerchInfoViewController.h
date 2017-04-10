//
//  MerchInfoViewController.h
//  Inspecting
//
//  Created by liuyuanpeng on 2017/3/2.
//  Copyright © 2017年 default. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class RadioButton;
@class ITextView;
@class ILogViewController;
@class IShopViewController;
@class ITermViewController;
@class PickerView;

@interface MerchInfoViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, MKMapViewDelegate>

@property (nonatomic, strong) UIImageView *merchimg;
@property (nonatomic, strong) UITextField *merchname;
@property (nonatomic, strong) UILabel *merchtype;
@property (nonatomic, strong) UILabel *merchcode;
@property (nonatomic, strong) UILabel *merchinst;
@property (nonatomic, strong) UITextField *merchAddr;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, weak) RadioButton *radioButton;
@property (nonatomic, strong) ITextView *desc;
@property (nonatomic, strong) UIImageView *licencePic;
@property (nonatomic, strong) UIImageView *facadePic;
@property (nonatomic, strong) UIImageView *signPic;
@property (nonatomic, strong) UIImageView *sitePic;
 
@property (nonatomic, assign) BOOL bEdit;

@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@property (nonatomic, strong) NSDictionary *taskInfo;
@property (nonatomic, strong) NSMutableDictionary *merchInfo;

@property (nonatomic, strong) ILogViewController *logViewController;
@property (nonatomic, strong) IShopViewController *shopViewController;
@property (nonatomic, strong) ITermViewController *termViewController;
@property (nonatomic, strong) PickerView *pickerView;

@property (nonatomic, weak) UIImageView *curSelPic;
@property (nonatomic, assign) NSInteger insp_cnt_id;

@property (nonatomic, strong) NSMutableArray *imgArray;
@property (nonatomic, strong) UIButton *editBtn;

@property (nonatomic, strong) NSMutableArray *inspresultArray;
@property (nonatomic, strong) NSMutableDictionary *userImgDict;

@property (nonatomic, assign) BOOL needupdate;
@property (nonatomic, strong) UIImage *loadingImage;

@property (nonatomic, strong) UIScrollView *scrollView;
@end
