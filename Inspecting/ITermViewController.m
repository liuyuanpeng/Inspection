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
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, rNav.origin.y + rNav.size.height, rScreen.size.width, rScreen.size.height - rNav.origin.y - rNav.size.height) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSDictionary *params = @{
                             @"staffcode": [iUser getInstance].staffcode,
                             @"instcode": [self.merchInfo objectForKey:@"instcode"],
                             @"merchcode": [self.merchInfo objectForKey:@"merchcode"],
                             @"batchcode": [self.merchInfo objectForKey:@"batchcode"],
                             @"shopcode": self.shopInfo == nil ? @"" : [self.shopInfo objectForKey:@"shopcode"],
                             @"state":@""
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
    if (!self.termDetailViewController) {
        self.termDetailViewController = [[ITermDetailViewController alloc] init];
    }
    self.termDetailViewController.merchInfo = [[NSDictionary alloc] initWithDictionary:self.merchInfo];
    self.termDetailViewController.termInfo = [[NSDictionary alloc] initWithDictionary:[self.termArray objectAtIndex:indexPath.row]];
    [self.termDetailViewController setNeedupdate:YES];
    [self.navigationController pushViewController:self.termDetailViewController animated:YES];
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
