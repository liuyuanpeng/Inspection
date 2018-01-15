//
//  IShopViewController.m
//  Inspecting
//
//  Created by liuyuanpeng on 2017/3/4.
//  Copyright © 2017年 default. All rights reserved.
//

#import "IShopViewController.h"
#import "IShopTableViewCell.h"
#import "IShopDetailViewController.h"
#import "iUser.h"
#import "AFNRequestManager.h"
#import "INewShopViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MHProgress.h"

@interface IShopViewController ()

@end

@implementation IShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:236.0/255.0 alpha:1.0];
    CGRect rScreen = [[UIScreen mainScreen] bounds];
    CGRect rNav = self.navigationController.navigationBar.frame;
    
    UIBarButtonItem *buttonSearch = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(onSearch:)];
    [buttonSearch setTintColor:[UIColor whiteColor]];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addShop:)];
    [barItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItems = @[buttonSearch, barItem];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    self.searchView = [[UIView alloc] initWithFrame:CGRectMake(0, rNav.origin.y + rNav.size.height, rNav.size.width, 90)];
    self.searchView.backgroundColor = [UIColor clearColor];
    [self.searchView setHidden:YES];
    [self.view addSubview:self.searchView];
    self.keywordText = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, rNav.size.width - 20, 25)];
    [self.keywordText setBorderStyle:UITextBorderStyleRoundedRect];
    [self.keywordText setPlaceholder:@"请输入关键字"];
    [self.searchView addSubview:self.keywordText];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    searchBtn.frame = CGRectMake(rScreen.size.width/2 - 100, 55, 90, 25);
    [searchBtn setBackgroundColor:[UIColor colorWithRed:233/255.0 green:63/255.0 blue:51/255.0 alpha:1.0]];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [searchBtn.layer setCornerRadius:2.0f];
    [searchBtn.layer setMasksToBounds:YES];
    [searchBtn addTarget:self action:@selector(onSearchAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.searchView addSubview:searchBtn];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelBtn.frame = CGRectMake(rScreen.size.width/2 + 10, 55, 90, 25);
    [cancelBtn setBackgroundColor:[UIColor colorWithRed:60/255.0 green:179/255.0 blue:113/255.0 alpha:1.0]];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn.layer setCornerRadius:2.0f];
    [cancelBtn.layer setMasksToBounds:YES];
    [cancelBtn addTarget:self action:@selector(onCancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.searchView addSubview:cancelBtn];

    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,  rScreen.size.width, 30)];
    titleLabel.text = @"门店列表";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLabel;

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, rNav.origin.y + rNav.size.height, rScreen.size.width, rScreen.size.height - rNav.origin.y - rNav.size.height) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.tableView];
    NSMutableArray *imageArray = [[NSMutableArray alloc] initWithCapacity:12];
    for (int i = 1; i <= 12; i++) {
        [imageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"loading%d", i]]];
    }
    self.loadingImage = [UIImage animatedImageWithImages:imageArray duration:10.f];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSDictionary *params = @{
                             @"staffcode": [iUser getInstance].staffcode,
                             @"instcode": [self.merchInfo objectForKey:@"instcode"],
                             @"merchcode": [self.merchInfo objectForKey:@"merchcode"],
                             @"batchcode": [self.merchInfo objectForKey:@"batchcode"],
                             @"state":@"",
                             @"keyword": self.keywordText.text
                             };
    [[MHProgress getSeachInstance] showLoadingView];
    [AFNRequestManager requestAFURL:@"getShopList.json" httpMethod:METHOD_POST params:params succeed:^(NSDictionary *ret) {
        if (0 == [[ret objectForKey:@"status"] integerValue]) {
            if (self.shopArray == nil) {
                self.shopArray = [[NSMutableArray alloc] init];
            }
            [self.shopArray removeAllObjects];
            [self.shopArray addObjectsFromArray:[ret objectForKey:@"detail"]];
            [self.tableView reloadData];
        }
        [[MHProgress getSeachInstance] closeLoadingView];
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
        [[MHProgress getSeachInstance] closeLoadingView];
    }];
    
}

