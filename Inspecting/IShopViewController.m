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

@interface IShopViewController ()

@end

@implementation IShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:236.0/255.0 alpha:1.0];
    CGRect rScreen = [[UIScreen mainScreen] bounds];
    CGRect rNav = self.navigationController.navigationBar.frame;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,  rScreen.size.width, 30)];
    titleLabel.text = @"门店列表";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLabel;
    
    UIButton *addshopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addshopBtn.frame = CGRectMake(0, 0, 24, 24);
    [addshopBtn setBackgroundImage:[UIImage imageNamed:@"i_add.png"] forState:UIControlStateNormal];
    [addshopBtn addTarget:self action:@selector(addShop:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:addshopBtn];
    self.navigationItem.rightBarButtonItem = barItem;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

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
                             @"state":@""
                             };
    [AFNRequestManager requestAFURL:@"getShopList.json" httpMethod:METHOD_POST params:params succeed:^(NSDictionary *ret) {
        if (0 == [[ret objectForKey:@"status"] integerValue]) {
            if (self.shopArray == nil) {
                self.shopArray = [[NSMutableArray alloc] init];
            }
            [self.shopArray removeAllObjects];
            [self.shopArray addObjectsFromArray:[ret objectForKey:@"detail"]];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (IBAction)addShop:(id)sender {
    if (nil == self.addShopViewController) {
        self.addShopViewController = [[INewShopViewController alloc] init];
    }
    self.addShopViewController.merchInfo = [[NSDictionary alloc] initWithDictionary:self.merchInfo];
    [self.navigationController pushViewController:self.addShopViewController animated:YES];
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
    return 150.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.shopDetailViewController) {
        self.shopDetailViewController = [[IShopDetailViewController alloc] init];
    }
    self.shopDetailViewController.merchInfo = [[NSDictionary alloc] initWithDictionary:self.merchInfo];
    self.shopDetailViewController.shopInfo = [[NSDictionary alloc] initWithDictionary:[self.shopArray objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:self.shopDetailViewController animated:YES];
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
