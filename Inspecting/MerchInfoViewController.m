//
//  MerchInfoViewController.m
//  Inspecting
//
//  Created by liuyuanpeng on 2017/3/2.
//  Copyright © 2017年 default. All rights reserved.
//

#import "MerchInfoViewController.h"
#import <RadioButton/RadioButton.h>
#import "ITextView.h"
#import "AFNRequestManager.h"
#import "iUser.h"
#import "ILogViewController.h"
#import "IShopViewController.h"
#import "ITermViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Utils.h"
#import <Toast/UIView+Toast.h>
#import "PickerView.h"
#import <PYPhotoBrowser/PYPhotoBrowser.h>

@interface MerchInfoViewController ()

@end

@implementation MerchInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0]];
    CGRect rScreen = [[UIScreen mainScreen] bounds];
    CGRect rNav = self.navigationController.navigationBar.frame;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, rNav.origin.y + rNav.size.height, rScreen.size.width, rScreen.size.height - rNav.origin.y - rNav.size.height)];
    [self.view addSubview:self.scrollView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,  rScreen.size.width, 30)];
    titleLabel.text = @"商户详情";
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
    
    self.editBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [self.editBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    self.editBtn.frame = CGRectMake(rScreen.size.width - 50, - rNav.origin.y - rNav.size.height + 5, 40, 20);
    [self.editBtn addTarget:self action:@selector(onEdit:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.editBtn];
    
    UIView *baseInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, - rNav.origin.y - rNav.size.height + 35, rScreen.size.width, 130)];
    [baseInfoView setBackgroundColor:[UIColor whiteColor]];
    [self.scrollView addSubview:baseInfoView];
    
    self.merchimg = [[UIImageView alloc] initWithFrame:CGRectMake(5, 15, 70, 70)];
    [self.merchimg.layer setCornerRadius:2.0f];
    [self.merchimg.layer setMasksToBounds:YES];
    self.merchimg.image = [UIImage imageNamed:@"i_default_company.png"];
    [baseInfoView addSubview:self.merchimg];
    
    UILabel *merchNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 30, 20)];
    merchNameLabel.textColor = [UIColor darkGrayColor];
    merchNameLabel.font = [UIFont systemFontOfSize:12.0f];
    merchNameLabel.text = @"名称:";
    [baseInfoView addSubview:merchNameLabel];
    
    self.merchname = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, rScreen.size.width - 115, 20)];
    self.merchname.textColor = [UIColor darkGrayColor];
    self.merchname.font = [UIFont systemFontOfSize:12.0f];
    self.merchname.delegate = self;
    [baseInfoView addSubview:self.merchname];
    
    UILabel *merchtypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 30, 30, 20)];
    merchtypeLabel.textColor = [UIColor darkGrayColor];
    merchtypeLabel.font = [UIFont systemFontOfSize:12.0f];
    merchtypeLabel.text = @"类型:";
    [baseInfoView addSubview:merchtypeLabel];
    
    self.merchtype = [[UILabel alloc] initWithFrame:CGRectMake(110, 30, rScreen.size.width - 115, 20)];
    self.merchtype.textColor = [UIColor darkGrayColor];
    self.merchtype.font = [UIFont systemFontOfSize:12.0f];
    self.merchtype.userInteractionEnabled = YES;
    [self.merchtype addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSelectType:)]];
    [baseInfoView addSubview:self.merchtype];
    
    self.merchcode = [[UILabel alloc] initWithFrame:CGRectMake(80, 50, rScreen.size.width - 90, 20)];
    self.merchcode.textColor = [UIColor darkGrayColor];
    self.merchcode.font = [UIFont systemFontOfSize:12.0f];
    self.merchcode.text = @"商户编码:";
    [baseInfoView addSubview:self.merchcode];
    
    self.merchinst = [[UILabel alloc] initWithFrame:CGRectMake(80, 70, rScreen.size.width - 90, 20)];
    self.merchinst.textColor = [UIColor darkGrayColor];
    self.merchinst.font = [UIFont systemFontOfSize:12.0f];
    self.merchinst.text  = @"隶属:";
    [baseInfoView addSubview:self.merchinst];
    
    UIImageView *localImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 100, 20, 20)];
    localImageView.image = [UIImage imageNamed:@"i_location.png"];
    localImageView.userInteractionEnabled = YES;
    [localImageView addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onGetGeoCode)]];
    [baseInfoView addSubview:localImageView];
    
    self.merchAddr = [[UITextField alloc] initWithFrame:CGRectMake(40, 95, rScreen.size.width - 50, 30)];
    [self.merchAddr setBorderStyle:UITextBorderStyleNone];
    [self.merchAddr setText:@""];
    self.merchAddr.font = [UIFont systemFontOfSize:12.0f];
    self.merchAddr.delegate = self;
    [baseInfoView addSubview:self.merchAddr];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, baseInfoView.frame.origin.y + baseInfoView.frame.size.height + 5, rScreen.size.width, 59) style:UITableViewStylePlain];
    [self.scrollView addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.bEdit = false;
    
    UILabel *resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, self.tableView.frame.origin.y + self.tableView.frame.size.height + 5, 100, 25)];
    resultLabel.text = @"巡检结果";
    resultLabel.font = [UIFont systemFontOfSize:13];
    [self.scrollView addSubview:resultLabel];
    
    UIView *resultView = [[UIView alloc] initWithFrame:CGRectMake(0, resultLabel.frame.origin.y + 30, rScreen.size.width, 180)];
    [resultView setBackgroundColor:[UIColor whiteColor]];
    [self.scrollView addSubview:resultView];
    
    NSMutableArray *buttons = [NSMutableArray arrayWithCapacity:3];
    CGRect btnRect = CGRectMake(25, 10, 100, 30);
    NSInteger btntag = 1;
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
        btn.tag = btntag;
        btntag++;
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
    
    self.licencePic = [[UIImageView alloc] initWithFrame: CGRectMake(40, 120, 50, 50)];
    self.licencePic.image = [UIImage imageNamed:@"i_add_yyzz.png"];
    self.licencePic.tag = 0;
    self.licencePic.userInteractionEnabled = YES;
    [self.licencePic addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSelectPic:)]];
    [self.licencePic addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onImgPreview:)]];
    [resultView addSubview:self.licencePic];
    
    self.facadePic = [[UIImageView alloc] initWithFrame: CGRectMake(100, 120, 50, 50)];
    self.facadePic.image = [UIImage imageNamed:@"i_add_mmzp.png"];
    self.facadePic.tag = 1;
    self.facadePic.userInteractionEnabled = YES;
    [self.facadePic addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSelectPic:)]];
    [self.facadePic addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onImgPreview:)]];
    [resultView addSubview:self.facadePic];
    
    self.signPic = [[UIImageView alloc] initWithFrame: CGRectMake(160, 120, 50, 50)];
    self.signPic.image = [UIImage imageNamed:@"i_add_zp.png"];
    self.signPic.tag = 2;
    self.signPic.userInteractionEnabled = YES;
    [self.signPic addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSelectPic:)]];
    [self.signPic addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onImgPreview:)]];
    [resultView addSubview:self.signPic];
    
    self.sitePic = [[UIImageView alloc] initWithFrame: CGRectMake(220, 120, 50, 50)];
    self.sitePic.image = [UIImage imageNamed:@"i_add_jycs.png"];
    self.sitePic.tag = 3;
    self.sitePic.userInteractionEnabled = YES;
    [self.sitePic addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSelectPic:)]];
    [self.sitePic addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onImgPreview:)]];
    [resultView addSubview:self.sitePic];
    
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
    
    self.pickerView = [[PickerView alloc] initWithFrame:CGRectMake(0, rNav.origin.y + rNav.size.height, rScreen.size.width, rScreen.size.height - rNav.origin.y - rNav.size.height)];
    [self.pickerView setHidden:YES];
    __block MerchInfoViewController *blockSelf = self;
    [self.pickerView setComplete:^(NSDictionary *type) {
        [blockSelf.merchInfo setValue:[type objectForKey:@"mcc"] forKey:@"merchtype"];
        [blockSelf.merchtype setText:[NSString stringWithString:[type objectForKey:@"remark"]]];
    }];
    [self.view addSubview:self.pickerView];
    
    self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.indicator setCenter:CGPointMake(rScreen.size.width/2, rScreen.size.height/2)];
    self.indicator.color = [UIColor blueColor];
    [self.view addSubview:self.indicator];
    
    self.userImgDict = [[NSMutableDictionary alloc] initWithCapacity:4];
    self.inspresultArray = [[NSMutableArray alloc] initWithCapacity:4];
    
    NSMutableArray *imageArray = [[NSMutableArray alloc] initWithCapacity:12];
    for (int i = 1; i <= 12; i++) {
        [imageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"loading%d", i]]];
    }
    self.loadingImage = [UIImage animatedImageWithImages:imageArray duration:10.f];
    self.needupdate = YES;
}

