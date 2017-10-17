//
//  ITagView.h
//  Inspecting
//
//  Created by liuyuanpeng on 2017/10/16.
//  Copyright © 2017年 default. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ITagView : UIView

-(instancetype) initWithFrame:(CGRect)frame tagArray:(NSMutableArray *)tagArray;
- (NSMutableArray *)getSelectedTags;

@property (nonatomic, copy) NSArray *tagArray;
@property (nonatomic, copy) NSMutableArray *selectedTags;
@property (nonatomic, strong) UIColor *textColorSelected;
@property (nonatomic, strong) UIColor *textColorNormal;
@property (nonatomic, strong) UIColor *backgroundColorSelected;
@property (nonatomic, strong) UIColor *backgroundColorNormal;

@end
