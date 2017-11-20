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
#import "AFNRequestManager.h"
#import "NSString+MD5.h"
#import "iPhone.h"
#import <Toast/UIView+Toast.h>
#import "iUser.h"
#import "ITermType.h"
#import "IVersion.h"
#import "Utils.h"
#import "ITags.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldEditChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewEditChanged:) name:UITextViewTextDidChangeNotification object:nil];
    
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
    [self.username setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self.username setAutocapitalizationType:UITextAutocapitalizationTypeNone];
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
    
    // load term types
    ITermType *termtype = [ITermType getInstance];
    [termtype requestTypes];
    [IVersion getInstance];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLogin:(id)sender {
    // check location access
    if (![Utils locationAccess]) {
        [self.view makeToast:@"请先开启定位服务!"];
        [Utils openLocationSetting:self];
        return;
    }
    
    // check username
    NSString *username = [self.username.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *pwd = [self.password.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *imsi = [iPhone getIMSI];
    NSString *imei = [iPhone getIMEI];
    if (username.length == 0) {
        [self.view makeToast:@"请输入用户名!"];
        return;
    }
    else if (pwd.length  == 0) {
        [self.view makeToast:@"请输入密码!"];
        return;
    }
    
    NSDictionary *params = @{
                             @"acctid": username,
                             @"pwd": [pwd md5],
                             @"imsi": imsi,
                             @"imei": imei,
                             @"version":[IVersion getInstance].version,
                             @"system":@"IOS"
                             };
    [AFNRequestManager requestAFURL:@"loginCheck.json" httpMethod:METHOD_POST params:params succeed:^(NSDictionary *ret) {
        if (4 == [[ret valueForKey:@"status"] integerValue]) {
            [self.view makeToast:[ret valueForKey:@"desc"]];
        }else if (6 == [[ret valueForKey:@"status"] integerValue]) {
            [self.view makeToast:[ret valueForKey:@"desc"]];
            [Utils openUpdate:self];
        }
        else if (0 != [[ret valueForKey:@"status"] integerValue]) {
//            [self onLoginSuccess];
            [self.view makeToast:[ret valueForKey:@"desc"]];
        }
        else {
            [self saveTags:[ret valueForKey:@"paytype"]];
            [self onLoginSuccess: [ret valueForKey:@"datas"]];
        }
    } failure:^(NSError * error) {
        NSLog(@"fail:%@", error);
    }];
}

-(void)saveTags:(NSMutableArray *)array {
    [[ITags getInstance] setTags:array];
}

- (void) onLoginSuccess:(NSDictionary *)dict {
    iUser *userInst = [iUser getInstance];
    [userInst setData:dict];
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 49)];
    backView.backgroundColor = [UIColor colorWithRed:225/255.0 green:64/255.0 blue:67/255.0 alpha:1.0];
    [tabBarController.tabBar insertSubview:backView atIndex:0];
    tabBarController.tabBar.opaque = YES;
    [tabBarController.tabBar setTintColor:[UIColor whiteColor]];
//    [tabBarController.tabBar setUnselectedItemTintColor:[UIColor whiteColor]];
    
    HomeViewController *homeViewController = [[HomeViewController alloc] init];
    PublicMissionViewController *publicMissionViewController = [[PublicMissionViewController alloc] init];
    MyMissionViewController *myMissionViewController = [[MyMissionViewController alloc] init];
    UserInfoViewController *userInfoViewController = [[UserInfoViewController alloc] init];
    
    homeViewController.myMissionViewController = myMissionViewController;
    
    NSDictionary *textAttribute = @{
                                    NSForegroundColorAttributeName: [UIColor whiteColor],
                                    NSFontAttributeName: [UIFont systemFontOfSize:12.0]
                                    };
    
    UINavigationController *navHome = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    [navHome.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics: UIBarMetricsDefault];
    [navHome.navigationBar setBackgroundColor:[UIColor colorWithRed:225/255.0 green:64/255.0 blue:67/255.0 alpha:1.0]];
    navHome.tabBarItem.title = @"首页";
    navHome.tabBarItem.image = [[UIImage scaleToSize:[UIImage imageNamed:@"i_home.png"] size:CGSizeMake(30, 30)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [navHome.tabBarItem setTitleTextAttributes:textAttribute forState:UIControlStateNormal];
    
    
    UINavigationController *navMyMission = [[UINavigationController alloc] initWithRootViewController:myMissionViewController];
    
    [navMyMission.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics: UIBarMetricsDefault];
    [navMyMission.navigationBar setBackgroundColor:[UIColor colorWithRed:225/255.0 green:64/255.0 blue:67/255.0 alpha:1.0]];
    navMyMission.tabBarItem.title = @"我的任务";
    navMyMission.tabBarItem.image = [[UIImage scaleToSize:[UIImage imageNamed:@"i_mymission.png"] size:CGSizeMake(30, 30)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [navMyMission.tabBarItem setTitleTextAttributes:textAttribute forState:UIControlStateNormal];
    
    UINavigationController *navPublicMission = [[UINavigationController alloc] initWithRootViewController:publicMissionViewController];
    
    [navPublicMission.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics: UIBarMetricsDefault];
    [navPublicMission.navigationBar setBackgroundColor:[UIColor colorWithRed:225/255.0 green:64/255.0 blue:67/255.0 alpha:1.0]];
    navPublicMission.tabBarItem.title = @"公共任务";
    navPublicMission.tabBarItem.image = [[UIImage scaleToSize:[UIImage imageNamed:@"i_allmission.png"] size:CGSizeMake(30, 30)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [navPublicMission.tabBarItem setTitleTextAttributes:textAttribute forState:UIControlStateNormal];
    
    UINavigationController *navUserInfo = [[UINavigationController alloc] initWithRootViewController:userInfoViewController];
    
    [navUserInfo.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics: UIBarMetricsDefault];
    [navUserInfo.navigationBar setBackgroundColor:[UIColor colorWithRed:225/255.0 green:64/255.0 blue:67/255.0 alpha:1.0]];
    navUserInfo.tabBarItem.title = @"我的";
    navUserInfo.tabBarItem.image = [[UIImage scaleToSize:[UIImage imageNamed:@"i_mine.png"] size:CGSizeMake(30, 30)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [navUserInfo.tabBarItem setTitleTextAttributes:textAttribute forState:UIControlStateNormal];
    
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


#pragma mark - UITextFieldDidChanged Notification
- (void)textFieldEditChanged:(NSNotification *)obj {
    UITextField *textField = (UITextField *)obj.object;
    NSInteger maxLength = 30;
    NSString *toBeString = textField.text;
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage; //键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > maxLength) {
                textField.text = [toBeString substringToIndex:maxLength];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > maxLength) {
            textField.text = [toBeString substringToIndex:maxLength];
        }
    }
}

- (void)textViewEditChanged:(NSNotification *)obj {
    UITextView *textView = (UITextView *)obj.object;
    NSInteger maxLength = 100; // 默认限制长度
    NSString *toBeString = textView.text;
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage; //键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > maxLength) {
                textView.text = [toBeString substringToIndex:maxLength];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > maxLength) {
            textView.text = [toBeString substringToIndex:maxLength];
        }
    }
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
