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
#import "IMission.h"
#import "IPubTaskDetailViewController.h"
#import "MerchInfoViewController.h"
#import "IPubTask.h"

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
    NSInteger btnTag = 1;
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
        btn.tag = btnTag++;
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
    
    self.myTaskArray = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldEditChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)showTabBar

{
    if (self.tabBarController.tabBar.hidden == NO)
    {
        return;
    }
    UIView *contentView;
    if ([[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]])
        
        contentView = [self.tabBarController.view.subviews objectAtIndex:1];
    
    else
        
        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
    contentView.frame = CGRectMake(contentView.bounds.origin.x, contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height - self.tabBarController.tabBar.frame.size.height);
    self.tabBarController.tabBar.hidden = NO;
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)filter004:(NSArray *)array{
    for (NSDictionary *dict in array) {
        if ([@"004" isEqualToString: [dict objectForKey:@"state"]]) {
            continue;
        }
        [self.myTaskArray addObject:dict];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showTabBar];
    if (![IMission getInstance].needupdate) {
        return;
    }
    [self getCurMission];
    [IMission getInstance].needupdate = NO;
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
    [self hideSeachView:NO];
}

- (IBAction)onSearchAction:(id)sender {
    NSString *state = @"";
    switch (self.radioButtons.selectedButton.tag) {
        case 1:
            state = @"002";
            break;
            
        case 2:
            state = @"001";
            break;
            
        default:
            break;
    }
    [self searchMissionWithState:state keyword:self.keywordText.text];
    
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
    
    NSDictionary *merchInfo = [self.myTaskArray objectAtIndex:indexPath.row];
    
    if (1 == [[merchInfo objectForKey:@"tasktype"] integerValue]) {
        MerchInfoViewController *merchInfoViewController = [[MerchInfoViewController alloc] init];
        merchInfoViewController.taskInfo = [[NSDictionary alloc] initWithDictionary:merchInfo];
        [self.navigationController pushViewController:merchInfoViewController animated:NO];
    }
    else {
        IPubTask *pubTask = [IPubTask shareInstance];
        NSDictionary *params = @{
                                 @"staffcode":[iUser getInstance].staffcode,
                                 @"batchcode":[merchInfo objectForKey:@"batchcode"],
                                 @"serialnbr": [merchInfo objectForKey:@"serialnbr"]
                                 };
        self.view.userInteractionEnabled = NO;
        [AFNRequestManager requestAFURL:@"getPubTaskInfo.json" httpMethod:METHOD_POST params:params succeed:^(NSDictionary *ret) {
            if (0 == [[ret objectForKey:@"status"] integerValue]) {
                pubTask.stepArray = [[NSArray alloc]initWithArray:[ret objectForKey:@"datas"]];
                pubTask.taskInfo = [[NSDictionary alloc] initWithDictionary:merchInfo];
                [pubTask.inspPubArray removeAllObjects];
                self.view.userInteractionEnabled = YES;
                if (pubTask.stepArray.count > 0) {
                    IPubTaskDetailViewController *pubTaskDetail = [[IPubTaskDetailViewController alloc] init];
                    [pubTaskDetail setStep:1];
                    [self.navigationController pushViewController:pubTaskDetail animated:YES];
                }
            }
        } failure:^(NSError *error) {
            self.view.userInteractionEnabled = YES;
        }];
        
    }
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

#pragma mark - getallmissions
- (void) getMission {
    if ([IMission getInstance].curSel == -1) {
        [self getAllMission];
    }
    else {
        [self getCurMission];
    }
}
- (void)getAllMission {
    [self.myTaskArray removeAllObjects];
    [self requestMission:0 recursive:YES];
}

- (void)getCurMission {
    [self.myTaskArray removeAllObjects];
    [self requestMission:[IMission getInstance].curSel recursive:NO];
}

- (void)requestMission:(NSInteger)index recursive:(BOOL)bRecursive{
    if (index >= [IMission getInstance].missions.count) {
        if (bRecursive) {
            [self.tableview reloadData];
        }
        return;
    }
    NSDictionary *taskInfo = [[IMission getInstance].missions objectAtIndex:index];
    NSDictionary *params = @{
                             @"staffcode": [iUser getInstance].staffcode,
                             @"batchcode": [taskInfo objectForKey:@"taskcode"],
                             @"state":@"",
                             @"keyword":@""
                             };
    index++;
    [AFNRequestManager requestAFURL:@"getMyTaskList.json" httpMethod:METHOD_POST params:params succeed:^(NSDictionary *ret) {
        if (0 == [[ret objectForKey:@"status"] integerValue]) {
            [self filter004:[ret objectForKey:@"detail"]];
            if (bRecursive) {
                [self requestMission:(index) recursive:YES];
            }
            else {
                [self.tableview reloadData];
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)searchMissionWithState:(NSString *)state keyword:(NSString *)keyword {
    [self.myTaskArray removeAllObjects];
    if ([IMission getInstance].curSel == -1) {
        [self requestMission:0 recursive:YES withState:state keyword:keyword];
    }
    else {
        [self requestMission:[IMission getInstance].curSel recursive:NO withState:state keyword:keyword];
    }
}

- (void)requestMission:(NSInteger)index recursive:(BOOL)bRecursive withState:(NSString *)state keyword:(NSString *)keyword{
    if (index >= [IMission getInstance].missions.count) {
        if (bRecursive) {
            [self hideSeachView:YES];
            [self.tableview reloadData];
        }
        return;
    }
    NSDictionary *taskInfo = [[IMission getInstance].missions objectAtIndex:index];
    NSDictionary *params = @{
                             @"staffcode": [iUser getInstance].staffcode,
                             @"batchcode": [taskInfo objectForKey:@"taskcode"],
                             @"state":state,
                             @"keyword":keyword
                             };
    index++;
    [AFNRequestManager requestAFURL:@"getMyTaskList.json" httpMethod:METHOD_POST params:params succeed:^(NSDictionary *ret) {
        if (0 == [[ret objectForKey:@"status"] integerValue]) {
            [self filter004:[ret objectForKey:@"detail"]];
            if (bRecursive) {
                [self requestMission:(index) recursive:YES withState:state keyword:keyword] ;
            }
            else {
                [self hideSeachView:YES];
                [self.tableview reloadData];
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}
#pragma mark - UITextFieldDidChanged Notification
- (void)textFieldEditChanged:(NSNotification *)obj {
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage; //键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > 20) {
                textField.text = [toBeString substringToIndex:20];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > 20) {
            textField.text = [toBeString substringToIndex:20];
        }
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
