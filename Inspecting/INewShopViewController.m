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
#import "Utils.h"
#import "AFNRequestManager.h"
#import <Toast/UIView+Toast.h>
#import <PYPhotoBrowser/PYPhotoBrowser.h>
#import "MHProgress.h"
#import "UIScrollView+UITouch.h"
#import "ITagView.h"
#import "ITags.h"


@interface INewShopViewController ()

@end

@implementation INewShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0]];
    CGRect rScreen = [[UIScreen mainScreen] bounds];
    CGRect rNav = self.navigationController.navigationBar.frame;
    
    CGFloat vTop = [Utils isAboveIOS11] ? 0: - rNav.origin.y - rNav.size.height;

    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, rNav.origin.y + rNav.size.height, rScreen.size.width, rScreen.size.height - rNav.origin.y - rNav.size.height)];
    [self.view addSubview:self.scrollView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,  rScreen.size.width, 30)];
    titleLabel.text = @"新增门店";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLabel;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    UILabel *baseinfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5 + vTop, 100, 25)];
    baseinfoLabel.font = [UIFont systemFontOfSize:13];
    baseinfoLabel.text = @"基本信息";
    [self.scrollView addSubview:baseinfoLabel];
    
    UIView *baseInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 35 + vTop, rScreen.size.width, 120)];
    [baseInfoView setBackgroundColor:[UIColor whiteColor]];
    [self.scrollView addSubview:baseInfoView];
    
    UILabel *shopLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 55, 15)];
    shopLabel.font = [UIFont systemFontOfSize:12.0f];
    shopLabel.text = @"门店名称";
    [baseInfoView addSubview:shopLabel];
    
    self.shopName = [[UITextField alloc] initWithFrame:CGRectMake(60, 10, rScreen.size.width - 65, 15)];
    [self.shopName setPlaceholder:@"请填写门店名称"];
    self.shopName.font = [UIFont systemFontOfSize:12.0f];
    self.shopName.textAlignment = NSTextAlignmentRight;
    self.shopName.textColor = [UIColor darkGrayColor];
    [baseInfoView addSubview:self.shopName];
    
    UILabel *addrLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 40, 55, 15)];
    addrLabel.font = [UIFont systemFontOfSize:12.0f];
    addrLabel.text = @"门店地址";
    [baseInfoView addSubview:addrLabel];
    
    UIImageView *addrImgView = [[UIImageView alloc]initWithFrame:CGRectMake(rScreen.size.width - 24, 35, 20, 20)];
    addrImgView.image = [UIImage imageNamed:@"i_location.png"];
    addrImgView.userInteractionEnabled = YES;
    [addrImgView addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onGetGeoCode)]];
    [baseInfoView addSubview:addrImgView];
    
    self.shopAddr = [[UITextField alloc] initWithFrame:CGRectMake(60, 40, rScreen.size.width - 88, 15)];
    [self.shopAddr setPlaceholder:@"请填写门店地址"];
    self.shopAddr.font = [UIFont systemFontOfSize:12.0f];
    self.shopAddr.textAlignment = NSTextAlignmentRight;
    self.shopAddr.textColor = [UIColor darkGrayColor];
    [baseInfoView addSubview:self.shopAddr];
    
    UILabel *merchLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 70, 55, 15)];
    merchLabel.font = [UIFont systemFontOfSize:12.0f];
    merchLabel.text = @"所属商户";
    [baseInfoView addSubview:merchLabel];
    
    UILabel *merchNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 70, rScreen.size.width - 65, 15)];
    merchNameLabel.text = [NSString stringWithString:[self.merchInfo objectForKey:@"merchname"]];
    merchNameLabel.font = [UIFont systemFontOfSize:12.0f];
    merchNameLabel.textAlignment = NSTextAlignmentRight;
    merchNameLabel.textColor = [UIColor darkGrayColor];
    [baseInfoView addSubview:merchNameLabel];
    
    UILabel *instLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 100, 55, 15)];
    instLabel.font = [UIFont systemFontOfSize:12.0f];
    instLabel.text = @"所属机构";
    [baseInfoView addSubview:instLabel];
    
    UILabel *instNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 100, rScreen.size.width - 65, 15)];
    instNameLabel.text = [NSString stringWithString:[self.merchInfo objectForKey:@"instname"]];
    instNameLabel.font = [UIFont systemFontOfSize:12.0f];
    instNameLabel.textAlignment = NSTextAlignmentRight;
    instNameLabel.textColor = [UIColor darkGrayColor];
    [baseInfoView addSubview:instNameLabel];
    
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
    
    self.nameText = [[UITextField alloc] initWithFrame:CGRectMake(60, 10, rScreen.size.width - 65, 15)];
    [self.nameText setPlaceholder:@"请填写门店联系人"];
    self.nameText.font = [UIFont systemFontOfSize:12.0f];
    self.nameText.textAlignment = NSTextAlignmentRight;
    self.nameText.textColor = [UIColor darkGrayColor];
    [contactView addSubview:self.nameText];
    
    UILabel *telLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 40, 55, 15)];
    telLabel.font = [UIFont systemFontOfSize:12.0f];
    telLabel.text = @"电话";
    [contactView addSubview:telLabel];
    
    self.telText = [[UITextField alloc] initWithFrame:CGRectMake(60, 40, rScreen.size.width - 65, 15)];
    [self.telText setPlaceholder:@"请填写联系人电话"];
    self.telText.font = [UIFont systemFontOfSize:12.0f];
    self.telText.textAlignment = NSTextAlignmentRight;
    self.telText.textColor = [UIColor darkGrayColor];
    self.telText.keyboardType = UIKeyboardTypeNumberPad;
    [contactView addSubview:self.telText];
    
    UILabel *mailLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 70, 55, 15)];
    mailLabel.font = [UIFont systemFontOfSize:12.0f];
    mailLabel.text = @"邮箱";
    [contactView addSubview:mailLabel];
    
    self.mailText = [[UITextField alloc] initWithFrame:CGRectMake(60, 70, rScreen.size.width - 65, 15)];
    [self.mailText setPlaceholder:@"请填写电子邮箱"];
    self.mailText.font = [UIFont systemFontOfSize:12.0f];
    self.mailText.textAlignment = NSTextAlignmentRight;
    self.mailText.textColor = [UIColor darkGrayColor];
    self.mailText.keyboardType = UIKeyboardTypeEmailAddress;
    [contactView addSubview:self.mailText];
    
    for (NSInteger i = 1; i <= 2; i++) {
        UIView *split = [[UIView alloc] initWithFrame:CGRectMake(5, 30*i, rScreen.size.width - 10, 1)];
        [split setBackgroundColor:[UIColor lightGrayColor]];
        [contactView addSubview:split];
    }
    
    
    UILabel *resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, contactView.frame.origin.y + contactView.frame.size.height + 5, 100, 25)];
    resultLabel.text = @"巡检结果";
    resultLabel.font = [UIFont systemFontOfSize:13];
    [self.scrollView addSubview:resultLabel];
    
    NSMutableArray *tagsArray = [[ITags getInstance] getTagsArray];
    self.tagView = [[ITagView alloc] initWithFrame:CGRectMake(0, 100, rScreen.size.width, 0) tagArray:tagsArray];
    UIView *resultView = [[UIView alloc] initWithFrame:CGRectMake(0, resultLabel.frame.origin.y + 30, rScreen.size.width, 260 + self.tagView.frame.size.height)];
    [resultView setBackgroundColor:[UIColor whiteColor]];
    [self.scrollView addSubview:resultView];
    [resultView addSubview:self.tagView];
    
    self.otherPay = [[ITextView alloc] initWithFrame:CGRectMake(30, 100 + self.tagView.frame.size.height, rScreen.size.width - 60, 50)];
    [self.otherPay.layer setCornerRadius:2.0f];
    [self.otherPay.layer setBorderColor:[UIColor grayColor].CGColor];
    [self.otherPay.layer setBorderWidth:1.0f];
    [self.otherPay setPlaceholder:@"请输入其他支付方式"];
    [self.otherPay setPlaceholderColor:[UIColor grayColor]];
    [resultView addSubview:self.otherPay];
    
    NSMutableArray *buttons = [NSMutableArray arrayWithCapacity:3];
    CGRect btnRect = CGRectMake(25, 10, 100, 30);
    NSInteger btnTag = 1;
    for (NSString *optionTitle in @[@"正常", @"不存在", @"其他情况"]) {
        RadioButton *btn = [[RadioButton alloc] initWithFrame:btnRect];
        if ([optionTitle isEqualToString:@"正常"]) {
            btnRect.origin.x += 80;
        }
        else {
            btnRect.origin.x += 100;
        }
        [btn setTitle:optionTitle forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [btn setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateSelected];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
        btn.tag = btnTag;
        btnTag++;
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
    
    UIView *splitView = [[UIView alloc] initWithFrame:CGRectMake(0, 170 + self.tagView.frame.size.height, rScreen.size.width, 1)];
    splitView.backgroundColor = [UIColor grayColor];
    [resultView addSubview:splitView];
    
    UILabel *photoLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 180 + self.tagView.frame.size.height, 30, 20)];
    photoLabel.text = @"拍照";
    photoLabel.font = [UIFont systemFontOfSize:13];
    [resultView addSubview:photoLabel];
    
    self.licencePic = [[UIImageView alloc] initWithFrame: CGRectMake(5, 180 + self.tagView.frame.size.height+photoLabel.frame.size.height, 48, 48)];
    self.licencePic.image = [UIImage imageNamed:@"i_add_yyzz.png"];
    self.licencePic.tag = 0;
    self.licencePic.userInteractionEnabled = YES;
    [self.licencePic addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSelectPic:)]];
    [self.licencePic addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onImgPreview:)]];
    [resultView addSubview:self.licencePic];
    
    self.facadePic = [[UIImageView alloc] initWithFrame: CGRectMake(58, 180 + self.tagView.frame.size.height+photoLabel.frame.size.height, 48, 48)];
    self.facadePic.image = [UIImage imageNamed:@"i_add_mmzp.png"];
    self.facadePic.tag = 1;
    self.facadePic.userInteractionEnabled = YES;
    [self.facadePic addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSelectPic:)]];
    [self.facadePic addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onImgPreview:)]];
    [resultView addSubview:self.facadePic];
    
    self.signPic = [[UIImageView alloc] initWithFrame: CGRectMake(111, 180 + self.tagView.frame.size.height+photoLabel.frame.size.height, 48, 48)];
    self.signPic.image = [UIImage imageNamed:@"i_add_zp.png"];
    self.signPic.tag = 2;
    self.signPic.userInteractionEnabled = YES;
    [self.signPic addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSelectPic:)]];
    [self.signPic addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onImgPreview:)]];
    [resultView addSubview:self.signPic];
    
    self.sitePic = [[UIImageView alloc] initWithFrame: CGRectMake(164, 180 + self.tagView.frame.size.height+photoLabel.frame.size.height, 48, 48)];
    self.sitePic.image = [UIImage imageNamed:@"i_add_jycs.png"];
    self.sitePic.tag = 3;
    self.sitePic.userInteractionEnabled = YES;
    [self.sitePic addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSelectPic:)]];
    [self.sitePic addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onImgPreview:)]];
    [resultView addSubview:self.sitePic];
    
    self.ylsignPic = [[UIImageView alloc] initWithFrame: CGRectMake(217, 180 + self.tagView.frame.size.height+photoLabel.frame.size.height, 48, 48)];
    self.ylsignPic.image = [UIImage imageNamed:@"i_add_ylbs.png"];
    self.ylsignPic.tag = 4;
    self.ylsignPic.userInteractionEnabled = YES;
    [self.ylsignPic addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSelectPic:)]];
    [self.ylsignPic addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onImgPreview:)]];
    [resultView addSubview:self.ylsignPic];
    
    self.mpewmPic = [[UIImageView alloc] initWithFrame: CGRectMake(270, 180 + self.tagView.frame.size.height+photoLabel.frame.size.height, 48, 48)];
    self.mpewmPic.image = [UIImage imageNamed:@"i_add_mpewm.png"];
    self.mpewmPic.tag = 5;
    self.mpewmPic.userInteractionEnabled = YES;
    [self.mpewmPic addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSelectPic:)]];
    [self.mpewmPic addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onImgPreview:)]];
    [resultView addSubview:self.mpewmPic];


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
    
    self.scrollView.contentSize = CGSizeMake(rScreen.size.width, commitBtn.frame.origin.y + commitBtn.frame.size.height+20);
    
    self.userImgDict = [[NSMutableDictionary alloc] initWithCapacity:4];
    self.inspresultArray = [[NSMutableArray alloc] initWithCapacity:4];
    
    self.needupdate = YES;

}

