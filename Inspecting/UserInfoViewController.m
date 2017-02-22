//
//  UserInfoViewController.m
//  Inspecting
//
//  Created by liuyuanpeng on 2017/2/16.
//  Copyright © 2017年 default. All rights reserved.
//

#import "UserInfoViewController.h"

@interface UserInfoViewController ()

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:234/255.0 green:230/255.0 blue:221/255.0 alpha:1.0];
    
    CGRect rScreen = [[UIScreen mainScreen] bounds];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,  rScreen.size.width, 30)];
    titleLabel.text = @"个人中心";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLabel;
    
    CGRect rHeader = self.navigationController.navigationBar.frame;
    
    UIImageView *header = [[UIImageView alloc] initWithFrame:CGRectMake(0, rHeader.origin.y + rHeader.size.height, rScreen.size.width, 270/2)];
    header.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"b_protrait.png"]] ;
    //    header.backgroundColor = [UIColor grayColor];
    [self.view addSubview:header];
    
    self.avatar = [[UIImageView alloc] initWithFrame:CGRectMake(10, 27, 80, 80)];
    [self.avatar.layer setCornerRadius:40];
    [self.avatar.layer setMasksToBounds:YES];
    self.avatar.backgroundColor = [UIColor whiteColor];
    [header addSubview:self.avatar];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(112, 38, 150, 30)];
    self.nameLabel.text = @"姓名：xxx";
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    self.organLabel = [[UILabel alloc] initWithFrame:CGRectMake(112, 77, 150, 30)];
    self.organLabel.text = @"隶属机构：xxxxxxxx";
    self.organLabel.textColor = [UIColor whiteColor];
    self.organLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    [header addSubview:self.nameLabel];
    [header addSubview:self.organLabel];
    
    UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(0, header.frame.origin.y + header.frame.size.height, rScreen.size.width, 94)];
    infoView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:infoView];
    
    UIView *split1 = [[UIView alloc] initWithFrame:CGRectMake(10, 30, rScreen.size.width - 20, 2)];
    split1.backgroundColor = [UIColor grayColor];
    UIView *split2 = [[UIView alloc] initWithFrame:CGRectMake(10, 62, rScreen.size.width - 20, 2)];
    split2.backgroundColor = [UIColor grayColor];
    [infoView addSubview:split1];
    [infoView addSubview:split2];
    
    CGFloat fontSize = 13;
    
    UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, fontSize)];
    labelName.font = [UIFont fontWithName:@"Helvetica" size:fontSize];
    labelName.text = @"姓名";
    [infoView addSubview:labelName];
    UILabel *labelIdType = [[UILabel alloc] initWithFrame:CGRectMake(10, 42, 100, fontSize)];
    labelIdType.font = [UIFont fontWithName:@"Helvetica" size:fontSize];
    labelIdType.text = @"证件类型";
    [infoView addSubview:labelIdType];
    UILabel *labelIdNo = [[UILabel alloc] initWithFrame:CGRectMake(10, 74, 100, fontSize)];
    labelIdNo.font = [UIFont fontWithName:@"Helvetica" size:fontSize];
    labelIdNo.text = @"证件号";
    [infoView addSubview:labelIdNo];
    
    self.name = [[UILabel alloc] initWithFrame:CGRectMake(rScreen.size.width - 150, 10, 140, 20)];
    self.name.font = [UIFont fontWithName:@"Helvetica" size:fontSize];
    self.name.textColor = [UIColor grayColor];
    self.name.textAlignment = NSTextAlignmentRight;
    [infoView addSubview:self.name];
    
    self.idType = [[UILabel alloc] initWithFrame:CGRectMake(rScreen.size.width - 150, 42, 140, 20)];
    self.idType.font = [UIFont fontWithName:@"Helvetica" size:fontSize];
    self.idType.textAlignment = NSTextAlignmentRight;
    self.idType.textColor = [UIColor grayColor];
    [infoView addSubview:self.idType];
    
    self.idNO = [[UILabel alloc] initWithFrame:CGRectMake(rScreen.size.width - 150, 74, 140, 20)];
    self.idNO.font = [UIFont fontWithName:@"Helvetica" size:fontSize];
    self.idNO.textAlignment = NSTextAlignmentRight;
    self.idNO.textColor = [UIColor grayColor];
    [infoView addSubview:self.idNO];
    
    UIView *versionContainer = [[UIView alloc] initWithFrame:CGRectMake(0, infoView.frame.origin.y + infoView.frame.size.height + 15, rScreen.size.width, 30)];
    versionContainer.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:versionContainer];
    self.currentVersion = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, rScreen.size.width - 20, fontSize)];
    self.currentVersion.font = [UIFont fontWithName:@"Helvetica" size:fontSize];
    [versionContainer addSubview:self.currentVersion];
    
    UIButton *changePW = [UIButton buttonWithType:UIButtonTypeCustom];
    changePW.frame = CGRectMake(0, versionContainer.frame.origin.y + versionContainer.frame.size.height + 15, rScreen.size.width, 30);
    [changePW setTitle:@"修改密码" forState:UIControlStateNormal];
    [changePW setBackgroundColor:[UIColor whiteColor]];
    [changePW setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    changePW.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [changePW addTarget:self action:@selector(onChangePassword:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changePW];
    
    UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutBtn.frame = CGRectMake(0, changePW.frame.origin.y + changePW.frame.size.height + 15, rScreen.size.width, 30);
    [logoutBtn setTitle:@"注销" forState:UIControlStateNormal];
    [logoutBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [logoutBtn setBackgroundColor:[UIColor whiteColor]];
    logoutBtn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [logoutBtn addTarget:self action:@selector(onLogout:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logoutBtn];
    
    [self setAvatar:nil name:@"fdskfjk" organ:@"fjdkfjdkfj"];
    [self setIdType:@"shenfenzheng" idNo:@"350525198808013578"];
    [self setVersion:@"1.0.0"];
}

- (void)setAvatar:(UIImage *)avatar name:(NSString *)name organ:(NSString *)organ {
    if (avatar) {
        self.avatar.image = avatar;
    }
    else {
        self.avatar.image = [UIImage imageNamed:@"i_default_inspector.png"];
    }
    self.nameLabel.text = [NSString stringWithFormat:@"姓名: %@", name];
    self.name.text = [NSString stringWithString:name];
    self.organLabel.text = [NSString stringWithFormat:@"机构: %@", organ];
}

- (void)setIdType:(NSString *)type idNo:(NSString *)idNo {
    self.idType.text = [NSString stringWithString:type];
    self.idNO.text = [NSString stringWithString:idNo];
}

- (void)setVersion:(NSString *)version {
    self.currentVersion.text = [NSString stringWithFormat:@"当前版本: %@", version];
}

- (IBAction)onChangePassword:(id)sender {
    
}

- (IBAction)onLogout:(id)sender {
    
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
