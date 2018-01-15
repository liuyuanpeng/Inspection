//
//  MHProgress.m
//  MHProgress
//
//  Created by Macro on 10/12/15.
//  Copyright © 2015 Macro. All rights reserved.
//

#import "MHProgress.h"
#import "DEFINE.h"

@interface MHProgress ()
{
    UIActivityIndicatorView *_activityIndicatorView;
    MHPopViewType _popViewType;
    NSString *_tips;
    UILabel *_tipsLabel;
    CGSize _tipsSize;
    NSTimer *_timer;
    NSArray *_tipsArray;
    NSInteger _tipsIndex;
    failedBlock _failedBlock;
}

@end

@implementation MHProgress

+ (MHProgress *) getSeachInstance {
    static dispatch_once_t onceToken;
    static MHProgress *setSharedInstance;
    dispatch_once(&onceToken, ^{
        setSharedInstance = [[MHProgress alloc] initWithType:MHPopViewTypeFullScreenWithTips];
    });
    return setSharedInstance;
}

+ (MHProgress *) getCommitInstance {
    static dispatch_once_t onceToken;
    static MHProgress *setSharedInstance;
    dispatch_once(&onceToken, ^{
        setSharedInstance = [[MHProgress alloc] initWithType:MHPopViewTypeFullScreenWithTips NSString:@"数据努力上报中"];
    });
    return setSharedInstance;
}

// 初始化
- (instancetype)initWithType:(MHPopViewType)type {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, kWidth, kHeight);
        _popViewType = type;
        _tips = kTips;
    }
    return self;
}

- (instancetype)initWithType:(MHPopViewType)type failedBlock:failedBlock{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, kWidth, kHeight);
        _popViewType = type;
        _tips = kTips;
        if (_failedBlock) {
            _failedBlock = nil;
        }
        _failedBlock = failedBlock;
    }
    return self;
}

- (instancetype)initWithType:(MHPopViewType)type NSString:tips{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, kWidth, kHeight);
        _popViewType = type;
        _tips = tips;
    }
    return self;
}

// 添加中间View
- (void)addBgView {
    CGFloat w = kSideWidth;
    CGFloat h = kSideHeight;
    CGFloat correction = 0;
    if (_popViewType == MHPopViewTypeWrapContentWithTips) {
        w = _tipsSize.width + 20;
        correction = 10;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake((kWidth - w) / 2, (kHeight - h - correction) / 2 + correction, w, h)];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.6;
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = kCornerRadius;
    [self addSubview:view];
}

// 初始化加载圈
- (void)initActivityIndicatorView {
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityIndicatorView.center = self.center;
    _activityIndicatorView.color = [UIColor whiteColor];
}

// 设置背景色
- (void)setBackgroundColor {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
}

// 添加提示语
- (void)addTipsLabel {
    _tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake((kWidth - _tipsSize.width) / 2, self.center.y + 20, _tipsSize.width, _tipsSize.height)];
    _tipsLabel.text = _tipsArray[0];
    _tipsLabel.textAlignment = NSTextAlignmentCenter;
    _tipsLabel.textColor = [UIColor whiteColor];
    [self addSubview:_tipsLabel];
}

// 初始化等待加载的相关属性
- (void)initLoadingAttribute {
    if (_popViewType == MHPopViewTypeWrapContentWithTips || _popViewType == MHPopViewTypeFullScreenWithTips) {
        _tipsArray = @[_tips,
                       [_tips stringByAppendingString:@"."],
                       [_tips stringByAppendingString:@".."],
                       [_tips stringByAppendingString:@"..."],
                       [_tips stringByAppendingString:@"...."],
                       [_tips stringByAppendingString:@"....."],
                       [_tips stringByAppendingString:@"......"]];
        _tipsIndex = 0;
        _tipsSize = [self getSizeOfString:_tipsArray[_tipsArray.count - 1] maxBoundSizeWidth:kWidth - 100 fontSize:17];
    }
}

