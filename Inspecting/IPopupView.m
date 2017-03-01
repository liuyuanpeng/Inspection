//
//  IPopupView.m
//  Inspecting
//
//  Created by liuyuanpeng on 2017/2/27.
//  Copyright © 2017年 default. All rights reserved.
//

#import "IPopupView.h"

@implementation IPopupView

- (instancetype) init {
    self = [super init];
    if (self) {
        CGRect rScreen = [[UIScreen mainScreen] bounds];
        self.frame = CGRectMake(0, 0, rScreen.size.width, rScreen.size.height);
        
        self.backgroundColor = [UIColor grayColor];
    }
    return self;
}

- (void)setContentView:(UIView *)view {
    [self addSubview:view];
}

- (void)setContainer:(UIWindow *)window {
    self.window = window;
}

- (void)show {
    [self.window addSubview:self];
}

- (void)hide {
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
