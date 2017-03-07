//
//  PickerView.m
//  Inspecting
//
//  Created by liuyuanpeng on 2017/3/5.
//  Copyright © 2017年 default. All rights reserved.
//

#import "PickerView.h"
#import "AFNRequestManager.h"

@implementation PickerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self initData];
        self.backgroundColor = [UIColor colorWithWhite:236.0/255.0 alpha:1.0];
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(150, 0, frame.size.width - 150, frame.size.height)];
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self addSubview:self.tableView];
    }
    return self;
}

- (void)createSelBtns {
    if (self.selBtns == nil) {
        self.selBtns = [[NSMutableArray alloc] initWithCapacity:6];
    }
    for (NSInteger i= 0; i < self.types.count; i++) {
        NSDictionary *dict = self.types[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, i*20, 150, 19);
        [btn setBackgroundColor:[UIColor whiteColor]];
        btn.tag = i;
        [btn setTitle:[dict objectForKey:@"bg_cata_name"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [btn addTarget:self action:@selector(onChangeSel:) forControlEvents:UIControlEventTouchUpInside];
        [self.selBtns addObject:btn];
        [self addSubview:btn];
    }
    [self.selBtns[self.btnTag] setBackgroundColor:[UIColor colorWithRed:234/255.0 green:230/255.0 blue:221/255.0 alpha:1.0]];
}

- (IBAction)onChangeSel:(UIButton *)sender {
    if (sender.tag == self.btnTag) {
        return;
    }
    [self.selBtns[self.btnTag] setBackgroundColor:[UIColor whiteColor]];
    [self.selBtns[sender.tag] setBackgroundColor:[UIColor colorWithRed:234/255.0 green:230/255.0 blue:221/255.0 alpha:1.0]];
    self.btnTag = sender.tag;
    [self.tableView reloadData];
}

- (void)setComplete:(complete)block {
    self.block = block;
}

- (void)initData {
    [AFNRequestManager requestAFURL:@"getMCC.json" httpMethod:METHOD_POST params:nil succeed:^(NSDictionary *ret) {
        if (0 == [[ret objectForKey:@"status"] integerValue]) {
            self.types = [[NSArray alloc] initWithArray:[ret objectForKey:@"datas"]];
            self.btnTag = 0L;
            [self createSelBtns];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


#pragma mark - UITableView Delegate Impletation

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 20.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self setHidden:YES];
    NSArray *array = [[self.types objectAtIndex:self.btnTag] objectForKey:@"mcclst"];
    self.block([array objectAtIndex:indexPath.row]);
}

#pragma mark - UITableView Datasource Impletation

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (nil == self.types) {
        return 0L;
    }
    NSArray *array = [[self.types objectAtIndex:self.btnTag] objectForKey:@"mcclst"];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"ipickercell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell setBackgroundColor:[UIColor colorWithRed:234/255.0 green:230/255.0 blue:221/255.0 alpha:1.0]];
        cell.textLabel.font = [UIFont systemFontOfSize:11.0f];
    }
    
    NSArray *array = [[self.types objectAtIndex:self.btnTag] objectForKey:@"mcclst"];
    cell.textLabel.text = [NSString stringWithString:[[array objectAtIndex:indexPath.row] objectForKey:@"remark"]];
    return cell;
}

@end
