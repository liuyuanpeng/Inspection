//
//  iUser.m
//  Inspecting
//
//  Created by liuyuanpeng on 2017/2/28.
//  Copyright © 2017年 default. All rights reserved.
//

#import "iUser.h"

@implementation iUser

+ (iUser *) getInstance {
    static dispatch_once_t onceToken;
    static iUser *setSharedInstance;
    dispatch_once(&onceToken, ^{
        setSharedInstance = [[iUser alloc] init];
    });
    return setSharedInstance;
}

- (void)setData:(NSDictionary *)data {
    self.account = [NSString stringWithString:[data valueForKey:@"account"]];
    self.headimg = [NSString stringWithString:[data valueForKey:@"headimg"]];
    self.idcode = [NSString stringWithString:[data valueForKey:@"idcode"]];
    self.idtype = [NSString stringWithString:[data valueForKey:@"idtype"]];
    self.instcode = [NSString stringWithString:[data valueForKey:@"instcode"]];
    self.instname = [NSString stringWithString:[data valueForKey:@"instname"]];
    self.lastdate = [NSString stringWithString:[data valueForKey:@"lastdate"]];
    self.name = [NSString stringWithString:[data valueForKey:@"name"]];
    self.roleid = [[data valueForKey:@"roleid"] integerValue];
    self.rolename = [NSString stringWithString:[data valueForKey:@"rolename"]];
    self.staffcode  = [NSString stringWithString:[data valueForKey:@"staffcode"]];
    self.tel = [NSString stringWithString:[data valueForKey:@"tel"]];
}
@end
