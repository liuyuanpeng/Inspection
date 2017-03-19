//
//  IPubTaskDetailViewController.h
//  Inspecting
//
//  Created by liuyuanpeng on 2017/3/18.
//  Copyright © 2017年 default. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ITextView;

@interface IPubTaskDetailViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, assign) NSInteger step;
@property (nonatomic, strong) UIButton *preButton;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UIButton *commitButton;
@property (nonatomic, strong) ITextView *inspContentText;
@property (nonatomic, strong) UIImage *loadingImage;
@property (nonatomic, strong) NSMutableArray *picViewArray;
@property (nonatomic, assign) NSInteger curImgViewIndex;
@property (nonatomic, strong) IPubTaskDetailViewController *nextStepViewController;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@property (nonatomic, strong) NSMutableDictionary * userImageDict;
@property (nonatomic, assign) NSInteger maxNum;
@end
