//
//  LoginViewController.m
//  Inspecting
//
//  Created by liuyuanpeng on 2017/2/16.
//  Copyright © 2017年 default. All rights reserved.
//

#import "LoginViewController.h"
#import "HomeViewController.h"
#import "PublicMissionViewController.h"
#import "MyMissionViewController.h"
#import "UserInfoViewController.h"
#import "UIImage+UIImageEx.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGRect rScreen = [[UIScreen mainScreen] bounds];
    
    self.view.backgroundColor = [UIColor colorWithRed:234/255.0 green:230/255.0 blue:221/255.0 alpha:1.0];
    
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"p_login_logo3.png"]];
    logo.frame = CGRectMake(rScreen.size.width/2 - 324/4, 50, 324/2, 203/2);
    [self.view addSubview:logo];
    
    UIImageView *logo2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"p_login_logo2.png"]];
    logo2.frame = CGRectMake(rScreen.size.width/2 - 215/4, 157 + 31, 215/2, 20);
    [self.view addSubview:logo2];
    
    // input field
    UIView *inputField = [[UIView alloc] initWithFrame:CGRectMake(rScreen.size.width/2 - 494/4, 157 + 31 + 53, 494/2, 240/2)];
    [inputField.layer setBorderColor:[UIColor whiteColor].CGColor];
    [inputField.layer setBorderWidth:2.0];
    [inputField.layer setCornerRadius:5];
    inputField.backgroundColor = [UIColor whiteColor];
    
    self.username = [[UITextField alloc] initWithFrame:CGRectMake(180/2, 0, 146, 240/4 - 1)];
    self.password = [[UITextField alloc] initWithFrame:CGRectMake(180/2, 240/4 + 1, 146, 240/4)];
    
    UIView *splitLine = [[UIView alloc] initWithFrame:CGRectMake(0, 240/4 - 2, 494/2, 2)];
    [splitLine setBackgroundColor:[UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0]];

    [self.username setPlaceholder:@"请输入登录账号"];
//    [self.username becomeFirstResponder];
    self.username.delegate = self;
    [self.password setPlaceholder:@"请输入密码"];
    self.password.secureTextEntry = YES;
    self.password.delegate = self;
    
    UIImageView *userLogo = [[UIImageView alloc] initWithFrame:CGRectMake(28/2, 42/2, 35/1.5, 28/1.5)];
    userLogo.image = [UIImage imageNamed:@"i_login_user.png"];
    UIImageView *pwLogo = [[UIImageView alloc] initWithFrame:CGRectMake(28/2, 42/2 + 240/4, 35/1.5, 28/1.5)];
    pwLogo.image = [UIImage imageNamed:@"i_login_password.png"];
    
    [inputField addSubview:self.username];
    [inputField addSubview:self.password];
    [inputField addSubview:splitLine];
    
    [inputField addSubview:userLogo];
    [inputField addSubview:pwLogo];
    
    [self.view addSubview:inputField];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(rScreen.size.width/2 - 188/4, 361 + 84/2, 188/2, 76/2);
    [button addTarget:self action:@selector(onLogin:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor colorWithRed:209/255.0 green:120/255.0 blue:119/255.0 alpha:1.0];
    [button setTitle:@"登陆" forState:UIControlStateNormal];
    [button.layer setCornerRadius:3.0];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onLogin:(id)sender {
    NSLog(@"login action");
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 49)];
    backView.backgroundColor = [UIColor colorWithRed:225/255.0 green:64/255.0 blue:67/255.0 alpha:1.0];
    [tabBarController.tabBar insertSubview:backView atIndex:0];
    tabBarController.tabBar.opaque = YES;
    [tabBarController.tabBar setTintColor:[UIColor whiteColor]];
    [tabBarController.tabBar setUnselectedItemTintColor:[UIColor whiteColor]];
    
    HomeViewController *homeViewController = [[HomeViewController alloc] init];
    PublicMissionViewController *publicMissionViewController = [[PublicMissionViewController alloc] init];
    MyMissionViewController *myMissionViewController = [[MyMissionViewController alloc] init];
    UserInfoViewController *userInfoViewController = [[UserInfoViewController alloc] init];
    
    UINavigationController *navHome = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    [navHome.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics: UIBarMetricsDefault];
    [navHome.navigationBar setBackgroundColor:[UIColor colorWithRed:225/255.0 green:64/255.0 blue:67/255.0 alpha:1.0]];
    navHome.tabBarItem.title = @"首页";
    navHome.tabBarItem.image = [UIImage scaleToSize:[UIImage imageNamed:@"i_home.png"] size:CGSizeMake(30, 30)];
    
    UINavigationController *navMyMission = [[UINavigationController alloc] initWithRootViewController:myMissionViewController];
    
    [navMyMission.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics: UIBarMetricsDefault];
    [navMyMission.navigationBar setBackgroundColor:[UIColor colorWithRed:225/255.0 green:64/255.0 blue:67/255.0 alpha:1.0]];
    navMyMission.tabBarItem.title = @"我的任务";
    navMyMission.tabBarItem.image = [UIImage scaleToSize:[UIImage imageNamed:@"i_mymission.png"] size:CGSizeMake(30, 30)];
    
    UINavigationController *navPublicMission = [[UINavigationController alloc] initWithRootViewController:publicMissionViewController];
    
    [navPublicMission.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics: UIBarMetricsDefault];
    [navPublicMission.navigationBar setBackgroundColor:[UIColor colorWithRed:225/255.0 green:64/255.0 blue:67/255.0 alpha:1.0]];
    navPublicMission.tabBarItem.title = @"公共任务";
    navPublicMission.tabBarItem.image = [UIImage scaleToSize:[UIImage imageNamed:@"i_allmission.png"] size:CGSizeMake(30, 30)];
    
    UINavigationController *navUserInfo = [[UINavigationController alloc] initWithRootViewController:userInfoViewController];
    
    [navUserInfo.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics: UIBarMetricsDefault];
    [navUserInfo.navigationBar setBackgroundColor:[UIColor colorWithRed:225/255.0 green:64/255.0 blue:67/255.0 alpha:1.0]];
    navUserInfo.tabBarItem.title = @"我的";
    navUserInfo.tabBarItem.image = [UIImage scaleToSize:[UIImage imageNamed:@"i_mine.png"] size:CGSizeMake(30, 30)];
    
    [tabBarController addChildViewController:navHome];
    [tabBarController addChildViewController:navMyMission];
    [tabBarController addChildViewController:navPublicMission];
    [tabBarController addChildViewController:navUserInfo];
    [self presentViewController:tabBarController animated:NO completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - UITextField Delegate Impletation

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (textField == self.username) {
        [self.password becomeFirstResponder];
    }
    return YES;
}

@end
