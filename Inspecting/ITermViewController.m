//
//  ITermViewController.m
//  Inspecting
//
//  Created by liuyuanpeng on 2017/3/4.
//  Copyright © 2017年 default. All rights reserved.
//

#import "ITermViewController.h"
#import "ITermDetailViewController.h"
#import "ITermTableViewCell.h"
#import "iUser.h"
#import "AFNRequestManager.h"

@interface ITermViewController ()

@end

@implementation ITermViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:236.0/255.0 alpha:1.0];
    CGRect rScreen = [[UIScreen mainScreen] bounds];
    CGRect rNav = self.navigationController.navigationBar.frame;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,  rScreen.size.width, 30)];
    titleLabel.text = @"终端列表";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLabel;
    
    UIBarButtonItem *buttonSearch = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(onSearch:)];
    [buttonSearch setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = buttonSearch;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
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
    

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, rNav.origin.y + rNav.size.height, rScreen.size.width, rScreen.size.height - rNav.origin.y - rNav.size.height) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.tableView];
}

- (BOOL)hideSeachView:(BOOL)bHide {
    if (self.searchView.isHidden == bHide) {
        return NO;
    }
    CGRect rTable = self.tableView.frame;
    if (bHide) {
        rTable.size.height += 90;
        rTable.origin.y -= 90;
    }
    else {
        rTable.size.height -= 90;
        rTable.origin.y += 90;
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
                             @"shopcode": self.shopInfo == nil ? @"" : [self.shopInfo objectForKey:@"shopcode"],
                             @"state":@"",
                             @"keyword": self.keywordText.text
                             };
    [AFNRequestManager requestAFURL:@"getTermList.json" httpMethod:METHOD_POST params:params succeed:^(NSDictionary *ret) {
        if (0 == [[ret objectForKey:@"status"] integerValue]) {
            if (self.termArray == nil) {
                self.termArray = [[NSMutableArray alloc] init];
            }
            [self hideSeachView:YES];
            [self.termArray removeAllObjects];
            [self.termArray addObjectsFromArray:[ret objectForKey:@"detail"]];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSDictionary *params = @{
                             @"staffcode": [iUser getInstance].staffcode,
                             @"instcode": [self.merchInfo objectForKey:@"instcode"],
                             @"merchcode": [self.merchInfo objectForKey:@"merchcode"],
                             @"batchcode": [self.merchInfo objectForKey:@"batchcode"],
                             @"shopcode": self.shopInfo == nil ? @"" : [self.shopInfo objectForKey:@"shopcode"],
                             @"state":@"",
                             @"keyword": self.keywordText.text
                             };
    [AFNRequestManager requestAFURL:@"getTermList.json" httpMethod:METHOD_POST params:params succeed:^(NSDictionary *ret) {
        if (0 == [[ret objectForKey:@"status"] integerValue]) {
            if (self.termArray == nil) {
                self.termArray = [[NSMutableArray alloc] init];
            }
            [self.termArray removeAllObjects];
            [self.termArray addObjectsFromArray:[ret objectForKey:@"detail"]];
            [self.tableView reloadData];
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


#pragma mark - UITableView Delegate Impletation

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 180.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ITermDetailViewController *termDetailViewController = [[ITermDetailViewController alloc] init];
    termDetailViewController.merchInfo = [[NSDictionary alloc] initWithDictionary:self.merchInfo];
    termDetailViewController.termInfo = [[NSDictionary alloc] initWithDictionary:[self.termArray objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:termDetailViewController animated:YES];
}

#pragma mark - UITableView Datasource Impletation

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.termArray == nil) {
        return 0L;
    }
    return self.termArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ITermTableViewCell *cell = [ITermTableViewCell cellWithTableView:tableView];
    NSDictionary *dict = [self.termArray objectAtIndex:indexPath.row];
    [cell setBatchcode:[dict objectForKey:@"batchcode"] serialnbr:[dict objectForKey:@"serialnbr"]];
    [cell setShop:[dict objectForKey:@"shopname"] termcode:[dict objectForKey:@"termcode"] merchname:[self.merchInfo objectForKey:@"merchname"] instname:[self.merchInfo objectForKey:@"instname"] termname:[dict objectForKey:@"termname"] termtype:[dict objectForKey:@"termtypedesc"] termmodel:[dict objectForKey:@"termmode"]];
    if ([@"001" isEqualToString:[dict objectForKey:@"state"]]) {
        [cell setFinished:NO];
    }
    else {
        [cell setFinished:YES];
    }
    return cell;
}

@end
