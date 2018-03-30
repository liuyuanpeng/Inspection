//
//  INewShopViewController.h
//  Inspecting
//
//  Created by liuyuanpeng on 2017/3/5.
//  Copyright © 2017年 default. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class ITextView;
@class RadioButton;
@class ITagView;


@interface INewShopViewController : UIViewController<UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, MKMapViewDelegate>

@property (nonatomic, strong) UITextField *shopName;
@property (nonatomic, strong) UITextField *shopAddr;

@property (nonatomic, strong) UITextField *nameText;
@property (nonatomic, strong) UITextField *telText;
@property (nonatomic, strong) UITextField *mailText;

@property (nonatomic, weak) RadioButton *radioButton;
@property (nonatomic, strong) ITextView *desc;
@property (nonatomic, strong) ITextView *otherPay;
@property (nonatomic, strong) UIImageView *licencePic;
@property (nonatomic, strong) UIImageView *facadePic;
@property (nonatomic, strong) UIImageView *signPic;
@property (nonatomic, strong) UIImageView *sitePic;
@property (nonatomic, strong) UIImageView *ylsignPic;
@property (nonatomic, strong) UIImageView *mpewmPic;


@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) ITagView *tagView;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@property (nonatomic, strong) NSDictionary *merchInfo;

@property (nonatomic, strong) NSString *shopcode;
@property (nonatomic, assign) NSInteger inspcntid;
@property (nonatomic, strong) NSString *serialnbr;

@property (nonatomic, weak) UIImageView *curSelPic;

@property (nonatomic, strong) NSMutableArray *inspresultArray;
@property (nonatomic, strong) NSMutableDictionary *userImgDict;
@property (nonatomic, assign) BOOL needupdate;
@end
