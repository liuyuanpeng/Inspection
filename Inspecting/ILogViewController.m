//
//  ILogViewController.m
//  Inspecting
//
//  Created by liuyuanpeng on 2017/3/4.
//  Copyright © 2017年 default. All rights reserved.
//

#import "ILogViewController.h"
#import "ILogTableViewCell.h"
#import "iUser.h"
#import "AFNRequestManager.h"
#import <Toast/UIView+Toast.h>

@interface ILogViewController ()

@end

@implementation ILogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:236.0/255.0 alpha:1.0];
    CGRect rScreen = [[UIScreen mainScreen] bounds];
    CGRect rNav = self.navigationController.navigationBar.frame;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,  rScreen.size.width, 30)];
    titleLabel.text = @"变更日志";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLabel;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, rNav.origin.y + rNav.size.height, rScreen.size.width, rScreen.size.height - rNav.origin.y - rNav.size.height) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.termInfo != nil) {
        NSDictionary *params = @{
                                 @"staffcode": [iUser getInstance].staffcode,
                                 @"instcode": [self.merchInfo objectForKey:@"instcode"],
                                 @"merchcode": [self.merchInfo objectForKey:@"merchcode"],
                                 @"batchcode": [self.merchInfo objectForKey:@"batchcode"],
                                 @"shopcode": self.shopInfo ? [self.shopInfo objectForKey:@"shopcode"] : [self.termInfo objectForKey:@"shopcode"],
                                 @"termcode": [self.termInfo objectForKey:@"termcode"]
                                 };
        [AFNRequestManager requestAFURL:@"inspTermLog.json" httpMethod:METHOD_POST params:params succeed:^(NSDictionary *ret) {
            if (0 == [[ret objectForKey:@"status"] integerValue]) {
                NSDictionary *datas = [ret valueForKey:@"datas"];
                self.logTime = [NSString stringWithFormat:@"巡检时间:%@", [datas objectForKey:@"insptime"]];
                if (self.logInfo == nil) {
                    self.logInfo = [[NSMutableArray alloc] init];
                }
                [self.logInfo removeAllObjects];
                if (![[datas objectForKey:@"stermname"] isEqualToString:[datas objectForKey:@"ttermname"]]) {
                    [self.logInfo addObject:@{
                                              @"title": @"终端序列",
                                              @"old": [datas objectForKey:@"stermname"],
                                              @"cur": [datas objectForKey:@"ttermname"]
                                              }];
                }
                if (![[datas objectForKey:@"stermmode"] isEqualToString:[datas objectForKey:@"ttermmode"]]) {
                    [self.logInfo addObject:@{
                                              @"title": @"终端型号",
                                              @"old": [datas objectForKey:@"stermmode"],
                                              @"cur": [datas objectForKey:@"ttermmode"]
                                              }];
                }
                if (![[datas objectForKey:@"stermband"] isEqualToString:[datas objectForKey:@"ttermband"]]) {
                    [self.logInfo addObject:@{
                                              @"title": @"终端品牌",
                                              @"old": [datas objectForKey:@"stermband"],
                                              @"cur": [datas objectForKey:@"ttermband"]
                                              }];
                }
                if (![[datas objectForKey:@"stermtypedesc"] isEqualToString:[datas objectForKey:@"ttermtypedesc"]]) {
                    [self.logInfo addObject:@{
                                              @"title": @"终端类型",
                                              @"old": [datas objectForKey:@"stermtypedesc"],
                                              @"cur": [datas objectForKey:@"ttermtypedesc"]
                                              }];
                }
                [self.tableView reloadData];
            }
            else {
                [self.view makeToast:[ret objectForKey:@"desc"]];
            }
        } failure:^(NSError *error) {
            NSLog(@"%@", error);
        }];
        
    }
    else if (self.shopInfo != nil) {
        NSDictionary *params = @{
                                 @"staffcode": [iUser getInstance].staffcode,
                                 @"instcode": [self.merchInfo objectForKey:@"instcode"],
                                 @"merchcode": [self.merchInfo objectForKey:@"merchcode"],
                                 @"batchcode": [self.merchInfo objectForKey:@"batchcode"],
                                 @"shopcode": [self.shopInfo objectForKey:@"shopcode"]
                                 };
        [AFNRequestManager requestAFURL:@"inspShopLog.json" httpMethod:METHOD_POST params:params succeed:^(NSDictionary *ret) {
            if (0 == [[ret objectForKey:@"status"] integerValue]) {
                NSDictionary *datas = [ret valueForKey:@"datas"];
                self.logTime = [NSString stringWithFormat:@"巡检时间:%@", [datas objectForKey:@"insptime"]];
                if (self.logInfo == nil) {
                    self.logInfo = [[NSMutableArray alloc] init];
                }
                [self.logInfo removeAllObjects];
                if (![[datas objectForKey:@"sshopename"] isEqualToString:[datas objectForKey:@"tshopname"]]) {
                    [self.logInfo addObject:@{
                                              @"title": @"门店名称",
                                              @"old": [datas objectForKey:@"sshopname"],
                                              @"cur": [datas objectForKey:@"tshopname"]
                                              }];
                }
                if (![[datas objectForKey:@"saddress"] isEqualToString:[datas objectForKey:@"taddress"]]) {
                    [self.logInfo addObject:@{
                                              @"title": @"门店地址",
                                              @"old": [datas objectForKey:@"saddress"],
                                              @"cur": [datas objectForKey:@"taddress"]
                                              }];
                }
                if (![[datas objectForKey:@"speople"] isEqualToString:[datas objectForKey:@"tpeople"]]) {
                    [self.logInfo addObject:@{
                                              @"title": @"姓名",
                                              @"old": [datas objectForKey:@"speople"],
                                              @"cur": [datas objectForKey:@"tpeople"]
                                              }];
                }
                if (![[datas objectForKey:@"stel"] isEqualToString:[datas objectForKey:@"ttel"]]) {
                    [self.logInfo addObject:@{
                                              @"title": @"电话",
                                              @"old": [datas objectForKey:@"stel"],
                                              @"cur": [datas objectForKey:@"ttel"]
                                              }];
                }
                if (![[datas objectForKey:@"semail"] isEqualToString:[datas objectForKey:@"temail"]]) {
                    [self.logInfo addObject:@{
                                              @"title": @"邮箱",
                                              @"old": [datas objectForKey:@"semail"],
                                              @"cur": [datas objectForKey:@"temail"]
                                              }];
                }
                [self.tableView reloadData];
            }
            else {
                [self.view makeToast:[ret objectForKey:@"desc"]];
            }
        } failure:^(NSError *error) {
            NSLog(@"%@", error);
        }];
    }
    else {
        NSDictionary *params = @{
                                 @"staffcode": [iUser getInstance].staffcode,
                                 @"instcode": [self.merchInfo objectForKey:@"instcode"],
                                 @"merchcode": [self.merchInfo objectForKey:@"merchcode"],
                                 @"batchcode": [self.merchInfo objectForKey:@"batchcode"]
                                 };
        [AFNRequestManager requestAFURL:@"inspMerchLog.json" httpMethod:METHOD_POST params:params succeed:^(NSDictionary *ret) {
            if (0 == [[ret objectForKey:@"status"] integerValue]) {
                NSDictionary *datas = [ret valueForKey:@"datas"];
                self.logTime = [NSString stringWithFormat:@"巡检时间:%@", [datas objectForKey:@"insptime"]];
                if (self.logInfo == nil) {
                    self.logInfo = [[NSMutableArray alloc] init];
                }
                [self.logInfo removeAllObjects];
                if (![[datas objectForKey:@"smerchname"] isEqualToString:[datas objectForKey:@"tmerchname"]]) {
                    [self.logInfo addObject:@{
                                              @"title": @"商户名称",
                                              @"old": [datas objectForKey:@"smerchname"],
                                              @"cur": [datas objectForKey:@"tmerchname"]
                                              }];
                }
                if (![[datas objectForKey:@"saddress"] isEqualToString:[datas objectForKey:@"taddress"]]) {
                    [self.logInfo addObject:@{
                                              @"title": @"商户地址",
                                              @"old": [datas objectForKey:@"saddress"],
                                              @"cur": [datas objectForKey:@"taddress"]
                                              }];
                }
                if (![[datas objectForKey:@"smcc"] isEqualToString:[datas objectForKey:@"tmcc"]]) {
                    [self.logInfo addObject:@{
                                              @"title": @"商户类型",
                                              @"old": [datas objectForKey:@"smcc"],
                                              @"cur": [datas objectForKey:@"tmcc"]
                                              }];
                }
                [self.tableView reloadData];
            }
            else {
                [self.view makeToast:[ret objectForKey:@"desc"]];
            }
        } failure:^(NSError *error) {
            NSLog(@"%@", error);
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

#pragma mark - UITableViewDataSource Implementation


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.logInfo == nil) {
        return 0;
    }
    else {
        return 1L;
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.logInfo == nil) {
        return 0;
    }
    else {
        return self.logInfo.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ILogTableViewCell *cell = [ILogTableViewCell cellWithTableView:tableView];
    NSDictionary *dict = [self.logInfo objectAtIndex:indexPath.row];
    [cell setLogType:[dict objectForKey:@"title"] logOld:[dict objectForKey:@"old"] logCur:[dict objectForKey:@"cur"]];
    return cell;
}

#pragma mark - UITableViewDelegate Implementation


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 65.0f;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 23.0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGRect rScreen = [[UIScreen mainScreen] bounds];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rScreen.size.width, 23)];
    UILabel *labelTime = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, rScreen.size.width, 20)];
    [labelTime setBackgroundColor:[UIColor whiteColor]];
    [labelTime setTextAlignment:NSTextAlignmentCenter];
    labelTime.font = [UIFont systemFontOfSize:13.0f];
    [headerView addSubview:labelTime];
    
    labelTime.text = self.logTime;
    return headerView;
    
}
@end
