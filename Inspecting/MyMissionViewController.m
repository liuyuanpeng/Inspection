//
//  MyMissionViewController.m
//  Inspecting
//
//  Created by liuyuanpeng on 2017/2/16.
//  Copyright © 2017年 default. All rights reserved.
//

#import "MyMissionViewController.h"
#import "IMyTableViewCell.h"
#import <RadioButton/RadioButton.h>
#import "iUser.h"
#import "AFNRequestManager.h"
#import "MerchInfoViewController.h"
#import "iMyTask.h"

@interface MyMissionViewController ()

@end

@implementation MyMissionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0];
    
    CGRect rScreen = [[UIScreen mainScreen] bounds];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,  rScreen.size.width, 30)];
    titleLabel.text = @"我的任务";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLabel;
    
    UIBarButtonItem *buttonSearch = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(onSearch:)];
    [buttonSearch setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = buttonSearch;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    CGRect rNav = self.navigationController.navigationBar.frame;
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, rNav.origin.y + rNav.size.height, rScreen.size.width, rScreen.size.height - rNav.origin.y - rNav.size.height - self.tabBarController.tabBar.frame.size.height) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableview setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.tableview];
    
    self.searchView = [[UIView alloc] initWithFrame:CGRectMake(0, rNav.origin.y + rNav.size.height, rNav.size.width, 130)];
    self.searchView.backgroundColor = [UIColor clearColor];
    [self.searchView setHidden:YES];
    [self.view addSubview:self.searchView];
    self.keywordText = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, rNav.size.width - 20, 25)];
    [self.keywordText setBorderStyle:UITextBorderStyleRoundedRect];
    [self.keywordText setPlaceholder:@"请输入关键字"];
    [self.searchView addSubview:self.keywordText];
    
    NSMutableArray *buttons = [NSMutableArray arrayWithCapacity:3];
    CGRect btnRect = CGRectMake(25, 45, 100, 30);
    for (NSString *optionTitle in @[@"已完成", @"未完成", @"全部"]) {
        RadioButton *btn = [[RadioButton alloc] initWithFrame:btnRect];
        btnRect.origin.x += 100;
        [btn setTitle:optionTitle forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [btn setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateSelected];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
        [self.searchView addSubview:btn];
        [buttons addObject:btn];
    }
    
    [buttons[0] setGroupButtons:buttons];
    [buttons[0] setSelected:YES];
    
    self.radioButtons = buttons[0];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    searchBtn.frame = CGRectMake(rScreen.size.width/2 - 100, 95, 90, 25);
    [searchBtn setBackgroundColor:[UIColor colorWithRed:233/255.0 green:63/255.0 blue:51/255.0 alpha:1.0]];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [searchBtn.layer setCornerRadius:2.0f];
    [searchBtn.layer setMasksToBounds:YES];
    [searchBtn addTarget:self action:@selector(onSearchAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.searchView addSubview:searchBtn];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelBtn.frame = CGRectMake(rScreen.size.width/2 + 10, 95, 90, 25);
    [cancelBtn setBackgroundColor:[UIColor colorWithRed:60/255.0 green:179/255.0 blue:113/255.0 alpha:1.0]];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn.layer setCornerRadius:2.0f];
    [cancelBtn.layer setMasksToBounds:YES];
    [cancelBtn addTarget:self action:@selector(onCancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.searchView addSubview:cancelBtn];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (![iMyTask getInstance].taskcode) {
        NSLog(@"Params error!");
        return;
    }
    NSDictionary *params = @{
                             @"staffcode": [iUser getInstance].staffcode,
                             @"batchcode": [iMyTask getInstance].taskcode,
                             @"state":@"",
                             @"keyword":@""
                             };
    [AFNRequestManager requestAFURL:@"getMyTaskList.json" httpMethod:METHOD_POST params:params succeed:^(NSDictionary *ret) {
        if (0 == [[ret objectForKey:@"status"] integerValue]) {
            self.myTaskArray = [[NSArray alloc] initWithArray:[ret objectForKey:@"detail"]];
            [self.tableview reloadData];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (BOOL)hideSeachView:(BOOL)bHide {
    if (self.searchView.isHidden == bHide) {
        return NO;
    }
    CGRect rTable = self.tableview.frame;
    if (bHide) {
        rTable.size.height += 130;
        rTable.origin.y -= 130;
    }
    else {
        rTable.size.height -= 130;
        rTable.origin.y += 130;
    }
    
    self.tableview.frame = rTable;
    [self.searchView setHidden:bHide];
    return YES;
}

- (IBAction)onSearch:(id)sender {
    if ([self hideSeachView:NO]) {
        
    }
}

- (IBAction)onSearchAction:(id)sender {
    NSDictionary *params = @{
                             @"staffcode": [iUser getInstance].staffcode,
                             @"batchcode": @"batchcode",
                             @"state": @"0",
                             @"keyword": self.keywordText.text
                             };
    [AFNRequestManager requestAFURL:@"getMyTaskList.json" httpMethod:METHOD_POST params:params succeed:^(NSDictionary *ret) {
        if (0 == [[ret objectForKey:@"status"] integerValue]) {
            
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
    [self hideSeachView:YES];
}

- (IBAction)onCancelAction:(id)sender {
    [self hideSeachView:YES];
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
    if (!self.merchInfoViewController) {
        self.merchInfoViewController = [[MerchInfoViewController alloc] init];
    }
    NSDictionary *merchInfo = [self.myTaskArray objectAtIndex:indexPath.row];
    self.merchInfoViewController.taskInfo = [[NSDictionary alloc] initWithDictionary:merchInfo];
    [self.merchInfoViewController setBNeedUpdate:YES];
    [self.navigationController pushViewController:self.merchInfoViewController animated:NO];
}

#pragma mark - UITableView Datasource Impletation

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.myTaskArray) {
        return self.myTaskArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = [self.myTaskArray objectAtIndex:indexPath.row];
    IMyTableViewCell *cell = [IMyTableViewCell cellWithTableView:tableView];
    [cell setMissionNO:[dict objectForKey:@"batchcode"] endtime:[dict objectForKey:@"enddate"]];
    [cell setName:[dict objectForKey:@"merchname"] typy:[dict objectForKey:@"mcc"] organ:[dict objectForKey:@"instname"]];
    [cell setAddr:[dict objectForKey:@"addr"]];
    [cell setFinished:[(NSString *)[dict objectForKey:@"state"] isEqualToString:@"001"] ? NO: YES];
    [cell setOrganImg:[NSString stringWithFormat:@"%@%@", IMG_URL, [dict objectForKey:@"pic"]]];
    return cell;
}

@end
