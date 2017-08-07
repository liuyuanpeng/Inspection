//
//  ITermDetailViewController.m
//  Inspecting
//
//  Created by liuyuanpeng on 2017/3/5.
//  Copyright © 2017年 default. All rights reserved.
//

#import "ITermDetailViewController.h"
#import "ILogViewController.h"
#import "ITextView.h"
#import <RadioButton/RadioButton.h>
#import "iUser.h"
#import "Utils.h"
#import "ITermType.h"
#import "AFNRequestManager.h"
#import <ActionSheetPicker_3_0/ActionSheetPicker.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <Toast/UIView+Toast.h>
#import <PYPhotoBrowser/PYPhotoBrowser.h>

@interface ITermDetailViewController ()

@end

@implementation ITermDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0]];
    CGRect rScreen = [[UIScreen mainScreen] bounds];
    CGRect rNav = self.navigationController.navigationBar.frame;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, rNav.origin.y + rNav.size.height, rScreen.size.width, rScreen.size.height - rNav.origin.y - rNav.size.height)];
    [self.view addSubview:self.scrollView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,  rScreen.size.width, 30)];
    titleLabel.text = @"终端详情";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLabel;
    
    UIButton *updateLog = [UIButton buttonWithType:UIButtonTypeCustom];
    updateLog.frame = CGRectMake(0, 0, 24, 24);
    [updateLog setBackgroundImage:[UIImage imageNamed:@"i_updata.png"] forState:UIControlStateNormal];
    [updateLog addTarget:self action:@selector(onUpdateLog:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:updateLog];
    self.navigationItem.rightBarButtonItem = barItem;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    UILabel *baseinfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, - rNav.origin.y - rNav.size.height + 5, 100, 25)];
    baseinfoLabel.font = [UIFont systemFontOfSize:13];
    baseinfoLabel.text = @"基本信息";
    [self.scrollView addSubview:baseinfoLabel];
    
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [editBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    editBtn.frame = CGRectMake(rScreen.size.width - 50, - rNav.origin.y - rNav.size.height + 5, 40, 20);
    [editBtn addTarget:self action:@selector(onEdit:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:editBtn];
    
    UIView *baseInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, - rNav.origin.y - rNav.size.height + 35, rScreen.size.width, 165)];
    [baseInfoView setBackgroundColor:[UIColor whiteColor]];
    [self.scrollView addSubview:baseInfoView];
    
    UILabel *serialLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 55, 15)];
    serialLabel.textColor = [UIColor darkGrayColor];
    serialLabel.font = [UIFont systemFontOfSize:12.0f];
    serialLabel.text = @"终端序列:";
    [baseInfoView addSubview:serialLabel];

    
    self.termSerialnbr = [[UITextField alloc] initWithFrame:CGRectMake(60, 5, rScreen.size.width - 65, 15)];
    self.termSerialnbr.textColor = [UIColor darkGrayColor];
    self.termSerialnbr.font = [UIFont systemFontOfSize:12.0f];
    self.termSerialnbr.text = [NSString stringWithString:[self.termInfo objectForKey:@"serialnbr"]];
    self.termSerialnbr.delegate = self;
    [baseInfoView addSubview:self.termSerialnbr];
    
    self.termCode = [[UILabel alloc] initWithFrame:CGRectMake(5, 25, rScreen.size.width - 10, 15)];
    self.termCode.textColor = [UIColor darkGrayColor];
    self.termCode.font = [UIFont systemFontOfSize:12.0f];
    self.termCode.text = [NSString stringWithFormat:@"终端编号:%@", [self.termInfo objectForKey:@"termcode"]];
    [baseInfoView addSubview:self.termCode];
    
    
    UILabel *brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 45, 55, 15)];
    brandLabel.textColor = [UIColor darkGrayColor];
    brandLabel.font = [UIFont systemFontOfSize:12.0f];
    brandLabel.text = @"终端品牌:";
    [baseInfoView addSubview:brandLabel];

    self.termBrand = [[UITextField alloc] initWithFrame:CGRectMake(60, 45, rScreen.size.width - 90, 15)];
    self.termBrand.textColor = [UIColor darkGrayColor];
    self.termBrand.font = [UIFont systemFontOfSize:12.0f];
    self.termBrand.text = @"rest";
    self.termBrand.delegate = self;
    [baseInfoView addSubview:self.termBrand];
    
    UILabel *modelLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 65, 55, 15)];
    modelLabel.textColor = [UIColor darkGrayColor];
    modelLabel.font = [UIFont systemFontOfSize:12.0f];
    modelLabel.text = @"终端型号:";
    [baseInfoView addSubview:modelLabel];
    
    self.termModel = [[UITextField alloc] initWithFrame:CGRectMake(60, 65, rScreen.size.width - 90, 15)];
    self.termModel.textColor = [UIColor darkGrayColor];
    self.termModel.font = [UIFont systemFontOfSize:12.0f];
    self.termModel.text  = @"testt";
    self.termModel.delegate = self;
    [baseInfoView addSubview:self.termModel];
    
    UILabel *typeModel = [[UILabel alloc] initWithFrame:CGRectMake(5, 85, 55, 15)];
    typeModel.textColor = [UIColor darkGrayColor];
    typeModel.font = [UIFont systemFontOfSize:12.0f];
    typeModel.text = @"终端类型:";
    [baseInfoView addSubview:typeModel];
    
    self.termType = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.termType setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    self.termType.frame = CGRectMake(60, 85, rScreen.size.width - 90, 15);
    self.termType.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    self.termType.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.termType setTitle:@"拨号POS" forState:UIControlStateNormal];
    [self.termType addTarget:self action:@selector(onSelectType:) forControlEvents:UIControlEventTouchUpInside];
    self.termType.tag = 0;
    [baseInfoView addSubview:self.termType];
    
    self.shopName = [[UILabel alloc] initWithFrame:CGRectMake(5, 105, rScreen.size.width - 10, 15)];
    self.shopName.textColor = [UIColor darkGrayColor];
    self.shopName.font = [UIFont systemFontOfSize:12.0f];
    self.shopName.text = [NSString stringWithFormat:@"所属门店:%@", self.shopInfo ? [self.shopInfo objectForKey:@"shopname"] : [self.termInfo objectForKey:@"shopname"]];
    [baseInfoView addSubview:self.shopName];

    self.merchName = [[UILabel alloc] initWithFrame:CGRectMake(5, 125, rScreen.size.width - 10, 15)];
    self.merchName.textColor = [UIColor darkGrayColor];
    self.merchName.font = [UIFont systemFontOfSize:12.0f];
    self.merchName.text = [NSString stringWithFormat:@"所属商户:%@", [self.merchInfo objectForKey:@"merchname"]];
    [baseInfoView addSubview:self.merchName];

    self.instName = [[UILabel alloc] initWithFrame:CGRectMake(5, 145, rScreen.size.width - 10, 15)];
    self.instName.textColor = [UIColor darkGrayColor];
    self.instName.font = [UIFont systemFontOfSize:12.0f];
    self.instName.text = [NSString stringWithFormat:@"所属机构:%@", [self.merchInfo objectForKey:@"instname"]];
    [baseInfoView addSubview:self.instName];

    self.bEdit = false;
    
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
        [resultView addSubview:btn];
        btn.tag = btnTag;
        btnTag++;
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
    
    self.instPic = [[UIImageView alloc] initWithFrame: CGRectMake(40, 120, 50, 50)];
    self.instPic.tag = 0;
    self.instPic.userInteractionEnabled = YES;
    [self.instPic addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSelectPic:)]];
    [self.instPic addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onImgPreview:)]];
    [resultView addSubview:self.instPic];
    
    self.serialPic = [[UIImageView alloc] initWithFrame: CGRectMake(100, 120, 50, 50)];
    self.serialPic.tag = 1;
    self.serialPic.userInteractionEnabled = YES;
    [self.serialPic addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSelectPic:)]];
    [self.serialPic addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onImgPreview:)]];
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
    
    self.scrollView.contentSize = CGSizeMake(rScreen.size.width, commitBtn.frame.origin.y + commitBtn.frame.size.height);
    
    self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.indicator setCenter:CGPointMake(rScreen.size.width/2, rScreen.size.height/2)];
    self.indicator.color = [UIColor blueColor];
    [self.view addSubview:self.indicator];
    
    self.inspresultArray = [[NSMutableArray alloc] initWithCapacity:2];
    self.userImgDict = [[NSMutableDictionary alloc] initWithCapacity:2];
    NSMutableArray *imageArray = [[NSMutableArray alloc] initWithCapacity:12];
    for (int i = 1; i <= 12; i++) {
        [imageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"loading%d", i]]];
    }
    self.loadingImage = [UIImage animatedImageWithImages:imageArray duration:10.f];
    
    self.needupdate = YES;
}

