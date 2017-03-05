//
//  IShopDetailViewController.m
//  Inspecting
//
//  Created by liuyuanpeng on 2017/3/5.
//  Copyright © 2017年 default. All rights reserved.
//

#import "IShopDetailViewController.h"
#import "ITextView.h"
#import "ILogViewController.h"
#import "ITermDetailViewController.h"
#import "INewTermViewController.h"
#import <RadioButton/RadioButton.h>
#import "iUser.h"
#import "AFNRequestManager.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface IShopDetailViewController ()

@end

@implementation IShopDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0]];
    CGRect rScreen = [[UIScreen mainScreen] bounds];
    CGRect rNav = self.navigationController.navigationBar.frame;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, rNav.origin.y + rNav.size.height, rScreen.size.width, rScreen.size.height - rNav.origin.y - rNav.size.height - self.tabBarController.tabBar.frame.size.height)];
    [self.view addSubview:self.scrollView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,  rScreen.size.width, 30)];
    titleLabel.text = @"门店详情";
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
    
    UILabel *baseinfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5 - rNav.origin.y - rNav.size.height, 100, 25)];
    baseinfoLabel.font = [UIFont systemFontOfSize:13];
    baseinfoLabel.text = @"基本信息";
    [self.scrollView addSubview:baseinfoLabel];
    
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [editBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    editBtn.frame = CGRectMake(rScreen.size.width - 50, 5 - rNav.origin.y - rNav.size.height, 40, 20);
    [editBtn addTarget:self action:@selector(onEdit:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:editBtn];
    
    UIView *baseInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 35 - rNav.origin.y - rNav.size.height, rScreen.size.width, 130)];
    [baseInfoView setBackgroundColor:[UIColor whiteColor]];
    [self.scrollView addSubview:baseInfoView];
    
    self.shopImg = [[UIImageView alloc] initWithFrame:CGRectMake(5, 15, 70, 70)];
    [self.shopImg.layer setCornerRadius:2.0f];
    [self.shopImg.layer setMasksToBounds:YES];
    self.shopImg.image = [UIImage imageNamed:@"i_store.png"];
    [baseInfoView addSubview:self.shopImg];
    
    UILabel *shop = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 55, 20)];
    shop.textColor = [UIColor darkGrayColor];
    shop.font = [UIFont systemFontOfSize:12.0f];
    shop.text = @"门店名称:";
    [baseInfoView addSubview:shop];
    
    self.shopName = [[UITextField alloc] initWithFrame:CGRectMake(135, 10, rScreen.size.width - 145, 20)];
    self.shopName.textColor = [UIColor darkGrayColor];
    self.shopName.font = [UIFont systemFontOfSize:12.0f];
    [self.shopName setBorderStyle:UITextBorderStyleNone];
    self.shopName.delegate = self;
    self.shopName.text = @"dfjdk";
    [baseInfoView addSubview:self.shopName];
    
    self.shopCode = [[UILabel alloc] initWithFrame:CGRectMake(80, 30, rScreen.size.width - 90, 20)];
    self.shopCode.textColor = [UIColor darkGrayColor];
    self.shopCode.font = [UIFont systemFontOfSize:12.0f];
    self.shopCode.text = @"门店编码:";
    [baseInfoView addSubview:self.shopCode];
    
    self.merchName = [[UILabel alloc] initWithFrame:CGRectMake(80, 50, rScreen.size.width - 90, 20)];
    self.merchName.textColor = [UIColor darkGrayColor];
    self.merchName.font = [UIFont systemFontOfSize:12.0f];
    self.merchName.text = @"商户名称:";
    [baseInfoView addSubview:self.merchName];
    
    self.instName = [[UILabel alloc] initWithFrame:CGRectMake(80, 70, rScreen.size.width - 90, 20)];
    self.instName.textColor = [UIColor darkGrayColor];
    self.instName.font = [UIFont systemFontOfSize:12.0f];
    self.instName.text  = @"机构名称:";
    [baseInfoView addSubview:self.instName];
    
    UIImageView *localImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 100, 20, 20)];
    localImageView.image = [UIImage imageNamed:@"i_location.png"];
    [baseInfoView addSubview:localImageView];
    
    self.addr = [[UITextField alloc] initWithFrame:CGRectMake(40, 95, rScreen.size.width - 50, 30)];
    [self.addr setBorderStyle:UITextBorderStyleNone];
    self.addr.font = [UIFont systemFontOfSize:12.0f];
    self.addr.delegate = self;
    [baseInfoView addSubview:self.addr];
    
    UILabel *contactorInfo = [[UILabel alloc] initWithFrame:CGRectMake(5, baseInfoView.frame.origin.y + baseInfoView.frame.size.height + 5, 100, 25)];
    contactorInfo.font = [UIFont systemFontOfSize:13];
    contactorInfo.text = @"联系人信息";
    [self.scrollView addSubview:contactorInfo];
    
    UIView *contactorInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, contactorInfo.frame.origin.y + contactorInfo.frame.size.height + 5, rScreen.size.width, 90)];
    contactorInfoView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:contactorInfoView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 30, 20)];
    nameLabel.font = [UIFont systemFontOfSize:12.0f];
    nameLabel.text = @"姓名";
    [contactorInfoView addSubview:nameLabel];
    
    self.nameTextView = [[ITextView alloc] initWithFrame:CGRectMake(35, 10, rScreen.size.width - 40, 20)];
    self.nameTextView.font = [UIFont systemFontOfSize:12.0];
    self.nameTextView.textColor = [UIColor darkGrayColor];
    self.nameTextView.textAlignment = NSTextAlignmentRight;
    self.nameTextView.delegate = self;
    [contactorInfoView addSubview:self.nameTextView];
    
    UILabel *telLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 35, 30, 20)];
    telLabel.font = [UIFont systemFontOfSize:12.0f];
    telLabel.text = @"电话";
    [contactorInfoView addSubview:telLabel];
    
    self.telTextView = [[ITextView alloc] initWithFrame:CGRectMake(35, 10, rScreen.size.width - 40, 20)];
    self.telTextView.font = [UIFont systemFontOfSize:12.0];
    self.telTextView.textColor = [UIColor darkGrayColor];
    self.telTextView.textAlignment = NSTextAlignmentRight;
    self.telTextView.delegate = self;
    [contactorInfoView addSubview:self.telTextView];

    
    UILabel *mailLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 65, 30, 20)];
    mailLabel.font = [UIFont systemFontOfSize:12.0f];
    mailLabel.text = @"邮箱";
    [contactorInfoView addSubview:mailLabel];
    
    self.mailTextView = [[ITextView alloc] initWithFrame:CGRectMake(35, 10, rScreen.size.width - 40, 20)];
    self.mailTextView.font = [UIFont systemFontOfSize:12.0];
    self.mailTextView.textColor = [UIColor darkGrayColor];
    self.mailTextView.textAlignment = NSTextAlignmentRight;
    self.mailTextView.delegate = self;
    [contactorInfoView addSubview:self.mailTextView];

    
    UIView *split1 = [[UIView alloc] initWithFrame:CGRectMake(5, 30, rScreen.size.width - 10, 1)];
    split1.backgroundColor = [UIColor lightGrayColor];
    [contactorInfoView addSubview:split1];
    
    UIView *split2 = [[UIView alloc] initWithFrame:CGRectMake(5, 60, rScreen.size.width - 10, 1)];
    split2.backgroundColor = [UIColor lightGrayColor];
    [contactorInfoView addSubview:split2];
    
    UILabel *termLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, contactorInfoView.frame.origin.y + contactorInfoView.frame.size.height + 5, 100, 25)];
    termLabel.text = @"本店终端";
    termLabel.font = [UIFont systemFontOfSize:13];
    [self.scrollView addSubview:termLabel];
    
    UIButton *addTermBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [addTermBtn setTitle:@"新增" forState:UIControlStateNormal];
    [addTermBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    addTermBtn.frame = CGRectMake(rScreen.size.width - 50, termLabel.frame.origin.y, 40, 20);
    [addTermBtn addTarget:self action:@selector(addTerm:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:addTermBtn];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, termLabel.frame.origin.y + termLabel.frame.size.height + 5, rScreen.size.width, 0) style:UITableViewStylePlain];
    [self.scrollView addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.bEdit = false;
    
    UILabel *resultLabel = self.resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, self.tableView.frame.origin.y + self.tableView.frame.size.height + 5, 100, 25)];
    resultLabel.text = @"巡检结果";
    resultLabel.font = [UIFont systemFontOfSize:13];
    [self.scrollView addSubview:resultLabel];
    
    UIView *resultView = self.resultView = [[UIView alloc] initWithFrame:CGRectMake(0, resultLabel.frame.origin.y + 30, rScreen.size.width, 180)];
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
    
    self.licencePic = [[UIImageView alloc] initWithFrame: CGRectMake(40, 120, 50, 50)];
    self.licencePic.image = [UIImage imageNamed:@"i_add_yyzz.png"];
    self.licencePic.tag = 0;
    self.licencePic.userInteractionEnabled = YES;
    [self.licencePic addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSelectPic:)]];
    [resultView addSubview:self.licencePic];
    
    self.facadePic = [[UIImageView alloc] initWithFrame: CGRectMake(100, 120, 50, 50)];
    self.facadePic.image = [UIImage imageNamed:@"i_add_mmzp.png"];
    self.facadePic.tag = 0;
    self.facadePic.userInteractionEnabled = YES;
    [self.facadePic addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSelectPic:)]];
    [resultView addSubview:self.facadePic];
    
    self.signPic = [[UIImageView alloc] initWithFrame: CGRectMake(160, 120, 50, 50)];
    self.signPic.image = [UIImage imageNamed:@"i_add_zp.png"];
    self.signPic.tag = 0;
    self.signPic.userInteractionEnabled = YES;
    [self.signPic addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSelectPic:)]];
    [resultView addSubview:self.signPic];
    
    self.sitePic = [[UIImageView alloc] initWithFrame: CGRectMake(220, 120, 50, 50)];
    self.sitePic.image = [UIImage imageNamed:@"i_add_jycs.png"];
    self.sitePic.tag = 0;
    self.sitePic.userInteractionEnabled = YES;
    [self.sitePic addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSelectPic:)]];
    [resultView addSubview:self.sitePic];
    
    UIButton *commitBtn = self.commitBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
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

