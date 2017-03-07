//
//  INewTermViewController.m
//  Inspecting
//
//  Created by liuyuanpeng on 2017/3/5.
//  Copyright © 2017年 default. All rights reserved.
//

#import "INewTermViewController.h"
#import "ITextView.h"
#import <RadioButton/RadioButton.h>
#import "iUser.h"
#import "Utils.h"
#import "AFNRequestManager.h"
#import <ActionSheetPicker_3_0/ActionSheetPicker.h>
#import "ITermType.h"

@interface INewTermViewController ()

@end

@implementation INewTermViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0]];
    CGRect rScreen = [[UIScreen mainScreen] bounds];
    CGRect rNav = self.navigationController.navigationBar.frame;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, rNav.origin.y + rNav.size.height, rScreen.size.width, rScreen.size.height - rNav.origin.y - rNav.size.height - self.tabBarController.tabBar.frame.size.height)];
    [self.scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onScrollViewClicked:)]];
    [self.view addSubview:self.scrollView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,  rScreen.size.width, 30)];
    titleLabel.text = @"新增终端";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLabel;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    UILabel *baseinfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5 - rNav.origin.y - rNav.size.height, 100, 25)];
    baseinfoLabel.font = [UIFont systemFontOfSize:13];
    baseinfoLabel.text = @"基本信息";
    [self.scrollView addSubview:baseinfoLabel];
    
    UIView *baseInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 35 - rNav.origin.y - rNav.size.height, rScreen.size.width, 210)];
    [baseInfoView setBackgroundColor:[UIColor whiteColor]];
    [self.scrollView addSubview:baseInfoView];
    
    UILabel *serialLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 55, 15)];
    serialLabel.font = [UIFont systemFontOfSize:12.0f];
    serialLabel.text = @"终端序号:";
    [baseInfoView addSubview:serialLabel];
    
    self.termSerialnbr = [[UITextField alloc] initWithFrame:CGRectMake(70, 10, rScreen.size.width - 75, 15)];
    [self.termSerialnbr setPlaceholder:@"请填写终端序列"];
    self.termSerialnbr.font = [UIFont systemFontOfSize:12.0f];
    self.termSerialnbr.textColor = [UIColor darkGrayColor];
    self.termSerialnbr.textAlignment = NSTextAlignmentRight;
    [baseInfoView addSubview:self.termSerialnbr];
    
    UILabel *brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 40, 55, 15)];
    brandLabel.font = [UIFont systemFontOfSize:12.0f];
    brandLabel.text = @"终端品牌:";
    [baseInfoView addSubview:brandLabel];
    
    self.termBrand = [[UITextField alloc] initWithFrame:CGRectMake(70, 40, rScreen.size.width - 75, 15)];
    [self.termBrand setPlaceholder:@"请填写品牌"];
    self.termBrand.font = [UIFont systemFontOfSize:12.0f];
    self.termBrand.textColor = [UIColor darkGrayColor];
    self.termBrand.textAlignment = NSTextAlignmentRight;
    [baseInfoView addSubview:self.termBrand];
    
    UILabel *modelLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 70, 55, 15)];
    modelLabel.font = [UIFont systemFontOfSize:12.0f];
    modelLabel.text = @"终端型号:";
    [baseInfoView addSubview:modelLabel];
    
    self.termModel = [[UITextField alloc] initWithFrame:CGRectMake(70, 70, rScreen.size.width - 75, 15)];
    [self.termModel setPlaceholder:@"请填写型号"];
    self.termModel.font = [UIFont systemFontOfSize:12.0f];
    self.termModel.textColor = [UIColor darkGrayColor];
    self.termModel.textAlignment = NSTextAlignmentRight;
    [baseInfoView addSubview:self.termModel];
    
    UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 100, 55, 15)];
    typeLabel.font = [UIFont systemFontOfSize:12.0f];
    typeLabel.text = @"终端类型:";
    [baseInfoView addSubview:typeLabel];
    
    self.termType = [UIButton buttonWithType:UIButtonTypeCustom];
    self.termType.frame = CGRectMake(rScreen.size.width - 100, 93, 90, 26);
    [self.termType setBackgroundColor:[UIColor grayColor]];
    self.termType.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    self.termType.titleLabel.textColor = [UIColor darkGrayColor];
    
    [self.termType setTitle:[[[ITermType getInstance].types objectAtIndex:0] objectForKey:@"remark"] forState:UIControlStateNormal];
    self.termType.tag = 0;
    [self.termType addTarget:self action:@selector(onSelectType:) forControlEvents:UIControlEventTouchUpInside];
    [baseInfoView addSubview:self.termType];
    
    UILabel *shopLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 130, 55, 15)];
    shopLabel.font = [UIFont systemFontOfSize:12.0f];
    shopLabel.text = @"所属门店:";
    [baseInfoView addSubview:shopLabel];
    
    UILabel *shopNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 130, rScreen.size.width - 75, 15)];
    shopNameLabel.font = [UIFont systemFontOfSize:12.0f];
    shopNameLabel.textColor = [UIColor darkGrayColor];
    shopNameLabel.textAlignment = NSTextAlignmentRight;
    shopNameLabel.text = [NSString stringWithString: [self.shopInfo objectForKey:@"shopname"]];
    [baseInfoView addSubview:shopNameLabel];
    
    UILabel *merchLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 160, 55, 15)];
    merchLabel.font = [UIFont systemFontOfSize:12.0f];
    merchLabel.text = @"所属商户:";
    [baseInfoView addSubview:merchLabel];
    
    UILabel *merchNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 160, rScreen.size.width - 75, 15)];
    [merchNameLabel setText:[self.merchInfo objectForKey:@"merchname"]];
    merchNameLabel.font = [UIFont systemFontOfSize:12.0f];
    merchNameLabel.textColor = [UIColor darkGrayColor];
    merchNameLabel.textAlignment = NSTextAlignmentRight;
    [baseInfoView addSubview:merchNameLabel];
    
    
    UILabel *instLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 190, 55, 15)];
    instLabel.font = [UIFont systemFontOfSize:12.0f];
    instLabel.text = @"所属机构:";
    [baseInfoView addSubview:instLabel];
    
    UILabel *instNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 190, rScreen.size.width - 75, 15)];
    [instNameLabel setText:[self.merchInfo objectForKey:@"instname"]];
    instNameLabel.font = [UIFont systemFontOfSize:12.0f];
    instNameLabel.textColor = [UIColor darkGrayColor];
    instNameLabel.textAlignment = NSTextAlignmentRight;
    [baseInfoView addSubview:instNameLabel];
    
    for (NSInteger i = 1; i <= 6; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(5, 30*i, rScreen.size.width - 10, 1)];
        [view setBackgroundColor:[UIColor lightGrayColor]];
        [baseInfoView addSubview:view];
    }
    
    
    UILabel *resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, baseInfoView.frame.origin.y + baseInfoView.frame.size.height + 5, 100, 25)];
    resultLabel.text = @"巡检结果";
    resultLabel.font = [UIFont systemFontOfSize:13];
    [self.scrollView addSubview:resultLabel];
    
    UIView *resultView = [[UIView alloc] initWithFrame:CGRectMake(0, resultLabel.frame.origin.y + 30, rScreen.size.width, 180)];
    [resultView setBackgroundColor:[UIColor whiteColor]];
    [self.scrollView addSubview:resultView];
    
    NSMutableArray *buttons = [NSMutableArray arrayWithCapacity:3];
    CGRect btnRect = CGRectMake(25, 10, 100, 30);
    NSInteger btnTag = 1;
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
        btn.tag = btnTag++;
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
    
    self.termPic = [[UIImageView alloc] initWithFrame: CGRectMake(40, 120, 50, 50)];
    self.termPic.userInteractionEnabled = YES;
    [self.termPic addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSelectPic:)]];
    self.termPic.image = [UIImage imageNamed:@"i_add_pic.png"];
    [resultView addSubview:self.termPic];
    
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

