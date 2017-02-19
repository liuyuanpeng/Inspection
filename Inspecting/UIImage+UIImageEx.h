//
//  UIImage+UIImageEx.h
//  Inspecting
//
//  Created by liuyuanpeng on 2017/2/18.
//  Copyright © 2017年 default. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (UIImageEx)

+ (UIImage*) scaleToSize:(UIImage *)img size:(CGSize)size;

- (UIImage*) imageByScallingAndCroppingForSize:(CGSize)targetSize;

@end
