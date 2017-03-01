//
//  iUser.h
//  Inspecting
//
//  Created by liuyuanpeng on 2017/2/28.
//  Copyright © 2017年 default. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iUser : NSObject

@property (nonatomic, strong) NSString *account;
@property (nonatomic, strong) NSString *headimg;
@property (nonatomic, strong) NSString *idcode;
@property (nonatomic, strong) NSString *idtype;
@property (nonatomic, strong) NSString *instcode;
@property (nonatomic, strong) NSString *instname;
@property (nonatomic, strong) NSString *lastdate;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger roleid;
@property (nonatomic, strong) NSString *rolename;
@property (nonatomic, strong) NSString *staffcode;
@property (nonatomic, strong) NSString *tel;

+ (iUser *)getInstance;

- (void)setData:(NSDictionary *)data;

@end
