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

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) BOOL isHidden;

- (void)setContentView:(UIView *)contentView;
- (void) show;
- (void) hide;
@end