- (IBAction)onSelectType:(UIButton *)sender {
    if (!self.bEdit) {
        return;
    }
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:7];
    for (NSDictionary *dict in [ITermType getInstance].types) {
        [array addObject:[dict objectForKey:@"remark"]];
    }
    
    [ActionSheetStringPicker showPickerWithTitle:@"请选择终端类型" rows:array initialSelection:sender.tag doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        sender.tag = selectedIndex;
        [sender setTitle:selectedValue forState:UIControlStateNormal];
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        NSLog(@"cancel");
    } origin:sender];
}

- (IBAction)onCommit:(id)sender {
    if (![Utils locationAccess]) {
        [self.view makeToast:@"定位功能不可用!"];
        return;
    }
    for (NSInteger i = 0; i < 2; i++) {
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
                             @"termname":self.termSerialnbr.text,
                             @"termband":self.termBrand.text,
                             @"termtype":[[[ITermType getInstance].types objectAtIndex:self.termType.tag] objectForKey:@"term_type"],
                             @"termmode":self.termModel.text
                             };
    NSDictionary *params = @{
                             @"staffcode": [iUser getInstance].staffcode,
                             @"instcode": [self.merchInfo objectForKey:@"instcode"],
                             @"merchcode": [self.merchInfo objectForKey:@"merchcode"],
                             @"batchcode": [self.merchInfo objectForKey:@"batchcode"],
                             @"addrcode": [Utils getAddrCode],
                             @"serialnbr": [self.termInfo objectForKey:@"serialnbr"],
                             @"seq":@1,
                             @"content": self.desc.text,
                             @"shopcode": self.shopInfo ? [self.shopInfo objectForKey:@"shopcode"] : [self.termInfo objectForKey:@"shopcode"],
                             @"termcode": [self.termInfo objectForKey:@"termcode"],
                             @"flag": @(self.radioButton.selectedButton.tag),
                             @"content": self.desc.text,
                             @"data": [AFNRequestManager convertToJSONData:data]
                             };
    [self.indicator startAnimating];
    self.view.userInteractionEnabled = NO;
    [AFNRequestManager requestAFURL:@"inspTermInfo.json" httpMethod:METHOD_POST params:params succeed:^(NSDictionary *ret) {
        if (0 == [[ret objectForKey:@"status"] integerValue]) {
            self.inspcntid = [[ret objectForKey:@"insp_cnt_id"] integerValue];
            [self uploadImages:0];
        }
    } failure:^(NSError *error) {
        [self.indicator stopAnimating];
        self.view.userInteractionEnabled = YES;
        [self.view makeToast:@"终端巡检请求失败!"];
        NSLog(@"%@", error);
    }];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.needupdate) {
        self.needupdate = YES;
        return;
    }
    [self.userImgDict removeAllObjects];
    [self.inspresultArray removeAllObjects];
    self.instPic.image = [UIImage imageNamed:@"i_add_posup.png"];
    self.serialPic.image = [UIImage imageNamed:@"i_add_posdown.png"];
    self.radioButton.selected = YES;
    self.desc.text = @"";

    NSDictionary *params = @{
                             @"staffcode": [iUser getInstance].staffcode,
                             @"merchcode": [self.merchInfo objectForKey:@"merchcode"],
                             @"instcode": [self.merchInfo objectForKey:@"instcode"],
                             @"batchcode": [self.merchInfo objectForKey:@"batchcode"],
                             @"termcode": [self.termInfo objectForKey:@"termcode"],
                             @"shopcode": self.shopInfo ? [self.shopInfo objectForKey:@"shopcode"] :[self.termInfo objectForKey:@"shopcode"]
                             };
    [AFNRequestManager requestAFURL:@"getTermInfo.json" httpMethod:METHOD_POST params:params succeed:^(NSDictionary *ret) {
        if (0 == [[ret objectForKey:@"status"] integerValue]) {
            if (nil == self.termDetail) {
                self.termDetail = [[NSMutableDictionary alloc] initWithCapacity:6];
            }
            [self.termDetail removeAllObjects];
            [self.termDetail setDictionary:[ret objectForKey:@"datas"]];
            for (NSInteger i = 0; i < [ITermType getInstance].types.count; i++) {
                NSDictionary *dict = [[ITermType getInstance].types objectAtIndex:i];
                if ([(NSString *)[dict objectForKey:@"term_type"] isEqualToString:[self.termDetail objectForKey:@"termtype"]]) {
                    self.termType.tag = i;
                    break;
                }
            }
            [self.termType setTitle:[self.termDetail objectForKey:@"termtypedesc"] forState:UIControlStateNormal];
            self.termSerialnbr.text = [NSString stringWithString:[self.termDetail objectForKey:@"termname"]];
            self.termCode.text = [NSString stringWithFormat:@"终端编号:%@",[self.termDetail objectForKey:@"termcode"]];
            self.termModel.text = [NSString stringWithString:[self.termDetail objectForKey:@"termmode"]];
            if ([self.termDetail objectForKey:@"termband"]) {
                self.termBrand.text = [NSString stringWithString:[self.termDetail objectForKey:@"termband"]];
            }
            else {
                self.termBrand.text = @"";
            }
            
            NSArray *inspresults = [[NSArray alloc] initWithArray:[self.termDetail objectForKey:@"inspresult"]];
            [self.inspresultArray addObjectsFromArray:inspresults];
            for (NSInteger i = 0; i < inspresults.count; i++) {
                NSDictionary *dict = [inspresults objectAtIndex:i];
                if (i == 0) {
                    if (![@"" isEqualToString:[dict objectForKey:@"picuri"]]) {
                        [self.instPic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMG_URL, [dict objectForKey:@"picuri"]]] placeholderImage:self.loadingImage];
                    }
                    [self.radioButton setSelectedWithTag:[[dict objectForKey:@"flag"] integerValue]];
                    self.desc.text = [NSString stringWithString:[dict objectForKey:@"content"]];
                }
                else if (i == 1) {
                    if (![@"" isEqualToString:[dict objectForKey:@"picuri"]]) {
                        [self.serialPic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMG_URL, [dict objectForKey:@"picuri"]]] placeholderImage:self.loadingImage];
                    }
                }
            }

        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
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
    if ([image isEqual:[UIImage imageNamed:@"i_add_posup.png"]] ||
        [image isEqual:[UIImage imageNamed:@"i_add_posdown.png"]]) {
        return;
    }
    
    PYPhotoBrowseView *photoBroseView = [[PYPhotoBrowseView alloc] init];
    photoBroseView.sourceImgageViews = @[imgView];
    [photoBroseView show];
}