- (IBAction)onGetGeoCode {
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    [geoCoder reverseGeocodeLocation:[Utils getMyLocation] completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placeMark = [placemarks objectAtIndex:0];
            
            self.shopAddr.text = [NSString stringWithFormat:@"%@%@%@%@",placeMark.administrativeArea?placeMark.administrativeArea:@"", placeMark.locality?placeMark.locality:@"", placeMark.subLocality?placeMark.subLocality:@"", placeMark.thoroughfare?placeMark.thoroughfare:@""];
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.needupdate) {
        self.needupdate = YES;
        return;
    }
    self.shopName.text = @"";
    self.shopAddr.text = @"";
    self.nameText.text = @"";
    self.telText.text = @"";
    self.mailText.text = @"";
    self.radioButton.selected = YES;
    self.desc.text = @"";
    self.licencePic.image = [UIImage imageNamed:@"i_add_yyzz.png"];
    self.facadePic.image = [UIImage imageNamed:@"i_add_mmzp"];
    self.signPic.image = [UIImage imageNamed:@"i_add_zp.png"];
    self.sitePic.image = [UIImage imageNamed:@"i_add_jycs.png"];
    self.ylsignPic.image = [UIImage imageNamed:@"i_add_ylbs.png"];
    self.mpewmPic.image = [UIImage imageNamed:@"i_add_mpewm.png"];


}

