//
//  HomeViewController.h
//  Inspecting
//
//  Created by liuyuanpeng on 2017/2/16.
//  Copyright © 2017年 default. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) UIImageView *organAvatar;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *organLabel;
@property (nonatomic, strong) UILabel *finishedLabel;
@property (nonatomic, strong) UILabel *unfinishedLabel;

- (void)setAvartar:(UIImage *)avatar organAvatar:(UIImage *)organAvatar;
- (void)setUsername:(NSString *)username organname:(NSString *)organname;
- (void)setFinished:(NSInteger)finished Unfinished:(NSInteger)unfinished;

@end