- (void)resizeView:(NSInteger) count {
    static NSInteger termcount = 0;
    if (termcount != count) {
        termcount = count;
        CGRect rTable = self.tableView.frame;
        rTable.size.height = 30*count;
        [self.tableView setFrame:rTable];
        
        [self.resultLabel setFrame:CGRectMake(5, self.tableView.frame.origin.y + self.tableView.frame.size.height + 5, 100, 25)];
        [self.resultView setFrame:CGRectMake(0, self.resultLabel.frame.origin.y + 30, rTable.size.width, 180)];
        [self.commitBtn setFrame:CGRectMake(rTable.size.width/2 - 50, self.resultView.frame.origin.y + self.resultView.frame.size.height + 10, 100, 30)];
        self.scrollView.contentSize = CGSizeMake(rTable.size.width, self.commitBtn.frame.origin.y + self.commitBtn.frame.size.height);
        
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSDictionary *params = @{
                             @"staffcode": [iUser getInstance].staffcode,
                             @"instcode": [self.shopInfo objectForKey:@"instcode"],
                             @"merchcode": [self.merchInfo objectForKey:@"merchcode"],
                             @"batchcode": [self.merchInfo objectForKey:@"batchcode"],
                             @"shopcode": [self.shopInfo objectForKey:@"shopcode"]
                             };
    [AFNRequestManager requestAFURL:@"getShopInfo.json" httpMethod:METHOD_POST params:params succeed:^(NSDictionary *ret) {
        if (0 == [[ret objectForKey:@"status"] integerValue]) {
            self.shopDetail = [[NSDictionary alloc] initWithDictionary:[ret objectForKey:@"datas"]];
            [self.shopImg sd_setImageWithURL:[NSURL URLWithString:[self.shopDetail objectForKey:@"pic"]] placeholderImage:[UIImage imageNamed:@"i_store.png"]];
            self.shopName.text = [NSString stringWithString:[self.shopDetail objectForKey:@"shopname"]];
            self.shopCode.text = [NSString stringWithFormat:@"门店编码:%@",[self.shopDetail objectForKey:@"shopcode"]];
            self.merchName.text  =[NSString stringWithFormat:@"商户名称:%@", [self.merchInfo objectForKey:@"merchname"]];
            self.instName.text = [NSString stringWithFormat:@"机构名称:%@", [self.merchInfo objectForKey:@"instname"]];
            self.addr.text = [NSString stringWithString:[self.shopDetail objectForKey:@"addr"]];
            self.nameTextView.text = [NSString stringWithString:[self.shopDetail objectForKey:@"people"]];
            self.telTextView.text = [NSString stringWithString:[self.shopDetail objectForKey:@"tel"]];
            self.mailTextView.text = [NSString stringWithString:[self.shopDetail objectForKey:@"email"]];
            NSArray *termArray = [[NSArray alloc] initWithArray:[self.shopDetail objectForKey:@"termlst"]];
            [self resizeView:termArray.count];
            [self.tableView reloadData];
            
            
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

- (IBAction)addTerm:(id)sender {
    if (nil == self.addTermViewController) {
        self.addTermViewController = [[INewTermViewController alloc] init];
    }
    [self.navigationController pushViewController:self.addTermViewController animated:YES];
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
        [self.addr becomeFirstResponder];
    }
    else if ([sender.currentTitle isEqualToString:@"保存"]) {
        self.bEdit = false;
        [sender setTitle:@"编辑" forState:UIControlStateNormal];
        [self.addr resignFirstResponder];
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return self.bEdit;
}

#pragma mark - UITextViewDelegate Implementation
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return self.bEdit;
}

#pragma mark - UITableViewDataSource implementation
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (nil == self.shopDetail) {
        return 0L;
    }
    return [[self.shopDetail objectForKey:@"termlst"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"iterminfocell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.imageView.image = [UIImage imageNamed:@"i_pos.png"];
        CGSize itemSize = CGSizeMake(20, 20);
        UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [cell.imageView.image drawInRect:imageRect];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    if (self.shopDetail != nil) {
        NSDictionary *dict = [[self.shopDetail objectForKey:@"termlst"] objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"编号: %@--%@", [dict objectForKey:@"termname"], [dict objectForKey:@"termcode"]];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate implementation

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.termDetailViewController == nil) {
        self.termDetailViewController = [[ITermDetailViewController alloc] init];
    }
    self.termDetailViewController.merchInfo = [[NSDictionary alloc] initWithDictionary:self.merchInfo];
    [self.navigationController pushViewController:self.termDetailViewController animated:YES];
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