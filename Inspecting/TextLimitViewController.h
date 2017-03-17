//
//  TextLimitViewController.h
//  Inspecting
//
//  Created by liuyuanpeng on 2017/3/18.
//  Copyright © 2017年 default. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TextLimitViewControllerDelegate <NSObject>

@optional
- (NSInteger)getTextFieldLimit:(UITextField *)textField;
- (NSInteger)getTextViewLimit:(UITextView *)textView;

@end

@interface TextLimitViewController : UIViewController
@property (nonatomic, weak) id<TextLimitViewControllerDelegate> textLimitDelegate;
@end
