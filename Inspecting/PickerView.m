//
//  PickerView.m
//  Inspecting
//
//  Created by liuyuanpeng on 2017/3/5.
//  Copyright © 2017年 default. All rights reserved.
//

#import "PickerView.h"

@implementation PickerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self initData];
    }
    return self;
}

- (void)setComplete:(complete)block {
    self.block = block;
}

- (void)initData {
    self.types = @[@{
                       @"category":@"餐娱类",
                       @"types":@[
                               @"贵重珠宝、首饰，钟表零售",
                               @"包办伙食，宴会承包商人",
                               @"就餐场所和餐馆",
                               @"饮酒场所(酒吧、酒馆、夜总会、鸡尾酒大厅、迪斯科舞厅)",
                               @"古玩店--出售、维修及还原",
                               @"古玩复制店",
                               @"银器店",
                               @"玻璃器皿和水晶饰品店",
                               @"工艺美术商店",
                               @"艺术商和画廊",
                               @"住宿服务(旅馆、酒店、汽车旅馆、度假村等",
                               @"分时使用的别墅或度假用房",
                               @"运动和娱乐露营地",
                               @"活动房车长及露营场所",
                               @"按摩店",
                               @"保健及美容SPA",
                               @"手表、钟表和首饰维修点",
                               @"电影和录像创作、发行",
                               @"歌舞厅",
                               @"戏剧制片(不含电影)、演出和票务",
                               @"乐队、文艺表演",
                               @"台球、撞球场所",
                               @"保龄球馆",
                               @"商业体育馆、职业体育俱乐部、运动场和体育推广公司",
                               @"公共高尔夫球场",
                               @"大型游戏机和游戏场所",
                               @"游乐园、马戏团、嘉年华、占卜",
                               @"会员俱乐部(体育、娱乐、运动等)、乡村俱乐部以及私人高尔夫课程班",
                               @"水族馆、海洋馆和海豚馆",
                               @"其他娱乐服务"
                               ]
                   },
                   @{
                       @"category":@"房车类",
                       @"types":@[
                               @"一般承包商 - 住宅与商业楼",
                               @"活动房车销售商",
                               @"汽车货车经销商 - 新旧车的销售、服务、维修、零件和出租",
                               @"汽车货车经销商 - 专门从事旧车的销售、服务、维修、零件及出租",
                               @"船只销售商",
                               @"旅行拖车、娱乐用车销售商",
                               @"摩托车商店和经销商",
                               @"摩托车商店和经销商",
                               @"露营、房车销售商",
                               @"雪车商",
                               @"汽车、飞行器、农用机车综合经营商",
                               @"当铺",
                               @"不动产代理--房地产经纪"
                               ]
                       },
                   @{
                       @"category":@"批发类",
                       @"types":@[
                               @"烟草配送",
                               @"机动车供应及零配件(批发商)",
                               @"办公及商务家具(批发商)",
                               @"建材批发(批发商)",
                               @"办公、影印及微缩摄影器材(批发商)"
                               ]
                       }
                   
                   ];
    
    self.btnTag = 0L;
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
    NSArray *array = [[self.types objectAtIndex:self.btnTag] objectForKey:@"types"];
    self.block([array objectAtIndex:indexPath.row]);
}

#pragma mark - UITableView Datasource Impletation

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (nil == self.types) {
        return 0L;
    }
    return self.types.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"ipickercell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NSArray *array = [[self.types objectAtIndex:self.btnTag] objectForKey:@"types"];
    cell.textLabel.text = [NSString stringWithString:[array objectAtIndex:indexPath.row]];
    return cell;
}

@end