- (IBAction)onSelectPic:(UIGestureRecognizer *)sender {
    if (![Utils cameraAccess]) {
        [self.view makeToast:@"请先打开相机的使用权限!"];
        return;
    }
    self.curSelPic = (UIImageView *)(sender.view);
    @try {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        imagePicker.allowsEditing = YES;
        [self presentViewController:imagePicker animated:YES completion:^{
            self.needupdate = NO;
        }];
        
    } @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
}

- (IBAction)onImgPreview:(UIGestureRecognizer *)sender {
    if (sender.state != UIGestureRecognizerStateBegan) {
        return;
    }
    UIImageView *imgView = (UIImageView *)(sender.view);
    self.curSelPic = imgView;
    UIImage *image = imgView.image;
    if ([image isEqual:[UIImage imageNamed:@"i_add_yyzz.png"]] ||
        [image isEqual:[UIImage imageNamed:@"i_add_mmzp.png"]] ||
        [image isEqual:[UIImage imageNamed:@"i_add_zp.png"]] ||
        [image isEqual:[UIImage imageNamed:@"i_add_jycs.png"]]||
        [image isEqual:[UIImage imageNamed:@"i_add_ylbs.png"]]) {
        return;
    }
    
    PYPhotoBrowseView *photoBroseView = [[PYPhotoBrowseView alloc] init];
    photoBroseView.sourceImgageViews = @[imgView];
    [photoBroseView show];
}

