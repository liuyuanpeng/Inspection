//
//  INewShopViewController.m
//  Inspecting
//
//  Created by liuyuanpeng on 2017/3/5.
//  Copyright © 2017年 default. All rights reserved.
//

#import "INewShopViewController.h"
#import "ITextView.h"
#import <RadioButton/RadioButton.h>
#import "iUser.h"
#import "AFNRequestManager.h"

@interface INewShopViewController ()

@end

@implementation INewShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0]];
    CGRect rScreen = [[UIScreen mainScreen] bounds];
    CGRect rNav = self.navigationController.navigationBar.frame;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, rNav.origin.y + rNav.size.height, rScreen.size.width, rScreen.size.height - rNav.origin.y - rNav.size.height - self.tabBarController.tabBar.frame.size.height)];
    [self.view addSubview:self.scrollView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,  rScreen.size.width, 30)];
    titleLabel.text = @"新增门店";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLabel;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    UILabel *baseinfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5 - rNav.origin.y - rNav.size.height, 100, 25)];
    baseinfoLabel.font = [UIFont systemFontOfSize:13];
    baseinfoLabel.text = @"基本信息";
    [self.scrollView addSubview:baseinfoLabel];
    
    UIView *baseInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 35 - rNav.origin.y - rNav.size.height, rScreen.size.width, 120)];
    [baseInfoView setBackgroundColor:[UIColor whiteColor]];
    [self.scrollView addSubview:baseInfoView];
    
    UILabel *serialLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 55, 15)];
    serialLabel.font = [UIFont systemFontOfSize:12.0f];
    serialLabel.text = @"门店名称";
    [baseInfoView addSubview:serialLabel];
    
    UILabel *brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 40, 55, 15)];
    brandLabel.font = [UIFont systemFontOfSize:12.0f];
    brandLabel.text = @"门店地址";
    [baseInfoView addSubview:brandLabel];
    
    UILabel *modelLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 70, 55, 15)];
    modelLabel.font = [UIFont systemFontOfSize:12.0f];
    modelLabel.text = @"所属商户";
    [baseInfoView addSubview:modelLabel];
    
    UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 100, 55, 15)];
    typeLabel.font = [UIFont systemFontOfSize:12.0f];
    typeLabel.text = @"所属机构";
    [baseInfoView addSubview:typeLabel];
    
    for (NSInteger i = 1; i <= 3; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(5, 30*i, rScreen.size.width - 10, 1)];
        [view setBackgroundColor:[UIColor lightGrayColor]];
        [baseInfoView addSubview:view];
    }

    UILabel *contactLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, baseInfoView.frame.origin.y + baseInfoView.frame.size.height + 5, 100, 25)];
    contactLabel.font = [UIFont systemFontOfSize:13];
    contactLabel.text = @"联系人信息";
    [self.scrollView addSubview:contactLabel];
    
    UIView *contactView = [[UIView alloc] initWithFrame:CGRectMake(0, 35 + baseInfoView.frame.origin.y + baseInfoView.frame.size.height, rScreen.size.width, 90)];
    [contactView setBackgroundColor:[UIColor whiteColor]];
    [self.scrollView addSubview:contactView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 55, 15)];
    nameLabel.font = [UIFont systemFontOfSize:12.0f];
    nameLabel.text = @"姓名";
    [contactView addSubview:nameLabel];
    
    UILabel *telLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 40, 55, 15)];
    telLabel.font = [UIFont systemFontOfSize:12.0f];
    telLabel.text = @"电话";
    [contactView addSubview:telLabel];
    
    UILabel *mailLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 70, 55, 15)];
    mailLabel.font = [UIFont systemFontOfSize:12.0f];
    mailLabel.text = @"邮箱";
    [contactView addSubview:mailLabel];
    
    for (NSInteger i = 1; i <= 2; i++) {
        UIView *split = [[UIView alloc] initWithFrame:CGRectMake(5, 30*i, rScreen.size.width - 10, 1)];
        [split setBackgroundColor:[UIColor lightGrayColor]];
        [contactView addSubview:split];
    }
    
    
    UILabel *resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, contactView.frame.origin.y + contactView.frame.size.height + 5, 100, 25)];
    resultLabel.text = @"巡检结果";
    resultLabel.font = [UIFont systemFontOfSize:13];
    [self.scrollView addSubview:resultLabel];
    
    UIView *resultView = [[UIView alloc] initWithFrame:CGRectMake(0, resultLabel.frame.origin.y + 30, rScreen.size.width, 180)];
    [resultView setBackgroundColor:[UIColor whiteColor]];
    [self.scrollView addSubview:resultView];
    
    NSMutableArray *buttons = [NSMutableArray arrayWithCapacity:3];
    CGRect btnRect = CGRectMake(25, 10, 100, 30);
    for (NSString *optionTitle in @[@"不存在", @"正常", @"其他情况"]) {
        RadioButton *btn = [[RadioButton alloc] initWithFrame:btnRect];
        btnRect.origin.x += 100;
        [btn setTitle:optionTitle forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [btn setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateSelected];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
        [resultView addSubview:btn];
        [buttons addObject:btn];
    }
    
    [buttons[0] setGroupButtons:buttons];
    [buttons[0] setSelected:YES];
    
    self.radioButton = buttons[0];
    
    self.desc = [[ITextView alloc] initWithFrame:CGRectMake(30, 50, rScreen.size.width - 60, 50)];
    [self.desc.layer setCornerRadius:2.0f];
    [self.desc.layer setBorderColor:[UIColor grayColor].CGColor];
    [self.desc.layer setBorderWidth:1.0f];
    [self.desc setPlaceholder:@"请输入情况说明"];
    [self.desc setPlaceholderColor:[UIColor grayColor]];
    [resultView addSubview:self.desc];
    
    UIView *splitView = [[UIView alloc] initWithFrame:CGRectMake(0, 110, rScreen.size.width, 1)];
    splitView.backgroundColor = [UIColor grayColor];
    [resultView addSubview:splitView];
    
    UILabel *photoLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 120, 30, 20)];
    photoLabel.text = @"拍照";
    photoLabel.font = [UIFont systemFontOfSize:13];
    [resultView addSubview:photoLabel];
    
    self.instPic = [UIButton buttonWithType:UIButtonTypeCustom];
    self.instPic.frame = CGRectMake(40, 120, 50, 50);
    [self.instPic setBackgroundImage:[UIImage imageNamed:@"i_add_posup.png"] forState:UIControlStateNormal];
    self.instPic.tag = 0;
    [self.instPic addTarget:self action:@selector(onSelectPic:) forControlEvents:UIControlEventTouchUpInside];
    [resultView addSubview:self.instPic];
    
    self.serialPic = [UIButton buttonWithType:UIButtonTypeCustom];
    self.serialPic.frame = CGRectMake(100, 120, 50, 50);
    [self.serialPic setBackgroundImage:[UIImage imageNamed:@"i_add_posup.png"] forState:UIControlStateNormal];
    self.serialPic.tag = 1;
    [self.serialPic addTarget:self action:@selector(onSelectPic:) forControlEvents:UIControlEventTouchUpInside];
    [resultView addSubview:self.serialPic];
    
    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    commitBtn.frame = CGRectMake(rScreen.size.width/2 - 50, resultView.frame.origin.y + resultView.frame.size.height + 10, 100, 30);
    [commitBtn.layer setCornerRadius:2.0f];
    [commitBtn.layer setMasksToBounds:YES];
    [commitBtn setBackgroundColor:[UIColor colorWithRed:233/255.0 green:63/255.0 blue:51/255.0 alpha:1.0]];
    [commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [commitBtn addTarget:self action:@selector(onCommit:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:commitBtn];
    
    self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.indicator setCenter:CGPointMake(rScreen.size.width/2, rScreen.size.height/2)];
    self.indicator.color = [UIColor blueColor];
    [self.view addSubview:self.indicator];
    
    self.scrollView.contentSize = CGSizeMake(rScreen.size.width, commitBtn.frame.origin.y + commitBtn.frame.size.height);
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (IBAction)onSelectPic:(id)sender {
    @try {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        imagePicker.allowsEditing = YES;
        [self presentViewController:imagePicker animated:YES completion:^{
            NSLog(@"complete");
        }];
        
    } @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
}



- (IBAction)onCommit:(id)sender {
    
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

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}


#pragma mark - UIImagePickerControllerDelegate Implementation

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image= [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    [self dismissViewControllerAnimated:YES completion:^{
        NSDictionary *params = @{
                                 @"batchcode":@"",
                                 @"oldfile":@"",
                                 @"logo":@"",
                                 @"posi":@"",
                                 @"inspcntid":@1
                                 };
        [AFNRequestManager requestAFURL:@"inspMerchPics" params:params imageData:UIImageJPEGRepresentation(image, 1.0) succeed:^(NSDictionary *ret) {
            if (0 == [[ret objectForKey:@"status"] integerValue]) {
                
            }
        } failure:^(NSError *error) {
            NSLog(@"%@", error);
        }];
    }];
}


@end
