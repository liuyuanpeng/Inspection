//
//  IAnnotationView.m
//  Inspecting
//
//  Created by liuyuanpeng on 2017/4/8.
//  Copyright © 2017年 default. All rights reserved.
//

#import "IAnnotationView.h"

@implementation IAnnotationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        //大头针的图片
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [self addSubview:imageView];
    }
    
    return self;
}


@end