- (IBAction)onUpdateLog:(id)sender {
    ILogViewController *logViewController = [[ILogViewController alloc] init];
    logViewController.merchInfo = [[NSDictionary alloc] initWithDictionary:self.merchInfo];
    logViewController.termInfo = [[NSDictionary alloc] initWithDictionary:self.termInfo];
    if (self.shopInfo) {
        logViewController.shopInfo = [[NSDictionary alloc] initWithDictionary:self.shopInfo];
    }
    [self.navigationController pushViewController:logViewController animated:YES];
}

- (IBAction)onEdit:(UIButton *)sender {
    if ([sender.currentTitle isEqualToString:@"编辑"]) {
        self.bEdit = true;
        [sender setTitle:@"保存" forState:UIControlStateNormal];
    }
    else if ([sender.currentTitle isEqualToString:@"保存"]) {
        self.bEdit = false;
        [sender setTitle:@"编辑" forState:UIControlStateNormal];
    }
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return self.bEdit;
}

#pragma mark - UIImagePickerControllerDelegate Implementation

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image= [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    [self dismissViewControllerAnimated:YES completion:^{
        self.curSelPic.image = image;
        [self.userImgDict setObject:image forKey:@(self.curSelPic.tag)];
    }];
}

- (void)uploadImgOK {
    self.view.userInteractionEnabled = YES;
    [self.indicator stopAnimating];
    [self.view makeToast:@"终端巡检请求成功!"];
}

- (void)uploadImgFail {
    self.view.userInteractionEnabled = YES;
    [self.indicator stopAnimating];
    [self.view makeToast:@"上传图片失败!"];
}

- (void) uploadImages:(NSInteger)index {
    if (index >= 2) {
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
                             @"serialnbr": [self.termDetail objectForKey:@"termcode"],
                             @"seq":[self.self.termInfo objectForKey:@"seq"],
                             @"oldfile":oldFile,
                             @"logo": index == 0 ? @"yes" : @"",
                             @"posi": [NSString stringWithFormat:@"%ld", (long)index]
                             };
    index++;
    if (img) {
        [AFNRequestManager requestAFURL:@"inspTermPics.json" params:params imageData:UIImageJPEGRepresentation(img, 0.2) succeed:^(NSDictionary *ret) {
            if (0 == [[ret objectForKey:@"status"] integerValue]) {
                [self uploadImages:(index)];
            }
        } failure:^(NSError *error) {
            [self uploadImgFail];
            NSLog(@"%@",error);
        }];
    }
    else {
        [AFNRequestManager requestAFURL:@"inspTermPics.json" httpMethod:METHOD_POST params:params succeed:^(NSDictionary *ret) {
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
