//
//  MyMissionViewController.m
//  Inspecting
//
//  Created by liuyuanpeng on 2017/2/16.
//  Copyright © 2017年 default. All rights reserved.
//

#import "MyMissionViewController.h"

@interface MyMissionViewController ()

@end

@implementation MyMissionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:234/255.0 green:230/255.0 blue:221/255.0 alpha:1.0];
    
    CGRect rScreen = [[UIScreen mainScreen] bounds];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,  rScreen.size.width, 30)];
    titleLabel.text = @"我的任务";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLabel;
    
    UIButton *buttonSearch = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonSearch setFrame:CGRectMake(rScreen.size.width - 50, 5, 40, 20)];
    [titleLabel addSubview:buttonSearch];
    buttonSearch.titleLabel.text = @"搜索";
    [buttonSearch addTarget:self action:@selector(onSearch:) forControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)onSearch:(id)sender {
    
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
