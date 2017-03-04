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
#import "UIImage+UIImageEx.h"
#import "AFNRequestManager.h"
#import "iUser.h"
#import "ILogViewController.h"
#import "IShopViewController.h"
#import "ITermViewController.h"

@interface MerchInfoViewController ()

@end

@implementation MerchInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0]];
    CGRect rScreen = [[UIScreen mainScreen] bounds];
    CGRect rNav = self.navigationController.navigationBar.frame;
    
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
    
    UILabel *baseinfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, rNav.origin.y + rNav.size.height + 5, 100, 25)];
    baseinfoLabel.font = [UIFont systemFontOfSize:13];
    baseinfoLabel.text = @"基本信息";
    [self.view addSubview:baseinfoLabel];
    
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [editBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    editBtn.frame = CGRectMake(rScreen.size.width - 50, rNav.origin.y + rNav.size.height + 5, 40, 20);
    [editBtn addTarget:self action:@selector(onEdit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:editBtn];
    
    UIView *baseInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, rNav.origin.y + rNav.size.height + 35, rScreen.size.width, 130)];
    [baseInfoView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:baseInfoView];
    
    self.merchimg = [[UIImageView alloc] initWithFrame:CGRectMake(5, 15, 70, 70)];
    [self.merchimg.layer setCornerRadius:2.0f];
    [self.merchimg.layer setMasksToBounds:YES];
    self.merchimg.image = [UIImage imageNamed:@"i_default_company.png"];
    [baseInfoView addSubview:self.merchimg];
    
    self.merchname = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, rScreen.size.width - 90, 20)];
    self.merchname.textColor = [UIColor darkGrayColor];
    self.merchname.font = [UIFont systemFontOfSize:12.0f];
    self.merchname.text = @"klfjasljfa";
    [baseInfoView addSubview:self.merchname];
    
    self.merchtype = [[UILabel alloc] initWithFrame:CGRectMake(80, 30, rScreen.size.width - 90, 20)];
    self.merchtype.textColor = [UIColor darkGrayColor];
    self.merchtype.font = [UIFont systemFontOfSize:12.0f];
    self.merchtype.text = @"test";
    [baseInfoView addSubview:self.merchtype];
    
    self.merchcode = [[UILabel alloc] initWithFrame:CGRectMake(80, 50, rScreen.size.width - 90, 20)];
    self.merchcode.textColor = [UIColor darkGrayColor];
    self.merchcode.font = [UIFont systemFontOfSize:12.0f];
    self.merchcode.text = @"rest";
    [baseInfoView addSubview:self.merchcode];
    
    self.merchinst = [[UILabel alloc] initWithFrame:CGRectMake(80, 70, rScreen.size.width - 90, 20)];
    self.merchinst.textColor = [UIColor darkGrayColor];
    self.merchinst.font = [UIFont systemFontOfSize:12.0f];
    self.merchinst.text  = @"testt";
    [baseInfoView addSubview:self.merchinst];
    
    UIImageView *localImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 100, 20, 20)];
    localImageView.image = [UIImage imageNamed:@"i_location.png"];
    [baseInfoView addSubview:localImageView];
    
    self.merchAddr = [[UITextField alloc] initWithFrame:CGRectMake(40, 95, rScreen.size.width - 50, 30)];
    [self.merchAddr setBorderStyle:UITextBorderStyleNone];
    [self.merchAddr setText:@"dfjasdlfjdaksfkdjfkd"];
    self.merchAddr.font = [UIFont systemFontOfSize:12.0f];
    self.merchAddr.delegate = self;
    [baseInfoView addSubview:self.merchAddr];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, baseInfoView.frame.origin.y + baseInfoView.frame.size.height + 5, rScreen.size.width, 59) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.bEdit = false;
    
    UILabel *resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, self.tableView.frame.origin.y + self.tableView.frame.size.height + 5, 100, 25)];
    resultLabel.text = @"巡检结果";
    resultLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:resultLabel];
    
    UIView *resultView = [[UIView alloc] initWithFrame:CGRectMake(0, resultLabel.frame.origin.y + 30, rScreen.size.width, 180)];
    [resultView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:resultView];
    
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
    
    self.licencePic = [UIButton buttonWithType:UIButtonTypeCustom];
    self.licencePic.frame = CGRectMake(40, 120, 50, 50);
    [self.licencePic setBackgroundImage:[UIImage imageNamed:@"i_add_yyzz.png"] forState:UIControlStateNormal];
    self.licencePic.tag = 0;
    [self.licencePic addTarget:self action:@selector(onSelectPic:) forControlEvents:UIControlEventTouchUpInside];
    [resultView addSubview:self.licencePic];
    
    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    commitBtn.frame = CGRectMake(rScreen.size.width/2 - 50, resultView.frame.origin.y + resultView.frame.size.height + 10, 100, 30);
    [commitBtn.layer setCornerRadius:2.0f];
    [commitBtn.layer setMasksToBounds:YES];
    [commitBtn setBackgroundColor:[UIColor colorWithRed:233/255.0 green:63/255.0 blue:51/255.0 alpha:1.0]];
    [commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [commitBtn addTarget:self action:@selector(onCommit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commitBtn];
    
    self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.indicator setCenter:CGPointMake(rScreen.size.width/2, rScreen.size.height/2)];
    self.indicator.color = [UIColor blueColor];
    [self.view addSubview:self.indicator];
}

