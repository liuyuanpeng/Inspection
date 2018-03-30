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
@property (nonatomic, strong) UIButton *termType;

@property (nonatomic, weak) RadioButton *radioButton;
@property (nonatomic, strong) ITextView *desc;
@property (nonatomic, strong) ITextView *qgdkh;
@property (nonatomic, strong) UIImageView *instPic;
@property (nonatomic, strong) UIImageView *serialPic;
@property (nonatomic, strong) UIImageView *qgdewmPic;
@property (nonatomic, strong) UIImageView *qgdsjpPic;


@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@property (nonatomic, strong) NSDictionary *merchInfo;
@property (nonatomic, strong) NSDictionary *shopInfo;

@property (nonatomic, strong) NSString *termcode;
@property (nonatomic, assign) NSInteger snseq;
@property (nonatomic, assign) NSInteger inspcntid;

@property (nonatomic, strong) NSMutableDictionary *userImgDict;
@property (nonatomic, weak) UIImageView *curSelPic;
@property (nonatomic, assign) BOOL needupdate;
@end
