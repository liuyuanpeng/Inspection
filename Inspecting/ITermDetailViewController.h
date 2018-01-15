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
@property (nonatomic, strong) UIImageView *instPic;
@property (nonatomic, strong) UIImageView *serialPic;
@property (nonatomic, strong) UIImageView *testPic;
@property (nonatomic, strong) UIButton *editBtn;

@property (nonatomic, assign) BOOL bEdit;

@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@property (nonatomic, strong) NSDictionary *merchInfo;
@property (nonatomic, strong) NSDictionary *shopInfo;
@property (nonatomic, strong) NSDictionary *termInfo;

@property (nonatomic, strong) NSMutableDictionary *termDetail;

@property (nonatomic, assign) NSInteger inspcntid;

@property (nonatomic, strong) NSMutableArray *inspresultArray;
@property (nonatomic, strong) NSMutableDictionary *userImgDict;
@property (nonatomic, weak) UIImageView *curSelPic;
@property (nonatomic, strong) UIImage *loadingImage;
@property (nonatomic, assign) BOOL needupdate;

@property (nonatomic, strong) UIScrollView *scrollView;
@end