- (IBAction)onCommit:(id)sender {
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSDictionary *params = @{
                             @"staffcode": [iUser getInstance].staffcode,
                             @"instcode":  [self.taskInfo objectForKey:@"instcode"],
                             @"merchcode": [self.taskInfo objectForKey:@"merchcode"],
                             @"batchcode": [self.taskInfo objectForKey:@"batchcode"]
                             };
    [AFNRequestManager requestAFURL:@"getMerchInfo.json" httpMethod:METHOD_POST params:params succeed:^(NSDictionary *ret) {
        if (0 == [[ret objectForKey:@"status"] integerValue]) {
            self.merchInfo = [[NSDictionary alloc] initWithDictionary:[ret objectForKey:@"datas"]];
            [self.tableView reloadData];
            NSString *imgurl = [NSString stringWithFormat:@"%@", [self.merchInfo objectForKey:@"pic"]];
            if (imgurl && ![imgurl isEqualToString:@""]) {
                self.merchimg.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMG_URL, imgurl]]]];
            }
            self.merchname.text = [NSString stringWithFormat:@"名称: %@", [self.merchInfo objectForKey:@"merchname"]];
            self.merchtype.text = [NSString stringWithFormat:@"类型: %@", [self.merchInfo objectForKey:@"merchtypedesc"]];            self.merchcode.text = [NSString stringWithFormat:@"商户编码: %@", [self.merchInfo objectForKey:@"merchcode"]];
            self.merchinst.text = [NSString stringWithFormat:@"隶属: %@", [self.merchInfo objectForKey:@"instname"]];
            
            self.merchAddr.text = [NSString stringWithFormat:@"%@", [self.merchInfo objectForKey:@"addr"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
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

- (IBAction)onUpdateLog:(id)sender {
    if (nil == self.logViewController) {
        self.logViewController = [[ILogViewController alloc] init];
    }
    self.logViewController.merchInfo = [[NSDictionary alloc] initWithDictionary:self.merchInfo];
    [self.navigationController pushViewController:self.logViewController animated:YES];
}

- (IBAction)onEdit:(UIButton *)sender {
    if ([sender.currentTitle isEqualToString:@"编辑"]) {
        self.bEdit = true;
        [sender setTitle:@"保存" forState:UIControlStateNormal];
        [self.merchAddr becomeFirstResponder];
    }
    else if ([sender.currentTitle isEqualToString:@"保存"]) {
        self.bEdit = false;
        [sender setTitle:@"编辑" forState:UIControlStateNormal];
        [self.merchAddr resignFirstResponder];
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
        cell.textLabel.text = [NSString stringWithFormat:@"门店: %ld", self.merchInfo ? [[self.merchInfo objectForKey:@"shopcnt"] integerValue] : 0];
    }
    else {
        cell.textLabel.text = [NSString stringWithFormat:@"终端: %ld", self.merchInfo ? [[self.merchInfo objectForKey:@"termcnt"] integerValue] : 0];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate implementation

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        if (nil == self.shopViewController) {
            self.shopViewController = [[IShopViewController alloc] init];
        }
        self.shopViewController.merchInfo = [[NSDictionary alloc] initWithDictionary:self.merchInfo];
        [self.navigationController pushViewController:self.shopViewController animated:YES];
    }
    else {
        if (nil == self.termViewController) {
            self.termViewController = [[ITermViewController alloc] init];
        }
        [self.navigationController pushViewController:self.termViewController animated:YES];
    }
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