- (IBAction)addShop:(id)sender {
    INewShopViewController *addShopViewController = [[INewShopViewController alloc] init];
    addShopViewController.merchInfo = [[NSDictionary alloc] initWithDictionary:self.merchInfo];
    [self.navigationController pushViewController:addShopViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (BOOL)hideSeachView:(BOOL)bHide {
    if (self.searchView.isHidden == bHide) {
        return NO;
    }
    CGRect rTable = self.tableView.frame;
    if (bHide) {
        rTable.size.height += 90;
        rTable.origin.y -= 90;
        [self.keywordText resignFirstResponder];
    }
    else {
        rTable.size.height -= 90;
        rTable.origin.y += 90;
        [self.keywordText becomeFirstResponder];
    }
    
    self.tableView.frame = rTable;
    [self.searchView setHidden:bHide];
    return YES;
}


- (IBAction)onSearch:(id)sender {
    [self hideSeachView:NO];
}

-(IBAction)onCancelAction:(id)sender {
    [self hideSeachView:YES];
}

-(IBAction)onSearchAction:(id)sender {
    NSDictionary *params = @{
                             @"staffcode": [iUser getInstance].staffcode,
                             @"instcode": [self.merchInfo objectForKey:@"instcode"],
                             @"merchcode": [self.merchInfo objectForKey:@"merchcode"],
                             @"batchcode": [self.merchInfo objectForKey:@"batchcode"],
                             @"state":@"",
                             @"keyword": self.keywordText.text
                             };
    [[MHProgress getSeachInstance] showLoadingView];
    [AFNRequestManager requestAFURL:@"getShopList.json" httpMethod:METHOD_POST params:params succeed:^(NSDictionary *ret) {
        if (0 == [[ret objectForKey:@"status"] integerValue]) {
            if (self.shopArray == nil) {
                self.shopArray = [[NSMutableArray alloc] init];
            }
            [self hideSeachView:YES];
            [self.shopArray removeAllObjects];
            [self.shopArray addObjectsFromArray:[ret objectForKey:@"detail"]];
            [self.tableView reloadData];
        }
        [[MHProgress getSeachInstance] closeLoadingView];
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
        [[MHProgress getSeachInstance] closeLoadingView];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - UITableView Delegate Impletation

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    IShopDetailViewController *shopDetailViewController = [[IShopDetailViewController alloc] init];
    shopDetailViewController.merchInfo = [[NSDictionary alloc] initWithDictionary:self.merchInfo];
    shopDetailViewController.shopInfo = [[NSDictionary alloc] initWithDictionary:[self.shopArray objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:shopDetailViewController animated:YES];
}

#pragma mark - UITableView Datasource Impletation

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.shopArray == nil) {
        return 0L;
    }
    return self.shopArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IShopTableViewCell *cell = [IShopTableViewCell cellWithTableView:tableView];
    NSDictionary *dict = [self.shopArray objectAtIndex:indexPath.row];
    [cell setMissionNO:[dict objectForKey:@"batchcode"] floatNO:[dict objectForKey:@"serialnbr"]];
    [cell setShop:[dict objectForKey:@"shopname"] code:[dict objectForKey:@"shopcode"] merch:[self.merchInfo objectForKey:@"merchname"] inst:[self.merchInfo objectForKey:@"instname"]];
    [cell setAddr:[dict objectForKey:@"addr"]];
    if ([@"001" isEqualToString:[dict objectForKey:@"state"]]) {
        [cell setFinished:NO];
    }
    else {
        [cell setFinished:YES];
    }
    if (![@"" isEqualToString: [dict objectForKey:@"pic"]]) {
        [cell.shopImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMG_URL, [dict objectForKey:@"pic"]]] placeholderImage:self.loadingImage];
    }
    return cell;
}

@end