- (IBAction)onGetGeoCode {
    if (!self.bEdit) {
        return;
    }
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    [geoCoder reverseGeocodeLocation:[Utils getMyLocation] completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placeMark = [placemarks objectAtIndex:0];
            
            self.merchAddr.text = [NSString stringWithFormat:@"%@%@%@%@",placeMark.administrativeArea?placeMark.administrativeArea:@"", placeMark.locality?placeMark.locality:@"", placeMark.subLocality?placeMark.subLocality:@"", placeMark.thoroughfare?placeMark.thoroughfare:@""];
        }
    }];
}

- (void)hideTabBar {
    if (self.tabBarController.tabBar.hidden == YES) {
        return;
    }
    UIView *contentView;
    if ( [[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] )
        contentView = [self.tabBarController.view.subviews objectAtIndex:1];
    else
        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
    contentView.frame = CGRectMake(contentView.bounds.origin.x,  contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height + self.tabBarController.tabBar.frame.size.height);
    self.tabBarController.tabBar.hidden = YES;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (IBAction)onSelectType:(id)sender {
    if (self.bEdit) {
        [self.pickerView setHidden:NO];
    }
}

- (IBAction)onCommit:(id)sender {
    for (NSInteger i = 0; i < 4; i++) {
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
    NSDictionary *datas = @{
                            @"merchname":self.merchname.text,
                            @"mcc":[self.merchInfo objectForKey:@"merchtype"],
                            @"address":self.merchAddr.text
                            };
    NSDictionary *params = @{
                             @"staffcode": [iUser getInstance].staffcode,
                             @"instcode":  [self.taskInfo objectForKey:@"instcode"],
                             @"merchcode": [self.taskInfo objectForKey:@"merchcode"],
                             @"batchcode": [self.taskInfo objectForKey:@"batchcode"],
                             @"addrcode": [Utils getAddrCode],
                             @"flag":@(self.radioButton.selectedButton.tag),
                             @"content": self.desc.text,
                             @"data": [AFNRequestManager convertToJSONData:datas]
                             };
    [self.indicator startAnimating];
    self.view.userInteractionEnabled = NO;
    [AFNRequestManager requestAFURL:@"inspMerchInfo.json" httpMethod:METHOD_POST params:params succeed:^(NSDictionary *ret) {
        if (0 == [[ret objectForKey:@"status"] integerValue]) {
            self.insp_cnt_id = [[ret objectForKey:@"insp_cnt_id"] integerValue];
            [self uploadImages:0];
        }
    } failure:^(NSError *error) {
        [self.view makeToast:@"巡检上传失败!"];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.needupdate) {
        self.needupdate = YES;
        return;
    }
    [self hideTabBar];
    [self.userImgDict removeAllObjects];
    [self.inspresultArray removeAllObjects];
    self.licencePic.image = [UIImage imageNamed:@"i_add_yyzz.png"];
    self.facadePic.image = [UIImage imageNamed:@"i_add_mmzp"];
    self.signPic.image = [UIImage imageNamed:@"i_add_zp.png"];
    self.sitePic.image = [UIImage imageNamed:@"i_add_jycs.png"];
    self.radioButton.selected = YES;
    self.desc.text = @"";
    NSDictionary *params = @{
                             @"staffcode": [iUser getInstance].staffcode,
                             @"instcode":  [self.taskInfo objectForKey:@"instcode"],
                             @"merchcode": [self.taskInfo objectForKey:@"merchcode"],
                             @"batchcode": [self.taskInfo objectForKey:@"batchcode"]
                             };
    [AFNRequestManager requestAFURL:@"getMerchInfo.json" httpMethod:METHOD_POST params:params succeed:^(NSDictionary *ret) {
        if (0 == [[ret objectForKey:@"status"] integerValue]) {
            self.merchInfo = [[NSMutableDictionary alloc] initWithDictionary:[ret objectForKey:@"datas"]];
            [self.tableView reloadData];
            NSString *imgurl = [NSString stringWithFormat:@"%@", [self.merchInfo objectForKey:@"pic"]];
            if (imgurl && ![imgurl isEqualToString:@""]) {
                [self.merchimg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMG_URL, imgurl]] placeholderImage:self.loadingImage];
            }
            self.merchname.text = [NSString stringWithString: [self.merchInfo objectForKey:@"merchname"]];
            self.merchtype.text = [NSString stringWithString: [self.merchInfo objectForKey:@"merchtypedesc"]];
            self.merchcode.text = [NSString stringWithFormat:@"商户编码: %@", [self.merchInfo objectForKey:@"merchcode"]];
            self.merchinst.text = [NSString stringWithFormat:@"隶属: %@", [self.merchInfo objectForKey:@"instname"]];
            self.merchAddr.text = [NSString stringWithFormat:@"%@", [self.merchInfo objectForKey:@"addr"]];
            
            NSArray *inspresults = [[NSArray alloc] initWithArray:[self.merchInfo objectForKey:@"inspresult"]];
            [self.inspresultArray addObjectsFromArray:inspresults];
            for (NSInteger i = 0; i < inspresults.count; i++) {
                NSDictionary *dict = [inspresults objectAtIndex:i];
                if ([@"" isEqualToString:[dict objectForKey:@"picuri"]]) {
                    continue;
                }
                if (i == 0) {
                    [self.licencePic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMG_URL, [dict objectForKey:@"picuri"]]] placeholderImage: self.loadingImage];
                    [self.radioButton setSelectedWithTag:[[dict objectForKey:@"flag"] integerValue]];
                    self.desc.text = [NSString stringWithString:[dict objectForKey:@"content"]];
                }
                else if (i == 1) {
                    [self.facadePic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMG_URL, [dict objectForKey:@"picuri"]]] placeholderImage:self.loadingImage];
                }
                else if (i == 2) {
                    [self.signPic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMG_URL, [dict objectForKey:@"picuri"]]] placeholderImage:self.loadingImage];
                }

                else if (i == 3) {
                    [self.sitePic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMG_URL, [dict objectForKey:@"picuri"]]] placeholderImage:self.loadingImage];
                }
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (IBAction)onSelectPic:(UITapGestureRecognizer *)sender {
    if (![Utils cameraAccess]) {
        [self.view makeToast:@"请先打开相机的使用权限!"];
        return;
    }
    self.curSelPic = (UIImageView *)sender.view;
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
        [image isEqual:[UIImage imageNamed:@"i_add_jycs.png"]]) {
        return;
    }
    
    PYPhotoBrowseView *photoBroseView = [[PYPhotoBrowseView alloc] init];
    photoBroseView.sourceImgageViews = @[imgView];
    [photoBroseView show];
}