- (IBAction)onScrollViewClicked:(id)sender {
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.needupdate) {
        self.termSerialnbr.text = @"";
        self.termModel.text = @"";
        self.termBrand.text = @"";
        [self.termType setTitle:[[[ITermType getInstance].types objectAtIndex:0] objectForKey:@"remark"] forState:UIControlStateNormal];
        [self.radioButton setSelected:YES];
        self.desc.text = @"";
        self.termPic.image = [UIImage imageNamed:@"i_add_pic.png"];
        self.needupdate = false;
    }
}

- (IBAction)onSelectType:(UIButton *)sender {
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:7L];
    for (NSDictionary *dict in [ITermType getInstance].types) {
        [array addObject:[dict objectForKey:@"remark"]];
    }
    [ActionSheetStringPicker showPickerWithTitle:@"请选择终端类型" rows:array initialSelection:sender.tag doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        [sender setTitle:selectedValue forState:UIControlStateNormal];
        sender.tag = selectedIndex;
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        NSLog(@"cancel picker");
    } origin:sender];
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
    NSDictionary *data = @{
                           @"termtype": [[[ITermType getInstance].types objectAtIndex:self.termType.tag] objectForKey:@"term_type"],
                           @"termmode": self.termModel.text,
                           @"termname": self.termSerialnbr.text,
                           @"termband": self.termBrand.text
                           };
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *serialnbr = [dateFormatter stringFromDate:[NSDate date]];
    NSDictionary *params = @{
                             @"staffcode": [iUser getInstance].staffcode,
                             @"instcode": [self.merchInfo objectForKey:@"instcode"],
                             @"merchcode": [self.merchInfo objectForKey:@"merchcode"],
                             @"batchcode": [self.merchInfo objectForKey:@"batchcode"],
                             @"addrcode": [Utils getAddrCode],
                             @"content": self.desc.text,
                             @"shopcode": [self.shopInfo objectForKey:@"shopcode"],
                             @"serialnbr":serialnbr,
                             @"data": [AFNRequestManager convertToJSONData:data]
                             };
    [AFNRequestManager requestAFURL:@"inspNewTermInfo.json" httpMethod:METHOD_POST params:params succeed:^(NSDictionary *ret) {
        if (0 == [[ret objectForKey:@"status"] integerValue]) {
            self.inspcntid = [[ret objectForKey:@"insp_cnt_id"] integerValue];
            self.snseq = [[ret objectForKey:@"snseq"] integerValue];
            self.termcode = [NSString stringWithString:[ret objectForKey:@"termcode"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
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
        self.termPic.image = image;
        self.termimage = image;
    }];
}


@end
