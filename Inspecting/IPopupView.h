//
//  IPopupView.h
//  Inspecting
//
//  Created by liuyuanpeng on 2017/2/27.
//  Copyright © 2017年 default. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPopupView : UIView

@property (nonatomic, weak) UIWindow *window;

- (void) setContentView:(UIView *)view;
- (void) show;
- (void) hide;

@end