- (IBAction)onUpdateLog:(id)sender {
    ILogViewController *logViewController = [[ILogViewController alloc] init];
    logViewController.merchInfo = [[NSDictionary alloc] initWithDictionary:self.merchInfo];
    [self.navigationController pushViewController:logViewController animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.bEdit = false;
    [self.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [self.view endEditing:YES];
}

- (IBAction)onEdit:(UIButton *)sender {
    if ([sender.currentTitle isEqualToString:@"编辑"]) {
        self.bEdit = true;
        [sender setTitle:@"保存" forState:UIControlStateNormal];
        [self.merchname becomeFirstResponder];
    }
    else if ([sender.currentTitle isEqualToString:@"保存"]) {
        self.bEdit = false;
        [sender setTitle:@"编辑" forState:UIControlStateNormal];
        [self.view endEditing:YES];
    }
}

- (void)uploadImgOK {
    self.view.userInteractionEnabled = YES;
    [self.indicator stopAnimating];
    [self.view makeToast:@"巡检上传成功!"];
}

- (void)uploadImgFail {
    self.view.userInteractionEnabled = YES;
    [self.indicator stopAnimating];
    [self.view makeToast:@"巡检图片上传失败!"];
}

- (void) uploadImages:(NSInteger)index {
    if (index >= 4) {
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
                             @"inspcntid": @(self.insp_cnt_id),
                             @"oldfile":oldFile,
                             @"logo": index == 1 ? @"yes" : @"",
                             @"posi": [NSString stringWithFormat:@"%ld", (long)index]
                             };
    index++;
    if (img) {
        [AFNRequestManager requestAFURL:@"inspMerchPics.json" params:params imageData:UIImageJPEGRepresentation(img, 0.2) succeed:^(NSDictionary *ret) {
            if (0 == [[ret objectForKey:@"status"] integerValue]) {
                [self uploadImages:(index)];
            }
        } failure:^(NSError *error) {
            [self uploadImgFail];
        }];
    }
    else {
        [AFNRequestManager requestAFURL:@"inspMerchPics.json" httpMethod:METHOD_POST params:params succeed:^(NSDictionary *ret) {
            if (0 == [[ret objectForKey:@"status"] integerValue]) {
                [self uploadImages:index];
            }
        } failure:^(NSError *error) {
            [self uploadImgFail];
        }];
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

#pragma mark - UITableViewDataSource implementation
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2L;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"merchinfocell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0L) {
            cell.imageView.image = [UIImage imageNamed:@"i_store.png"];
        }
        else {
            cell.imageView.image = [UIImage imageNamed:@"i_pos.png"];
        }
        CGSize itemSize = CGSizeMake(20, 20);
        UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [cell.imageView.image drawInRect:imageRect];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = [NSString stringWithFormat:@"门店: %ld", self.merchInfo ? [[self.merchInfo objectForKey:@"shopcnt"] integerValue] : 0L];
    }
    else {
        cell.textLabel.text = [NSString stringWithFormat:@"终端: %ld", self.merchInfo ? [[self.merchInfo objectForKey:@"termcnt"] integerValue] : 0L];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate implementation

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        IShopViewController *shopViewController = [[IShopViewController alloc] init];
        shopViewController.merchInfo = [[NSDictionary alloc] initWithDictionary:self.merchInfo];
        [self.navigationController pushViewController:shopViewController animated:YES];
    }
    else {
        ITermViewController *termViewController = [[ITermViewController alloc] init];
        termViewController.merchInfo = [[NSDictionary alloc] initWithDictionary:self.merchInfo];
        [self.navigationController pushViewController:termViewController animated:YES];
    }
}

#pragma mark - UIImagePickerControllerDelegate Implementation

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image= [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self.userImgDict setObject:image forKey:@(self.curSelPic.tag)];
        self.curSelPic.image = image;
    }];
}
@end
