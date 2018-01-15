//
//  NSObject+UIScrollView.m
//  Inspecting
//
//  Created by 林开斌 on 2018/1/11.
//  Copyright © 2018年 default. All rights reserved.
//

#import "UIScrollView+UITouch.h"

@implementation UIScrollView (UITouch)

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 选其一即可
    [super touchesBegan:touches withEvent:event];
    //  [[self nextResponder] touchesBegan:touches withEvent:event];
}

@end 
