//
//  RSAEncryptor.h
//  Inspecting
//
//  Created by liuyuanpeng on 2017/3/14.
//  Copyright © 2017年 default. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSAEncryptor : NSObject

@property (nonatomic, strong) NSString *publicKey;

#pragma mark - Instance Method

- (NSString *)encryptString:(NSString *)str;

- (NSString *)encryptString:(NSString *)str withPadding:(SecPadding)padding;

#pragma mark - Class Method

+ (RSAEncryptor *)shareInstance;

@end
