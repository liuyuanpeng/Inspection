//
//  IPopupView.m
//  Inspecting
//
//  Created by liuyuanpeng on 2017/2/27.
//  Copyright © 2017年 default. All rights reserved.
//

#import "IPopupView.h"
#import "AppDelegate.h"

@implementation IPopupView

- (instancetype) init {
    self = [super init];
    if (self) {
        CGRect rScreen = [[UIScreen mainScreen] bounds];
        self.frame = CGRectMake(0, 0, rScreen.size.width, rScreen.size.height);
        
        self.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
        self.isHidden = YES;
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTaped:)]];
    }
    return self;
}

- (IBAction)onTaped:(id)sender {
    [self hide];
}

- (void)setContentView:(UIView *)contentView {
    if (self.subviews.count == 1) {
        [self.subviews[0] removeFromSuperview];
    }
    _contentView = contentView;
    [self addSubview:contentView];
}

- (void)show {
    if (!self.isHidden) {
        return;
    }
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.window addSubview:self];
    self.isHidden = NO;
}

- (void)hide {
    if (self.isHidden) {
        return;
    }
    [self removeFromSuperview];
    self.isHidden = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