- (IBAction)onCommit:(id)sender {
    [self.view endEditing:YES];
    if (![Utils locationAccess]) {
        [self.view makeToast:@"请先开启定位服务!"];
        [Utils openLocationSetting:self];
        return;
    }
    if ([self.tagView getSelectedTags].count == 0) {
        [self.view makeToast:@"至少选择一种支付方式!"];
        return;
    }
    if ([[self.tagView getSelectedTags] containsObject:@"其他"] && [self.otherPay.text compare:@""] == NSOrderedSame) {
        [self.view makeToast:@"选择其他时请填写其他支付方式!"];
        return;
    }

    for (NSInteger i = 0; i < 5; i++) {
        if (self.inspresultArray.count > i) {
            NSDictionary *dict = [self.inspresultArray objectAtIndex:i];
            NSString *oldFile = @"";
            if (dict) {
                oldFile = [NSString stringWithString:[dict objectForKey:@"picuri"]];
            }
            if ([oldFile isEqualToString:@""]) {
                if ([self.userImgDict objectForKey:@(i)] == nil) {
                    [self.view makeToast:@"请先上传图片!"];
                    return;
                }
            }
        }
        else {
            if ([self.userImgDict objectForKey:@(i)] == nil) {
                [self.view makeToast:@"请先上传图片!"];
                return;
            }
        }
    }

    NSDictionary *data = @{
                           @"shopname":self.shopName.text,
                           @"people":self.nameText.text,
                           @"address":self.shopAddr.text,
                           @"tel":self.telText.text,
                           @"email":self.mailText.text
                           };
    NSDictionary *params = @{
                             @"staffcode": [iUser getInstance].staffcode,
                             @"instcode": [self.merchInfo objectForKey:@"instcode"],
                             @"merchcode": [self.merchInfo objectForKey:@"merchcode"],
                             @"batchcode": [self.merchInfo objectForKey:@"batchcode"],
                             @"addrcode": [Utils getAddrCode],
                             @"content": self.desc.text,
                             @"flag": @(self.radioButton.selectedButton.tag),
                             @"paytype": [[ITags getInstance] getCodesBySelectedTags:[self.tagView getSelectedTags]],
                             @"paytypedesc": self.otherPay.text,
                             @"data": [AFNRequestManager convertToJSONData:data]
                             };
    
    [self.indicator startAnimating];
    self.view.userInteractionEnabled = NO;
    [[MHProgress getCommitInstance] showLoadingView];
    [AFNRequestManager requestAFURL:@"inspNewShopInfo.json" httpMethod:METHOD_POST params:params succeed:^(NSDictionary *ret) {
        if (0 == [[ret objectForKey:@"status"] integerValue]) {
            self.shopcode = [NSString stringWithString:[ret objectForKey:@"shopcode"]];
            self.inspcntid = [[ret objectForKey:@"insp_cnt_id"] integerValue];
            self.serialnbr = [ret objectForKey:@"serialnbr"];
            [self uploadImages:0];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
        [[MHProgress getCommitInstance] closeLoadingView];
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
        [self.userImgDict setObject:image forKey:@(self.curSelPic.tag)];
        self.curSelPic.image = image;
    }];}

#pragma mark - uploadImage 
- (void)uploadImgOK {
    [self.view makeToast:@"新建门店成功!" duration:2 position:CSToastPositionBottom title:nil image:nil style:[[CSToastStyle alloc] initWithDefaultStyle] completion:^(BOOL didTap) {
        [self.navigationController popViewControllerAnimated:YES];
        self.view.userInteractionEnabled = YES;
        [self.indicator stopAnimating];
    }];
    [[MHProgress getCommitInstance] closeLoadingView];
}

- (void)uploadImgFail {
    self.view.userInteractionEnabled = YES;
    [self.indicator stopAnimating];
    [self.view makeToast:@"上传图片失败!"];
    [[MHProgress getCommitInstance] closeLoadingView];
}

- (void) uploadImages:(NSInteger)index {
    if (index >= 6) {
        [self uploadImgOK];
        return;
    }
    
    
    NSString *oldFile = @"";
    UIImage *img = [self.userImgDict objectForKey:@(index)];
    
    if (self.inspresultArray.count > index && img == nil) {
        NSDictionary *dict = [self.inspresultArray objectAtIndex:index];
        if (dict) {
            oldFile = [NSString stringWithString:[dict objectForKey:@"picuri"]];
        }
    }
    NSDictionary *params = @{
                             @"batchcode": [self.merchInfo objectForKey:@"batchcode"],
                             @"inspcntid": @(self.inspcntid),
                             @"serialnbr": self.serialnbr,
                             @"oldfile":oldFile,
                             @"logo": index == 1 ? @"yes" : @"",
                             @"posi": [NSString stringWithFormat:@"%ld", (long)index]
                             };
    index++;
    if (img) {
        [AFNRequestManager requestAFURL:@"inspShopPics.json" params:params imageData:UIImageJPEGRepresentation(img, 0.2) succeed:^(NSDictionary *ret) {
            if (0 == [[ret objectForKey:@"status"] integerValue]) {
                [self uploadImages:(index)];
            }
        } failure:^(NSError *error) {
            [self uploadImgFail];
            NSLog(@"%@",error);
        }];
    }
    else {
        [AFNRequestManager requestAFURL:@"inspShopPics.json" httpMethod:METHOD_POST params:params succeed:^(NSDictionary *ret) {
            if (0 == [[ret objectForKey:@"status"] integerValue]) {
                [self uploadImages:index];
            }
        } failure:^(NSError *error) {
            [self uploadImgFail];
            NSLog(@"%@", error);
        }];
    }
}


@end
