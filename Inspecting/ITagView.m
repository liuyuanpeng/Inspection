//
//  ITagView.m
//  Inspecting
//
//  Created by liuyuanpeng on 2017/10/16.
//  Copyright © 2017年 default. All rights reserved.
//

#import "ITagView.h"

@implementation ITagView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame tagArray:(NSMutableArray *)tagArray {
    self = [super initWithFrame:frame];
    if (self) {
        _tagArray = tagArray;
        _selectedTags = [[NSMutableArray alloc]init];
        [self setUp];
    }
    return self;
}

- (NSMutableArray *)getSelectedTags{
    [_selectedTags removeAllObjects];
    for(int i=0;i < _tagArray.count; i++){
        UIButton* btn = (UIButton*)[self viewWithTag:100+i];
        if(btn.selected){
            [_selectedTags addObject:[_tagArray objectAtIndex:i]];
        }
    }
    return _selectedTags;
}

- (void)setSelectedTags:(NSMutableArray *)selectedTags {
    _selectedTags = selectedTags;
    for (NSInteger i = 0; i < _tagArray.count; i++) {
        for (NSString *selectedTag in selectedTags) {
            if ([selectedTag compare:[_tagArray objectAtIndex:i]] == NSOrderedSame) {
                ((UIButton*)[self viewWithTag:100+i]).selected = YES;
            }
        }
    }
}

-(void) setUp {
    _textColorNormal = [UIColor darkGrayColor];
    _textColorSelected = [UIColor whiteColor];
    _backgroundColorNormal = [UIColor whiteColor];
    _backgroundColorSelected = [UIColor redColor];
    
    [self createTagButton];
}

-(void)setTagArray:(NSMutableArray*)tagArray {
    _tagArray = tagArray;
    [self resetTagButton];
}

-(void)setTextColorNormal:(UIColor *)textColorNormal {
    _textColorNormal = textColorNormal;
    [self resetTagButton];
}

-(void) setTextColorSelected:(UIColor *)textColorSelected {
    _textColorSelected = textColorSelected;
    [self resetTagButton];
}

- (void) setBackgroundColorNormal:(UIColor *)backgroundColorNormal {
    _backgroundColorNormal = backgroundColorNormal;
    [self resetTagButton];
}

- (void)setBackgroundColorSelected:(UIColor *)backgroundColorSelected {
    _backgroundColorSelected = backgroundColorSelected;
    [self resetTagButton];
}

#pragma mark - Private

-(void) resetTagButton {
    for (UIButton *btn in self.subviews) {
        [btn removeFromSuperview];
    }
    [self createTagButton];
}

- (void)createTagButton {
    CGFloat btnH = 28.0;
    CGFloat leftX = 6.0;
    CGFloat topY = 10.0;
    CGFloat marginX = 10.0;
    CGFloat marginY = 10.0;
    CGFloat fontMargin = 10.0;
    
    for (int i = 0; i < _tagArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(marginX + leftX, topY, 100, btnH);
        btn.tag = 100 + i;
        
        [btn setTitle:_tagArray[i] forState:UIControlStateNormal];
        
        //------ 默认样式
        //按钮文字默认样式
        NSMutableAttributedString* btnDefaultAttr = [[NSMutableAttributedString alloc]initWithString:btn.titleLabel.text];
        // 文字大小
        [btnDefaultAttr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, btn.titleLabel.text.length)];
        // 默认颜色
        [btnDefaultAttr addAttribute:NSForegroundColorAttributeName value:self.textColorNormal range:NSMakeRange(0, btn.titleLabel.text.length)];
        [btn setAttributedTitle:btnDefaultAttr forState:UIControlStateNormal];
        
        // 默认背景颜色
        [btn setBackgroundImage:[self imageWithColor:self.backgroundColorNormal] forState:UIControlStateNormal];
        
        //-----  选中样式
        // 选中字体颜色
        NSMutableAttributedString* btnSelectedAttr = [[NSMutableAttributedString alloc]initWithString:btn.titleLabel.text];
        // 选中颜色
        [btnSelectedAttr addAttribute:NSForegroundColorAttributeName value:self.textColorSelected range:NSMakeRange(0, btn.titleLabel.text.length)];
        // 选中文字大小
        [btnSelectedAttr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, btn.titleLabel.text.length)];
        [btn setAttributedTitle:btnSelectedAttr forState:UIControlStateSelected];
        
        // 选中背景颜色
        [btn setBackgroundImage:[self imageWithColor:self.backgroundColorSelected] forState:UIControlStateSelected];
        
        // 圆角
        btn.layer.cornerRadius = btn.frame.size.height / 2.f;
        btn.layer.masksToBounds = YES;
        // 边框
        btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        btn.layer.borderWidth = 0.5;
        
        // 设置按钮的边距、间隙
        [self setTagButtonMargin:btn fontMargin:fontMargin];
        
        // 处理换行
        if (btn.frame.origin.x + btn.frame.size.width + marginX > self.frame.size.width) {
            // 换行
            topY += btnH + marginY;
            
            // 重置
            leftX = 6;
            btn.frame = CGRectMake(marginX + leftX, topY, 100, btnH);
            
            // 设置按钮的边距、间隙
            [self setTagButtonMargin:btn fontMargin:fontMargin];
        }
        
        // 重置高度
        CGRect frame = btn.frame;
        frame.size.height = btnH;
        btn.frame = frame;
        
        //----- 选中事件
        [btn addTarget:self action:@selector(selectdButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:btn];
        
        leftX += btn.frame.size.width + marginX;
    }
    
    CGRect frame = self.frame;
    frame.size.height = topY + btnH + marginY;
    self.frame = frame;
    
    // 检测按钮状态，最少选中一个
    [self checkButtonState];
}

- (void)setTagButtonMargin:(UIButton*)btn fontMargin:(CGFloat)fontMargin{
    
    // 按钮自适应
    [btn sizeToFit];
    
    // 重新计算按钮文字左右间隙
    CGRect frame = btn.frame;
    frame.size.width += fontMargin*2;
    btn.frame = frame;
}

- (void)checkButtonState{
    int selectCount = 0;
    UIButton* selectedBtn = nil;
    for(int i=0;i < _tagArray.count; i++){
        UIButton* btn = (UIButton*)[self viewWithTag:100+i];
        if(btn.selected){
            selectCount++;
            selectedBtn = btn;
        }
    }
    if (selectCount == 1) {
        // 只有一个就把这一个给禁用手势
        selectedBtn.userInteractionEnabled = NO;
    }else{
        // 解除禁用手势
        for(int i=0;i < _tagArray.count; i++){
            UIButton* btn = (UIButton*)[self viewWithTag:100+i];
            if(!btn.userInteractionEnabled){
                btn.userInteractionEnabled = YES;
            }
        }
    }
}

- (UIImage*)imageWithColor:(UIColor*)color{
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    // 开始画图的上下文
    UIGraphicsBeginImageContext(rect.size);
    
    // 设置背景颜色
    [color set];
    // 设置填充区域
    UIRectFill(CGRectMake(0, 0, rect.size.width, rect.size.height));
    
    // 返回UIImage
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - Event

// 标签按钮点击事件
- (void)selectdButton:(UIButton*)btn{
    
    btn.selected = !btn.selected;
    
    // 检测按钮状态，最少选中一个
    [self checkButtonState];
}

@end