// 显示加载视图
- (void)showLoadingView {
    [self initLoadingAttribute];
    if (!_activityIndicatorView) {
        [self initActivityIndicatorView];
    }
    switch (_popViewType) {
        case MHPopViewTypeFullScreen: {
            [self setBackgroundColor];
            break;
        }
        case MHPopViewTypeWrapContent: {
            [self addBgView];
            break;
        }
        case MHPopViewTypeFullScreenWithTips: {
            [self setBackgroundColor];
            [self addTipsLabel];
            break;
        }
        case MHPopViewTypeWrapContentWithTips: {
            [self addBgView];
            [self addTipsLabel];
            break;
        }
        default:
            break;
    }
    [self addSubview:_activityIndicatorView];
    [_activityIndicatorView startAnimating];
    [WINDOW addSubview:self];
    [NSTimer scheduledTimerWithTimeInterval:kLoadingTime
                                     target:self
                                   selector:@selector(selfCloseLoadingView)
                                   userInfo:nil
                                    repeats:NO];
    if (_popViewType == MHPopViewTypeWrapContentWithTips
        || _popViewType == MHPopViewTypeFullScreenWithTips) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:kTipsTimeInterval
                                                  target:self
                                                selector:@selector(changeLoadingTips)
                                                userInfo:nil
                                                 repeats:YES];
    }
}

// 改变提示语
- (void)changeLoadingTips {
    _tipsIndex = (_tipsIndex + 1) % _tipsArray.count;
    _tipsLabel.text = _tipsArray[_tipsIndex];
}

- (void)selfCloseLoadingView {
    if (_failedBlock) {
        _failedBlock();
    }
    [self closeLoadingView];
}

// 关闭加载视图
- (void)closeLoadingView {
    if (_timer.isValid) {
        [_timer invalidate];
    }
    if (_activityIndicatorView) {
        [_activityIndicatorView removeFromSuperview];
    }
    if (_tipsLabel) {
        [_tipsLabel removeFromSuperview];
    }
    if (_failedBlock) {
        _failedBlock = nil;
    }
    if (self) {
        [self removeFromSuperview];
    }
}

// 显示提示语
- (void)showTips:(NSString *)tips
     intInterval:(CGFloat)timeInterval {
    CGSize size = [self getSizeOfString:tips
                      maxBoundSizeWidth:kWidth - 40
                               fontSize:17];
    _tipsLabel = [[UILabel alloc] initWithFrame:
                  CGRectMake((kWidth - size.width - 30) / 2,
                             kHeight - 150,
                             size.width + 20,
                             size.height)];
    _tipsLabel.backgroundColor = [[UIColor blackColor]
                                  colorWithAlphaComponent:0.7];
    _tipsLabel.text = tips;
    _tipsLabel.textColor = [UIColor whiteColor];
    _tipsLabel.textAlignment = NSTextAlignmentCenter;
    _tipsLabel.layer.masksToBounds = YES;
    _tipsLabel.layer.cornerRadius = size.height / 4;
    [self addSubview:_tipsLabel];
    
    [WINDOW addSubview:self];
    
    [NSTimer scheduledTimerWithTimeInterval:timeInterval
                                     target:self
                                   selector:@selector(closeTips)
                                   userInfo:nil
                                    repeats:NO];
}

// 关闭提示语
- (void)closeTips {
    if ([_timer isValid]) {
        [_timer invalidate];
    }
    if (_tipsLabel) {
        [_tipsLabel removeFromSuperview];
    }
    if (self) {
        [self removeFromSuperview];
    }
}


// 获取提示语大小
- (CGSize)getSizeOfString:(NSString*)string
        maxBoundSizeWidth:(CGFloat)width
                 fontSize:(CGFloat)fontSize {
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         [UIFont systemFontOfSize:fontSize],
                         NSFontAttributeName,  nil];
    CGSize size = [string
                   boundingRectWithSize:CGSizeMake(width, kHeight)
                                options:NSStringDrawingTruncatesLastVisibleLine
                                        |NSStringDrawingUsesLineFragmentOrigin
                                        |NSStringDrawingUsesFontLeading
                             attributes:dic
                                context:nil].size;
    return size;
}


@end
