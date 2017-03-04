//
//  ITermViewController.m
//  Inspecting
//
//  Created by liuyuanpeng on 2017/3/4.
//  Copyright © 2017年 default. All rights reserved.
//

#import "ITermViewController.h"

@interface ITermViewController ()

@end

@implementation ITermViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:236.0/255.0 alpha:1.0];
    CGRect rScreen = [[UIScreen mainScreen] bounds];
    CGRect rNav = self.navigationController.navigationBar.frame;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,  rScreen.size.width, 30)];
    titleLabel.text = @"终端列表";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLabel;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
